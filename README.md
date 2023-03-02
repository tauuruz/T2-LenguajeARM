# T2: Programación de E/S en lenguaje arm
    Profesor: Dr. Adán Geovanni Medrano Chávez
    UEA: Microcontroladores

## Integrantes del equipo
    Erick David Ruiz Coronel    2143067521
    

## Proceso de instalación del compilador cruzado para arm

Bajo una distribución basada en Ubuntu, basta con utilizar el comando
siguiente para instalar el compilador cruzado de arm y un emulador que
permitirá ejecutar aplicaciones arm desde el pc.
````
sudo apt install gcc- arm -linux -gnueabi qemu-user-static
````

## Compilación

Sigue los pasos del proceso de compilación para crear tu
programa ejecutable con extensión ELF. Nota que arm-gcc y arm-
as son alias del compilador cruzado GCC para arm.

1. Compilación del programa base escrito en с mediante el
    comando 
    ````arm
    arm-gcc main.c S-march=armv7-m-
    mtune=cortex-m3.
    ````
2. Ensamble del programa en ensamblador modificado que lee y
    escribe desde la terminal estándar mediante el comando arm-
    as main.s s-o main.o.
3. Enlace del código objeto con la biblioteca estándar mediante
    el comando arm-gcc main.o -о main.elf -static. El enlace
    implícito con la biblioteca estándar permite que la función
    main pueda ser ejecutada. La opción static indica que el
    programa no tiene dependencias con bibliotecas dinámicas.
4. Ejecución del programa mediante el comando ./main.elf. La
    ejecución también se consigue empleando el comando arm-


