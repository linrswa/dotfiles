# macOS chezmoi 同步 .claude 設定

## 背景

我在 Linux (gjtek-server) 上已經完成了以下工作：
- 安裝 chezmoi，指向現有的 `~/dotfiles` repo
- 在 `~/dotfiles/` 建立了 `.chezmoiignore`（忽略舊 stow 目錄 + .claude runtime）
- 在 `~/dotfiles/private_dot_claude/` 建立了完整的 chezmoi source 結構
- 已 commit & push 到 `origin/master`（https://github.com/linrswa/dotfiles）

macOS 是我的主力開發機，`~/dotfiles` repo 已存在（用 stow 管理 nvim/zsh/tmux/starship/aerospace）。

## 本次目標

在 macOS 上設定 chezmoi，**只 apply `~/.claude`**，讓 Linux 上開發的 skills/agents/commands 同步過來。
**不能動到任何現有 stow symlinks**（nvim, zsh, tmux, starship, aerospace）。

## 需要你執行的步驟

### Step 1: 安裝 chezmoi

```bash
# 用 brew 或直接下載都行，選一個
brew install chezmoi
# 或
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin
```

### Step 2: 拉取最新 dotfiles

```bash
cd ~/dotfiles && git pull origin master
```

確認 `private_dot_claude/` 和 `.chezmoiignore` 都存在。

### Step 3: 設定 chezmoi source 指向 ~/dotfiles

建立 `~/.config/chezmoi/chezmoi.toml`：

```toml
sourceDir = "/Users/<我的使用者名稱>/dotfiles"
```

注意路徑是 macOS 的 `/Users/...`，不是 Linux 的 `/home/...`。
請先用 `echo $HOME` 確認正確的 home 路徑。

驗證：`chezmoi source-path` 應該回傳 `/Users/<使用者名稱>/dotfiles`。

### Step 4: 預覽變更

```bash
chezmoi managed    # 應該只有 .claude/ 下的檔案
chezmoi diff       # 預覽差異
chezmoi apply --dry-run -v ~/.claude  # dry run
```

確認：
- `chezmoi managed` 只列出 `.claude/` 的檔案，沒有 nvim/zsh/tmux 等
- diff 看起來合理（macOS 上如果 ~/.claude 已存在，可能有部分檔案一致）

### Step 5: Apply

```bash
chezmoi apply -v ~/.claude
```

### Step 6: 驗證

```bash
# .claude 設定到位
test -f ~/.claude/CLAUDE.md && echo "OK: CLAUDE.md"
test -f ~/.claude/settings.json && echo "OK: settings.json"
test -f ~/.claude/commands/commit.md && echo "OK: commit.md"
test -f ~/.claude/agents/architecture-reviewer.md && echo "OK: architecture-reviewer"
test -f ~/.claude/agents/senior-engineer.md && echo "OK: senior-engineer"
test -f ~/.claude/plugins/installed_plugins.json && echo "OK: installed_plugins"

# skills 到位
test -f ~/.claude/skills/agent-browser/SKILL.md && echo "OK: agent-browser"
test -f ~/.claude/skills/find-skills/SKILL.md && echo "OK: find-skills"
test -f ~/.claude/skills/ask-codex/SKILL.md && echo "OK: ask-codex"
test -f ~/.claude/skills/go-watch-this/SKILL.md && echo "OK: go-watch-this"
test -f ~/.claude/skills/skill-creator/SKILL.md && echo "OK: skill-creator"

# shell scripts 有執行權限
test -x ~/.claude/skills/agent-browser/templates/authenticated-session.sh && echo "OK: executable"

# stow 管理的東西完全沒被動到
test -L ~/.config/nvim && echo "OK: nvim still symlink"  # 或確認 nvim 設定存在
test -f ~/.zshrc && echo "OK: zshrc untouched"
test -f ~/.tmux.conf && echo "OK: tmux untouched"

# 沒有被 chezmoi 誤建的目錄
test ! -d ~/nvim && echo "OK: no ~/nvim"
test ! -d ~/zsh && echo "OK: no ~/zsh"

# chezmoi diff 應該乾淨
chezmoi diff
```

## 重要注意事項

- **只 apply `~/.claude`**，不要跑裸的 `chezmoi apply`（雖然 .chezmoiignore 應該會擋住 stow 目錄，但保險起見限定路徑）
- macOS 上如果 `~/.claude` 已經有自己的 settings.json 或 CLAUDE.md，chezmoi 會用 repo 的版本覆蓋。如果 macOS 上有獨特設定，apply 前先在 diff 裡確認，必要時先備份
- `.chezmoiignore` 已經排除了所有 runtime 資料（projects/, history.jsonl, credentials 等），不會被覆蓋
- macOS 上如果 `~/.claude/skills/agent-browser` 也是 symlink 到 `~/.agents/`，apply 後會變成真實目錄（預期行為）
