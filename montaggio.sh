#!/bin/bash

mostra_aiuto() {
    echo "Uso: $0 [opzione] <nome_dispositivo>"
    echo
    echo "Opzioni:"
    echo "  -h                Mostra questo messaggio di aiuto"
    echo "  -r <nome_dispositivo>  Smonta il dispositivo specificato"
    echo "  <nome_dispositivo>     Monta il dispositivo specificato in /mnt/<nome_dispositivo>"
    echo
    echo "Per verificare i possibili dispositivi da montare, esegui il comando:"
    echo "  lsblk "
}

if [ $# -eq 0 ]; then
    mostra_aiuto
    exit 1
fi

while getopts ":hr" opt; do
    case $opt in
        h)
            mostra_aiuto
            exit 0
            ;;
        r)
            smonta_dispositivo=true
            ;;
        \?)
            echo "Opzione non valida: -$OPTARG" >&2
            mostra_aiuto
            exit 1
            ;;
    esac
done

shift $((OPTIND -1))

if [ -z "$1" ]; then
    echo "Errore: è necessario specificare un nome di dispositivo." >&2
    mostra_aiuto
    exit 1
fi

dispositivo=$1
punto_di_mount="/mnt/$dispositivo"

if [ "$smonta_dispositivo" = true ]; then
    # Smonta il dispositivo
    echo "Smontaggio di /dev/$dispositivo da $punto_di_mount..."
    sudo umount "$punto_di_mount"
    echo "Il dispositivo /dev/$dispositivo è stato smontato da $punto_di_mount."
else
    # Controlla se il dispositivo è già montato
    if mount | grep "/dev/$dispositivo" > /dev/null; then
        echo "Il dispositivo /dev/$dispositivo è già montato."
    else
        # Controlla se la cartella di mount esiste, altrimenti la crea
        if [ ! -d "$punto_di_mount" ]; then
            echo "La cartella $punto_di_mount non esiste. Creazione in corso..."
            sudo mkdir "$punto_di_mount"
        else
            echo "La cartella $punto_di_mount esiste già."
        fi

        # Monta il dispositivo
        echo "Montaggio di /dev/$dispositivo in $punto_di_mount..."
        sudo mount "/dev/$dispositivo" "$punto_di_mount"

        # Modifica i permessi della cartella di mount
        echo "Modifica dei permessi della cartella $punto_di_mount..."
        sudo chmod 777 "$punto_di_mount"

        echo "Il dispositivo /dev/$dispositivo è stato montato in $punto_di_mount con permessi modificati."
    fi
fi
