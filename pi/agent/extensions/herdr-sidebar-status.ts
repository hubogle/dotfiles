import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

/**
 * Pi -> Herdr Sidebar Metadata
 *
 *   ● my-project · backend
 *     pi · GPT-5.6 Sol                <- agent · $model_low|mid|high
 *
 * 模型名的颜色反映 context 使用率：按阈值上报到 model_low / model_mid /
 * model_high 之一，其余两个清空，颜色在 herdr config.toml 里配置。
 * herdr 规则只能看 token 自身的值，无法用 ctx 给模型名上色，所以分档在这里做。
 *
 * 只通过 report-metadata 上报展示信息，working / idle / blocked 等生命周期状态
 * 由 herdr 官方 pi integration（herdr-agent-state.ts）管理，互不干扰。
 */

const SOURCE = "user:pi-sidebar";
const MODEL_TOKENS = ["model_low", "model_mid", "model_high"] as const;
const CLEAR_MODEL = MODEL_TOKENS.flatMap((t) => ["--clear-token", t]);

// 与 claude 的 statusline.sh 口径一致：取整后比较。
function modelTier(percent: number | null | undefined): (typeof MODEL_TOKENS)[number] {
  const ctx = Math.floor(percent ?? 0);
  if (ctx > 70) return "model_high";
  if (ctx > 40) return "model_mid";
  return "model_low";
}

export default function herdrSidebarStatus(pi: ExtensionAPI) {
  const herdr = process.env.HERDR_BIN_PATH;
  const paneId = process.env.HERDR_PANE_ID;

  if (process.env.HERDR_ENV !== "1" || !herdr || !paneId) {
    return;
  }

  // 只有 TUI 根会话才上报；子进程（subagent 的 rpc/json/print 模式）继承了
  // HERDR_* 环境变量，若不拦截会覆盖父会话的侧边栏。
  let enabled = false;

  // 串行发送，避免相邻事件并发执行 CLI 时旧状态覆盖新状态；内容不变则跳过。
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
        // 仅用于展示，失败不影响 pi。
      }
    });
    return queue;
  }

  function report(ctx: ExtensionContext): Promise<void> {
    // 显示名（如 GPT-5.6 Sol），与 claude 侧的 display_name 口径一致；没有时退回 id。
    const model = ctx.model?.name || ctx.model?.id;
    const tier = modelTier(ctx.getContextUsage()?.percent);

    return send([
      ...CLEAR_MODEL,
      ...(model ? ["--token", `${tier}=${model.slice(0, 40)}`] : []),
    ]);
  }

  // 正常启动 / resume / reload / fork
  pi.on("session_start", (_event, ctx) => {
    enabled = ctx.mode === "tui";
    return report(ctx);
  });

  pi.on("model_select", (_event, ctx) => report(ctx));

  // context 使用率在每轮 assistant 回复后变化。
  pi.on("turn_end", (_event, ctx) => report(ctx));
  pi.on("agent_settled", (_event, ctx) => report(ctx));

  // reload / new / resume / fork 之后会紧接着 session_start 重新上报，只有真正退出才需要清空。
  pi.on("session_shutdown", (event) => {
    if (event.reason === "quit") {
      return send(CLEAR_MODEL);
    }
  });
}
