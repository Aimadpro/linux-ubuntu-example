#!/bin/bash

printf "Introduce tu direccion de correo electronico: "
read -r correo

printf "Introduce el tipo de incidencia: "
read -r tipo

printf "Introduce una descripcion de la incidencia: "
read -r descripcion

# Verificar si el archivo incidencias.txt existe
if [ ! -f "incidencias.txt" ]; then
    touch incidencias.txt
    echo "Archivo incidencias.txt creado."
fi

numero_incidencia=$(wc -l < incidencias.txt)
numero_incidencia=$((numero_incidencia + 1))

printf "%s|%s|%s|%s|%s|oberta||\n" "$numero_incidencia" "$correo" "$tipo" "$descripcion" "$(date +"%Y-%m-%d %H:%M:%S")" >> incidencias.txt

echo "Incidencia registrada correctamente."