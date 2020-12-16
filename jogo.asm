.data
.include "yingyang.s"
pontos: .byte 0,0
stages: .byte 2
clocks: .word 0 , 0 
clock_color: .half 0xf800,0x0700,0xf800
cc: .byte 0
current_animation: .word 0,0
animation_state: .byte 0,0,0,0
high_punch_hurt: .half 31,36,6,11
p2_hitbox: .half 14,31,0,51
NOTAS: .word 62,270,62,270,59,270,59,270,57,270,57,270,59,270,59,270,62,70,62,70,62,70,62,70,62,70,62,70,62,70,62,70,62,70,62,70,62,70,62,70,62,600
fases: .word -1
dan: .string "  NOVICE"," 1ST DAN"," 2ND DAN"," 3RD DAN"," 4TH DAN"," 5TH DAN"," 6TH DAN"," 7TH DAN"," 8TH DAN"," 9TH DAN","10TH DAN"
.include "\animacoes\jump\jump.s"
.include "\animacoes\high_punch\high_punch.s"
.include "\animacoes\high_punch\high_punch2.s"
.include "\animacoes\jab\jab.s"
.include "\animacoes\jab\jab2.s"
.include "\animacoes\kick\kick.s"
.include "\animacoes\kick\kick2.s"
.include "\animacoes\player1idle.s"
.include "stage.s"
.include "\animacoes\crounch\low_punch.s"
.include "\animacoes\walk\walk.s"
.include "\animacoes\walk\walk_1.s"
.include "\animacoes\start\stance1.s"
.include "\animacoes\foward_sweep\foward_sweep.s"
.include "\animacoes\Flying_kick\flying_kick.s"
.include "\animacoes\death\death2.s"
.include "\animacoes\crounch\low_punch2.s"
.include "\animacoes\guard\guard.s"
.include "\animacoes\backwards_sweep\back_sweep.s"
.include "\animacoes\round_house\round_house.s"
.include "\animacoes\high_back_kick\high_back_kick.s"
.include "\animacoes\walk\walk2.s"
.include "\MACROSv21.s"

.macro conti_ani()
	mv a6,s3
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
.end_macro
.macro conti_ani2()
	mv s5,s3
	la t0,current_animation
	sw t6,4(t0)
	mv s0,s6
	li t5,1
	advance_animation2(s3,t5)
	image(s3,s0,s1,s2)
	
	la t0,animation_state
	li t1,1
	lb t2,0(t6)
	sb t1,2(t0)
	sb t2,3(t0)
.end_macro

.macro pontos()
	la s0,yingyang
	la t0,pontos
	lb t0,0(t0)
	beq t0,zero,NEXT_YY
	addi t0,t0,-1
	li t1,640
	mul t0,t0,t1
	add s0,s0,t0
	
	li s8,0x2828
	add s8,s10,s8
					#frame changer
	li t0,0
	li t1,0
	li s1,40
	li s2,16
YY:	beq t0,s2,NEXT_YY
	beq t1,s1,CORRE_YY
		lw t4,0(s0)
		sw t4,0(s8)
		addi s0,s0,4
		addi s8,s8,4
		addi t1,t1,4
		j YY
CORRE_YY:
	li t1,0
	addi s8,s8,280
	addi t0,t0,1
	j YY
NEXT_YY:
	la s0,yingyang
	addi s0,s0,1920
	addi s0,s0,640
	la t0,pontos
	lb t0,1(t0)
	beq t0,zero,END_YY	
	addi t0,t0,-1
	li t1,640
	mul t0,t0,t1
	add s0,s0,t0
	
	li s8,0x2828
	add s8,s10,s8 
	
	li t0,0
	li t1,0
	li s1,40
	li s2,16
YY1:	beq t0,s2,END_YY
	beq t1,s1,CORRE_YY1
		lw t4,0(s0)
		sw t4,0(s8)
		addi s0,s0,4
		addi s8,s8,4
		addi t1,t1,4
		j YY1
CORRE_YY1:
	li t1,0
	addi s8,s8,280
	addi t0,t0,1
	j YY1
END_YY:
.end_macro

.macro check_hitbox(%hurt, %hit, %phurt, %phit)    #macro para checar colisao entre hitboxes
    li a0,0                    #hitboxes sao .half x1,x2,y1,y2
    #ys das hitboxes            #retorna a0 = 0 se falso, a0 = 1 se verdadeiro, a0 = 2 se for golpe perfeito
    lh t0,4(%hurt)
    lh t1,6(%hurt)
    lh t2,4(%hit)
    lh t3,6(%hit)
    sub t4,s10,%phurt
    li t5,320
    div t4,t4,t5
    add t0,t0,t4
    add t1,t1,t4
    sub t4,s10,%phit
    div t4,t4,t5
    add t2,t2,t4
    add t3,t3,t4
    blt t3,t0,END
    bgt t2,t1,END
    
    #xs das hitboxes
    lh t0,0(%hurt)
    lh t1,2(%hurt)
    lh t2,0(%hit)
    lh t3,2(%hit)
    sub t4,s10,%phurt
    li t5,320
    rem t4,t4,t5
    add t0,t0,t4
    add t1,t1,t4
    sub t4,s10,%phit
    div t4,t4,t5
    add t2,t2,t4
    add t3,t3,t4
    blt t3,t0,END
    bgt t2,t1,END
    
    li a0,1
    bne t1,t2,END
    li a0,2

END:
.end_macro

.macro stage()
	mv t1,a5
	#addi t1,t1,8
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

.macro advance_animation2(%image_adress,%time)
	la t0,current_animation
	lw t0,4(t0)
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
	la s3,stance3
	mv s0,s6
	addi s0,s0,16
	image(s3,s0,s1,s2)
	frame_changer()
	stage()
	la s3,stance2
	mv s0,s9
	image(s3,s0,s1,s2)
	la s3,stance4
	mv s0,s6
	image(s3,s0,s1,s2)
	li a0,250
	li a7,32
	ecall
	frame_changer()
	stage()
	la s3,stance1
	mv s0,s9
	image(s3,s0,s1,s2)
	la s3,stance3
	mv s0,s6
	addi s0,s0,16
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
	ble t0,zero,NEXT_STAGE		#ELSE -> NEXT_STAGE
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
	#li a2,25
	#li a1,145
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
	lb t1,0(t6)
	lb t2,1(t6)
	bne t1,t2,NO_HIT
	la s1,high_punch_hurt
        la s2,p2_hitbox
        check_hitbox(s1,s2,s9,s6)
	j HIT
NO_HIT:
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



.macro next_stage()
	la t0,stages
	lb t3,0(t0)
	li t2,3
	addi t3,t3,1
	rem t3,t3,t2
	sb t3,0(t0)
	la t0,stage
	li t1, 76800
	mul t1,t1,t3
	add a5,t0,t1
	
.end_macro

.macro jump()
	li t6,119
	beq a6,t6,JUMP 
	li t6,87
	beq a6,t6,JUMP
	j CONTI_JUMP
JUMP:	la t6,animation_state
	lb t1,0(t6)
	lb t2,1(t6)
	addi t1,t1,1
	sb t1,0(t6)
	
	slli t2,t2,1
	
	beq t1,zero,CONTI_JUMP
	mv s0,s9
	bge t1,t2,KEY_CHECK
	
	srai t2,t2,1
	
	bgt t1,t2,IF_JUMP
	
	mv t3,t1
	j ELSE_JUMP
IF_JUMP:
	slli t2,t2,1
	sub t3,t2,t1
ELSE_JUMP:
	
	advance_animation(s3,t3)
	image(s3,s0,s1,s2)
	j MAIN
CONTI_JUMP:	
	
.end_macro

.macro jump2()
	#li t6,117
	#beq s5,t6,JUMP2 
	#li t6,85
	#beq s5,t6,JUMP2
	#j CONTI_JUMP2
JUMP2:	la t6,animation_state
	lb t1,2(t6)
	lb t2,3(t6)
	addi t1,t1,1
	sb t1,2(t6)
	
	slli t2,t2,1
	
	beq t1,zero,CONTI_JUMP2
	mv s0,s6
	bge t1,t2,KEY
	
	srai t2,t2,1
	
	bgt t1,t2,IF_JUMP2
	
	mv t3,t1
	j ELSE_JUMP2
IF_JUMP2:
	slli t2,t2,1
	sub t3,t2,t1
ELSE_JUMP2:
	
	advance_animation2(s3,t3)
	image(s3,s0,s1,s2)
	j PLAYER1
CONTI_JUMP2:	
	
.end_macro

.macro walk()
	li t3,100
	beq a6,t3,WALK
	li t3,97
	beq a6,t3,WALK
	j WALK_CONTI

WALK:	bne t5,t3,KEY_CHECK
	la t6,animation_state
	lb t1,0(t6)
	lb t2,1(t6)
	beq t1,t2,WALK_IF
	li t3,97
	beq a6,t3,MINUS
	addi s9,s9,4
	j NEXT_WALK
MINUS:	addi s9,s9,-4
NEXT_WALK:	
	addi t1,t1,1
	sb t1,0(t6)
	j WS
WALK_IF:	
	li t1,1
	sb t1,0(t6)
	addi s9,s9,4
WS:	mv s0,s9
	advance_animation(s3,t1)
	image(s3,s0,s1,s2)
	j MAIN
WALK_CONTI:	
	
.end_macro

.macro walk2()
	li t3,104
	beq s5,t3,WALK2
	li t3,107
	beq s5,t3,WALK2
	j WALK_CONTI2

WALK2:	bne t5,t3,KEY
	la t6,animation_state
	lb t1,2(t6)
	lb t2,3(t6)
	li t3,107
	beq s5,t3,MINUS2
	addi s6,s6,-4
	j NEXT_WALK2
MINUS2:	addi s6,s6,4
NEXT_WALK2:	
	beq t1,t2,WALK_IF2
	addi t1,t1,1
	sb t1,2(t6)
	j WS2
WALK_IF2:	
	li t1,1
	sb t1,2(t6)
WS2:	mv s0,s6
	advance_animation2(s3,t1)
	image(s3,s0,s1,s2)
	j PLAYER1
WALK_CONTI2:	
	
.end_macro

.macro theme()
	li s1,21				
	la s0,NOTAS		
	li t0,0			
	li a2,7		
	li a3,127		

LOOPM:	beq t0,s1, FIM		
	lw a0,0(s0)		
	lw a1,4(s0)		
	li a7,31		
	ecall			
	mv a0,a1		
	li a7,32		
	ecall			
	addi s0,s0,8		
	addi t0,t0,1		
	j LOOPM			
FIM:	
.end_macro

.macro dan()
	la t0,fases
	li t2,9
	lw t1,0(t0)
	la t0,dan
	mul t1,t1,t2
	add a0,t0,t1
	li a2,60
	li a1,42
	li a7,104
	ecall
.end_macro

.text	
	li a3,0x0700
	li s7,0xFF200000	#Key state
	li s10,0xFF000000	#start of the screen
	li s11,0xFF012C00	#end of the screen
	
	j NEXT_STAGE
Y:	
	la t6,high_punch2
	j KEYS1
B: 	
	la t6,jab2
	j KEYS1
u:
	la t6,flying_kick2
	addi t6,t6,1
	j KEYS1
	
h:	la t6,mid_kick2
	j KEYS1
y:	la t6,high_kick2
	addi t6,t6,2
	j KEYS1
b:	la t6,short_jab_kick2
	j KEYS1

N:	la t6,low_punch2
	conti_ani2()
	li s5,98
	j PLAYER1
k:	la s3,guard2
	mv s0,s6
	image(s3,s0,s1,s2)
	j PLAYER1
m:	la t6,back_sweep2
	j KEYS1
H:	la t6,walk2				
	addi s6,s6,-4
	j KEYS1
	
K:	la t6,walk2			
	addi s6,s6,4
	j KEYS1

KEYS1:
	conti_ani2()
	j PLAYER1
	
###########
NEXT_STAGE:
	theme()
	la t0,animation_state
	sb zero,0(t0)
	sb zero,2(t0)
	
	la t0,fases
	lw t1,0(t0)
	addi t1,t1,1
	sw t1,0(t0)
	li t2,11
	beq t1,t2,END_GAME
	li s6,0xFF00C775 	#current position player 2
	li s9,0xFF00C5D4	#current position player 1
	li t0,0x100000
	mul t0,t0,a4
	or s6,s6,t0
	or s9,s9,t0

	
	la t0,pontos
	sb zero,0(t0)
	sb zero,0(t0)
	next_stage()
	
	la t0,cc
	lb t1,0(t0)
	
	la t0,clock_color
	li t2,2
	mul t2,t1,t2
	add t0,t0,t2
	lh a3,0(t0)
	
	la t0,cc
	addi t1,t1,1
	li t2,3
	rem t1,t1,t2
	sb t1,0(t0)
	
	start_animation()
	li a2,60	
	
	
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
	dan()
	clock()
	frame_changer()
	stage()
	pontos()
	
	la t2,clocks
	lw a0,0(t2)	
	li a1,145
	li a7,101	#li a7,101 muda o valor s8
	ecall		
	
	walk2()
	jump2()	
KEY:	li s3,121
	beq t5,s3,Y
	li s3,98
	beq t5,s3,B
	li s3,85
	beq t5,s3,u
	li s3,72
	beq t5,s3,h
	li s3,89
	beq t5,s3,y
	li s3,66
	beq t5,s3,b
	li s3,110
	beq s3,t5,N
	li s3,75
	beq s3,t5,k
	li s3,77
	beq s3,t5,m
	li s3,104
	beq s3,t5,H
	li s3,107
	beq s3,t5,K
	la s3,player2idle
	mv s0,s6
	image(s3,s0,s1,s2)
PLAYER1:
	walk()
	jump()
	animation()
KEY_CHECK:
	
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
	li s3,119
	beq t5,s3,W
	li s3,69
	beq t5,s3,e
	li s3,68
	beq t5,s3,d
	li s3,67
	beq t5,s3,c
	li s3,88
	beq t5,s3,x
	li s3,87
	beq t5,s3,w
	li s3,115
	beq t5,s3,S
	li s3,65
	beq t5,s3,a
	li s3,81
	beq t5,s3,q
IDLE1:	#la t6,animation_state
	#sb zero,0(t6)
	la s3,player1idle			#
	mv s0,s9				#          IDLE		
	image(s3,s0,s1,s2)			#
	j MAIN
END_GAME:
	li a7,10
	ecall

HIT:	
	beq a0,zero,MAIN
	mv t0,a3
	li a0,39		
	li a1,290		
	li a2,127		
	li a3,127		
	li a7,33		
	ecall
	mv a3,t0	
	la t0,pontos
	li t1,4
	lb t2,0(t0)
	addi t2,t2,1
	sb t2,0(t0)
	bne t1,t2,MAIN
	pontos()
	frame_changer()
	j NEXT_STAGE
	
D:	la t6,walk
	addi s9,s9,4
	j KEYS
	
S:	la s3,guard
	mv s0,s9
	image(s3,s0,s1,s2)
	j MAIN
	
A:
	la t6,walk
	addi s9,s9,-4
	j KEYS
	
E:	la t6,high_punch
	j KEYS

C:	la t6,jab
	j KEYS
X:	la t6,low_punch
	conti_ani()
	li a6,99
	j MAIN
W:	la t6,jump
	addi t6,t6,1
	j KEYS
e:	la t6,high_kick
	j KEYS
d:	la t6,mid_kick
	j KEYS
c:	la t6,short_jab_kick
	j KEYS
x:	la t6,foward_sweep
	addi t6,t6,3
	j KEYS
w:	la t6,flying_kick
	j KEYS
a:	la t6,round_house
	j KEYS
q:	la t6,high_back_kick
	j KEYS
KEYS:	conti_ani()
	j MAIN
.include "\SYSTEMv21.s"
