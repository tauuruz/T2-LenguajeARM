.section .text
    //; r0 = buffer to write to
    //; r1 = number of bytes to read
.global _start

read_user_input:
     # prologue starts here
     push   {r7}
     sub    sp, sp, #12
     add    r7, sp, #0
     str    r0, [r7, #4]   @ backs buffer's base address up
     str    r1, [r7, #8]   @ backs buffer size up
     
     # Function body
     Ldr    r2, [r7, #8]   @ Loads buffer size
     Ldr    r1, [r7. #4]   @ Loads buffer's base address
     mov    r0, #0x0       @ file descritor kind (STDIN)
     mov    r7, #3         @ sets the kind of function call
     svc    0x0            @ performs system call
     mov    r3, ro
     add    r7, sp, #0

     # Epilogue
     move   ro, r3
     adds   r7, r7, #12
     mov    sp, r7
     pop    {r7}
     bx     lr