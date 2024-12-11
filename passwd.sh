ruta_actual="/home/ramon/Documentos/Bash/passwd"
cd "$ruta_actual"
source .env

encript() {
    contenido="$@"
    contenido=$(echo "$contenido" | tr ' ' '\n')
    echo "$contenido" > "$name2"
    gpg --batch --yes --passphrase "$passwd" -c "$name2"
    rm "$name2"
}

descript(){
    contenido=$(gpg --decrypt "$name_arch")
    if [ $? -ne 0 ] || [ -z "$contenido" ]; then
        echo "Error al descifrar el archivo. Asegúrate de que la contraseña sea correcta."
        echo "que concho pasa"
        exit 1
    fi

}

add(){
    cd "$ruta"
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Error: Necesitas proporcionar un nombre y una contraseña."
        return 1
    fi
    name="$1"
    contra="$2"
    new="$name:$contra"
    echo "$new" 
    descript
    contenido="$contenido$(echo -e "\n$new")"
    echo "esto es $contenido"
    encript "$contenido"
    echo "Se ha añadido con éxito."
}

eliminar() {
    cd "$ruta"
    descript
    eleccion=$(echo "$contenido" | fzf)
    if [ -z "$eleccion" ]; then
        echo "No se ha seleccionado nada"    
        return 1
    fi
    contenido=$(echo "$contenido" | sed "/$eleccion/d")
    encript "$contenido"
    echo "Se ha eliminado $eleccion con éxito."
}


visualizar() {
    cd "$ruta"
    descript
    eleccion=$(echo "$contenido" | fzf)
    if [ -z "$eleccion" ]; then
        echo "No se ha seleccionado nada"
        return 1
    fi
    echo "$eleccion" | xclip -sel clip
}

    
generar() {
    cd "$ruta" 
    name="$1"
    number="$2"

    if [ -z "$name" ] || [ -z "$number" ]; then
        echo "Error: Necesitas proporcionar un nombre y un tamaño para la cadena generada."
        echo "Uso: generar <nombre> <tamaño>"
        return 1
    fi

    lista=("a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v"
                 "w" "x" "y" "z" "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R"
                 "S" "T" "U" "V" "W" "X" "Y" "Z" "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "_" "@")

    generado=""
    for ((i = 1; i <= number; i++)); do
        generado+="${lista[RANDOM % ${#lista[@]}]}"
    done

    resultado="$name:$generado"
    echo "$resultado"
    descript
    contenido="$contenido$(echo -e "\n$resultado")"
    encript $contenido
    echo "Se ha generado con éxito"
}

comprobacion(){
    if [ ! -f "$ruta/$name_arch" ]; then
    cd "$ruta"
    echo "____Listado_de_contraseñas______" > "$name2"
    gpg -c "$name2"
fi
}
comprobacion
case $1 in 
    add)
    add "$2" "$3"
    ;;
    generar)
    generar "$2" "$3"
    ;;
    eliminar)
    eliminar
    ;;
    visualizar)
    visualizar
    ;;
    *)
    echo "Comando no valido"
    ;;
esac