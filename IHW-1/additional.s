.text
	# основная функция программы, создает массив B, у которого 
	# нет элементов равных первому и последнему массива А
	.macro make_b_array
		# распаковываем наш стек
		pop (t2) # ptr(b)
		pop (t3) # ptr(a)
		pop (t4) # len(a)
		find_first_a0 (t3) # нашли первый элемент массива А
		mv	t5 a0 	
		find_last_a0 (t3, t4) # нашли последний элемент А
		mv 	t6 a0 
		
		li	a1 0 # длина массива В
		li	t0, 0 # счетчик
		
		loop:
			lw	t1 (t3) # записываем значение из t3
			beq	t1, t5, skip_element # проверка что элемент !=last or !=first
			beq 	t1, t6, skip_element
			
			sw	t1 (t2) # сохраняем если подошло t1 в область памяти куда указывает t2
			addi	a1, a1, 1 # добавляем + 1 к длине массива В
			addi	t2, t2, 4 # перемещаем указатель для массива В
			addi	t3, t3, 4 # перемещаем указатель для массива А
			addi	t0, t0, 1 # +1 к счетчику
			end_loop:
			blt	t0 t4 loop
		j end
		
		 skip_element: 
			addi	t3, t3, 4 #
			addi	t0, t0, 1 #
			j end_loop
		end:
			# выход из макроса
	.end_macro
	       
	.macro find_first_a0 (%array)
		lw	a0 (%array)
	.end_macro
	
	.macro find_last_a0 (%array, %len)
		li	t1, 0 # счетчик
		mv	t0, %array # начало массива
		loop:
			addi	t0 t0 4		# переходим на следующую ячейку памяти в %array
			addi	t1 t1 1		# счетчик + 1
			blt	t1 %len loop	# проверка
		lw	a0  -4(t0) 	# берем последний элемент, откатываясь на -4 (тк в цикле мы вышли
					# за пределы %array)
	.end_macro
       
