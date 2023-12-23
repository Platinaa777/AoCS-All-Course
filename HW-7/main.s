.include "func.s"


.global main

.data
	.align 2
	r:	.word 0xffff0010 #r
	.align 2
	l:	.word 0xffff0011 #l			
	bytes: .byte 
	0x3f 0x06 0x5b 0x4f 0x66 0x6d 0x7d 0x07 
	0x7f 0x6f 0x77 0x7c 0x39 0x5e 0x79 0x71 
.text
	main:	

	li s5 0
main_loop: 
	display (s5, r)
	display	(s5, l)
	sleep(1000)
	addi s5 s5 1	
	j main_loop	
.text

	display_digit:
	addi	sp sp -4
	sw	ra (sp)
	li	t5 16
	li	t6 0
	
	blt	a0 t5 without_dot
	
	addi	t6 t6 128

	without_dot:	
	andi	t3 a0 0x0f
	la	t5 bytes
	add	t5 t5 t3
	lb	t2 (t5)	
	
	add	t6 t6 t2
	sb	t6 (a1)	
	lw	ra (sp)
	addi	sp sp 4
	ret
end:
	