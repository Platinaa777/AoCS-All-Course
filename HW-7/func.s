
# sleep
.macro sleep (%ms)
	li	a0 %ms
	li	a7 32
	ecall
.end_macro

# display number
.macro display(%t, %ind)
	lw	a1 %ind
	mv	a0 %t
	jal	display_digit
.end_macro