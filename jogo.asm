.data
.include "\animacoes\player1idle.s"
.include "stage1.s"
.include "stage2.s"
.include "stage3.s"
.include "\animacoes\walk\walk1.s"
.include "\animacoes\walk\walk_1.s"
.include "\animacoes\start\stance1.s"
.include "\animacoes\start\stance2.s"
.include "\animacoes\high_punch\high_punch1.s"
.include "\animacoes\high_punch\high_punch2.s"
.macro stage(%adress,%initial_point,%end_point,%tempo)
STAGE:	bge %initial_point,%end_point,END_STAGE
	lw %tempo,0(%adress)
	sw %tempo,0(%initial_point)
	addi %initial_point,%initial_point,4
	addi %adress,%adress,4
	j STAGE
END_STAGE:
.end_macro

.macro frame_changer(%position,%init_screen,%end_screen,%frame,%aux)
	li %aux,0x100000
	xori %frame,%frame,1
	xor %position,%position,%aux
	xor %init_screen,%init_screen,%aux
	xor %end_screen,%end_screen,%aux
.end_macro

.macro image(%address,%position,%length,%height,%tempo,%tempo1,%tempo2,%mask,%corre)
	lw %length,0(%address)
	lw %height,4(%address)
	li %tempo1,0
	li %tempo2,0
	li %mask,-1
	addi %address,%address,8
IMAGE:	beq %tempo1,%height,END_IMAGE
	beq %tempo2,%length,CORRECTION
	lb %tempo,0(%address)
	beq %tempo,%mask,MASK
	sb %tempo,0(%position)
MASK:	addi %tempo2,%tempo2,1
	addi %address,%address,1
	addi %position,%position,1
	j IMAGE
CORRECTION:
	li %tempo2,0
	addi,%tempo1,%tempo1,1
	add %position,%position,%corre
	j IMAGE
END_IMAGE:
.end_macro

.macro keyboard(%address,%temp,%zero)
	lw %temp,0(%address)
	andi %temp,%temp,1
	bne %temp,%zero,Press
	li %temp,0
	j No_Press
Press:	lw %temp,4(%address)
No_Press:
.end_macro

	
.text	
	li s5,0		#current state player 1
	li s6,0 	#last state player 1
	li s7,0xFF200000	#Key state
	li s9,0xFF00C5D4	#current position player 1
	li s10,0xFF000000	#start of the screen
	li s11,0xFF012C00	#end of the screen
#######################################	
	la s2,stage3
	addi s2,s2,8
	mv s0,s10
	stage(s2,s0,s11,t1)
	
	la s3,stance1
	addi s0,s9,-320
	li t4,307
	image(s3,s0,s1,s2,t2,t0,t1,t3,t4)
	
	
	frame_changer(s9,s10,s11,s8,t1)
	
	
	la s2,stage3
	addi s2,s2,8
	mv s0,s10
	stage(s2,s0,s11,t1)
	
	la s3,stance2
	addi s0,s9,960
	li t4,291
	image(s3,s0,s1,s2,t2,t0,t1,t3,t4)
	
	li a0,250
	li a7,32
	ecall
	
	li s0,0xFF200604
	sw s8,0(s0)
	
	frame_changer(s9,s10,s11,s8,t1)
	
	la s2,stage3
	addi s2,s2,8
	mv s0,s10
	stage(s2,s0,s11,t1)
	
	la s3,stance1
	addi s0,s9,-320
	li t4,307
	image(s3,s0,s1,s2,t2,t0,t1,t3,t4)
	
	li a0,250
	li a7,32
	ecall
	
	li s0,0xFF200604
	sw s8,0(s0)
	
	li a0,250
	li a7,32
	ecall
	
################## animação do começo da luta ##################	
	
MAIN:	
	li s0,0xFF200604
	sw s8,0(s0)		#frame change		
	     
	keyboard(s7,t0,zero)

	
	frame_changer(s9,s10,s11,s8,t1)
	
	la s2,stage3		#loanding stage adresss
	addi s2,s2,8		#stage first color
	mv s0,s10		#first pixel
	stage(s2,s0,s11,t1)

	beq s6,zero,End_C_Ani			#
	li s3,101				#
	bne t0,s3,Corre_C_Ani			#
	la s3,high_punch2			#      LOOP de Continuação da animação
	li t4,281				#  ( no caso, eu ainda n criei um macro pro caso geral)   
	mv s0,s9				#
	image(s3,s0,s1,s2,t2,t0,t1,t3,t4)	#
	j MAIN					#
Corre_C_Ani:					#
	la s3,high_punch1			##
	li t4,292				##
	mv s0,s9				##            fim da animação
	image(s3,s0,s1,s2,t2,t0,t1,t3,t4)	##
	li s6,0					##
	j MAIN					##
End_C_Ani:
	li s6,0	
	li s3,100
	beq t0,s3,D				#
	li s3,97				#
	beq t0,s3,A				#       Check key
	li s3,101				#
	beq t0,s3,E				#
	
	la s3,player1idle			#
	mv s0,s9				#          IDLE
	li t4,280				#
	image(s3,s0,s1,s2,t2,t0,t1,t3,t4)	#
	
j MAIN

D:	la s3,walk1
	li t4,280
	addi s0,s9,-636				#(x+4,y+2)
	addi s9,s9,4
	image(s3,s0,s1,s2,t2,t0,t1,t3,t4)
	j MAIN
	
A:	la s3,walk_1
	li t4,288
	addi s0,s9,1				#(x+1,y)
	addi s9,s9,-4
	image(s3,s0,s1,s2,t2,t0,t1,t3,t4)
	j MAIN
	
E:	la s3,high_punch1
	li t4,292
	mv s0,s9
	image(s3,s0,s1,s2,t2,t0,t1,t3,t4)
	li s6,1
	j MAIN
