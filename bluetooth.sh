#!/bin/bash

#Questo è un piccolo script per connettere o disconnettere le Cuffie ed è eseguito tramite l'uso di uno shortcut da tastiera

DEVICE="2C:76:00:A8:44:C0"

# Controlla se il dispositivo è connesso
STATUS=$(bluetoothctl info $DEVICE | grep "Connected: yes")

if [ -z "$STATUS" ]; then
    # Se il dispositivo non è connesso, connettilo
    bluetoothctl connect $DEVICE
    notify-send "Bluetooth" "Cuffie connesse"
else
    # Se il dispositivo è connesso, disconnettilo
    bluetoothctl disconnect $DEVICE
    notify-send "Bluetooth" "Cuffie disconnesse"
fi
