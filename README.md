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
<summary>Core Tools</summary>

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
  ````
  git clone git@github.com:jthegedus/dotfiles.git ~/dev/dotfiles
  ```
* Symlink everything:
  ```
  bash ./install.sh
  ```

<details>
<summary>Use in DevContainers</summary>

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

## Configuration Features

- Auto-updating dotfiles: Automatically pulls repository updates once per day
- SSH agent integration: Bitwarden SSH agent configuration for both macOS and Linux
- Environment configuration: Shell identification and XDG Base Directory compliance for proper configuration directories
- Git aliases: Convenient shortcuts for common git operations
- Navigation aliases: Quick directory navigation shortcuts

## Dependencies

The tools listed here are required to execute these scripts and are not part of the Shell they're intended to execute in.
EG: `coreutils` tools like `ln` for symlinking are not part of Bash, ZSH or Fish, but required to run the `./install.sh` script.

<details>
<summary>System Tools Required by Shell Scripts</summary>

<!-- TODO: populate this list -->
* (in progress)

</details>

## Recommended Tools

<details>
<summary>Tools I recommend checking out</summary>

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
* [caligula](https://github.com/philocalyst/caligula): A terminal-based system monitoring tool.
* [dysk](https://github.com/Canop/dysk): A linux utility to get information on filesystems, like df but better.
* [fd](https://github.com/sharkdp/fd): fd is a simple, fast, and user-friendly alternative to find, designed for intuitive filesystem searching with sensible defaults and parallelized directory traversal.
* [fzf](https://github.com/junegunn/fzf): fzf is a general-purpose command-line fuzzy finder, an interactive filter program for any kind of list with a fuzzy matching algorithm for quick pattern typing.
* [g-ls (`g`)](https://github.com/voidint/g): g is a command-line tool for Linux, macOS, and Windows that simplifies managing and switching between multiple Go environment versions.
* [jqp](https://github.com/noahgorstein/jqp): A TUI playground for exploring jq.
* [lf](https://github.com/gokcehan/lf): lf (as "list files") is a terminal file manager written in Go with a focus on performance.
* [scooter](https://github.com/mjrusso/scoot): Scoot is a macOS utility that provides fast, keyboard-driven control over the mouse pointer, enabling cursor teleportation and actuation through element-based or grid-based navigation.
* [tealdeer (`tldr`)](https://github.com/dbrgn/tealdeer): A very fast implementation of tldr in Rust.
* [uutils-coreutils](https://github.com/uutils/coreutils): Cross-platform Rust rewrite of the GNU coreutils.
* [ugrep](https://github.com/Genivia/ugrep): ugrep: ultra fast grep with interactive TUI, fuzzy search, boolean queries, hexdumps and more.
* [wget](https://github.com/mirror/wget): GNU Wget is a free utility for non-interactive download of files from the Web.
* [xh](https://github.com/ducaale/xh): xh is a user-friendly and performant command-line tool for making HTTP requests, inspired by HTTPie and focused on speed.
* [xz](https://github.com/tukaani-project/xz): XZ Utils is free general-purpose data compression software with a high compression ratio.
* [zoxide (`z`)](https://github.com/ajeetdsouza/zoxide): zoxide is a smarter cd command that remembers your frequently used directories, allowing you to jump to them with fewer keystrokes across all major shells.

</details>

<details>
<summary>Homebrew Quick Install</summary>

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
  jj

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
  g-ls \
  jqp \
  lf \
  scooter \
  tealdeer \
  uutils-coreutils \
  ugrep \
  wget \
  xh \
  xz \
  zoxide
```

</details>

## TODO

Things to improve:

* fix the issue where the update function results in the shell session starting in this repository's `.config/fish/functions` directory
* mirror the `.config/fish/functions/prettify.fish` script for Bash & ZSH (probably should just rely on using dockerfiles of `sh`, `shfmt` & `shellcheck`)
* mirror the Fish prompt configuration in Bash
* ZSH support
  * point ZSH to utilise all the Bash configuration & scripts (eg: `.config/bash/**`). Is this as simple as changing ZDOTDIR to `XDG_CONFIG_HOME/bash`?
  * mirror the Fish prompt configuration in ZSH (if I cannot use the Bash configuration for the prompt)
  * set ZSH specific rules (eg: option for "CORRECT")

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
