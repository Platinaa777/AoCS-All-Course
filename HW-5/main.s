#
# Main program uses macro library and external subprogram
#
.include "services.s"

.global main
#.extern euclid, 32
	
.text
	main:
    		print_str ("Введите количество элементов в массиве - ")
    		read_int_a0
    		reserve (a0)
    		print_str ("Вводите элементы массива: \n")
		fill_array (a0) # array with length = a0
		print_array (a0)
		print_sum
		print_count
		exit