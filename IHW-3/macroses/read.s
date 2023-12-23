
# read name macro

.macro read()

.eqv	NAME_SIZE 256	# buf for name of file

.data
	prompt:  .asciz "Input file path: "     	# path to reading file
	er_name_mes: .asciz "Incorrect file name\n"
	default_name: .asciz "testout.txt"      	# default name of file
	file_name: .space	NAME_SIZE		# name of reading file
.text
    ###############################################################
    # input file name
    la	    a0 file_name
    li      a1 NAME_SIZE
    li      a7 8
    ecall
    
    # delete '\n'
    
    li  t4 '\n'
    la  t5  file_name
    mv  t3 t5	# save begging of buf for cheching empty string
loop:
    lb	t6  (t5)
    beq t4  t6	replace
    addi t5 t5 1
    b   loop
replace:
    sb  zero (t5)
    mv   a0, t3 	# inputing name

.end_macro
	
