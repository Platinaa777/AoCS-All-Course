# Macros library
	
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

# Print string from memory
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

.macro print_str_from_a0 ()
	li a7 4
	ecall
.end_macro

.macro read_request (%result)
.data
	True: .asciz "true"
	False: .asciz "false"
.text
	li t0 'Y'
	li t1 'y'
	li t2 'N'
	li t3 'n'
	repeat:
	li a7 12
	ecall
	beq a0 t0 write_console
	beq a0 t1 write_console
	beq a0 t2 ending
	beq a0 t3 ending
	print_str("\nНажата не та клавиша!\n")
	j repeat
	
write_console:
	beqz %result true_branch
	la a0 False
	cont:
	print_str("\n Result = ")
	li a7 4
	ecall
	j ending
	
true_branch:
	la a0 True
	j cont
	
ending:

.end_macro

# end of program
.macro exit
    print_str("\nEnding program...")
    li a7, 10
    ecall
.end_macro

