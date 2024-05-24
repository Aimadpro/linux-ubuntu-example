#!/bin/sh
crear_pagina_ejemplo() {
    if [ ! -f "paginawebejemplo.html" ]; then
        touch paginawebejemplo.html
        echo "<!DOCTYPE html>" >> paginawebejemplo.html
        echo "<html>" >> paginawebejemplo.html
        echo "<head>" >> paginawebejemplo.html
        echo "<title>Página de ejemplo</title>" >> paginawebejemplo.html
        echo "</head>" >> paginawebejemplo.html
        echo "<body>" >> paginawebejemplo.html
        echo "<h1>¡Esta es una página de ejemplo!</h1>" >> paginawebejemplo.html
        echo "</body>" >> paginawebejemplo.html
        echo "</html>" >> paginawebejemplo.html
        echo "Archivo paginawebejemplo.html creado."
    fi
}
incidencia_cambiar() {
    printf "Introduce el numero de incidencia para cambiar de estado: "
    read -r numero_incidencia

    if ! grep -q "^$numero_incidencia|" incidencias.txt; then
        printf "No existe una incidencia con ese número\n"
        return
    fi

    printf "Selecciona el nuevo estado:\n"
    printf "1. En proceso\n"
    printf "2. Tancada\n"
    read -r eleccion 

    case $eleccion in
        1)
            estado="en procés"
            sed -i "/^$numero_incidencia/s/|[^|]*oberta/|$estado/" incidencias.txt
            ;;
        2)
            estado="tancada"
            printf "Introduce tu nombre de usuario: "
            read -r nombre_usuario
            fecha=$(date +"%Y-%m-%d %H:%M:%S")
            printf "Introduce un comentario sobre la resolucion:\n"
            read -r comentario
            sed -i "/^$numero_incidencia/s/|[^|]*en procés/|$estado|$nombre_usuario|$fecha|$comentario/" incidencias.txt
            ;;
        *)
            printf "Opción no válida\n"
            return
            ;;
    esac

    printf "Se ha cambiado el estado de la incidencia\n"
}

menu_modificar_visualizar() {
    echo "1. Si quieres visualizar el codigo de la web"
    echo "2. Si quieres abrir la web en firefox"
    read -r f 

    case $f in 
        1)
            nano ./paginawebejemplo.html
            ;;
        2)
            firefox ./paginawebejemplo.html
            ;;
    esac
}

menu_Iniciar_aturar() {
    echo "Iniciar"
    echo "Aturar"
    echo "Reiniciar"
    echo "Estat servei i FTP"
    read -r d

    case $d in 
        1)
            sudo systemctl start apache2 && sudo systemctl start vsftpd
            ;;
        2)
            sudo systemctl stop apache2 && sudo systemctl stop vsftpd 
            ;;
        3)
            sudo systemctl restart apache2 && sudo systemctl restart vsftpd 
            ;;
        4)
            sudo systemctl status apache2 -q && sudo systemctl status vsftpd -q
            ;;
    esac
}

resolver_incidencias() {
    echo "1. Afegir i gestionar usuaris per al servidor FTP"
    echo "2. Poder iniciar, aturar, reiniciar i conèixer l'estat del servei web i FTP."
    echo "3. Resoldre problemes d'accés a les pàgines penjades al lloc web (permisos, pàgines no existents, etc)"
    echo "4. Poder modificar les pàgines web des d'un editor de text i visualitzar-les amb el navegador Firefox."
    read -r c

    case $c in 
        1)
            sudo adduser
            ;;
        2)
            menu_Iniciar_aturar
            ;;
        3)
	crear_pagina_ejemplo
            sudo chmod 700 ./paginawebejemplo.html
            echo "Se han solucionado los problemas"	
            ;;
        4)
		crear_pagina_ejemplo
            menu_modificar_visualizar
            ;;
    esac
}

gestionar_incidencias() {
	salir2=false
while [ "$salir2" = false ]; do
    echo "Introduce un numero segun lo que quieras gestionar"
    echo "1. Mostrar totes les incidències"
    echo "2. Mostrar les incidències obertes"
    echo "3. Mostrar les incidències en procés"
    echo "4. Mostrar les incidències tancades"
    echo "5. Mostrar incidència completa"
    echo "6. Canviar d'estat una incidència"
    echo "0. Sortir"
    read -r b
	
    case $b in
        1)
            cat incidencias.txt
            ;;
        2)
            echo "Mostrar les incidències obertes" 
            grep "|oberta|" incidencias.txt
            ;;
        3) 
            echo "Mostrar les incidències en procés"
            grep "|en procés|" incidencias.txt
            ;;
        4)
            echo "Mostrar les incidències tancades"
            grep "|tancada|" incidencias.txt
            ;;
        5)
            echo "Mostrar incidència completa"
            printf "Introduce el numero de incidencia: "
            read -r numero_incidencia
            printf "Mostrando incidencia %s:\n" "$numero_incidencia"
            grep "^$numero_incidencia|" incidencias.txt
            ;;
        6)
            echo "Canviar d'estat una incidència" 
            incidencia_cambiar
            ;;
        0)
	salir2=true
            ;;
        *)
            echo "El número seleccionado es incorrecto"
            ;;
    esac
done
}

salir=false
while [ "$salir" = false ]; do
    echo "Introduce un numero segun lo que quieres hacer"
    echo "1. Gestionar incidències"
    echo "2. Resoldre incidència"
    echo "0. Sortir"
    read -r a 

    case $a in
        1)
            gestionar_incidencias
            ;;
        2)
            resolver_incidencias
            ;;
        0)
            salir=true
            ;;
        *)
            echo "El número seleccionado es incorrecto"
            ;;
    esac
done
