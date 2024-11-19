.text
MAIN:
 	lu12i.w $a0, -1 # 0xfffff   


TEST:
	ld.b $s0,$a0,0x70#b
	ld.b $s1,$a0,0x71#a
	ld.b $s2,$a0,0x72
	andi $s0,$s0,0xff
	andi $s1,$s1,0xff
	srli.w $s2,$s2,5 #op
	andi $s2,$s2,0x7
	
#	addi.w $s0,$zero,0x25
#	addi.w $s1,$zero,0x10
	#addi.w $s2,$zero,0x1

	addi.w $t1,$zero,0 #情况计数
	beq $s2,$t1,CASE0
	addi.w $t1,$t1,1
	beq $s2,$t1,CASE1 #加法
	addi.w $t1,$t1,1
	beq $s2,$t1,CASE2 #减法
	addi.w $t1,$t1,1
	beq $s2,$t1,CASE3 #乘法
	addi.w $t1,$t1,1
	beq $s2,$t1,CASE4 #除法
	addi.w $t1,$t1,1
	beq $s2,$t1,CASE5 #生成随机数

	b TEST
CASE0:
	addi.w $a7,$zero,0 #结果置0
	addi.w $a6,$zero,0 #
	addi.w $u0,$zero,0 #标志位置0
	b DONE
CASE1:
	addi.w $a1,$zero,10 #进位
	andi $a2,$s0,0xf #小数b
	srli.w $a3,$s0,0x4 #整数b
	andi $a4,$s1,0xf #小数a
	srli.w $a5,$s1,0x4 #整数a
	add.w $a7,$a3,$a5#整数相加
	add.w $a6,$a2,$a4#小数相加
	blt $a6,$a1,BT8
	addi.w $a6,$a6,-10
	addi.w $a7,$a7,1
BT8:
	addi.w $a1,$zero,0 #边界
	addi.w $a2,$zero,0 #个位
	addi.w $a3,$zero,0 #十位
	addi.w $s7,$zero,0x5 #寄存次数
	addi.w $a4,$zero,0x5
BT8LOOP:
	blt $s7,$a1,BLDONE
	
	blt $a2,$a4,ONEXT
	addi.w $a2,$a2,0x3
ONEXT:
	blt $a3,$a4,TNEXT
	addi.w $a3,$a3,0x3
TNEXT:
	slli.w $a3,$a3,0x1#取十位数高三位
	andi $t1,$a2,0x8#个位数第四位
	srli.w $t1,$t1,0x3 #移到低位
	or $a3,$a3,$t1
	slli.w $a2,$a2,0x1
	srl.w $t2,$a7,$s7#g高位整数移动到低位
	andi $t2,$t2,0x1
	or $a2,$a2,$t2#拼接
	addi.w $s7,$s7,-1
	andi $a2,$a2,0xf
	andi $a3,$a3,0xf
	b BT8LOOP
BLDONE:
	andi $a2,$a2,0xf
	andi $a3,$a3,0xf
	slli.w $a3,$a3,0x4
	or $a7,$a3,$a2#整数结果保存在a7
	
	addi.w $u0,$zero,0x0
	
	b DONE
	

CASE2:
	blt $s0,$s1,SKIPSET #保证a位置大于b位置
	addi.w $t1,$s0,0x0
	addi.w $s0,$s1,0x0
	addi.w $s1,$t1,0x0
SKIPSET:
	andi $a2,$s0,0xf #小数b
	srli.w $a3,$s0,0x4 #整数b
	andi $a4,$s1,0xf #小数a
	srli.w $a5,$s1,0x4 #整数a
	sub.w $a6,$a4,$a2 #小数相减
	sub.w $a7,$a5,$a3 #整数相减
	bge $a6,$zero,SKIPMINUS 
	#小数为负
	addi.w $a7,$a7,-1
	addi.w $a6,$a6,0xa
SKIPMINUS:
	b BT8

CASE3:
	addi.w $a1,$zero,0xa #进位
	addi.w $a3,$s0,0x0#b
	andi $a6,$s1,0xf #小数a
	srli.w $a7,$s1,0x4 #整数a
	sll.w $a7,$a7,$a3 #整数移位
	sll.w $a6,$a6,$a3 #小数移位
CASE3LOOP:
	blt $a6,$a1,ADDDONE
	addi.w $a7,$a7,0x1
	addi.w $a6,$a6,-10
	b CASE3LOOP
ADDDONE:
	bl BT8v1
	
	addi.w $u0,$zero,0
	
	b DONE
BT8v1:
	addi.w $a1,$zero,0x0 #边界
	addi.w $a2,$zero,0x0 #个位
	addi.w $a3,$zero,0x0 #十位
	addi.w $s5,$zero,0x0 #百位
	addi.w $s6,$zero,0x0 #千位
	addi.w $s4,$zero,0x0 #万位(除法)
	addi.w $s7,$zero,0x10 #寄存次数
	addi.w $a4,$zero,0x5
BT8LOOPv1:
	blt $s7,$a1,BLDONEv1
	
	blt $a2,$a4,ONEXTv1
	addi.w $a2,$a2,0x3
ONEXTv1:
	blt $a3,$a4,TNEXTv1
	addi.w $a3,$a3,0x3
TNEXTv1:
	blt $s5,$a4,HNEXT
	addi.w $s5,$s5,0x3
HNEXT:
	blt $s6,$a4,DNEXT
	addi.w $s6,$s6,0x3
DNEXT:
	blt $s4,$a4,MNEXT
	addi.w $s4,$s4,0x3
MNEXT:
	slli.w $s4,$s4,0x1#取千位数高三位
	andi $t4,$s6,0x8#百位数第四位
	srli.w $t4,$t4,0x3#移到低位
	or $s4,$s4,$t4
	slli.w $s6,$s6,0x1#取千位数高三位
	andi $t4,$s5,0x8#百位数第四位
	srli.w $t4,$t4,0x3#移到低位
	or $s6,$s6,$t4
	slli.w $s5,$s5,0x1#取百位数高三位
	andi $t3,$a3,0x8#十位数第四位
	srli.w $t3,$t3,0x3#移到低位
	or $s5,$s5,$t3
	slli.w $a3,$a3,0x1#取十位数高三位
	andi $t1,$a2,0x8#个位数第四位
	srli.w $t1,$t1,0x3 #移到低位
	or $a3,$a3,$t1
	slli.w $a2,$a2,0x1
	srl.w $t2,$a7,$s7#g高位整数移动到低位
	andi $t2,$t2,0x1
	or $a2,$a2,$t2#拼接
	addi.w $s7,$s7,-1
	andi $a2,$a2,0xf
	andi $a3,$a3,0xf
	andi $s5,$s5,0xf
	andi $s6,$s6,0xf
	andi $s4,$s4,0xf
	b BT8LOOPv1
BLDONEv1:
	andi $a2,$a2,0xf
	andi $a3,$a3,0xf
	andi $s5,$s5,0xf
	andi $s6,$s6,0xf
	andi $s4,$s4,0xf
	slli.w $a3,$a3,0x4
	slli.w $s5,$s5,0x8
	slli.w $s6,$s6,12
	slli.w $s4,$s4,16
	or $a7,$a3,$a2#整数结果保存在a7
	or $a7,$a7,$s5
	or $a7,$a7,$s6
	or $a7,$a7,$s4
	jirl $zero,$ra,0x0
CASE4:
	addi.w $a3,$s0,0x0#b
	andi $a6,$s1,0xf #小数a
	srli.w $a7,$s1,0x4 #整数a
	slli.w $a4,$a7,0xd
	slli.w $a5,$a7,0xa
	add.w $a4,$a4,$a5
	slli.w $a5,$a7,0x9
	add.w $a4,$a4,$a5
	slli.w $a5,$a7,0x8
	add.w $a4,$a4,$a5
	slli.w $a5,$a7,0x4
	add.w $a4,$a4,$a5 # 整数a7*10000
	addi.w $t1,$a4,0x0
	###
	slli.w $a4,$a6,0x9
	slli.w $a5,$a6,0x8
	add.w $a4,$a4,$a5
	slli.w $a5,$a6,0x7
	add.w $a4,$a4,$a5
	slli.w $a5,$a6,0x6
	add.w $a4,$a4,$a5
	slli.w $a5,$a6,0x5
	add.w $a4,$a4,$a5 
	slli.w $a5,$a6,0x3
	add.w $a4,$a4,$a5# 小数a6*1000
	
	add.w $a4,$t1,$a4 # 归位
	srl.w $a4,$a4,$a3 #a/2^b
	addi.w $a7,$a4,0x0
	bl BT8v1
	slli.w $t1, $a7, 0x10   # 左移16位，高位清零
	srli.w $a6, $t1, 0x10     # 右移16位，低16位移到最低位
	srli.w $a7,$a7,0x10  
	
	addi.w $u0,$zero,0x0
	
	b DONE
CASE5:
	addi.w $t1,$zero,0 
	beq $u0,$t1,SEED#标志位置0
	#addi.w $t2,$t2,24960 #空指令循环80 65536*80
	lu12i.w $t2,0x01800	

	addi.w $t1,$zero,0
WAIT:
	bge $t1,$t2,SKIPWAIT
	addi.w $t1,$t1,0x1
	b WAIT
SKIPWAIT:
	andi $t1,$a1,0x1 #零位
	srli.w $t2,$a1,0x1
	andi $t2,$t2,0x1 # ? ?
	srli.w $t3,$a1,21
	andi $t3,$t3,0x1 #21
	srli.w $t4,$a1,31
	andi $t4,$t4,0x1 #31
	xor $t5,$t1,$t2
	xor $t5,$t5,$t3
	xor $t5,$t5,$t4
	andi $t5,$t5,0x1
	slli.w $a1,$a1,0x1#移位
	or $a1,$a1,$t5
	st.w $a1,$a0,0x0
	b TEST
SEED:
	addi.w $u0,$zero,1 #标志位置1
	slli.w $a1,$s0,24
	slli.w $t2,$s1,16
	or $a1,$a1,$t2
	slli.w $t2,$s0,8
	or $a1,$a1,$t2
	or $a1,$a1,$s1 #生成种子
	st.w $a1,$a0,0x0
	b CASE5

DONE:
	#st.b $a7,$a0,0x60
	#st.h $a6,$a0,0x0
	#st.h $a7,$a0,0x2
	#b TEST

	ld.w $t1,$a0,0x60
	andi $t1,$t1,-256 	#0xffffff00
	andi $t2,$a7,0xff
	or $t3,$t1,$t2
	st.w $t3,$a0,0x60

	
	lu12i.w $t1,0x00010
	addi.w $t1,$t1,-1
	and $t1,$t1,$a6
	slli.w $t2,$a7,16
	or $t3,$t2,$t1
	st.w $t3,$a0,0x0

	b TEST
	
	
	
	
	
	
	
	
	
	
	
 	
 	