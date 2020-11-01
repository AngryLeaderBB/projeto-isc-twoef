.data	
.include "yingyang.s"
.include "ying.s"	

.text
	la s2,yingyang
	lw s0,8(s2)
	lw t2,0(s2)          #tamanho altura e largura /4
	li t0,0
	li t1,0	
	li t4,-1
	addi s2,s2,24
LOOP1:	beq t0,t2,END
LOOP2:	beq t1,t2,CORRE
	lb t3,0(s2)
	beq t3,t4,COLOR
	sb  t3,0(s0)
COLOR:	addi s0,s0,1
	addi s2,s2,1
	addi t1,t1,1
	j LOOP2
CORRE:	li t1,0
	addi t0,t0,1
	addi s0,s0,304
	j LOOP1
END:	li a7,10
	ecall
