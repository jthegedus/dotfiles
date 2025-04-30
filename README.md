# Dotfiles
>symlink-free dotfiles using the *`$HOME` as the `git work-tree`* technique

## Quickstart

Clone to your system with https:

```shell
git clone --separate-git-dir="$HOME/.dotfiles.git" https://github.com/jthegedus/dotfiles.git "$HOME"
```

### Manual post-clone steps

* Create and Store an SSH key and use for Authentication/Commit-Signing in GitHub. I recommend using [BitWarden or an equivalent as an SSH Agent](https://bitwarden.com/help/ssh-agent/) for secure storage and ease of use.
* Run `cp ~/.dotfiles/.gitconfig.user.template ~/.gitconfig.user` to scaffold the git user file for defining `name`, `email` and ssh `signingkey`. Edit this new file with your settings.

## Longstart

* Fork this repository
* Modify the contents using the in-browser GitHub edit & commit capabilities
* Remove the SSH git configuration if you do not wish to use SSH
* Clone the repository to your machine from your own Fork
* Follow the above [Manual post-clone steps](#manual-post-clone-steps) instructions

## Tips

* Fork and modify this repository instead of cloning it directly.
* Instead of using branching codepaths in your scripts for system-specific configurations you could use *git branches* to manage a copy for each system, with common/shared configuration in the master branch.
    * You would have to merge the common/shared configuration into the other branches on change.

## Tools

I use [Development Containers](https://containers.dev/) in most projects to manage project-specific dependencies. This keeps my OS installation relatively clean. Since devcontainers can mount your home directory, this repository contains some configuration files for tooling I commonly use within devcontainers that may not appear on my machine and therefore Brewfile.

The list of tools I use as a base on each system/OS are:

* [fish](https://fishshell.com/): shell
* [ghostty](https://ghostty.org/): terminal
* [git](https://git-scm.com/): source control
* [macchina](https://github.com/Macchina-CLI/macchina): terminal util
* [starship](https://starship.rs/): terminal prompt
* [visual studio code](https://code.visualstudio.com/): code editor (use vscode native settings sync)
* [zed](https://zed.dev/): code editor

<details>
<summary>Notable Files</summary>

```
.config/
    ...         <-- most configuration files live here
.dotfiles/
    .gitconfig.user.template
    README.md
.gitconfig
.gitconfig.user <-- created from .gitconfig.user.template
                    & imported by .gitconfig
```

</details>

## Git Conditional Configuration

I use the `.gitconfig` conditional `includeIf` directive to manage sensitive settings in a separate configuration file to the ones committed to this repository. Sharing dotfiles across personal and work computers with the sensitive user configuration defined independently is useful.

The `includeIf` directive in Git configuration files (`.gitconfig`) allow conditionally including settings from other configuration files. The conditions can be:

* `gitdir:<pattern>`: <!-- TODO: descirbe -->
* `onbranch:<branch-name-pattern>`: <!-- TODO: descirbe -->
* `hasconfig:remote.<name>.url:<pattern>`: <!-- TODO: descirbe -->

See the documentation for full explanations - https://git-scm.com/docs/git-config#_conditional_includes

As an example:

```properties
[includeIf "gitdir:~/"]
	path = ~/.gitconfig.user
```

This includes the specified configuration file if the repository you are running `git` commands against ( where the `.git` directory is) matches the provided pattern.

Another useful pattern is conditionally override git config settings with further deeply-nested `.gitconfig` files and only apply them when in the directory defined by the `includeIf` directive.

## Creating your own git work-tree dotfiles repository

<!-- TODO: inline the steps here -->
create bare repo `git init --bare $HOME/.dotfiles.git`
set alias `alias dotfiles='/usr/local/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'`
set the repo to ignore all untracked files (using our alias "dotfiles"): `dotfiles config --local status.showUntrackedFiles no`
set the remote: `dotfiles remote add origin git@github.com:jthegedus/dotfiles.git`
now add files:

```
cd $HOME
dotfiles add .config/starship.toml
dotfiles status
dotfiles commit -m "feat: capture starship configuration"
dotfiles push
```

Source: [this HackerNews post](https://news.ycombinator.com/item?id=11070797) which was in response to "Ask HN: What do you use to manage dotfiles?".

## Licence

<details>
<summary>0BSD</summary>

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

</details>
