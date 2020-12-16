.data
animation_state: .byte 1,3

.macro walk()
	li t3,101
	beq a6,t3,WALK
	j IDLE1
	li t3,97
	beq a6,t3,WALK
	j IDLE1

WALK:	la t6,animation_state
	lb t1,0(t6)
	lb t2,1(t6)
		
	
	beq t1,zero,IDLE1
	mv s0,s9
	beq t1,t2,IDLE1
	
	addi t1,t1,1
	sb t1,0(t6)
	advance_animation(s3,t1)
	image(s3,s0,s1,s2)
	j MAIN
		
.end_macro

.text
MAIN:
	animation()
	li a7,10
	ecall
