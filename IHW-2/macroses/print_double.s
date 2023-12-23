
# macro: pring double number with some information
	# %x - double number
	# %string - message
	
.macro print_doubles_value_with_msg(%value, %accuracy %string)	
.data
	str: .asciz %string
	.align 2
.text
	print_str(%string)
	li	a7, 3
	fmv.d	fa0, %accuracy
	ecall
	print_str (" Equals = ")
	fmv.d	fa0, %value
	li	a7, 3
	ecall
.end_macro
