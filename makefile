default:
	arm-linux-gnueabi-as Practica_2.s -o Practica_2.o
	arm-linux-gnueabi-gcc-11 Practica_2.o -o Practica_2.elf -static -nostdlib
	qemu-arm-static Practica_2.elf