.data
	overflow: .asciz "overflow переменной для суммы... "
	.align 2
	odd: .asciz "нечетные = "
	.align 2
	even: .asciz "четные = "
	.align 2
	except: .asciz "неверные границы"
	.align 2
	arg01: .asciz "Введите количество элементов в массиве - "
	.align 2
	arg02: .asciz "Сумма -  "
	.align 2
	array:	.space 40
	array_end:
    	ln:     .asciz "\n"
.text
	la	a0, arg01
	li	a7, 4
	ecall
	li 	a7, 5
        ecall 
        mv 	t2, a0			# число элементов в массиве
        li	a0, 10
        bgt	t2, a0, exception 	# проверка на то что кол-во корректное
        blez	t2, exception
        
        li 	a2, 2			# const = 2
        li	a3, 0 			# нечетные
        li 	a4, 0			# четные
        li	t3, 0			# сумма
        li	t6, 0			# итерации
        la	t0, array		# начачо массива
        la	t1, array_end		# конец массива
        
loop:	# разберемся как будем проверять переполнение int, сам int лежит в отрезке [-2^31; 2^31 - 1]
	# получается пусть у нас будет какая-то уже сумма sum и приходящее число x
	# получается если sum и x имеют разные знаки переполнения быть не может (очевидно)
	# если sum and x имеют одинаковый знак, то возможно переполнение
	li 	a7, 5
       	ecall 
       	xor	a1, a0, t3
       	bgez	a1, check_is_overflow
       	is_correct_digit:
	sw	a0(t0)
	add	t3, t3, a0

	addi 	t6, t6, 1
	addi 	t0, t0, 4
	bltu 	t6, t2, loop
	
	# add even and odd
	li	t6, 0 
	la	t0, array
        la	t1, array_end
        
       	even_odd_loop:	
	lw	a0(t0)
	
	li	a5, 1
	and	a6, a0, a5
	bgtz	a6, add_odd
	j 	add_even
	return:
	addi 	t6, t6, 1	
	addi 	t0, t0, 4
	bltu 	t6, t2, even_odd_loop
		
	
	la	a0, ln
	li	a7, 4
	ecall
	
	la	a0, arg02
	li	a7, 4
	ecall
	li 	a7, 1
	mv	a0, t3
	ecall
	
	la	a0, ln
	li	a7, 4
	ecall
	
	la	a0, even
	li	a7, 4
	ecall
	li 	a7, 1
	mv	a0, a4
	ecall
	
	la	a0, ln
	li	a7, 4
	ecall
	
	la	a0, odd
	li	a7, 4
	ecall
	li 	a7, 1
	mv	a0, a3
	ecall
	j end
	
check_is_overflow:
	bgez	a0, maybe_positive_overflow
	j maybe_negative_overflow

maybe_negative_overflow:
	add	t4, t3, a0 	# t4 = sum + x
	li	t5, 0
	bgt	t4, t5, overflow_case
	j is_correct_digit
			
maybe_positive_overflow:
	add	t4, t3, a0 	# t4 = sum + x
	li	t5, 0
	blt	t4, t5, overflow_case
	j is_correct_digit

overflow_case:
	la	a0, arg02
	li	a7, 4
	ecall
	li 	a7, 1
	mv	a0, t3
	ecall
	
	la	a0, ln
	li	a7, 4
	ecall
	
	la	a0, overflow
	li	a7, 4
	ecall
	j end

add_even:
	addi a4,a4,1
	j return
add_odd:
	addi a3,a3,1
	j return

exception:
	la 	a0, except  
	li 	a7, 4       
	ecall
	li      a7 10     
	ecall
	
end:
	li	a7, 10
	ecall
