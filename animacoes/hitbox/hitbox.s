hurtbox:
.byte 32,37,7,13
hitbox_null:
.byte 0,0,0,0
null:
.byte 1
.byte -1,-1,-1,-1

hp_hit:
.byte 3
.half 18,28,1,11, 16,29,12,28, 11,36,29,52

#la t0,hp
#lb t1,0(t0)  => t1 == 3
#addi t0,t0,1
#lh t1,0(t0) => t1 == 18
