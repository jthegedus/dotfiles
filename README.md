# Dotfiles
>Fish for humans & Bash for AI

Warning: this is a work in progress. See goal/non-goals, contributing & todo sections.

Bash for AI? Yes! AI tools usually inherit the current terminal session's configuration, however support for this is poorly documented.
It is often unclear what tools our AI tools have access to and how we can configure them to utilise our bespoke tooling and configuration.
By explicitly mirroring configuration between Shells we can **TRY** to better control the environment we run our AI tools.

- [Goals & Non-goals](#goals--non-goals)
- [Managing Software](#managing-software)
- [Install](#install)
- [Structure](#structure)
- [Configuration Features](#configuration-features)
- [Dependencies](#dependencies)
- [Recommended Tools](#recommended-tools)
- [TODO](#todo)
- [Contributions](#contributions)
- [Licence](#licence)

## Goals & Non-goals

Capture Shell configuration and adjacent tooling, not OS or Desktop configurations.
Keep customisations simple.
Use a minimal set of modern tools to reduce footguns (Prefer statically compiled tools. 0 deps > speed > memory footprint > size).
Organise with standard patterns.
Manage AI configurations separately.

## Managing Software

This is how I recommend managing different software categories across machines:

| Type             | Example           | Version | Installed / managed via               |
| :--------------- | :---------------- | :------ | :------------------------------------ |
| Application      | Browser, Terminal | latest  | Depends on the OS: Flathub / Homebrew |
| System           | Shell, CLI Editor | latest  | Homebrew                              |
| Project-specific | Language Runtimes | pinned  | container / devcontainer / distrobox  |

This is important given the configuration in this repository references software from some of these categories (Eg: Bitwarden as the SSH Agent).

<details>
<summary>Core Tools (click to expand)</summary>

Daily drivers:
- Editor: [Helix](https://helix-editor.com/)
- Shell: [Fish Shell](https://fishshell.com/)
- Shell: [BASH Shell](https://www.gnu.org/software/bash/)
- VCS: [git](https://git-scm.com/)
- SSH: [Bitwarden](https://bitwarden.com/)
- Software: [Homebrew](https://brew.sh/)

For those random edge cases:
- Editor: [Vim](https://www.vim.org/)
- Shell: [ZSH Shell](https://www.zsh.org/)

</details>

## Install

Traditional setup with clone & symlink:
* Clone to your project directory:
  ```
  git clone git@github.com:jthegedus/dotfiles.git ~/dev/dotfiles
  ```
* Symlink everything:
  ```
  bash ./install.sh
  ```

<details>
<summary>Use in DevContainers (click to expand)</summary>

VSCode configuration for using these dotfiles in a DevContainer:

```json
{
  "dotfiles.repository": "jthegedus/dotfiles",
  "dotfiles.targetPath": "~/dotfiles",
  "dotfiles.installCommand": "install.sh"
}
```

</details>

## Structure

Fish defaults to using `.config/fish/*` with a `conf.d/` directory (a pattern from Apache projects) to control the automatic loading and order of startup scripts.

Bash has been configured to mirror the Fish configuration structure, with the root files `.bashrc` file containing that logic.

(work in progress) ZSH has been configured to utilise the same Bash scripts since ZSH is _mostly_ backwards compatible. The root `.zshenv` sets `.config/zsh` as the root directory for the ZSH entrypoint files (which then point to Bash).

### conf.d Load Order & Organization

Files in `conf.d/` load alphabetically. The numbering scheme ensures proper initialization order:

- **00-09**: Environment foundation (XDG paths, core shell config)
- **10-19**: Security & authentication (SSH agents)
- **20-29**: PATH & package managers (must load before tools)
- **30-39**: Standard system utilities (enhance with flags, don't replace)
- **40-49**: Shell features (completions, prompts)
- **50-98**: Custom tools (may override system tools - e.g., `bat` → `cat`)
- **99**: Startup/cleanup tasks (auto-updates)

**Key principle**: Files in the 30s enhance system tools with flags; files in the 50s may replace them entirely (e.g., `bat` → `cat`, `lla` → `ll`, `ugrep` → `grep`). Each custom tool gets its own `50-<toolname>` file.

## Configuration Features

- Auto-updating dotfiles: Automatically pulls repository updates once per day
- SSH agent integration: Bitwarden SSH agent configuration for both macOS and Linux
- Environment configuration: Shell identification and XDG Base Directory compliance for proper configuration directories
- File listing with lla: Modern file explorer with multiple views (tree, git, timeline, size map)
- Enhanced grep with ugrep: Ultra-fast grep with interactive TUI and fuzzy search
- Syntax highlighting: bat replaces cat for enhanced file viewing
- Smart directory navigation: zoxide learns frequently used directories
- Git aliases: Convenient shortcuts for common git operations
- Navigation aliases: Quick directory navigation shortcuts

## Aliases

This repository provides numerous aliases to enhance productivity. Aliases load conditionally based on available tools, with fallbacks for missing dependencies.

### File Listing & Navigation

**Primary listing (priority order):**
- `ll` → `lla -T` when lla available (tree view)
- `ll` → `ls -Alh` fallback when lla not installed

**LLA-specific views** (when lla installed):
- `search` → `lla --search` - interactive search
- `rg` → `lla --search` - search shorthand
- `fzf`, `fz`, `fuzz` → `lla --fuzzy -a` - fuzzy find with hidden files
- `lg` → `lla -G` - Git-aware view with repository status
- `lt` → `lla --timeline` - timeline view grouped by time periods
- `lsize` → `lla --sizemap --include-dirs` - size map with directory sizes

**Tree visualization** (when tree installed):
- `tree` → `tree -a -C -I .git` - colored tree excluding .git

**Smart navigation** (when zoxide installed):
- `z <dir>` - jump to frequently used directories

**Directory shortcuts:**
- `..`, `...`, `....`, `.....`, `......` - navigate up 1-5 levels
- `q` → `cd ~` - jump to home directory
- `d` → `cd ~/dev` - jump to dev directory
- `cl` → `clear` - clear terminal

### File Operations

**System utilities with enhanced defaults:**
- `rm` → `rm -Iv` - interactive mode with verbose output
- `mv` → `mv -i` - interactive mode (prompt before overwrite)
- `df` → `df -h` - human-readable disk usage
- `du` → `du -h -d 1` - human-readable directory sizes (1 level deep)

**File viewing** (when bat installed):
- `cat` → `bat` - syntax-highlighted file viewing

### Search & Grep

**Process search:**
- `p <pattern>` → `ps aux | ugrep <pattern>` - search running processes

**Ugrep aliases** (when ugrep installed):
- `ug` → `ugrep` - basic ugrep
- `ug+` → `ugrep+` - ugrep with additional features
- `uq` → `ug -Q` - interactive TUI search
- `uz` → `ug -z` - search compressed files/archives
- `ux` → `ug -U --hexdump` - binary pattern search with hexdump
- `ugit` → `ug -R --ignore-files` - Git-aware search (like git-grep)

**Grep family replacements** (when ugrep installed):
- `grep` → `ug -G` - basic regular expressions (BRE)
- `egrep` → `ug -E` - extended regular expressions (ERE)
- `fgrep` → `ug -F` - fixed string search
- `zgrep` → `ug -zG` - search compressed files (BRE)
- `zegrep` → `ug -zE` - search compressed files (ERE)
- `zfgrep` → `ug -zF` - search compressed files (fixed strings)

**Utility commands** (when ugrep installed):
- `xdump` → `ugrep -X ""` - hexdump files
- `zmore` → `ugrep+ -z -I -+ --pager ""` - view compressed/archived files

### Git Shortcuts

- `gl` → `git log --all --decorate --oneline --graph` - pretty log graph
- `gs` → `git status --short` - compact status
- `ga` → `git add` - stage files
- `gc` → `git commit --message` - commit with message
- `gp` → `git push` - push to remote
- `gpl` → `git pull` - pull from remote

### Notes

- Aliases in the 50s (e.g., `lla`, `bat`, `ugrep`) override base aliases when available
- Without optional tools, fallback aliases provide basic functionality
- All aliases work in both Fish and Bash shells
- LLA's jump directory feature auto-configures on first shell load when lla is installed

## Git Setup

This repository includes a custom Git setup workflow that emphasizes security and identity management through SSH agent integration.

### git-setup Command

The `git-setup` Fish function provides an interactive way to initialize new Git repositories with proper identity and authentication configuration:

```fish
git-setup
```

This command prompts for and configures:
- **Git identity**: user.name and user.email for commits
- **Signing key**: SSH key for commit signing (optional)
- **SSH identity**: Creates and configures SSH key files for authentication
- **Remote repository**: Sets up origin remote URL

The function automatically:
1. Initializes a new Git repository
2. Creates `~/.ssh/{identity}.pub` files with proper permissions
3. Configures `core.sshCommand` to use the public key for authentication
4. Sets up the remote origin URL

### SSH Authentication with Public Key and SSH Agent

This setup uses a unique SSH authentication workflow that leverages SSH Agent for enhanced security:

```
┌─────────┐    ┌─────────────────┐    ┌─────────────┐    ┌─────────────────┐    ┌─────────┐
│   Git   │───>│ SSH -i key.pub  │───>│ SSH Agent   │───>│ Bitwarden Agent │───>│ GitHub  │
│         │    │                 │    │ Lookup      │    │ User Approval   │    │         │
│ Command │    │ Public Key ID   │    │ Private Key │    │ Required        │    │ Auth    │
└─────────┘    └─────────────────┘    └─────────────┘    └─────────────────┘    └─────────┘
```

**Workflow Details:**

1. **Git initiates SSH connection** using `core.sshCommand` with `-i` pointing to a `.pub` file
2. **SSH uses the public key** as an identifier to locate the corresponding private key
3. **SSH Agent lookup** finds the matching private key in the agent's key store
4. **Bitwarden SSH Agent** requires explicit user authentication/approval
5. **Authentication completes** to the remote Git repository (GitHub, GitLab, etc.)

**Configuration Example:**
```bash
git config --local core.sshCommand "ssh -i ~/.ssh/github_username.pub -o IdentitiesOnly=yes"
```

**Important Notes:**
- Public key files (`.pub`) must have `600` permissions in this workflow to avoid SSH warnings
- This approach provides enhanced security by requiring explicit approval for each authentication
- The SSH Agent must be running and contain the corresponding private key
- Bitwarden SSH Agent integration requires user interaction for each authentication attempt

**Security Benefits:**
- No private keys stored in Git configuration
- Explicit approval required for each repository access
- SSH Agent manages key security and access
- Identity separation per repository/project

## Dependencies

The tools listed here are required to execute these scripts and are not part of the Shell they're intended to execute in.
EG: `coreutils` tools like `ln` for symlinking are not part of Bash, ZSH or Fish, but required to run the `./install.sh` script.

### Tool Categories by Installation Method

This section categorizes all tools referenced in the shell configurations and installation scripts by how they should be installed for cross-platform compatibility.

<details>
<summary>uutils-coreutils (Cross-Platform via Homebrew) (click to expand)</summary>

These are core Unix utilities reimplemented in Rust. Install via Homebrew to ensure consistent behavior across macOS and Linux:

```bash
brew install uutils-coreutils
```

**Tools from uutils-coreutils used in this repository:**
- `ls` - list directory contents
- `rm` - remove files/directories
- `mv` - move/rename files
- `cp` - copy files
- `df` - report file system disk space usage
- `du` - estimate file space usage
- `stat` - display file/filesystem status
- `ln` - create links between files
- `chmod` - change file mode bits
- `mkdir` - create directories
- `find` - search for files in directory hierarchy
- `cat` - concatenate files and print (optionally replaced by `bat`)

**Complete list of uutils-coreutils tools:**
arch, b2sum, base32, base64, basename, basenc, cat, chcon, chgrp, chmod, chown, chroot, cksum, comm, cp, csplit, cut, date, dd, df, dir, dircolors, dirname, du, echo, env, expand, expr, factor, false, fmt, fold, groups, head, hostid, hostname, id, install, join, kill, link, ln, logname, ls, md5sum, mkdir, mkfifo, mknod, mktemp, mv, nice, nl, nohup, nproc, numfmt, od, paste, pathchk, pinky, pr, printenv, printf, ptx, pwd, readlink, realpath, rm, rmdir, runcon, seq, sha1sum, sha224sum, sha256sum, sha384sum, sha512sum, shred, shuf, sleep, sort, split, stat, stdbuf, stty, sum, sync, tac, tail, tee, test, timeout, touch, tr, true, truncate, tsort, tty, uname, unexpand, uniq, unlink, uptime, users, vdir, wc, who, whoami, yes

**Note on compatibility:**
- uutils-coreutils supports both GNU-style long flags and BSD/POSIX short flags
- To maintain cross-platform compatibility, prefer POSIX short flags in shell aliases

</details>

<details>
<summary>System Native (Platform Dependent) (click to expand)</summary>

These tools are typically provided by the operating system but may have different flags/behavior between macOS (BSD) and Linux (GNU):

**Version Control:**
- `git` - distributed version control system (install latest via Homebrew)

**Process Management:**
- `ps` - process status (BSD vs GNU syntax differs)
- `uname` - print system information

**Note:** While these exist on most systems, consider installing via Homebrew for consistency.

</details>

<details>
<summary>Third-Party Tools (Homebrew) (click to expand)</summary>

Modern CLI tools that enhance or replace standard utilities:

**Shell Enhancements:**
- `bat` - cat clone with syntax highlighting (replaces `cat` when available)
- `lla` - modern file explorer with multiple views, plugins, and Git integration
- `zoxide` - smarter cd command that learns your habits
- `ugrep` - ultra-fast grep with interactive TUI and fuzzy search
- `tree` - directory tree visualization

**Shells:**
- `bash` - GNU Bash shell (install via Homebrew for latest version)
- `fish` - friendly interactive shell
- `zsh` - Z shell with advanced features

**Development Tools:**
- `delta` - syntax-highlighting pager for git/diff
- `difftastic` - structural diff tool
- `gh` - GitHub CLI
- `jj` - Jujutsu version control
- `lazygit` - terminal UI for git
- `helix` - modern modal text editor
- `vim` - classic text editor

**System Utilities:**
- `btop` - system resource monitor
- `fd` - user-friendly find alternative
- `fzf` - fuzzy finder for command-line
- `tealdeer` - fast tldr client
- `tmux` - terminal multiplexer
- `wget` - network downloader
- `xh` - friendly HTTP client

See the [Recommended Tools](#recommended-tools) section for the complete list and installation commands.

</details>

<details>
<summary>Installation Scripts Dependencies (click to expand)</summary>

**Required for `install.sh`:**
- `bash` - script interpreter
- `find` - locate files (uutils-coreutils)
- `ln` - create symbolic links (uutils-coreutils)
- `mkdir` - create directories (uutils-coreutils)
- `chmod` - change permissions (uutils-coreutils)
- `cp` - copy files (uutils-coreutils)
- `stat` - file statistics (uutils-coreutils or platform-specific)
- `realpath` - resolve path (uutils-coreutils)
- `dirname` - directory name (uutils-coreutils)

**Platform-specific considerations:**
- `stat` command syntax differs: GNU uses `-c %a`, macOS BSD uses `-f %A`
- Install uutils-coreutils to ensure consistent behavior

</details>

## Recommended Tools

<details>
<summary>Tools I recommend checking out (click to expand)</summary>

**Shells:**
* [bash](https://github.com/bminor/bash): GNU Bash is a powerful command-line interpreter and shell that implements the POSIX shell specification with interactive features, job control, and extensive customization options.
* [fish](https://github.com/fish-shell/fish-shell): The user-friendly command line shell.
* [zsh](https://github.com/ohmyzsh/ohmyzsh): Oh My Zsh is an open-source, community-driven framework for managing your Zsh configuration, enhancing your terminal with plugins and themes.

**Completions:**
* [carapace](https://github.com/carapace-sh/carapace): Carapace is a command argument completion generator that supports a wide range of shells, including Bash, Fish, Zsh, and Powershell.

**Version control:**
* [delta](https://github.com/dandavison/delta): A syntax-highlighting pager for git, diff, and grep output.
* [difftastic (`difft`)](https://github.com/Wilfred/difftastic): A structural diff that understands syntax.
* [gh](https://github.com/cli/cli): The GitHub CLI (`gh`) brings GitHub concepts like pull requests and issues to the terminal, integrating seamlessly with Git and your code.
* [git](https://github.com/git/git): Git is a fast, scalable, distributed revision control system with a rich command set for high-level operations and internal access.
* [jj](https://github.com/jj-vcs/jj): Jujutsu is a version control system designed for ease of use, abstracting its UI and algorithms from storage systems, and is compatible with Git repositories.
* [lazygit](https://github.com/jesseduffield/lazygit): A simple terminal UI for git commands, providing an intuitive interface for common git operations.

**Terminal editors:**
* [helix](https://github.com/helix-editor/helix): Helix is a Kakoune/Neovim inspired modal text editor written in Rust, featuring multiple selections and built-in language server support.
* [vim](https://github.com/vim/vim): Vim is a highly configurable text editor built to enable efficient text editing, offering features like multi-level undo, syntax highlighting, and a powerful scripting language.

**Container utils:**
* [talosctl](https://github.com/siderolabs/talos): Talos is a modern, secure, immutable, and minimal operating system designed specifically for running Kubernetes, managed entirely via an API.
* [podman](https://github.com/containers/podman): Podman is a tool for managing containers and images, volumes, and pods, offering a Docker-compatible CLI and a daemonless architecture for enhanced security and efficiency.
* [podman-compose](https://github.com/containers/podman-compose): Podman Compose is an implementation of the Compose Specification that uses Podman as its backend, focusing on rootless and daemon-less operation.
* [lazydocker](https://github.com/jesseduffield/lazydocker): A simple terminal UI for Docker and Docker Compose, written in Go with the gocui library.
* [kubectx](https://github.com/ahmetb/kubectx): Faster way to switch between clusters and namespaces in kubectl.
* [fubectl](https://github.com/kubermatic/fubectl): Reduces repetitive interactions with kubectl.
* [k9s](https://github.com/derailed/k9s): K9s is a terminal UI to manage Kubernetes clusters, making it easier to navigate, observe, and manage applications with continuous resource watching and command interaction.
* [stern](https://github.com/stern/stern): Multi pod and container log tailing for Kubernetes.

**Terminal utilities:**
* [bat](https://github.com/sharkdp/bat): bat is a cat(1) clone with syntax highlighting and Git integration, enhancing the command-line experience for viewing code and text files.
* [btop](https://github.com/aristocratos/btop): Btop is a modern, command-line system resource monitor written in C++20, offering features like CPU, memory, disk, and network usage monitoring with GPU support.
* [caligula](https://github.com/ifd3f/caligula): A user-friendly, lightweight TUI for imaging disks.
* [dysk](https://github.com/Canop/dysk): A linux utility to get information on filesystems, like df but better.
* [fd](https://github.com/sharkdp/fd): fd is a simple, fast, and user-friendly alternative to find, designed for intuitive filesystem searching with sensible defaults and parallelized directory traversal.
* [fzf](https://github.com/junegunn/fzf): fzf is a general-purpose command-line fuzzy finder, an interactive filter program for any kind of list with a fuzzy matching algorithm for quick pattern typing.
* [lla](https://github.com/chaqchase/lla): A modern, fast terminal file explorer with multiple views, plugins, and Git integration
* [jqp](https://github.com/noahgorstein/jqp): A TUI playground for exploring jq.
* [lf](https://github.com/gokcehan/lf): lf (as "list files") is a terminal file manager written in Go with a focus on performance.
* [scooter](https://github.com/mjrusso/scoot): Scoot is a macOS utility that provides fast, keyboard-driven control over the mouse pointer, enabling cursor teleportation and actuation through element-based or grid-based navigation.
* [tealdeer (`tldr`)](https://github.com/dbrgn/tealdeer): A very fast implementation of tldr in Rust.
* [tmux](https://github.com/tmux/tmux): tmux is a terminal multiplexer that allows multiple terminal sessions to be accessed and controlled from a single screen, enabling session persistence and detachment.
* [uutils-coreutils](https://github.com/uutils/coreutils): Cross-platform Rust rewrite of the GNU coreutils.
* [ugrep](https://github.com/Genivia/ugrep): ugrep: ultra fast grep with interactive TUI, fuzzy search, boolean queries, hexdumps and more.
* [wget](https://github.com/mirror/wget): GNU Wget is a free utility for non-interactive download of files from the Web.
* [xh](https://github.com/ducaale/xh): xh is a user-friendly and performant command-line tool for making HTTP requests, inspired by HTTPie and focused on speed.
* [xz](https://github.com/tukaani-project/xz): XZ Utils is free general-purpose data compression software with a high compression ratio.
* [zoxide (`z`)](https://github.com/ajeetdsouza/zoxide): zoxide is a smarter cd command that remembers your frequently used directories, allowing you to jump to them with fewer keystrokes across all major shells.

</details>

<details>
<summary>Homebrew Quick Install (click to expand)</summary>

```bash
### shells - even reinstall tools like Bash because they are more up to date
brew install \
  bash \
  fish \
  zsh \

### completions
brew install \
  carapace

### version control
brew install \
  delta \
  difftastic \
  gh \
  git \
  jj \
  lazygit

### terminal editors
brew install \
  helix \
  vim

### container utils
brew install \
  siderolabs/tap/talosctl \
  podman \
  podman-compose \
  lazydocker \
  kubectx \
  fubectl \
  derailed/k9s/k9s \
  stern

### terminal utilities
brew install \
  bat \
  btop \
  philocalyst/tap/caligula \
  dysk \
  fd \
  fzf \
  lla \
  jqp \
  lf \
  scooter \
  tealdeer \
  tmux \
  uutils-coreutils \
  ugrep \
  wget \
  xh \
  xz \
  zoxide
```

</details>

### Philosophy on Tools

I have grown to like simple software. These resources have been useful in discovering more in this space:

* [Suckless (software that sucks less)](https://suckless.org/philosophy/): Home of dwm, dmenu and other quality software with a focus on simplicity, clarity, and frugality.
* [harm-less](https://github.com/173duprot/harm-less/): Inspired by suckless and cat-v, this is a simple single document wiki of suckless practices and minimal software.

## TODO

Things to improve:

* complete git clone wrapper scripts
  * ask for identity & signing configuration
  * perform the clone
  * set the local git configuration to use the previously captured metadata
* document how Git setup works
  * wrapper scripts
* document how SSH setup works for Git Identity & Signing management
* mirror the `.config/fish/functions/prettify.fish` script for Bash & ZSH (probably should just rely on using dockerfiles of `sh`, `shfmt` & `shellcheck`)
* mirror the Fish prompt configuration in Bash
* ZSH support
  * point ZSH to utilise all the Bash configuration & scripts (eg: `.config/bash/**`). Is this as simple as changing ZDOTDIR to `XDG_CONFIG_HOME/bash`?
  * mirror the Fish prompt configuration in ZSH (if I cannot use the Bash configuration for the prompt)
  * set ZSH specific rules (eg: option for "CORRECT")
* complete Dependencies section (list of tools)

## Contributions

Welcome! Send PRs!

## Licence

```
Zero-Clause BSD
=============

Permission to use, copy, modify, and/or distribute this software for
any purpose with or without fee is hereby granted.

THE SOFTWARE IS PROVIDED “AS IS” AND THE AUTHOR DISCLAIMS ALL
WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE
FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY
DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT
OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```
