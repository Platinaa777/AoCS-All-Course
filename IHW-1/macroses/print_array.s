# macro: Печать массива
	# %array: Указатель на начало массива
	# %len: Длина массива
	# %string: Название массива (А или В в нашем случае)

.macro print_array(%array, %len, %string)	
.data
	str: .asciz %string
	.align 2
.text
	push %array
	push %len
	la	a0 str		# Название массива
	li	a7 4
	ecall
	beqz	%len end
	mv	t0 %array		# Кладем в t0 адрес начала массива
	li	t1 0	
loop:
	lw	a0 (t0)		# Загружаем элемент массива
	li	a7 1
	ecall
	la	a0 backspace		# Поставили пробел
	li	a7 4
	ecall
	addi	t0 t0 4		# увеличиваем счетчик на +1 и сдвигаем наш t0 на следующую 		
	addi	t1 t1 1		# ячейку в памяти
	blt	t1 %len loop
	
	pop %len
	pop %array
	print_str("\n\n")
	
end:
	# выход с макроса
.end_macro
