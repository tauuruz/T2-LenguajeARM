# T2: Programación de E/S en lenguaje arm
Profesor: Dr. Adán Geovanni Medrano Chávez  
UEA: Microcontroladores

## Integrantes del equipo
Erick David Ruiz Coronel - 2143067521  
Diego Reyes Blancas - 2213026667
    

## Proceso de instalación del compilador cruzado para arm
Bajo una distribución basada en Ubuntu, basta con utilizar el comando
siguiente para instalar el compilador cruzado de arm y un emulador que
permitirá ejecutar aplicaciones arm desde el pc.
````
sudo apt install gcc-arm-linux-gnueabi qemu-user-static
````

## Compilación
Se ha incluido el archivo ''makefile'' y para poder usarlo es necesario instalar los paquetes necesarios con el siguiente codigo
````
sudo apt install make
````
Lo anterior permitirá la compilación y la ejecución del proyecto con tan solo ejecutar el comando
````
make
````
NOTA: El directorio del bash debe de apuntar al directorio que incluye los archivos del proyecto incluido el makefile
## 
Sigue los pasos del proceso de compilación para crear tu
programa ejecutable con extensión ELF. Nota que arm-gcc y arm-
as son alias del compilador cruzado GCC para arm.

1. Compilación del programa base escrito en с mediante el
    comando 
    ````
    arm-gcc main.c S-march=armv7-m-mtune=cortex-m3.
    ````
2. Ensamble del programa en ensamblador modificado que lee y
    escribe desde la terminal estándar mediante el comando 
    ````
    arm-as main.s s-o main.o.
    ````
3. Enlace del código objeto con la biblioteca estándar mediante
    el comando 
    ````
    arm-gcc main.o -о main.elf -static
    ````
    El enlace
    implícito con la biblioteca estándar permite que la función
    main pueda ser ejecutada. La opción static indica que el
    programa no tiene dependencias con bibliotecas dinámicas.
    
4. Ejecución del programa mediante el comando 
    ````
    ./main.elf
    ````
    La ejecución también se consigue empleando el comando 
    ````
    arm-run main.elf
    ````
    donde arm-run es un alias de qemu-static-user.

## Objetivo de la práctica
1. Leer de la entrada estándar los argumentos de un programa
    que procesa un arreglo.
2. Procesar los argumentos de una función.
3. Imprimir en la terminal estándar el resultado de una función.

## Funcionamiento de la implementación
El presente proyecto resulta de compilar una
programa escrito en lenguaje с que procesa los elementos de un
arreglo de tal manera que dicho programa lea los argumentos de
la función desde la entrada estándar e imprima el resultado en la
salida estándar.  
Notese que el código de las funciones que leen la
entrada estándar y escriben en la salida estándar está en
ensamblador arm.  
Se incluyen las funciones de lectura, escritura y conversión de código ASCII a números
enteros.  
  
  
El funcionamiento se da de la siguiente manera:

1. De forma predeterminada la implementación crea un arreglo de 5 elementos inicializados con el valor numerico ''0''.  
2. Se solicita al usuario que ingrese valores numericos positivos durante 5 iteraciones (Con esto se modifican los valores del arreglo por los ingresados).  
3. Cada que se ingresa un valor el programa convierte el valor numerico a ASCII.  
4. Despues de la conversion procesa la cadena en reversa y lo convierte en entero.  
5. Cuando se realiza la segunda conversion al numero entero se agrega al arreglo.
6. Al final, el valor de salida es el resultado de sumar los 5 valores numericos dentro del arreglo.


## Marco de funciones.
insert_value:
````
    # prologue starts here
    push   {r7}            @ respalda r7 (frame pointer)
    sub    sp, sp, #20     @ ajusta el tamaño del marco de la funcion se solicitan 20 ya que a la funcion le llegan 3 parametros
    add    r7, sp, #0      @ actualiza r7 (frame pointer)
    
    str	r0, [r7, #12]@ r0 contiene la dirección del arreglo
	str	r1, [r7, #8]@ r1 contiene el índice    
	str	r2, [r7, #4] @ r2 contiene el valor a insertar
    
    # Epilogue
    movs r3,#0
    mov   r0, r3           @ returns 0
    adds   r7, r7, #20     @ frees the function stack space
    mov    sp, r7          @ gets sp original value back
    pop    {r7}            @ gets r7 original value back
    bx     lr              @ return to caller
````
sum_array:
````
    

    @ Guardamos los registros necesarios
    push   {r7}            @ respalda r7 (frame pointer)
    sub    sp, sp, #20     @ ajusta el tamaño del marco de la funcion se solicitan 20 ya que a la funcion le llegan 1 parametros 
                           @y guarda 2 valores en registros
    add    r7, sp, #0      @ actualiza r7 (frame pointer)

    @ Cargamos los parámetros en los registros

    str	r0, [r7, #4]   @ r0 contiene la dirección del arreglo
	movs	r3, #5     @la cantidad de elementos en el arreglo
	str	r3, [r7, #8]
	movs	r3, #0     @la suma de los valores del arreglo
	str	r3, [r7, #12]
    
    # Epilogue
    mov   r0, r3           @ returns la suma del arreglo
    adds   r7, r7, #20     @ frees the function stack space
    mov    sp, r7          @ gets sp original value back
    pop    {r7}            @ gets r7 original value back
    bx     lr              @ return to caller
````
read_user_input:
````
     # prologue starts here
    push   {r7}            @ respalda r7 (frame pointer)
    sub    sp, sp, #12     @ ajusta el tamaño del marco de la funcion
    add    r7, sp, #0      @ actualiza r7 (frame pointer)
    str    r0, [r7, #4]    @ backs buffer's base address up
    str    r1, [r7, #8]    @ backs buffer size up
    
     # Epilogue
    mov   r0, r3           @ returns the number of red characters
    adds   r7, r7, #12     @ frees the function stack space
    mov    sp, r7          @ gets sp original value back
    pop    {r7}            @ gets r7 original value back
    bx     lr              @ return to caller
````
