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
	.file	"array_8.c"
	.text
	.section	.rodata
	.align	2
.LC0:
	.word	10
	.word	20
	.word	30
	.word	40
	.text
	.align	1
	.global	main
	.syntax unified
	.thumb
	.thumb_func
	.type	main, %function
main:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	push	{r4, r7, lr}
	sub	sp, sp, #28
	add	r7, sp, #0
	ldr	r3, .L4
	ldr	r3, [r3]
	str	r3, [r7, #20]
	mov	r3, #0
	ldr	r3, .L4+4
	adds	r4, r7, #4
	ldm	r3, {r0, r1, r2, r3}
	stm	r4, {r0, r1, r2, r3}
	movs	r3, #100
	str	r3, [r7, #4]
	movs	r3, #200
	str	r3, [r7, #8]
	mov	r3, #300
	str	r3, [r7, #12]
	mov	r3, #400
	str	r3, [r7, #16]
	movs	r3, #0
	ldr	r2, .L4
	ldr	r1, [r2]
	ldr	r2, [r7, #20]
	eors	r1, r2, r1
	mov	r2, #0
	beq	.L3
	bl	__stack_chk_fail
.L3:
	mov	r0, r3
	adds	r7, r7, #28
	mov	sp, r7
	@ sp needed
	pop	{r4, r7, pc}
.L5:
	.align	2
.L4:
	.word	__stack_chk_guard
	.word	.LC0
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0"
	.section	.note.GNU-stack,"",%progbits
