.include "macroses/read.s"
.include "macroses/write.s"
.include "macroses/utils.s"
.include "macroses/validate_sequence_of_brackets.s"
.include "macroses/macrosyscalls.s"

# 28
# Разработать программу, которая в заданной ASCII–строке
# определяет корректность вложенности круглых скобок «(» и «)».
# Необходимо учесть, что вложенные скобки могут образовывать в
# тексте различные группы. Например: ...(...)...(...)....
.global main
.data 
	is_valid:	.asciz "true"
	is_not_valid:	.asciz "false"
.text
main:
# reading ######################################################
	print_str("Input path to reading file ")
	read()
	print_str("INPUT FILE NAME - ")
	mv s1 a0
	# save s1 for next macroses
	push (s1)
	print_str_from_a0()
	print_str("\n")
	
	print_str("Input path to output(writing) file ")
	read()
	print_str("OUTPUT FILE NAME - ")
	mv s2 a0
	push (s2)
	print_str_from_a0()
	print_str("\n")
	
	pop (s2)
	pop (s1)
	
# end-reading ######################################################
# start-get-data-from-file #########################################

	push (s1)
	push (s2)
	validate_sequence_of_brackets(s1)
	pop (s2)
	pop (s1)

# end-get-data-from-file #########################################
# write-to-output-file ###########################################
	
	print_str("\n")
	push (s3)
	write_to_file (s2, a5)
	pop (s3)
	
	print_str("PROGRAM SUCCESSFULY WRITE TO OUTPUT FILE!!!\n")
	
	print_str("Do you want to get informatin in console? Y - yes, N - no: ")
	read_request(a5)
	exit

# end ############################################################
	

		
	   
        
        
	
