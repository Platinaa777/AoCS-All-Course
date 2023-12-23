#===============================================================================
# Additional macro library for files
#===============================================================================

#-------------------------------------------------------------------------------

.eqv READ_ONLY	    0	# for reading
.eqv WRITE_ONLY	    1	# for writing
.eqv APPEND	    9	# for appending

# Openning file with some rules
.macro open(%file_name, %opt)
    li   	a7 1024     	# openning file
    mv      	a0 %file_name   # name of file
    li   	a1 %opt        	# flag
    ecall             	

.end_macro

#-------------------------------------------------------------------------------
# Чтение информации из открытого файла
.macro read(%file_descriptor, %strbuf, %size)
    li   a7, 63       		    # Системный вызов для чтения из файла
    mv   a0, %file_descriptor       # Дескриптор файла
    la   a1, %strbuf   	            # Адрес буфера для читаемого текста
    li   a2, %size 		    # Размер читаемой порции
    ecall             	            # Чтение
.end_macro

#-------------------------------------------------------------------------------
# read from openning file 
# %reg = address of the buffer 
# %size = maximum length to read
.macro read_addr_reg(%file_descriptor, %reg, %size)
    li   a7, 63       		    # read syscall
    mv   a0, %file_descriptor       # descriptor of file
    mv   a1, %reg   		    # address of buffer for reading file
    li   a2, %size 		    # reading size
    ecall             		    # reading from file
.end_macro

#-------------------------------------------------------------------------------
# Закрытие файла
.macro close(%file_descriptor)
    li   a7, 57       # Системный вызов закрытия файла
    mv   a0, %file_descriptor  # Дескриптор файла
    ecall             # Закрытие файла
.end_macro

#-------------------------------------------------------------------------------
# allocate dynamic memory
.macro allocate(%size)
    li a7, 9
    li a0, %size	# allocate %size
    ecall		
    # return => a0 = address to the allocated block
.end_macro

#-------------------------------------------------------------------------------
