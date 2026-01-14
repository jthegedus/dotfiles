# Dotfiles

> trying to keep things simple while practising the basics.

- Tools: Fish, Git, Helix, Vim, Go, Zig, Difftastic, Mergiraf, ast-grep, grex, Claude Code
- Bitwarden as the SSH agent
- Per-repository git configuration (`git-setup` & `git-clone`)
- Update system with `up`/`update`
- Abbreviations (list them with `abbr`)
- Desktop Environment: [MangoWC](https://mangowc.vercel.app/) & [DankMaterialShell](https://danklinux.com)

Contents:

- [Install](#install)
- [SSH Authentication Flow](#ssh-authentication-flow)
- [Git](#git)
- [Fish Commands](#fish-commands)
- [Linux Configurations](#linux-configurations)
- [Other](#other)
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

## SSH Authentication Flow

```
Git Command -> SSH -i key.pub -> Bitwarden SSH Agent -> GitHub
```

1. Git uses `core.sshCommand` with public key as identifier
2. Bitwarden finds matching private key in vault
3. User approves in Bitwarden
4. Authentication completes

Avoids storing private keys in your `~/.ssh/` directory.

## Git

I like to manage repository config on a per-repository basis. The following commands with prompt for:

- `remote.origin.url`
- `user.name`
- `user.email`
- select SSH public keys from `~/.ssh/*.pub` for use as:
  - authentication key
  - signing key

Run `git-setup` after a local `git init` to configure a repository with identity and SSH authentication:

```bash
git-setup
```

Run `git-clone` to clone a repository and then configure the per-repository configuration like `git-setup`:

```bash
git-clone <remote-url> [destination]
```

</details>

## Fish Commands

Fish abbreviations expand inline as you type. List them with `abbr`.

Noteable custom Fish functions:

| Function        | Description                                              |
| --------------- | -------------------------------------------------------- |
| `update` / `up` | Update system packages via Homebrew                      |
| `cc`            | Run Claude Code with MCP secrets from `.env.mcp.secrets` |
| `git-setup`     | Configure git identity and SSH for current repository    |
| `git-clone`     | Clone repository and configure identity/SSH              |
| `backup`        | Backup a file with .bak suffix                           |
| `copy`          | Copy directories recursively (cp wrapper)                |

<details>
<summary>Toybox Coreutils</summary>

> NOTE: not currently configured

Toybox provides consistent coreutils across platforms via Docker:

```bash
docker pull tianon/toybox:latest
```

Commands like `ls`, `cp`, `mv` can be aliased to use toybox when available.

</details>

## Linux Configurations

### Hardware

<details>
<summary>MS-A1 w AMD 8700G</summary>

The integrated GPU requires kernel parameters to prevent `ring gfx_0.0.0 timeout` crashes caused by MES (Micro Engine Scheduler) failures.

Configured in `/etc/default/limine`, applied with `sudo limine-update`.

```
amdgpu.gpu_recovery=1
amdgpu.ppfeaturemask=0xffff7fff
amdgpu.runpm=0
amdgpu.sg_display=0
amdgpu.dcdebugmask=0x10
```

| Parameter       | Value      | Purpose                                |
| --------------- | ---------- | -------------------------------------- |
| `gpu_recovery`  | 1          | Enable GPU reset on hang               |
| `ppfeaturemask` | 0xffff7fff | Disable GFXOFF (PP_GFXOFF_MASK bit 15) |
| `runpm`         | 0          | Disable runtime power management       |
| `sg_display`    | 0          | Disable scatter/gather display         |
| `dcdebugmask`   | 0x10       | Disable PSR (Panel Self Refresh)       |

Verify with: `cat /proc/cmdline | tr ' ' '\n' | grep gsamdgpu`

</details>

### Desktop Environments

<details>
<summary>Flatpak apps</summary>

Flatpak app installs: `flatpak install com.bitwarden.desktop com.brave.Browser dev.zed.Zed`

Wayland flags to launch properly from Wayland-native launchers:

- Brave Browser (`~/.var/app/com.brave.Browser/config/brave-flags.conf`):

  ```
  --ozone-platform=wayland
  --enable-features=UseOzonePlatform,VaapiVideoDecodeLinuxGL,WebRTCPipeWireCapturer
  ```

- Bitwarden:

  ```bash
  flatpak override --user --env=ELECTRON_OZONE_PLATFORM_HINT=wayland com.bitwarden.desktop
  ```

  This creates `~/.local/share/flatpak/overrides/com.bitwarden.desktop` with:

  ```ini
  [Environment]
  ELECTRON_OZONE_PLATFORM_HINT=wayland
  ```

</details>

## Other

* fonts: [commitmono](https://commitmono.com/), which has a [Nerd Fonts patch](https://github.com/ryanoasis/nerd-fonts).

## References

I recommend reading about the following:

- [suckless](https://suckless.org/) - quality software with simplicity, clarity, frugality
- [Toybox](https://landley.net/toybox/) - 0BSD licensed, simple, small, fast coreutils

<details>
<summary>themes</summary>

Note to future me, theme-hop these:

- Afterglow
- Birds Of Paradise
- Everblush
- Everforest dark hard
- Everforest light med
- Miasma
- Mona Lisa
- N0tch2k
- Neopolitan
- novmbr
- Owl
- Red Planet
- Sea Shells
- Sleepy Hollow
- Spacegray Eighties Dull
- Sundried
- Wombat
- Zenbones (dark & light)

Sourced from - https://github.com/mbadolato/iTerm2-Color-Schemes

</details>

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
