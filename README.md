# Dotfiles
>trying to keep things simple while practising the basics.

- Fish shell with Toybox coreutils (via Docker)
- Bitwarden as the SSH agent
- Per repository git configuration (`git-setup`)

Contents:

- [Install](#install)
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

Investigate the configurations:

```fish
alias
```

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

## Git Setup

I like to manage repository config on a per-repository basis. Run `git-setup` after `init` or `clone` to configure the repository with identity and SSH authentication:

```fish
git-setup
```

This prompts for:
- Git identity (user.name, user.email)
- SSH signing key (optional)
- SSH identity for authentication
- Remote repository URL

### SSH Authentication Flow

With Bitwarden as the SSH Agent, we can keep our private keys in our vault and use our public keys in `~/.ssh/*.pub` for lookups. The `git-setup` function configures the `git` command to use `ssh` with our public keys for manual Bitwarden authorization on each use.

```
Git Command → SSH -i key.pub → SSH Agent → Bitwarden → GitHub
```

1. Git uses `core.sshCommand` with **public key** as identifier
2. SSH Agent finds matching private key
3. Bitwarden requires user approval
4. Authentication completes

## Tools

- Fish: reliable & featureful shell
- Toybox: suckless-ish, portable, 0BSD licenced utils

Install via Homebrew:

```bash
brew install \
  fish \
  helix \
  vim \
  git \
  difftastic \
  mergiraf \
  ast-grep \
  grex \
  tailscale

brew install --cask \
  bitwarden \
  ghostty \
  claude-code
```

Install via Docker:

```bash
docker pull tianon/toybox:latest
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
