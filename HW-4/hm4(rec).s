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
	
	
	
	
	
	# ----------------------------------------------------
	# ra - return adress
	# sp - stack pointer (where our program points)
	# t6 - 0
	# t1 - n
	# t2 - sum
	# a0 - return 

check:
	beqz t2, set_1_to_sum # sum == 0 => set sum = 1
	sum_is_more_1:
	#---------------------------------------------------
	mulh	t3, t2, a3 # t3 = sum * cur
	# check if t2 < 0 => overflow
	# a3 - param
	bnez	t3, is_found_max_value_case 
	
	mul	t2, t2, a3 # 1 2! 3! 4! 5! 6! 7!
	mv 	t3, t2
	j continue
	# ---------------------------------------	
fact:   addi    sp sp -4	 
        sw      ra (sp)         # Сохраняем ra
        addi	sp sp -4
        sw	t6 (sp)		# сохраняем t6 в место куда на данный момент указывает sp
        
        mv	a3, t6 # param for check
        bgtz	t6, check
        continue:
        addi	t6, t6, 1		# add cur + 1
        jal fact
        addi	sp sp 4
done:          
        lw      ra (sp)         # Восстанавливаем ra
        addi    sp sp 4         # Восстанавливаем вершину стека
        ret
	

set_1_to_sum:
	li	t2, 1
	j sum_is_more_1
	
is_found_max_value_case:
	addi	a0, a3, -1
        ret
