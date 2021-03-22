#!/usr/bin/env zsh

zstyle ':completion:*' menu select
zstyle ':completion:*' verbose yes
zstyle ':completion:*' file-patterns '%p(D):globbed-files *(D-/):directories' '*(D):all-files'
