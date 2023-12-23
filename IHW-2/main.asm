.include "macroses/services.s"
.include "macroses/calculate_pi.s"
.include "macroses/print_double.s"

# вариант 20   	
#	 Разработать программу вычисления числа π с точностью не хуже
#	 0,05% посредством произведения элементов ряда Виета.
.global main

.text
	main:
		# print introduction
		# 1 argument - string which will be printed
		print_str ("Calculation of numbers π using multiplying of elements of Vieta row.\n") 
		
		# input accuracy 
		# return value in f10 register
		input_accuracy()
		fmv.d 	f18, f10 # save to f18 from f10
		push_double (f18) # save f18 before macros
		# works with f0-f7 registers
		# 1 argument - accuracy (f10)
		calculate_pi(f10) # return pi in register f10 ~ fa0
	
	 	pop_double(f18) # retrive data from stack 
		
		# void return
		# f10 - double number
		# second argument is string which will be printed
		fmv.d	f11, f10
		fmv.d	f12, f18
		push_double(f18)
		push_double(f10)
		# f11 - calculated pi
		# f12 - accuracy
		# %string - printing string
		print_doubles_value_with_msg(f11, f12, "π after calculating in Vieta row with accuracy ")
		
		pop_double(f10)
		pop_double(f18)
		# macros of ending program
		exit()
	   
        
        
	
