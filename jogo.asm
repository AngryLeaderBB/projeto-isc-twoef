.data
clocks: .word 0 , 0 
current_animation: .word 0,0
animation_state: .byte 0,0,0,0
.include "\animacoes\high_punch\high_punch.s"
.include "\animacoes\jab\jab.s"
.include "\animacoes\high_kick\high_kick.s"
.include "\animacoes\player1idle.s"
.include "\animacoes\player2idle.s"
.include "stage.s"
.include "\animacoes\crounch\low_punch.s"
.include "\animacoes\walk\walk1.s"
.include "\animacoes\walk\walk_1.s"
.include "\animacoes\start\stance1.s"
.include "\animacoes\start\stance2.s"
.include "\MACROSv21.s"

	
.macro stage()
	mv t1,a5
	addi t1,t1,8
	mv t0,s10
STAGE:	bge t0,s11,END_STAGE
	lw t2,0(t1)
	sw t2,0(t0)
	addi t0,t0,4
	addi t1,t1,4
	j STAGE
END_STAGE:
.end_macro
	
.macro frame_changer()
	li s0,0xFF200604
	sw a4,0(s0)
	li t1,0x100000
	xori a4,a4,1
	xor s9,s9,t1
	xor s6,s6,t1
	xor s10,s10,t1
	xor s11,s11,t1
.end_macro
		
.macro image(%address,%position,%length,%height)
	lw %length,0(%address)
	lw %height,4(%address)
	
	li t4,320
	li t2,52
	sub t2,t2,%height
	mul t2,t2,t4
	add %position,%position,t2
	sub t4,t4,%length
				
	li t0,0
	li t1,0
	li t3,-1
	addi %address,%address,8
IMAGE:	beq t0,%height,END_IMAGE
	beq t1,%length,CORRECTION
	lb t2,0(%address)
	beq t2,t3,MASK
	sb t2,0(%position)
MASK:	addi t1,t1,1
	addi %address,%address,1
	addi %position,%position,1
	j IMAGE
CORRECTION:
	li t1,0
	addi,t0,t0,1
	add %position,%position,t4
	j IMAGE
END_IMAGE:
.end_macro

.macro keyboard(%temp)
	lw %temp,0(s7)
	andi %temp,%temp,1
	bne %temp,zero,Press
	li %temp,0
	j No_Press
Press:	lw %temp,4(s7)
No_Press:
.end_macro

.macro advance_animation(%image_adress,%time)
	la t0,current_animation
	lw t0,0(t0)
	li %image_adress,4
	mul %image_adress,%image_adress,%time
	add %image_adress,%image_adress,t0
	lw %image_adress,0(%image_adress)
	add %image_adress,%image_adress,t0
.end_macro

.macro start_animation()	
	stage()
	
	la s3,stance1
	mv s0,s9
	image(s3,s0,s1,s2)
	frame_changer()
	stage()
	la s3,stance2
	mv s0,s9
	image(s3,s0,s1,s2)
	li a0,250
	li a7,32
	ecall
	frame_changer()
	stage()
	la s3,stance1
	mv s0,s9
	image(s3,s0,s1,s2)
	li a0,250
	li a7,32
	ecall
	li s0,0xFF200604
	sw a4,0(s0)
	li a0,250
	li a7,32
	ecall
.end_macro

.macro clock()
	la t2,clocks
	lw t0,0(t2)
	lw t1,4(t2)
	li t4,1000
	ble t0,zero,ELSE		#ELSE -> END
	li a7,30
	ecall
	sub t3,a0,t1		
	div t3,t3,t4
	sub t0,t0,t3
	bgt t3,zero,IF
	j ELSE
IF:	sw t0,0(t2)
	sw a0,4(t2)
	mv a0,t0
	li a1,145
	li a7,101
	ecall
ELSE:
.end_macro


.macro animation()
	la t6,animation_state
	lb t1,0(t6)
	lb t2,1(t6)
	
	beq t1,zero,CONTI
	mv s0,s9
	beq t1,t2,ESTA
	beq t5,a6,CONTI_IF
			
	addi t1,t1,-1
	sb t1,0(t6)
	beq t1,zero,CONTI
	advance_animation(s3,t1)
	image(s3,s0,s1,s2)
	j MAIN
CONTI_IF:
	addi t1,t1,1
	sb t1,0(t6)
	advance_animation(s3,t1)
	image(s3,s0,s1,s2)
	j MAIN
ESTA:	
	beq t5,a6,ESTA_IF
	addi t1,t1,-1
	sb t1,0(t6)
ESTA_IF:
	advance_animation(s3,t1)
	image(s3,s0,s1,s2)
	j MAIN
CONTI:	
	
.end_macro

.text	
	li s5,0		#current state player 1
	li s6,0xFF00C775 	#current position player 2
	li s7,0xFF200000	#Key state
	li s9,0xFF00C5D4	#current position player 1
	li s10,0xFF000000	#start of the screen
	li s11,0xFF012C00	#end of the screen
	la a5,stage2	
		
	start_animation()
	
###########
	li a3,0x38
	li a2,25
	
	la t1,clocks
	li t0,30		
	sw t0,0(t1)
	li t2,1000
	li a7,30
	ecall
	sw a0,4(t1)		
	li a0,30
	li a1,145
	li a7,101
	ecall
########
	
MAIN:			#frame change		
	keyboard(t5)
	clock()
	frame_changer()
	
	stage()
	
	la t2,clocks
	lw a0,0(t2)	
	li a1,145	
	li a7,101	#li a7,101 muda o valor s8
	ecall		
	
	#la s3,player2idle
	#mv s0,s6
	#image(s3,s0,s1,s2)
	
	animation()
	
	li s3,100
	beq t5,s3,D				#
	li s3,97				#
	beq t5,s3,A				#       Check key
	li s3,101				#
	beq t5,s3,E
	li s3,99				#
	beq t5,s3,C
	li s3,120
	beq t5,s3,X
	la s3,player1idle			#
	mv s0,s9				#          IDLE		
	image(s3,s0,s1,s2)			#
	
j MAIN

D:	la s3,walk1
	addi s0,s9,4			
	addi s9,s9,4
	image(s3,s0,s1,s2)
	j MAIN
	
A:	la s3,walk_1
	addi s0,s9,4				
	addi s9,s9,-4
	image(s3,s0,s1,s2)
	j MAIN
	
E:	la t6,high_punch
	la t0,current_animation
	sw t6,0(t0)
	mv s0,s9
	li t5,1
	advance_animation(s3,t5)
	image(s3,s0,s1,s2)
	
	la t0,animation_state
	li t1,1
	lb t2,0(t6)
	sb t1,0(t0)
	sb t2,1(t0)
	la t0,animation_state
	
	li a6,101
	j MAIN

C:	la t6,jab
	la t0,current_animation
	sw t6,0(t0)
	mv s0,s9
	li t5,1
	advance_animation(s3,t5)
	image(s3,s0,s1,s2)
	
	la t0,animation_state
	li t1,1
	lb t2,0(t6)
	sb t1,0(t0)
	sb t2,1(t0)
	la t0,animation_state
	
	li a6,99
	j MAIN
X:	la t6,low_punch
	la t0,current_animation
	sw t6,0(t0)
	mv s0,s9
	li t5,1
	advance_animation(s3,t5)
	image(s3,s0,s1,s2)
	
	la t0,animation_state
	li t1,1
	lb t2,0(t6)
	sb t1,0(t0)
	sb t2,1(t0)
	la t0,animation_state
	
	li a6,99
	j MAIN

.include "\SYSTEMv21.s"
