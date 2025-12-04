# Dotfiles
>trying to keep things simple while practising the basics.
- Fish shell with Toybox coreutils (via Docker)
- Bitwarden as the SSH agent
- Per repository git configuration (`git-setup`)

Contents:

- [Install](#install)
- [Structure](#structure)
- [Aliases](#aliases)
- [Toybox](#toybox)
- [Git Setup](#git-setup)
- [Tools](#tools)
- [Dependencies](#dependencies)
- [Licence](#licence)

## Install

```bash
git clone https://github.com/jthegedus/dotfiles.git ~/dev/dotfiles
bash ~/dev/dotfiles/install.sh
```

Then set Fish as your default shell:

```bash
# Add Fish to allowed shells (if needed)
echo $(which fish) | sudo tee -a /etc/shells

# Change default shell
chsh -s $(which fish)
```

## Structure

```
.config/
├── fish/
│   ├── config.fish      # All shell configuration
│   └── functions/       # Auto-loaded functions
├── ghostty/             # Terminal emulator
├── git/                 # Git config (difftastic, mergiraf)
├── helix/               # Editor
├── ssh/                 # SSH configuration
└── vim/                 # Fallback editor
```

## Aliases

<details>
<summary>File operations:</summary>

- `ll` - `toybox ls -Achop!`
- `rm` - `toybox rm -Iv` (interactive, verbose)
- `mv` - `toybox mv -i` (interactive)
- `df` - `toybox df -h` (human-readable)
- `du` - `toybox du -h -d 1`

</details>

<details>
<summary>Navigation:</summary>

- `..`, `...`, `....`, `.....` - Navigate up directories
- `q` - `cd ~`
- `d` - `cd ~/dev`
- `cl` - `clear`

</details>

<details>
<summary>Git:</summary>

- `gl` - `git log --all --decorate --oneline --graph`
- `gs` - `git status --short`
- `ga` - `git add`
- `gc` - `git commit --message`
- `gp` - `git push`
- `gpl` - `git pull`

</details>

<details>
<summary>Regex (grex):</summary>

- `rx` - `grex` (generate regex from examples)
- `rxd` - `grex --digits` (use \d for digits)
- `rxw` - `grex --words` (use \w for word chars)
- `rxs` - `grex --spaces` (use \s for whitespace)

</details>

<details>
<summary>AST search (ast-grep):</summary>

- `sg` - `ast-grep` (AST-based code search)
- `sgp` - `ast-grep --pattern` (search with pattern)
- `sgl` - `ast-grep --pattern --lang` (search with pattern and language)

</details>

## Toybox

Coreutils aliases route through a smart `toybox` wrapper function:

```fish
alias ls 'toybox ls -ACp'
alias cat 'toybox cat'
# ... etc
```

The wrapper:
- Checks docker and image availability (once per session)
- Falls back to system commands if unavailable
- Shows `docker pull tianon/toybox:latest` if image missing

Use `command <cmd>` to bypass toybox and use system commands directly.

Note: Docker adds ~100-500ms overhead per command.

## Git Setup

The `git-setup` function configures new repositories with identity and SSH authentication:

```fish
git-setup
```

This prompts for:
- Git identity (user.name, user.email)
- SSH signing key (optional)
- SSH identity for authentication
- Remote repository URL

### SSH Authentication Flow

```
Git Command → SSH -i key.pub → SSH Agent → Bitwarden → GitHub
```

1. Git uses `core.sshCommand` with **public key** as identifier
2. SSH Agent finds matching private key
3. Bitwarden requires user approval
4. Authentication completes

## Tools

Install via Homebrew:
```bash
brew install \
  ast-grep \
  fish \
  git \
  grex \
  helix \
  vim \
  difftastic \
  mergiraf \
  tailscale

brew install --cask \
  bitwarden \
  ghostty \
  claude-code
```

## Dependencies

Required:
- Docker (for Toybox coreutils)
- Fish shell
- Bitwarden desktop app (for SSH agent)

`install.sh` requires:
- bash
- ln, mkdir, chmod, cp, stat, realpath, dirname (system coreutils)

## Licence

```
Zero-Clause BSD

Permission to use, copy, modify, and/or distribute this software for
any purpose with or without fee is hereby granted.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL
WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE
FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY
DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT
OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```
