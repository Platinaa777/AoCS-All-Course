
	
# Сохранение заданного регистра на стеке
.macro push(%x)
	addi	sp, sp, -4
	sw	%x, (sp)
.end_macro

# Выталкивание значения с вершины стека в регистр
.macro pop(%x)
	lw	%x, (sp)
	addi	sp, sp, 4
.end_macro

# Печать содержимого регистра как целого
.macro print_int (%x)
	li a7, 1
	mv a0, %x
	ecall
.end_macro

.macro print_str (%x)
   .data
	str: .asciz %x
   .text
	   push (a0)
	   li a7, 4
	   la a0, str
	   ecall
	   pop	(a0)
.end_macro

# Завершение программы
.macro exit
    li a7, 10
    ecall
.end_macro

# Ввод целого числа с консоли в регистр a0
.macro read_int_a0
   li a7, 5
   ecall
.end_macro

.macro print_msg_with_number(%arg, %num)
	la	a0, %arg
	li	a7, 4
	ecall
	li 	a7, 1
	mv	a0, %num
	ecall
	
	la	a0, ln
	li	a7, 4
	ecall
.end_macro

.macro reserve (%x)
	push(%x)
        mv 	t2, %x			# число элементов в массиве
        li	a0, 10
        bgt	t2, a0, exception 	# проверка на то что кол-во корректное
        blez	t2, exception
        pop(%x)
.end_macro

.macro fill_array (%x)
	reserve(%x)
        
        li	t3, 0			# сумма
        li	t6, 0			# итерации
        la	t0, array		# начачо массива
        la	t1, array_end		# конец массива
        push(%x)
        
        
        li	t3, 0			# сумма
        li	t6, 0			# итерации
        la	t0, array		# начачо массива
        la	t1, array_end		# конец массива
        
loop:
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
	pop(%x)
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
	print_msg_with_number(sum, t3)
	print_msg_with_number(count, t6)
	
	la	a0, overflow
	li	a7, 4
	ecall
	exit
end:
	# выход из макроса
.end_macro

exception:
	la 	a0, except  
	li 	a7, 4       
	ecall
	exit

.macro print_array (%x)
	push(%x)
        
        li	t6, 0			# итерации
        la	t0, array		# начачо массива
        la	t1, array_end		# конец массива
        
loop:
	read_num_from_array_a0 (t0)
	print_int (a0)
	la	a0, backspace
	li	a7, 4
	ecall
	
	addi 	t6, t6, 1
	addi 	t0, t0, 4
	bltu 	t6, t2, loop
	
	la	a0, ln
	li	a7, 4
	ecall
	
	pop(%x)
	
.end_macro

.macro read_num_from_array_a0 (%add)
	lw	a0 (%add)
.end_macro

.macro print_sum
	push(a0)
	li	t5, 0
	li	t6, 0			# итерации
        la	t0, array		# начачо массива
        la	t1, array_end		# конец массива
        
loop:
	read_num_from_array_a0 (t0)
	add	t5, t5, a0
	addi 	t6, t6, 1
	addi 	t0, t0, 4
	bltu 	t6, t2, loop
	
	print_msg_with_number(sum, t5)
	
	pop(a0)
.end_macro

.macro print_count
	push(a0)
	li	t5, 0
	li	t6, 0			# итерации
        la	t0, array		# начачо массива
        la	t1, array_end		# конец массива
        
loop:
	read_num_from_array_a0 (t0)
	addi	t5, t5, 1
	addi 	t6, t6, 1
	addi 	t0, t0, 4
	bltu 	t6, t2, loop
	
	print_msg_with_number(count, t5)
	
	pop(a0)
.end_macro

.data
	backspace: .asciz " "
    	ln:     .asciz "\n"
    	.align 2
	overflow: .asciz "overflow переменной для суммы... "
	.align 2
	except: .asciz "неверные границы"
	.align 2
	sum: .asciz "Сумма -  "
	.align 2
	count: .asciz "Количество -  "
	.align 2
	array:	.space 40
	array_end:
