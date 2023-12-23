.macro print_str (%x)
   .data
           str: .asciz %x
   .text
	   li a7, 4
	   la a0, str
	   ecall
.end_macro

# Завершение программы
.macro exit
    li a7, 10
    ecall
.end_macro

# Ввод целого числа с консоли в регистр a0
.macro read_int
   li a7, 5
   ecall
.end_macro

# Ввод строки
.macro read_string
.eqv SIZE 100
.data
	str: .space SIZE
.text
	la a0 str
	li a1 SIZE
	li a7 8
	ecall
.end_macro

#Функция копирует первые num символов из строки srcptr в строку destptr.
.macro strncpy(%destptr, %srcptr, %num)
.eqv	numbers t0
.eqv	dest t1
.eqv	src  t2
.eqv	cur_char t3
.text
	
	mv t1 %destptr
	mv t2 %srcptr
	beqz %num, end
	
loop:   lb      cur_char (src)         # очередной символ src
	beqz    cur_char fin           # нулевой — конец строки (\0)
	sb	cur_char (dest)
        addi    numbers numbers 1      # увеличиваем количество в dest строке
	addi    src src 1              # следующий символ src
	addi	dest dest 1	       # следующий символ dest
        blt 	numbers, %num, loop    # проверка что num меньше кол-во записанных чисел
        
       	j end
fin:    
	blt	numbers, %num src_less_than_num
        li      a7 10
        ecall
        j end
   
src_less_than_num:
	sb	cur_char (dest) 	# добавили символ конца строки в строку dest
	j end
	
end:
.end_macro
