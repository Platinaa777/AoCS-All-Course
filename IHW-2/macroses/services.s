# Macros library

# return value in f10 register
.macro input_accuracy
.data 
	default_accuracy:	  .double 0.0005 # default accuracy in task,
						 # we can get less accuracy than 0.0005
	zero0:		          .double 0.0
.text
	fld	f0, default_accuracy, t0 # get default accuracy
	fld	f1, zero0, t0
get_accuracy_loop:
	print_str ("Input wanted accuracy ")
	li	a7, 7
	ecall
	fge.d	t1, f0, f10
	beqz	t1 try_again_input_accuracy
	fle.d	t0, f1, f10
	beqz	t0 try_again_input_accuracy
	
	j end_macro
	
try_again_input_accuracy:
	print_str ("Wrong accuracy (greater than default 0.0005) \n")
	j get_accuracy_loop

end_macro:
	# return accuracy in f10 register
.end_macro 
	
# save data to stack
.macro push(%x)
	addi	sp, sp, -4
	sw	%x, (sp)
.end_macro
# fetch data from stack
.macro pop(%x)
	lw	%x, (sp)
	addi	sp, sp, 4
.end_macro

# save float data to stack
.macro push_double(%x)
	# -8 because double has 8 bytes
	addi	sp, sp, -8
	fsd	%x, (sp)
.end_macro

# fetch float data from stack
.macro pop_double(%x)
	fld	%x, (sp)
	# add 8 to stack pointer because double has 8 bytes
	addi	sp, sp, 8
.end_macro

# Print string
	# %x: printed string
.macro print_str (%x)
   .data
	str: .asciz %x 
	.align 2
   .text
	   push (a0)		#  move a0 to stack
	   li a7, 4
	   la a0, str
	   ecall
	   pop	(a0)		# retrieve a0 from stack
.end_macro

# print message in console with int value
.macro print_msg_with_number(%arg, %num)
.data
	str: .asciz %arg
	ln:  .asciz "\n"
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

# end of program
.macro exit
    print_str("\nEnding program...")
    li a7, 10
    ecall
.end_macro

