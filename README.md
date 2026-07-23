# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Packages

| Package | Target |
|---|---|
| `aerospace` | `~/.config/aerospace/` |
| `nvim` | `~/.config/nvim/` |
| `starship` | `~/.config/starship.toml` |
| `tmux` | `~/.config/tmux/tmux.conf` |
| `zsh` | `~/.zshrc` |

## Setup

Install dependencies on macOS or Linux:

```bash
./zsh_dep_install.sh
```

From the repository root, link all packages:

```bash
stow --target="$HOME" aerospace nvim starship tmux zsh
```

To link only selected packages:

```bash
stow --target="$HOME" tmux zsh
```

To remove package links:

```bash
stow --delete --target="$HOME" tmux zsh
```

TPM manages `~/.config/tmux/plugins/`, and lazy.nvim manages
`~/.config/nvim/lazy-lock.json`; these generated files are not tracked.
