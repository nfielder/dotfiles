# nfielder's Dotfiles

Managed using [chezmoi](https://github.com/twpayne/chezmoi).

## Install

To install, run the following command:

```shell
chezmoi init nfielder
```

## Notes

### Fonts

After downloading fonts (via .chezmoiexternal.toml), the font cache needs updating using:

```shell
fc-cache -v
```

### asdf

`asdf` is used as a tool for installing versions of various binaries.

~~Do not install `fzf` from here! As of Feb 2025,`asdf` v0.16.0 and `fzf` were not playing nicely together. The ZSH keybinds for history, moving directories etc. was broken. As a workaround, install `fzf` using the system package manager or directly from GitHub Releases.~~ As of `asdf` v0.16.2, it appears the `fzf` issues relating to keybinds has been fixed. See commit [3525e9ed](https://github.com/asdf-vm/asdf/commit/3525e9ed4edb05f15a15f00378f5336ef29aa2f4) for more information.
