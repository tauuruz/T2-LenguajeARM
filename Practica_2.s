.section .text
    //; r0 = buffer to write to
    //; r1 = number of bytes to read
.global _start

insert_value:
    @ Guardamos los registros necesarios
    push    {r7}
    push    {r4-r6}
    
    @ Cargamos los parámetros en los registros
    mov     r4, r0      @ r0 contiene la dirección del arreglo
    mov     r5, r1      @ r1 contiene el índice
    mov     r6, r2      @ r2 contiene el valor a insertar

    @ Calculamos la dirección del elemento a insertar
    lsl     r5, r5, #2   @ Multiplicamos el índice por 4 (el tamaño de un word)
    add     r4, r4, r5   @ Sumamos la dirección base del arreglo con el offset del elemento

    @ Insertamos el valor en el arreglo
    str     r6, [r4]

    @ Recuperamos los registros y salimos de la función
    pop     {r4-r6}
    pop     {r7}

sum_array:
    @ Guardamos los registros necesarios
    push    {r7}
    push    {r4-r5}

    @ Cargamos los parámetros en los registros
    mov     r4, r0      @ r0 contiene la dirección del arreglo
    mov     r5, #0      @ r5 contendrá la suma de los valores del arreglo
    @ Recorremos el arreglo y sumamos sus valores
    ldr     r0, =5      @ r0 contendrá la cantidad de elementos en el arreglo
    ldr     r1, [r4], #4   @ r1 contendrá el primer elemento del arreglo
    ldr r5, =sum
    mov r5, #0
    add     r5, r5, r1    @ Sumamos el primer elemento del arreglo a la suma total

_loopS:
    subs    r0, r0, #1   @ Decrementamos el contador
    cmp     r0, #0      @ Compara el contador con 0
    beq     _end         @ Si el contador llega a 0, salimos del loop
    ldr     r1, [r4], #4   @ Cargamos el siguiente elemento del arreglo
    ldr r5, =sum
    add     r5, r5, r1    @ Sumamos el siguiente elemento del arreglo a la suma total
    b       _loopS

_end:
    @ Guardamos la suma en el registro de retorno y salimos de la función
    mov     r0, r5
    pop     {r4-r5}
    pop     {r7}

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


@ ASCII to Integer function (Processes in reverse byte by byte)
//; "123\n\0"
//; r0 = pointer to a string of ascii numbers
my_atoi:
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

int_to_string:
    push {r7}               @ respalda r7 (frame pointer)
    push {r4-r6}            @ respalda registros necesarios
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
    pop {r4-r6}
    pop {r7}

display:
    push {r7}               @ respalda r7 (frame pointer)
    mov r7, #0x4            @ system call to display
    mov r0, #0x1
    ldr r1, =sum
    mov r2,#0x8
    svc 0x0
    pop {r7}


_start:
	@ args = 0, pretend = 0, frame = 0
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	push {r7}               @ respalda r7 (frame pointer)
	add	r7, sp, #0          @ actualiza r7 (frame pointer)
	@pegar
    mov r10, #0
    b compara

for_loop:

    @ read user input
	ldr r0, =first
    ldr r1, =#0x6
    bl read_user_input

    @ convert input to number
    ldr r0, =first
    bl my_atoi
    mov r1,r0

    @ insert value to array
    ldr r0, =my_array
    mov r2, r5
    bl insert_value

    @ increments 
    add r10,r10,#1
    b compara

compara:
    cmp r10, #3
    blt for_loop


    ldr r0, =my_array
    bl sum_array
    bl int_to_string
    bl display
    mov r0,#0x0
    mov r7, #0x1
    svc 0x0 
	movs	r3, #0
	mov	r0, r3
	mov	sp, r7 @ sp needed
	pop	{r7}
	bx	lr
	.ident	"GCC: (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0"
	.section .note.GNU-stack,"",%progbits

.section .data

my_array:    .word   0, 0, 0, 0, 0   @ Arreglo de 5 valores inicializados en 0

first:
    .skip 8
second:
    .skip 8
sum:
    .skip 8
    