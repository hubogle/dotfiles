#!/usr/bin/env bash

# https://github.com/mathiasbynens/dotfiles/blob/main/.macos
###############################################################################
# 系统设置                                                                     #
###############################################################################

#`hammerspoon` 路径配置
defaults write org.hammerspoon.Hammerspoon MJConfigFile "~/.config/hammerspoon/init.lua"

#`Vscode VIM` 连点配置
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

# 全局连点配置
# defaults delete -g ApplePressAndHoldEnabled

# 所有显示器上显示cmd+应用程序切换器
# defaults write com.apple.Dock appswitcher-all-displays -bool true;killall Dock

###############################################################################
# 屏幕截图                                                                     #
###############################################################################
# 截图保存的位置
defaults write com.apple.screencapture location ~/Downloads

# 保存格式为 JPG
defaults write com.apple.screencapture type -string jpg

# 截图禁用阴影
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

# 禁用窗口动画和获取信息动画
defaults write com.apple.finder DisableAllAnimations -bool true

# 显示文件的扩展名
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# 显示状态栏
defaults write com.apple.finder ShowStatusBar -bool true

# 显示路径栏
defaults write com.apple.finder ShowPathbar -bool true

# 标题栏显示完整路径
defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES

# 更改文件名时不警告
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# 避免在网络卷上创建.DS_Store文件
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# 清空垃圾箱前不显示警告
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# 不显示隐藏文件
defaults write com.apple.finder AppleShowAllFiles -bool false;

###############################################################################
# Dock                                                                        #
###############################################################################

defaults write com.apple.dock springboard-columns -int 8

defaults write com.apple.dock springboard-rows -int 7

defaults write com.apple.dock ResetLaunchPad -bool TRUE # 重置Launchpad

# killall Dock 重启生效
