# nfielder's Dotfiles

Managed using [chezmoi](https://github.com/twpayne/chezmoi).

## Install

To install, run the following command:
```shell
chezmoi init nfielder
```

## Notes

After downloading fonts (via .chezmoiexternal.toml), the font cache needs updating using:
```shell
fc-cache -v
```

`asdf` is used as a tool for installing versions of various binaries. Do not install `fzf` from here! As of Feb 2025,`asdf` v0.16.0 and `fzf` were not playing nicely together. The ZSH keybinds for history, moving directories etc. was broken. As a workaround, install `fzf` using the system package manager or directly from GitHub Releases.
