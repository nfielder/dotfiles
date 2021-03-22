#!/usr/bin/env zsh

zstyle ':completion:*' menu select

#setopt COMPLETE_IN_WORD    # Complete from both ends of a word.
#setopt ALWAYS_TO_END       # Move cursor to the end of a completed word.
#setopt PATH_DIRS           # Perform path search even on command names with slashes.
#setopt AUTO_PARAM_SLASH    # If completed parameter is a directory, add a trailing slash.
#setopt EXTENDED_GLOB       # Needed for file modification glob modifiers with compinit

## Verbose makes the completion more verbose
#zstyle ':completion:*' verbose yes

## Use caching for all completion
 #zstyle ':completion::complete:*' use-cache on
 #zstyle ':completion::complete:*' cache-path "$XDG_CACHE_HOME/.zcompcache"

 ## Case-insensitive completion
 #zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
 #unsetopt CASE_GLOB

 ## Group matches and describe.
 #zstyle ':completion:*:*:*:*:*' menu select
 #zstyle ':completion:*:matches' group 'yes'
 #zstyle ':completion:*:options' description 'yes'
 #zstyle ':completion:*:options' auto-description '%d'
 #zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
 #zstyle ':completion:*:descriptions' format ' %F{green}-- %d --%f'
 #zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
 #zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
 #zstyle ':completion:*:default' list-prompt '%S%M matches%s'
 #zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
 #zstyle ':completion:*' group-name ''

 ## Don't complete unavailable commands.
 #zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

 ## Don't complete uninteresting users...
 #zstyle ':completion:*:*:*:users' ignored-patterns \
    #adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
    #dbus distcache docker dovecot fax ftp games gdm gkrellmd gopher \
    #hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
    #mailman mailnull mldonkey mysql nagios \
    #named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
    #operator pcap postfix postgres privoxy pulse pvm quagga radvd \
    #rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs '_*'

 ## Ignore multiple entries.
 #zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
 #zstyle ':completion:*:rm:*' file-patterns '*:all-files'
