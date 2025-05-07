# Dotfiles
>symlink-free dotfiles using the *`$HOME` as the `git work-tree`* technique

Used daily on macOS & [BluefinDX](https://projectbluefin.io/)/[Bazzite](https://bazzite.gg/)/[BazziteDX](https://dev.bazzite.gg/) Fedora Linux systems.

## Contents

* [Quickstart](#quickstart)
	* [Manual post-clone steps](#manual-post-clone-steps)
* [Longstart](#longstart)
* [Tips](#tips)
* [Tools](#tools)
* [Git Conditional Configuration](#git-conditional-configuration)
* [Creating your own git work-tree dotfiles repository](#creating-your-own-git-work-tree-dotfiles-repository)
* [Licence](#licence)

## Quickstart

1. Clone the bare repository (this stores the Git history without checking out files yet):
	```shell
	git clone --bare https://github.com/jthegedus/dotfiles.git "$HOME/.dotfiles.git"
	```
2. Define a temporary alias for interacting with the dotfiles repo:
	```shell
	alias dotfiles='git --git-dir="$HOME/.dotfiles.git/" --work-tree="$HOME"'
	```
3. Attempt to checkout the files:
	```shell
	dotfiles checkout
	```
4. Handle Conflicts: If the `checkout` command fails due to existing files you can perform one of two actions:
	* a) Backup existing files and replace (recommended):
		```shell
		# eg: backup the existing .config directory and git checkout
		mv ~/.config ~/.config.bak
		dotfiles checkout
		```
		Repeat the above for any other reported conflicting folders/files.
	* b) Overwrite existing files with force checkout:
		```shell
		dotfiles checkout -f
		```

5. Configure the repository to ignore other untracked files in `$HOME`:
	```shell
	dotfiles config --local status.showUntrackedFiles no
	```

This creates the following files in your `$HOME` directory:

```shell
# in $HOME
.config/*       <-- most configuration files live here
.dotfiles/      <-- template files for this repo
.dotfiles.git/  <-- git dir for this repo
.gitconfig      <-- shared git config file
.gitconfig.ssh  <-- created from .dotfiles/*.template
.gitconfig.user <-- created from .dotfiles/*.template
README.md       <-- this repo README
.zshenv         <-- tell ZSH to look at ~/.config/zsh/*
```

### Manual post-clone steps

* Setup Git User:
	* `cp ~/.dotfiles/.gitconfig.user.template ~/.gitconfig.user` and fill out the `name` and `email` properties in `~/.gitconfig.user`
	* If you wish to use SSH with Git then:
		* `cp ~/.dotfiles/.gitconfig.ssh.template ~/.gitconfig.ssh`
		* Then fill out the `signingkey` properties in `~/.gitconfig.ssh`, otherwise remove the `includeIf` from `~/.gitconfig`
		* Create and Store an SSH key and use for Authentication/Commit-Signing in GitHub
		* I recommend using [BitWarden or an equivalent as an SSH Agent](https://bitwarden.com/help/ssh-agent/) for secure storage and ease of use.
* Install tools in `.config/brewfile/Brewfile*` using [Homebrew](https://brew.sh/) and [Homebrew File](https://github.com/rcmdnk/homebrew-file/):
	* `brew install rcmdnk/file/brew-file`
	* `brew file install`

## Longstart

* Fork this repository
* Modify the contents using the in-browser GitHub edit & commit capabilities
* Remove the SSH git configuration if you do not wish to use SSH
* Clone the repository to your machine from your own Fork
* Follow the above [Manual post-clone steps](#manual-post-clone-steps) instructions

## Tips

* I recommend using Fish over ZSH. ZSH configuration is here for convenience but I am considering dropping maintenance of it.
* Fork and modify this repository instead of cloning it directly.
	* Files that may require modification are:
		* `.zshenv`
		* `.config/brewfile/Brewfile*`
* Instead of using branching codepaths in your scripts for system-specific configurations you could use *git branches* to manage a copy for each system, with common/shared configuration in the master branch.
	* You would have to merge the common/shared configuration into the other branches on change.

## Tools

I use [Development Containers](https://containers.dev/) in most projects to manage project-specific dependencies. This keeps my OS installation relatively clean. Since devcontainers can mount your home directory, this repository contains some configuration files for tooling I commonly use within devcontainers that may not appear on my machine and therefore Brewfile.

The list of tools I use as a base on each system/OS are:

* [fish](https://fishshell.com/): shell
* [git](https://git-scm.com/): source control
* [carapace](https://carapace.sh/): terminal completions
* [macchina](https://github.com/Macchina-CLI/macchina): terminal util
* [starship](https://starship.rs/): terminal prompt
* [ghostty](https://ghostty.org/): terminal
* [visual studio code](https://code.visualstudio.com/): code editor (use vscode native settings sync)
* [zed](https://zed.dev/): code editor

## Git Conditional Configuration

I use the `.gitconfig` conditional `includeIf` directive to manage sensitive settings in a separate configuration file to the ones committed to this repository (see the `.dotfiles/` directory for an example). Sharing dotfiles across personal and work computers with the sensitive user configuration defined independently is useful.

The `includeIf` directive in Git configuration files (`.gitconfig`) allow conditionally including settings from other configuration files. The conditions can be:

* `gitdir:<pattern>`: Matches if the Git directory path matches the pattern, useful for applying settings to projects in specific locations (e.g., `~/work/`).
* `onbranch:<branch-name-pattern>`: Matches if the current branch name matches the pattern, useful for branch-specific workflows or settings.
* `hasconfig:remote.<name>.url:<pattern>`: Matches if a remote's URL matches the pattern, useful for loading different user configs for work vs. personal projects or different Git platforms.

See the documentation for full explanations - https://git-scm.com/docs/git-config#_conditional_includes

As an example:

```properties
[includeIf "gitdir:~/"]
	path = ~/.gitconfig.user
```

This includes the specified configuration file if the repository you are running `git` commands against ( where the `.git` directory is) matches the provided pattern.

Another useful pattern is conditionally override git config settings with further deeply-nested `.gitconfig` files and only apply them when in the directory defined by the `includeIf` directive.

## Creating your own git work-tree dotfiles repository

Here is a quick guide to creating your own bare repository for dotfiles using the `$HOME` as the `git work-tree` technique:

* create a bare repository
* set a temporary alias to use the bare repository (you should add this alias to your shell config as well for future use)
* set the repo to ignore all untracked files (using our alias "dotfiles")
* set the remote origin to your GitHub (or other) repository

```shell
git init --bare $HOME/.dotfiles.git
alias dotfiles='git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
dotfiles remote add origin git@github.com:<username>/<repo>.git
```

Now add any of your existing `.config` files, track with `git` & push:

```shell
cd $HOME
dotfiles add .config/starship.toml
dotfiles status
dotfiles commit -m "feat: capture starship configuration"
dotfiles push
```

For more examples and inspiration see the [HackerNews post](https://news.ycombinator.com/item?id=11070797) where I learnt about this technique.

NB: The `dotfiles` alias is a temporary alias for the current shell session. I include it in my Fish & ZSH configuration files in this repository as a permanent way to quickly interact with my dotfiles repository.

NB: Even though all files are untracked thanks to the `status.showUntrackedFiles no` setting, I still recommend using `.gitignore` files when the configuration you wish to include is in a directory with other files you do not wish to include. This is purely a precautionary measure to avoid accidents. Though allow-listing files in `.gitignore` is a recommended practice.

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
