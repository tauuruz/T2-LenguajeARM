.section .text
    //; r0 = buffer to write to
    //; r1 = number of bytes to read
.global _start

read_user_input:
    push {lr}
    push {r4-r11}
    push {r1}
    push {r0}
    mov r7, #0x3
    mov r0, #0x0
    pop {r1}
    pop {r2}
    svc 0x0
    pop {r4-r11}
    pop {pc}
//; "123\n\0"
//; r0 = pointer to a string of ascii numbers
my_atoi:
    push {lr}
    push {r4-r11}
    mov r2, #0x0 //; our string counter
    mov r5, #0x0 //; end
    mov r6, #1 //; our string counter
    mov r7, #10 //; our string counter
_string_length_loop:
    ldrb r8, [r0]
    cmp r8, #0xa
    beq _count 
    add r0,r0,#1
    add r2,r2,#1
    b _string_length_loop
_count:
    sub r0, r0, #1
    ldrb r8, [r0]
    sub r8, r8, #0x30
    mul r4,r8,r6
    mov r8,r4
    mul r4,r6,r7
    mov r6,r4
    add r5,r5,r8
    sub r2,r2, #1
    cmp r2, #0x0
    beq _leave
    b _count
_leave:
    mov r0, r5
    pop {r4-r11}
    pop {pc}

int_to_string:
    push {lr}
    push {r4-r11}
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
    pop {r4-r11}
    pop {pc}
display:
    push {lr}
    push {r4-r11}
    mov r7, #0x4
    mov r0, #0x1
    ldr r1, =sum
    mov r2,#0x8
    svc 0x0
    pop {r4-r11}
    pop {pc}
_start:
    ldr r0, =first
    ldr r1, =#0x6
    bl read_user_input

    ldr r0, =second
    ldr r1, =#0x6
    bl read_user_input

    ldr r0, =first
    bl my_atoi
    mov r4,r0

    ldr r0, =second
    bl my_atoi
    mov r5, r0

    add r0, r4, r5
    bl int_to_string
    
    bl display
    mov r0,#0x0
    mov r7, #0x1
    svc 0x0 
.section .data
first:
    .skip 8
second:
    .skip 8
sum:
    .skip 8
    