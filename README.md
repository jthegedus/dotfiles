# Dotfiles
>trying to keep things simple while practising the basics.

- Tools: Fish, Git, Helix, Vim, Go, Zig, Difftastic, Mergiraf, ast-grep, grex, Claude Code
<!--- Toybox coreutils via Docker (aliased)-->
- Bitwarden as the SSH agent
- Per-repository git configuration (`git-setup` & `git-clone`)

Contents:
- [Install](#install)
- [Structure](#structure)
- [SSH Authentication Flow](#ssh-authentication-flow)
- [Git Setup](#git-setup)
- [References](#references)
- [Licence](#licence)

## Install

```bash
git clone https://github.com/jthegedus/dotfiles.git ~/dev/dotfiles
bash ~/dev/dotfiles/install.sh
```

This will:
1. Install Homebrew (if not present)
2. Install all tools via Brewfile
3. Configure Claude Code (disable auto-updater)
4. Symlink config files to `~/.config`
5. Set up SSH configuration
6. Set Fish as the default shell

Enable Bitwarden SSH Agent:

1. Open Bitwarden Desktop
2. Settings > SSH Agent > Enable
3. Unlock vault

## Structure

```
dotfiles/
├── .config/              # Symlinked to ~/.config
│   ├── brewfile/         # Homebrew packages
│   ├── fish/             # Shell config and functions
│   ├── git/              # Git config, attributes, ignore
│   ├── helix/            # Editor config
│   ├── ssh/config.d/     # Modular SSH configuration
│   └── vim/              # Fallback editor config
├── .ssh/
│   └── config.example    # Template copied to ~/.ssh/config
├── install.sh            # Setup script
└── README.md
```

## SSH Authentication Flow

```
Git Command -> SSH -i key.pub -> Bitwarden SSH Agent -> GitHub
```

1. Git uses `core.sshCommand` with public key as identifier
2. Bitwarden finds matching private key in vault
3. User approves in Bitwarden
4. Authentication completes

Avoids storing private keys in your `~/.ssh/` directory.

## Git Setup

I like to manage repository config on a per-repository basis. The following commands with prompt for:
- `user.name`
- `user.email`
- SSH signing key (optional)
- SSH authentication identity

Run `git-setup` after a local `git init` to configure a repository with identity and SSH authentication:

```bash
git-setup
```

Run `git-clone` to clone a repository and then configure the per-repository configuration like `git-setup`:

```bash
git-clone <remote-url> [destination]
```

</details>

<details>
<summary>Toybox Coreutils</summary>

>NOTE: not currently configured

Toybox provides consistent coreutils across platforms via Docker:

```bash
docker pull tianon/toybox:latest
```

Commands like `ls`, `cp`, `mv` can be aliased to use toybox when available.

</details>

## References

I recommend reading about the following:

- [suckless](https://suckless.org/) - quality software with simplicity, clarity, frugality
- [Toybox](https://landley.net/toybox/) - 0BSD licensed, simple, small, fast coreutils

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
