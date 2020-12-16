#level 0: high punch and jab
#level 1: level 0 and low punch
#level 2: level 1 and forward sweep
#
#0 -> nothing
#1 -> high punch
#2 -> jab
#3 -> low punch
#4 -> forward sweep
#
#

.macro randint(%reg,%range)
	li a0,0
	mv a1,%range
	li a7,42
	ecall
	mv %reg,a0
	mv a1,%reg
	li a7,40
	ecall
.end_macro

.text
p2_ctrl:
	sub t6,s6,s9	
	
	li t1,0
	beq t0,t1,level0
	li t1,1
	beq t0,t1,level1
	
level0:	addi t0,t0,3
	randint(t1,t0)
	
level1:	




p2_end:	ret
