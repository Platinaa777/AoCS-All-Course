#
# Main program uses macro library and external subprogram
#
.include "strncpy.s"

.global main

.eqv SIZE 100
.data
	str: .space SIZE
.text
main:
#note: max count chars in string equals 100

	#src
    	print_str ("Enter first string - ")
    	read_string
    	mv s1 a0
    	
    	#dest
    	la s2 str
    	
    	#count
    	print_str ("Enter count chars - ")
    	read_int
    	mv s3 a0
    	
    	#main func
    	strncpy(s2, s1, s3)
    	print_str ("Total string - ")
    	mv	a0, s2
    	li	a7, 4
    	ecall
	exit
