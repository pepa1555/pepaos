# Pepa OS - ~/.bashrc

export EDITOR=vim
export VISUAL=vim
export BROWSER=firefox
export TERMINAL=alacritty
export QT_QPA_PLATFORMTHEME=qt5ct
export GTK_THEME=Arc-Dark

alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -I'
alias ..='cd ..'
alias ...='cd ../..'
alias pacupdate='sudo pacman -Syu'
alias pacinstall='sudo pacman -S'
alias pacremove='sudo pacman -Rns'
alias paclean='sudo pacman -Sc'
alias orphans='pacman -Qdt'
alias neofetch='neofetch --source /usr/share/backgrounds/pepaos-wallpaper.png'
alias sysinfo='neofetch'
alias update='sudo reflector --latest 10 --sort rate --save /etc/pacman.d/mirrorlist && sudo pacman -Syu'

PS1='\[\e[38;5;79m\]\u\[\e[0m\]@\[\e[38;5;79m\]\h\[\e[0m\]:\[\e[38;5;245m\]\w\[\e[0m\]\$ '
