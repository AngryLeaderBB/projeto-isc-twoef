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
	li t2,320
	rem t3,s6,t2
	rem t4,s9,t2
	sub t6,t3,t4	

	li t1,0
	beq t0,t1,level0
	li t1,1
	beq t0,t1,level1
	
level0:	addi t0,t0,3
	randint(t5,t0)
	ret
	
level1:	li t2,40
	bgt t6,t2,p2wl
	blt t6,t2,p2wr
	ret


p2wl:	li t5,104
	ret

p2wr:	li t5,107
	ret
