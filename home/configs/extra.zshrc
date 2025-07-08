function terminal_title_preexec() {
    print -Pn -- "\e]2;${(q)1}\a"
}

function terminal_title_precmd() {
    print -Pn -- '\e]2;%~\a'
}

add-zsh-hook -Uz precmd terminal_title_precmd
add-zsh-hook -Uz preexec terminal_title_preexec
