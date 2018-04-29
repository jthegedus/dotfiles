# Dev Tools - Manual Guide

Instructions to install the setup I use.

## OS level dependencies

```shell
sudo apt install git curl automake autoconf libreadline-dev libncurses-dev \
libssl-dev libyaml-dev libxslt-dev libffi-dev libtool unixodbc-dev -y
```

[asdf](https://github.com/asdf-vm/asdf) for language management:

```shell
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.4.3
```

<details>
<summary>git</summary>

```markdown
# git config --global user.name john
git config --global user.name <username>

# git config --global user.email john@gmail.com
git config --global user.email <email>

# git config --global core.editor code
git config --global core.editor <editor>
```

</details>

## Language/Tool level dependencies

<details>
<summary>Nodejs</summary>

```markdown
# plugin

asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git

# nodejs release keyring

bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring

# nodejs LTS

asdf install nodejs 8.10.0

# set as global default

asdf global nodejs 8.10.0
```

</details>

<details>
<summary><a href="https://yarnpkg.com/en/docs/install">Yarn</a></summary>

```markdown
# add sources

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

# remove cmdtest (Ubuntu 18.04)

sudo apt remove cmdtest

# update sources

sudo apt-get update

# install yarn

sudo apt-get install yarn -y
yarn --version
```

add to `.*rc`

```shell
PATH="$PATH:/opt/yarn-[version]/bin"
PATH="$PATH:$(yarn global bin)"
export PATH
```

</details>

<details>
<summary><a href="https://github.com/koalaman/shellcheck#installing">Shellcheck</a></summary>

```shell
sudo apt install shellcheck -y
```

</details>

<details>
<summary>Python</summary>

```markdown
# deps

sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev -y

# plugin

asdf plugin-add python https://github.com/tuvistavie/asdf-python.git

# install python

asdf install python 3.6.0

# set as global default

asdf global python 3.6.0
```

**pip on python3**

assuming python 3 is installed and currently selected:

```
curl -O https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py --user
```

</details>

<details>
<summary>Java</summary>

```markdown
# plugin

asdf plugin-add java https://github.com/skotchpine/asdf-java

# latest java version

asdf install java 10.0.1

# set as global default

asdf global java 10.0.1
```

Note: Maven & Gradle installed separately.

</details>

<details>
<summary>Other langs</summary>

By now you surely get the idea for [setting up another lang or tool](https://github.com/asdf-vm/asdf-plugins) with [asdf](https://github.com/asdf-vm/asdf).

</details>

## Tools (depending on the now installed languages)

**[trash-cli](https://github.com/sindresorhus/trash-cli)**

```shell
yarn global add trash-cli
```

ensure `alias rm=trash` is in your `.bashrc` or `.zshrc`.

## Terminal mastery

**[z](https://github.com/rupa/z) - terminal nav via fuzzy finding [frecency](https://en.wikipedia.org/wiki/Frecency)**

```markdown
cd ~ && wget https://raw.githubusercontent.com/rupa/z/master/z.sh
```

ensure `source "$HOME/z.sh"` is in your `.bashrc` or `.zshrc`.

**[fzf](https://github.com/junegunn/fzf#using-git) - terminal command fuzzy finder**

```markdown
# download

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf

# install

~/.fzf/install
```