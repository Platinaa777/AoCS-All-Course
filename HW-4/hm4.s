.data
	arg01: .asciz "Максимальное число факториала равно =  "
	.align 2
.text
	jal	fact
	mv	s1, a0
	la	a0, arg01
	li	a7, 4
	ecall
	mv	a0, s1
	li 	a7, 1
        ecall 
	li 	a7, 10 # end
	ecall
	
	#• t0 - t6: temp variable
	#• s0 - s11: before value = after value
	#• a0 - a7: input in func
	#• a0, a1: return
	
fact: 
	li	t0, 1 # init = 1 ~ 1!
	li	t2, 1 # multiply
	li	t5, 1
	loop:
	mulh	t3, t2, t0 # if mulh > 0 => overflow
	# check if t2 < 0 => overflow
	bnez	t3, is_found_max_value_case 
	
	mul	t2, t2, t0 # 1 2! 3! 4! 5! 6! 7!
	mv 	t3, t2
	addi	t0, t0, 1
	mv	a0, t0 # save return value in a0
	j loop 
	
is_found_max_value_case:
	addi	a0, a0, -1
	ret
	