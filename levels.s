#level 0: high punch + jab
#level 1: level 0 + low punch + forward sweep
#level 2: level 1 + mid kick + high kick
#level 3: level 2 + short jab kick
#level 4: level 3 + backward sweep + high back kick

#0 -> nothing
#1 -> high punch
#2 -> jab
#3 -> low punch
#4 -> forward sweep
#5 -> mid kick
#6 -> high kick
#7 -> short jab kick
#8 -> backward sweep
#9 -> high back kick

.macro randint(%reg,%range)
	li a0,0
	mv a1,%range
	li a7,42
	ecall
	mv %reg,a0
	li a7,41
	ecall
	mv a1,a0
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
	li t1,2
	beq t0,t1,level2
	li t1,3
	beq t0,t1,level3
	li t1,4
	beq t0,t1,level4
	
level0:	addi t0,t0,3
	randint(t1,t0)
	j p2_end
	
level1:	li t2,40
	bgt t6,t2,p2wl
	li t2,25
	blt t6,t2,p2wr
	addi t0,t0,3
	randint(t1,t0)
	j p2_end

level2:	li t2,35
	bgt t6,t2,p2wl
	li t2,25
	blt t6,t2,p2wr
	addi t0,t0,4
	randint(t1,t0)
	j p2_end

level3:	li t2,35
	bgt t6,t2,p2wl
	li t2,25
	blt t6,t2,p2wr
	addi t0,t0,4
	randint(t1,t0)
	j p2_end

level4:li t2,35
	bgt t6,t2,p2wl
	li t2,25
	blt t6,t2,p2wr
	li t2,30
	blt t6,t2,p2grd
	addi t0,t0,5
	randint(t1,t0)
	j p2_end

p2_end:	li t2,1
	beq t1,t2,p2_hp
	li t2,2
	beq t1,t2,p2_jab
	li t2,3
	beq t1,t2,p2_lp
	#li t2,4
	#beq t1,t2,p2_fs
	li t2,5
	beq t1,t2,p2_mk
	li t2,6
	beq t1,t2,p2_hk
	li t2,7
	beq t1,t2,p2_sjk
	li t2,8
	beq t1,t2,p2_bs
	#li t2,9
	#beq t1,t2,p2_hbk
	ret

p2wl:	li t5,104
	ret

p2wr:	li t5,107
	ret

p2grd:	li t5,75
	ret

p2_hp:	li t5,121
	ret
	
p2_jab:	li t5,98
	ret
	
p2_lp:	li t5,110
	ret	
	
#p2_fs:	
	
	
p2_mk:	li t5,72
	ret

p2_hk:	li t5,89
	ret

p2_sjk:	li t5,66
	ret

p2_bs:	li t5,77
	ret

#p2_hbk: