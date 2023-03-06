	.arch armv7-m
	.fpu softvfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 1
	.eabi_attribute 18, 4
	.file	"suma.c"
	.text
	.align	1
	.global	read_user_input
	.syntax unified
	.thumb
	.thumb_func
	.type	read_user_input, %function

.data
my_array:    .word   0, 0, 0, 0, 0   @ Arreglo de 5 valores inicializados en 0

first:
    .skip 8
sum:
    .skip 8

    
insert_value:
    @ Guardamos los registros necesarios
    push    {r7}
    sub	sp, sp, #20
	add	r7, sp, #0

    @ Cargamos los parámetros en los registros
    str	r0, [r7, #12]@ r0 contiene la dirección del arreglo
	str	r1, [r7, #8]@ r1 contiene el índice    
	str	r2, [r7, #4] @ r2 contiene el valor a insertar
    
    ldr	r0, [r7, #12]
	ldr	r1, [r7, #8]
	ldr	r2, [r7, #4]

    @ Calculamos la dirección del elemento a insertar
    lsl     r1, r1, #2   @ Multiplicamos el índice por 4 (el tamaño de un word)
    add     r0, r0, r1   @ Sumamos la dirección base del arreglo con el offset del elemento

    @ Insertamos el valor en el arreglo
    str     r2, [r0]
    @ Recuperamos los registros y salimos de la función
    movs r3,#0
    mov	r0, r3
	adds	r7, r7, #20
	mov	sp, r7
    pop     {r7}
    bx lr


sum_array:
    @ Guardamos los registros necesarios@ r0 contiene la dirección del arreglo
    push    {r7}
    sub	sp, sp, #20
	add	r7, sp, #0

    @ Cargamos los parámetros en los registros

    str	r0, [r7, #4]   @ r0 contiene la dirección del arreglo
	movs	r3, #5     @la cantidad de elementos en el arreglo
	str	r3, [r7, #8]
	movs	r3, #0     @la suma de los valores del arreglo
	str	r3, [r7, #12]
    
    ldr	r0, [r7, #12]  @r0 contiene la suma de los valores del arreglo
    ldr	r1, [r7, #8]   @r1 contendrá la cantidad de elementos en el arreglo
	ldr	r2, [r7, #4]   @r2 contiene la dirección del arreglo


    @ Recorremos el arreglo y sumamos sus valores
    ldr     r3, [r2], #4   @ r1 contendrá el primer elemento del arreglo
    add     r0, r0, r3    @ Sumamos el primer elemento del arreglo a la suma total

    loop:
        subs    r1, r1, #1   @ Decrementamos el contador 
        beq     end         @ Si el contador llega a 0, salimos del loop
        ldr     r3, [r2], #4   @ Cargamos el siguiente elemento del arreglo
        add     r0, r0, r3    @ Sumamos el siguiente elemento del arreglo a la suma total
        b       loop
    end:
        @ Guardamos la suma en el registro de retorno y salimos de la función
        mov	r3, r0
        mov	r0, r3
        adds	r7, r7, #20
        mov	sp, r7
        @ sp needed
        pop	{r7}
        bx	lr
read_user_input:
    # prologue starts here
    push   {r7}            @ respalda r7 (frame pointer)
    sub    sp, sp, #12     @ ajusta el tamaño del marco de la funcion
    add    r7, sp, #0      @ actualiza r7 (frame pointer)
    str    r0, [r7, #4]    @ backs buffer's base address up
    str    r1, [r7, #8]    @ backs buffer size up
    
    # Function body
    ldr    r2, [r7, #8]    @ Loads buffer size
    ldr    r1, [r7, #4]    @ Loads buffer's base address
    mov    r0, #0x0        @ file descritor kind (STDIN)
    mov    r7, #3          @ sets the kind of function call
    svc    0x0             @ performs system call
    mov    r3, r0          @ saves the number of red characters
    add    r7, sp, #0      @ gets r7 back

    # Epilogue
    mov   r0, r3           @ returns the number of red characters
    adds   r7, r7, #12     @ frees the function stack space
    mov    sp, r7          @ gets sp original value back
    pop    {r7}            @ gets r7 original value back
    bx     lr              @ return to caller

my_atoi: @ ASCII to Integer function (Processes in reverse byte by byte)
    push {r7}               @ respalda r7 (frame pointer)
    push {r4-r8}            @ respalda registros necesarios
    mov r2, #0x0            @ our string counter
    mov r5, #0x0            @ end state counter value
    mov r6, #1              
    mov r7, #10             

_string_length_loop:
    ldrb r8, [r0]           @ load register bytes from r0 to r8 (first number of the string)
    cmp r8, #0xa            @ compare r8 to newline (#0xa)
    beq _count              @ if equal 
    add r0,r0,#1            @ adds 1 to r0 pointer
    add r2,r2,#1            @ internal value that tracks the string
    b _string_length_loop   @ iterates over the string and gets the lenght of the string

_count:
    sub r0, r0, #1          @ substract 1 to the r0 pointer to get the last number position
    ldrb r8, [r0]           @ load register bytes from r0 to r8 (first number of the string)
    sub r8, r8, #0x30       @ substract #0x30 to convert ASCII to Integer
    mul r4,r8,r6            @ current place times number          
    mov r8,r4               @ moves r4 value back to r8
    mul r4,r6,r7            @ increment the placeholder
    mov r6,r4               @ increment r6 by 10
    add r5,r5,r8            @ adds current number to counter
    sub r2,r2, #1           @ decrement the string counter (length, check for end)
    cmp r2, #0x0            @ compare string counter to 0            
    beq _leave              @ if equal branch to _leave
    b _count                @ iterates to count until string counter equals 0

_leave:
    mov r0, r5              @ moves r5 value to r0 (end state counter value)
    pop {r4-r8}             @ gets registers original value
    pop {r7}                @ gets r7 original value
    bx     lr              @ return to caller
    
int_to_string:
    push {r7}
    mov r2, #0x0
    mov r3, #1000
    mov r7, #10
_loop:
    mov r4, #0x0
    udiv r4,r0,r3
    add r4,r4,#0x30
    ldr r5, =sum
    add r5,r5,r2
    strb r4, [r5]
    add r2,r2,#1
    sub r4,r4,#0x30
    mul r6,r4,r3
    sub r0,r0,r6
    udiv r6,r3,r7
    mov r3,r6
    cmp r3, #0
    beq _leave_int
    b _loop
_leave_int:
    mov r4, #0xa
    ldr r5, =sum
    add r5,r5,r2
    add r5,r5,#1
    strb r4, [r5]
    pop {r7}
    bx {lr}
display:
    push	{r0,r1,r2,r7}
    @ Cargamos los parámetros en los registros
    movs	r7, #0x4     @representa el número de la llamada al sistema para la función "write"
    movs	r0, #0x1    @representa el descriptor de archivo para la salida estándar
    ldr 	r1, =sum    @Carga la dirección de la variable "sum"
    movs	r2, #0x8    @representa el descriptor de archivo para la salida estándar
    svc 0x0
    mov r3, #0
    mov	r0, r3
	@ sp needed
	pop	{r0,r1,r2,r7}
	bx	lr

    .align	1
	.global	main
	.syntax unified
	.thumb
	.thumb_func
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push	{r7,lr}
	add	r7, sp, #0
	@pegar
    mov r5, #0
    b compara
for_loop:
	ldr r0, =first
    ldr r1, =#0x6
    bl read_user_input

    ldr r0, =first
    bl my_atoi
    mov r2,r0
    ldr r0, =my_array
    mov r1, r5
    bl insert_value
    add r5,r5,#1
compara:
    cmp r5, #5
    blt for_loop
    ldr r0, =my_array
    bl sum_array
    bl int_to_string
    
    bl display
	movs	r3, #0
	mov	r0, r3
	mov	sp, r7
	@ sp needed
	pop	{r7,pc}
	bx	lr
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0"
	.section .note.GNU-stack,"",%progbits
