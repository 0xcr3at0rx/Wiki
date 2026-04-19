# Collection of Scripts

A curated collection of lightweight, terminal-based shell scripts to enhance your command-line experience. Designed to be fast, minimal, and easy to use straight out of the box.

## Dependencies

The scripts in this collection primarily rely on standard POSIX tools, along with a few common utilities:

- `curl`
- `jq`
- `fzf`
- `less`
- `yt-dlp`
- `mpv`
- `chafa` (optional, for thumbnails)
- `xclip`, `wl-copy`, or `pbcopy` (optional, for clipboard support)

### Installing Dependencies

<details>
<summary>Alpine Linux</summary>

```sh
apk add curl jq fzf less yt-dlp mpv chafa
```
</details>

<details>
<summary>Void Linux</summary>

```sh
xbps-install -S curl jq fzf less yt-dlp mpv chafa
```
</details>

<details>
<summary>Arch Linux</summary>

```sh
pacman -S curl jq fzf less yt-dlp mpv chafa
```
</details>

<details>
<summary>Debian / Ubuntu</summary>

```sh
apt install curl jq fzf less yt-dlp mpv chafa
```
</details>

<details>
<summary>Fedora</summary>

```sh
dnf install curl jq fzf less yt-dlp mpv chafa
```
</details>

<details>
<summary>macOS (Homebrew)</summary>

```sh
brew install curl jq fzf yt-dlp mpv chafa
```
</details>

## Installation

To install all scripts in the `scripts/` directory to your system:

```sh
git clone https://github.com/0xcr3at0rx/Wiki
cd Wiki
sudo ./install.sh # or doas ./install.sh
```

By default, scripts are installed to `/usr/local/bin`. You can customize the target directory by setting the `PREFIX` environment variable:

```sh
PREFIX=~/.local/bin ./install.sh
```

### Using Nix

<details>
<summary>Nix Instructions</summary>

Run a script without installing it permanently:

```sh
nix run github:0xcr3at0rx/Wiki -- <script_name> <arguments>
```

Enter a shell with the scripts available:

```sh
nix shell github:0xcr3at0rx/Wiki
<script_name> <arguments>
```

Install to your current profile:

```sh
nix profile add github:0xcr3at0rx/Wiki
```

Add to your NixOS or Home-Manager configuration:

```nix
inputs.scripts.url = "github:0xcr3at0rx/Wiki";

# Then include this in your packages
inputs.scripts.packages.${system}.default
```
</details>

## Usage

Once installed, you can run any of the provided scripts directly from your terminal. 

```sh
<script_name> [options] <arguments>
```

*(Note: Refer to individual scripts for specific usage instructions.)*

## License

This project is licensed under the [GPL-v3](LICENSE) License.
