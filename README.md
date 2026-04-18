## Wiki


Wiki is a POSIX shell script for searching Wikipedia without the hassle of opening a web browser because it lives in your terminal. It has fuzzy searching, disambiguation page handling, and is lightweight all out of the box

## Dependencies

<details>
<summary>Alpine</summary>

```sh
apk add curl jq fzf less
```
</details>

<details>
<summary>Void Linux</summary>

```sh
xbps-install -S curl jq fzf less
```
</details>

<details>
<summary>Arch</summary>

```sh
pacman -S curl jq fzf less
```
</details>

<details>
<summary>Debian/Ubuntu</summary>

```sh
apt install curl jq fzf less
```
</details>

<details>
<summary>Fedora</summary>

```sh
dnf install curl jq fzf less
```
</details>

<details>
<summary>macOS (Homebrew)</summary>

```sh
brew install curl jq fzf
```
</details>


## Installation

```sh
git clone https://github.com/0xcr3at0rx/Wiki
cd Wiki
doas/sudo cp wiki /usr/local/bin/wiki
```

<details>
<summary>
Using Nix
</summary>

Run without installing:

```sh
nix run github:0xcr3at0rx/Wiki -- <search query>
# or
nix shell github:0xcr3at0rx/Wiki
wiki <search query>
```

Install:
```sh
nix profile add github:0xcr3at0rx/Wiki
```

Or add to your NixOS/Home-Manager configuration:

```nix
inputs.wiki.url = "github:0xcr3at0rx/Wiki";
# then include this in your packages
inputs.wiki.packages.${system}.wiki
```
</details>


## Usage

```sh
wiki <search query>
```
## License

GPL-v3


