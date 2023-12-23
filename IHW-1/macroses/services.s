# Библиотека с различными макросами (не все используются)
	
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

# Читаем в регистр а0 длину будущего массива, если длина некорректная, 
# то программа заканчивает свою работу
.macro read_len_of_array_a0
	push t2
	li a7, 5	
   	ecall
        mv 	t2, a0			# число элементов в массиве
        li	a0, 10
        bgt	t2, a0, exception 	# проверка на то что кол-во корректное
        blez	t2, exception
        mv 	a0, t2			# а0 вывод данного макроса
        pop t2
.end_macro

# Печать строки
	# %x: строка для вывода
.macro print_str (%x)
   .data
	str: .asciz %x 
	.align 2
   .text
	   push (a0)		#  помещаем значение в регистра а0 на стек
	   li a7, 4
	   la a0, str
	   ecall
	   pop	(a0)		# восстанавливаем значение регистра а0
.end_macro

# печать строки с каким-то числом
	# %arg - строка
	# %num - число
.macro print_msg_with_number(%arg, %num)
.data
	str: .asciz %arg
.text
	la	a0, str
	li	a7, 4
	ecall
	li 	a7, 1
	mv	a0, %num
	ecall
	
	la	a0, ln
	li	a7, 4
	ecall
.end_macro

# Завершение программы
.macro exit
    li a7, 10
    ecall
.end_macro

# сообщение об ошибке, далее идет выход из программы
exception:
	la 	a0, except  
	li 	a7, 4       
	ecall
	exit

.data
	backspace: .asciz " "
	.align 2
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
