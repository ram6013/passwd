_passwd_completions() {
    local cur="${COMP_WORDS[COMP_CWORD]}"

    local commands="add generar eliminar visualizar"

    COMPREPLY=( $(compgen -W "$commands" -- "$cur") )
}
complete -F _passwd_completions passwd