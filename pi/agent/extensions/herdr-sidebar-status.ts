import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

/**
 * 将 Pi 当前模型名称上报给 Herdr 侧边栏。
 * working / idle / blocked 等生命周期状态由 Herdr 官方 Pi integration 管理。
 */
const SOURCE = "user:pi-sidebar";
const CLEAR_MODEL = ["--clear-token", "model"];

export default function herdrSidebarStatus(pi: ExtensionAPI) {
  const herdr = process.env.HERDR_BIN_PATH;
  const paneId = process.env.HERDR_PANE_ID;

  if (process.env.HERDR_ENV !== "1" || !herdr || !paneId) {
    return;
  }

  // 子进程会继承 HERDR_* 环境变量，只有 TUI 根会话可以更新侧边栏。
  let enabled = false;
  let queue: Promise<void> = Promise.resolve();
  let lastPayload = "";

  function send(args: string[]): Promise<void> {
    const payload = args.join("\0");
    if (!enabled || payload === lastPayload) {
      return queue;
    }
    lastPayload = payload;

    queue = queue.then(async () => {
      try {
        await pi.exec(herdr, ["pane", "report-metadata", paneId, "--source", SOURCE, ...args], {
          timeout: 2000,
        });
      } catch {
        // 仅用于展示，失败不影响 Pi。
      }
    });
    return queue;
  }

  function report(ctx: ExtensionContext): Promise<void> {
    const model = ctx.model?.name || ctx.model?.id;
    return send(model ? ["--token", `model=${model.slice(0, 40)}`] : CLEAR_MODEL);
  }

  pi.on("session_start", (_event, ctx) => {
    enabled = ctx.mode === "tui";
    return report(ctx);
  });

  pi.on("model_select", (_event, ctx) => report(ctx));

  pi.on("session_shutdown", (event) => {
    if (event.reason === "quit") {
      return send(CLEAR_MODEL);
    }
  });
}
