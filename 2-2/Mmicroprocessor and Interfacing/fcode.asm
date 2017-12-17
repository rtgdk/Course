.model tiny
.data
elvPos db 00h	;00h,01h,02h,03h
trvDir db 00h	;00(stop),01,10h
dest db 00h	;0fh(rest),00,01,02,03
newDest db ?

destBuff db 8 dup (0fh)
buffUp db 8 dup (0fh)
buffDown db 8 dup (0fh)
destSize dw 0
upSize dw 0
downSize dw 0
accStatus db 00h

creg equ 06h
pa equ 00h
pb equ 02h
pc equ 04h

creg2 equ 16h
pa2 equ 10h
pb2 equ 12h
pc2 equ 14h

door_close db 0bbh

up_cat db 0e7h,0ebh,0edh

down_cat db 0bdh,0beh,0eeh

inlift_cat db 0d7h,0dbh,0ddh,0deh

sensor_cat db 7eh,7dh,7bh



.code
.startup
;initialization
in0:	mov al,88h
	out creg,al

	mov al,80h
	out creg2,al

	mov al,00h
	out pa,al
	
	mov al,00h
	out pc2,al
;avoid key lockout
x0:	mov al,00h
	out pc,al
x1:	in al, pc
	and al,0f0h
	cmp al,0f0h
	jnz x1

	;call delay_20ms
	mov dx,4544d
w1:	nop
	dec dx
	jnz w1

;key press check
	mov al,00h
	out pc,al
x2:	in al,pc
	and al,0f0h
	cmp al,0f0h
	jz x2

	;call delay_20ms
	mov dx,4544d
jf9:	nop
	dec dx
	jnz jf9

	mov al,00h
	out pc,al
	in al,pc
	and al,0f0h
	cmp al,0f0h
	jz x2

;key press identification
	;column 1
	mov al,0eh
	mov bl,al
	out pc,al
	in al,pc
	and al,0f0h
	cmp al,0f0h
	jnz x3

	;column 2
	mov al,0dh
	mov bl,al
	out pc,al
	in al,pc
	and al,0f0h
	cmp al,0f0h
	jnz x3

	;column 3
	mov al,0bh
	mov bl,al
	out pc,al
	in al,pc
	and al,0f0h
	cmp al,0f0h
	jnz x3

	;column 4
	mov al,07h
	mov bl,al
	out pc,al
	in al,pc
	and al,0f0h
	cmp al,0f0h
	jz x2

;decode key
	;generate hex code
x3:	or al,bl

	;up key pressed
	mov cx,03h
	mov di,00h
x4:	cmp al,up_cat[di]
	jz x11
	inc di
	loop x4

	;down key pressed
	mov cx,03h
	mov di,00h
x5:	cmp al,down_cat[di]
	jz x12
	inc di
	loop x5

	;inlift key pressed
	mov cx,04h
	mov di,00h
x6:	cmp al,inlift_cat[di]
	jz x13
	inc di
	loop x6

	;sensor key pressed
	mov cx,03h
	mov di,00h
x7:	cmp al,sensor_cat[di]
	jz x14
	inc di
	loop x7

	jmp x15

;operate according to the key type pressed
;up key press operations
x11:	mov dl,trvDir
	cmp dl,00h
	jnz up6

	;if not moving
	mov ax,di
	cmp al,elvPos
	jz up4
	mov dest,al
	mov cl,4
	rol al,cl
	mov bl,elvPos
	or al,bl
	out pa,al
	;set traveling direction
	mov al,dest
	cmp al,elvPos
	jle up3
	mov trvDir,01h	;move elv up
	mov al,01h
	out pc2,al
	jmp up5
up3:	mov trvDir,10h	;move elv down
	mov al,02h
	out pc2,al
	jmp up5
up4:	mov al,04h	;elv at pos, just open door
	out pc2,al	
	jmp up5	

	;if moving
up6:	mov ax,di
	mov di,00
	cmp upSize,00h
	jz igr1
	mov cx,upSize
up1:	cmp al,buffUp[di]
	jz up5
	inc di
	loop up1
igr1:	mov buffUp[di],al
	inc upSize
	
up5:	jmp x16

;down key press operations
	;if not moving

x12:	inc di
	mov dl,trvDir
	cmp dl,00h
	jnz dwn6
	
	;if not moving
	mov ax,di
	cmp al,elvPos
	jz dwn4
	mov dest,al
	mov cl,4
	rol al,cl
	mov bl,elvPos
	or al,bl
	out pa,al
	;set traveling direction
	mov al,dest
	cmp al,elvPos
	jle dwn3
	mov trvDir,01h	;move elv up
	mov al,01h
	out pc2,al
	jmp dwn5
dwn3:	mov trvDir,10h	;move elv down
	mov al,02h
	out pc2,al
	jmp dwn5
dwn4:	mov al,04h	;elv at pos, just open door
	out pc2,al	
	jmp dwn5
	
	;if moving
dwn6:	mov ax,di
	mov di,00
	cmp downSize,00h
	jz igr2
	mov cx,downSize
dwn1:	cmp al,buffDown[di]
	jz dwn5
	inc di
	loop dwn1
igr2:	mov buffDown[di],al
	inc downSize
		
dwn5:	jmp x16

;inlift key press operations
x13:	cmp trvDir,00h
	jz inl1
	
	;if moving, check if floor requested is in queue
	;ckeck in buffUp
	mov ax,di
	mov di,00h
	cmp upSize,00h
	jz inl7
	mov cx,upSize
inl5:	cmp al,buffUp[di]
	jz inl2
	inc di
	loop inl5
inl7:
	;check in buffDown
	mov di,00h
	cmp downSize,00h
	jz inl8
	mov cx,downSize
inl6:	cmp al,buffDown[di]
	jz inl2
	inc di
	loop inl6
inl8:
	;check dest
	cmp al,dest
	jz inl2
	
	;check in destBuff
	mov ax,di
	mov di,00
	cmp destSize,00h
	jz igr3
	mov cx,destSize
inl4:	cmp al,destBuff[di]
	jz inl2
	inc di
	loop inl4
igr3:	mov destBuff[di],al
	inc destSize
	jmp inl2
	
inl1:	mov ax,di
	cmp al,elvPos
	jz inl2
	cmp al,elvPos
	jg inl3
	mov trvDir,10h
	mov dest,al
	jmp inl2
inl3:	mov trvDir,01h
	mov dest,al
inl2:	jmp x16

;sensor key press operations
x14:	cmp di,00h
	jnz co1
;coarse sensor 1 pressed
	;check travelling direction
	cmp trvDir,01h
	jnz goDown
	
	;if travelling up
	;light coarse 1 led
	mov al,01h
	out pb2,al
	
	;check acceleration status
	cmp accStatus,00h
	jnz co3
	
	;if not accelerating
	;close 20% generator
	mov al,00h
	out pc2,al
	;start 30% generator
	mov al,01h
	out pa2,al
	
	;wait
	mov dx,56800d
jf8:	nop
	dec dx
	jnz jf8
	
	;start 40% generator
	mov al,04h
	out pa2,al
	
	;wait
	mov dx,56800d
jf7:	nop
	dec dx
	jnz jf7
	
	;start 50% generator
	mov al,10h
	out pa2,al
	mov accStatus,01h

;if travelling down
;see if needs deceleration
goDown:	mov al,elvPos
	dec al
	;check with dest
	cmp al,dest
	jnz co4
	
	;deceleration required
co6:	;light coarse 1 led
	mov al,01h
	out pb2,al
	;start 40% generator
	mov al,08h
	out pa2,al
	
	;wait
	mov dx,56800d
jf6:	nop
	dec dx
	jnz jf6
	
	;start 30% generator
	mov al,02h
	out pa2,al
	
	;wait
	mov dx,56800d
jf5:	nop
	dec dx
	jnz jf5
	
	;stop 30% generator
	mov al,00h
	out pa2,al
	;start 20% generator
	mov al,02h
	out pc2,al
	mov accStatus,00h
	jmp co3
	
;check in destBuff
co4:	mov di,00h
	cmp destSize,00h
	jz co5
	mov cx,destSize
co7:	cmp al,destBuff[di]
	jz co6	;if found go for deceleration
	inc di
	loop co7
	
;check in buffDown
co5:	mov di,00h
	cmp downSize,00h
	jz co3
	mov cx,downSize
co8:	cmp al,buffDown[di]
	jz co6	;if found go for deceleration
	inc di
	loop co8

co3:	jmp x16

co1:	cmp di,01h
	jnz co2
;fine sensor pressed
	mov al,trvDir
	cmp al,01h
	jnz sen1

	;if moving up
	;update display
	inc elvPos
	mov al,elvPos
	mov bl,dest
	mov cl,4
	rol bl,cl
	or al,bl
	out pa,al

	;see if it has to stop
	mov al,elvPos
	cmp al,dest
	jnz alt1

	;stop
	mov al,04h
	out pc2,al

	;update dest
	mov al,elvPos
	mov newDest,al

	;look in destBuff
	mov dl,newDest
	mov di,00h
	cmp destSize,00h
	jz igr4
	mov cx,destSize
p2:	cmp dl,destBuff[di]
	jg p1
	mov dl,destBuff[di]
	mov si,di
p1:	inc di
	loop p2
igr4:	mov newDest,dl

	mov al,elvPos
	cmp newDest,al
	jz sen6	;not found in destBuff
	
	;found in destBuff
	;remove from destBuff
	mov di,si
	mov cx,destSize
	dec cx
	cmp cx,00h
	jz ign5
p3:	mov al,destBuff[di+1]
	mov destBuff[di],al
	inc di
	cmp di,cx
	jnz p3
ign5:	mov destBuff[di],0fh
	dec destSize
	mov al,newDest
	mov dest,al
	jmp sen2

	;not found in destBuff
	;look in buffUp
sen6:	mov dl,newDest
	mov di,00h
	cmp upSize,00h
	jz igr5
	mov cx,upSize
p5:	cmp dl,buffUp[di]
	jg p4
	mov dl,buffUp[di]
	mov si,di
p4:	inc di
	loop p5
igr5:	mov newDest,dl

	mov al,elvPos
	cmp newDest,al
	jz sen7	;not found in buffUp

	;found in buffUp
	;remove from buffUp
	mov di,si
	mov cx,upSize
	dec cx
	cmp cx,00h
	jz ign6
p6:	mov al,buffUp[di+1]
	mov buffUp[di],al
	inc di
	cmp di,cx
	jnz p6
ign6:	mov buffUp[di],0fh
	dec upSize
	mov al,newDest
	mov dest,al
	jmp sen2

	;not found in buffUp
	;look in buffDown
sen7:	mov dl,newDest
	mov di,00h
	cmp downSize,00h
	jz igr6
	mov cx,downSize
p8:	cmp dl,buffDown[di]
	jg p7
	mov dl,buffDown[di]
	mov si,di
p7:	inc di
	loop p8
igr6:	mov newDest,dl

	mov al,elvPos
	cmp newDest,al
	jz sen8	;not found in buffDown

	;found in buffDown
	;remove from buffDown
	mov di,si
	mov cx,downSize
	dec cx
	cmp cx,00h
	jz ign7
p9:	mov al,buffDown[di+1]
	mov buffDown[di],al
	inc di
	cmp di,cx
	jnz p9
ign7:	mov buffDown[di],0fh
	dec downSize
	mov al,newDest
	mov dest,al
	jmp sen2

;no place up to go
sen8:	mov trvDir,10h	;go down now

	;look in destBuff
	mov dl,newDest
	mov di,00h
	cmp destSize,00h
	jz igr7
	mov cx,destSize
q2:	cmp dl,destBuff[di]
	jl q1
	mov dl,destBuff[di]
	mov si,di
q1:	inc di
	loop q2
igr7:	mov newDest,dl

	mov al,elvPos
	cmp newDest,al
	jz ben6	;not found in destBuff
	
	;found in destBuff
	;remove from destBuff
	mov di,si
	mov cx,destSize
	dec cx
	cmp cx,00h
	jz ign8
q3:	mov al,destBuff[di+1]
	mov destBuff[di],al
	inc di
	cmp di,cx
	jnz q3
ign8:	mov destBuff[di],0fh
	dec destSize
	mov al,newDest
	mov dest,al
	jmp sen2

	;not found in destBuff
	;look in buffUp
ben6:	mov dl,newDest
	mov di,00h
	cmp upSize,00h
	jz igr8
	mov cx,upSize
q5:	cmp dl,buffUp[di]
	jl q4
	mov dl,buffUp[di]
	mov si,di
q4:	inc di
	loop q5
igr8:	mov newDest,dl

	mov al,elvPos
	cmp newDest,al
	jz ben7	;not found in buffUp

	;found in buffUp
	;remove from buffUp
	mov di,si
	mov cx,upSize
	dec cx
	cmp cx,00h
	jz ign9
q6:	mov al,buffUp[di+1]
	mov buffUp[di],al
	inc di
	cmp di,cx
	jnz q6
ign9:	mov buffUp[di],0fh
	dec upSize
	mov al,newDest
	mov dest,al
	jmp sen2

	;not found in buffUp
	;look in buffDown
ben7:	mov dl,newDest
	mov di,00h
	cmp downSize,00h
	jz igr9
	mov cx,downSize
q8:	cmp dl,buffDown[di]
	jl q7
	mov dl,buffDown[di]
	mov si,di
q7:	inc di
	loop q8
igr9:	mov newDest,dl

	mov al,elvPos
	cmp al,newDest
	jz ben8	;not found in buffDown

	;found in buffDown
	;remove from buffDown
	mov di,si
	mov cx,downSize
	dec cx
	cmp cx,00h
	jz ign10
q9:	mov al,buffDown[di+1]
	mov buffDown[di],al
	inc di
	cmp di,cx
	jnz q9
ign10:	mov buffDown[di],0fh
	dec downSize
	mov al,newDest
	mov dest,al
	jmp sen2

;nowhere to go, rest
ben8:	mov al,newDest
	mov dest,al
	mov trvDir,00h
	jmp sen2

;look in buffs
;look in destBuff
alt1:	mov al,elvPos
	mov di,00h
	cmp destSize,00h
	jz igr10
	mov cx,destSize
alt3:	cmp al,destBuff[di]
	jz alt2
	inc di
	loop alt3
igr10:	jmp alt5

;found it? remove
alt2:	mov cx,destSize
	dec cx
	cmp cx,00h
	jz ign1
alt4:	mov al,destBuff[di+1]
	mov destBuff[di],al
	inc di
	cmp di,cx
	jnz alt4
ign1:	mov destBuff[di],0fh
	dec destSize
	mov al,04h
	out pc2,al
	jmp sen2
	
;look in buffUp
alt5:	mov al,elvPos
	mov di,00h
	cmp upSize,00h
	jz igr11
	mov cx,upSize
alt7:	cmp al,buffUp[di]
	jz alt6
	inc di
	loop alt7
igr11:	jmp sen2

;found it? remove
alt6:	mov cx,upSize
	dec cx
	cmp cx,00h
	jz ign2
alt8:	mov al,buffUp[di+1]
	mov buffUp[di],al
	inc di
	cmp di,cx
	jnz alt8
ign2:	mov buffUp[di],0fh
	dec upSize
	mov al,04h
	out pc2,al
	jmp sen2



sen1:	
	;if moving down
	;update display
	dec elvPos
	mov al,elvPos
	mov bl,dest
	mov cl,4
	rol bl,cl
	or al,bl
	out pa,al

	;see if it has to stop
	mov al,elvPos
	cmp al,dest
	jnz act1

	;stop
	mov al,04h
	out pc2,al

	;update dest
	mov al,elvPos
	mov newDest,al

	;look in destBuff
	mov dl,newDest
	mov di,00h
	cmp destSize,00h
	jz igr13
	mov cx,destSize
m2:	cmp dl,destBuff[di]
	jl m1
	mov dl,destBuff[di]
	mov si,di
m1:	inc di
	loop m2
igr13:	mov newDest,dl

	mov al,elvPos
	cmp newDest,al
	jz sen3	;not found in destBuff
	
	;found in destBuff
	;remove from destBuff
	mov di,si
	mov cx,destSize
	dec cx
	cmp cx,00h
	jz ign11
m3:	mov al,destBuff[di+1]
	mov destBuff[di],al
	inc di
	cmp di,cx
	jnz m3
ign11:	mov destBuff[di],0fh
	dec destSize
	mov al,newDest
	mov dest,al
	jmp sen2

	;not found in destBuff
	;look in buffUp
sen3:	mov dl,newDest
	mov di,00h
	cmp upSize,00h
	jz igr14
	mov cx,upSize
m5:	cmp dl,buffUp[di]
	jl m4
	mov dl,buffUp[di]
	mov si,di
m4:	inc di
	loop m5
igr14:	mov newDest,dl

	mov al,elvPos
	cmp newDest,al
	jz sen4	;not found in buffUp

	;found in buffUp
	;remove from buffUp
	mov di,si
	mov cx,upSize
	dec cx
	cmp cx,00h
	jz ign12
m6:	mov al,buffUp[di+1]
	mov buffUp[di],al
	inc di
	cmp di,cx
	jnz m6
ign12:	mov buffUp[di],0fh
	dec upSize
	mov al,newDest
	mov dest,al
	jmp sen2

	;not found in buffUp
	;look in buffDown
sen4:	mov dl,newDest
	mov di,00h
	cmp downSize,00h
	jz igr15
	mov cx,downSize
m8:	cmp dl,buffDown[di]
	jl m7
	mov dl,buffDown[di]
	mov si,di
m7:	inc di
	loop m8
igr15:	mov newDest,dl

	mov al,elvPos
	cmp newDest,al
	jz sen5	;not found in buffDown

	;found in buffDown
	;remove from buffDown
	mov di,si
	mov cx,downSize
	dec cx
	cmp cx,00h
	jz ign13
m9:	mov al,buffDown[di+1]
	mov buffDown[di],al
	inc di
	cmp di,cx
	jnz m9
ign13:	mov buffDown[di],0fh
	dec downSize
	mov al,newDest
	mov dest,al
	jmp sen2

;no place up to go
sen5:	mov trvDir,10h	;go down now

	;look in destBuff
	mov dl,newDest
	mov di,00h
	cmp destSize,00h
	jz igr16
	mov cx,destSize
n2:	cmp dl,destBuff[di]
	jg n1
	mov dl,destBuff[di]
	mov si,di
n1:	inc di
	loop n2
igr16:	mov newDest,dl

	mov al,elvPos
	cmp newDest,al
	jz ben3	;not found in destBuff
	
	;found in destBuff
	;remove from destBuff
	mov di,si
	mov cx,destSize
	dec cx
	cmp cx,00h
	jz ign14
n3:	mov al,destBuff[di+1]
	mov destBuff[di],al
	inc di
	cmp di,cx
	jnz n3
ign14:	mov destBuff[di],0fh
	dec destSize
	mov al,newDest
	mov dest,al
	jmp sen2

	;not found in destBuff
	;look in buffUp
ben3:	mov dl,newDest
	mov di,00h
	cmp upSize,00h
	jz igr17
	mov cx,upSize
n5:	cmp dl,buffUp[di]
	jg n4
	mov dl,buffUp[di]
	mov si,di
n4:	inc di
	loop n5
igr17:	mov newDest,dl

	mov al,elvPos
	cmp newDest,al
	jz ben4	;not found in buffUp

	;found in buffUp
	;remove from buffUp
	mov di,si
	mov cx,upSize
	dec cx
	cmp cx,00h
	jz ign15
n6:	mov al,buffUp[di+1]
	mov buffUp[di],al
	inc di
	cmp di,cx
	jnz n6
ign15:	mov buffUp[di],0fh
	dec upSize
	mov al,newDest
	mov dest,al
	jmp sen2

	;not found in buffUp
	;look in buffDown
ben4:	mov dl,newDest
	mov di,00h
	cmp downSize,00h
	jz igr18
	mov cx,downSize
n8:	cmp dl,buffDown[di]
	jg n7
	mov dl,buffDown[di]
	mov si,di
n7:	inc di
	loop n8
igr18:	mov newDest,dl

	mov al,elvPos
	cmp newDest,al
	jz ben5	;not found in buffDown

	;found in buffDown
	;remove from buffDown
	mov di,si
	mov cx,downSize
	dec cx
	cmp cx,00h
	jz ign16
n9:	mov al,buffDown[di+1]
	mov buffDown[di],al
	inc di
	cmp di,cx
	jnz n9
ign16:	mov buffDown[di],0fh
	dec downSize
	mov al,newDest
	mov dest,al
	jmp sen2

;nowhere to go, rest
ben5:	mov al,newDest
	mov dest,al
	mov trvDir,00h
	jmp sen2
	
;look in buffs
;look in destBuff
act1:	mov al,elvPos
	mov di,00h
	cmp destSize,00h
	jz igr19
	mov cx,destSize
act3:	cmp al,destBuff[di]
	jz act2
	inc di
	loop act3
igr19:	jmp act5

;found it? remove
act2:	mov cx,destSize
	dec cx
	cmp cx,00h
	jz ign3
act4:	mov al,destBuff[di+1]
	mov destBuff[di],al
	inc di
	cmp di,cx
	jnz act4
ign3:	mov destBuff[di],0fh
	dec destSize
	mov al,04h
	out pc2,al
	jmp sen2
	
;look in buffDown
act5:	mov al,elvPos
	mov di,00h
	cmp downSize,00h
	jz igr21
	mov cx,downSize
act8:	cmp al,buffDown[di]
	jz act6
	inc di
	loop act8
igr21:	jmp sen2

;found it? remove
act6:	mov cx,downSize
	dec cx
	cmp cx,00h
	jz ign4
act7:	mov al,buffDown[di+1]
	mov buffDown[di],al
	inc di
	cmp di,cx
	jnz act7
ign4:	mov buffDown[di],0fh
	dec downSize
	mov al,04h
	out pc2,al


sen2:	jmp x16

;coarse sensor 2 pressed
;check for travelling direction
co2:	cmp trvDir,10h
	jnz goUp
	;if travelling down
	;light coarse 2 led
	mov al,02h
	out pb2,al
	
	;check acceleration status
	cmp accStatus,00h
	jnz cos3
	
	;if not accelerating
	;stop 20% generator
	mov al,00h
	out pc2,al
	;start 30% generator
	mov al,02h
	out pa2,al
	
	;wait
	mov dx,56800d
jf1:	nop
	dec dx
	jnz jf1
	
	;start 40% generator
	mov al,08h
	out pa2,al
	
	;wait
	mov dx,56800d
jf2:	nop
	dec dx
	jnz jf2
	
	;start 50% generator
	mov al,20h
	out pa2,al
	;update acceleration status
	mov accStatus,01h
	jmp cos3		

;if travelling up
goUp:	mov al,elvPos
	inc al
	;check with dest
	cmp al,dest
	jnz cos4
	
	;deceleration required
cos6:	;light coarse 2 led
	mov al,02h
	out pb2,al
	;start 40% generator
	mov al,04h
	out pa2,al
	
	;wait
	mov dx,56800d
jf3:	nop
	dec dx
	jnz jf3
	
	;start 30% generator
	mov al,01h
	out pa2,al
	
	;wait
	mov dx,56800d
jf4:	nop
	dec dx
	jnz jf4
	
	;stop 30% generator
	mov al,00h
	out pa2,al
	;start 20% generator
	mov al,01h
	out pc2,al
	mov accStatus,00h
	jmp cos3
	
;check in destBuff
cos4:	mov di,00h
	cmp destSize,00h
	jz cos5
	mov cx,destSize
cos7:	cmp al,destBuff[di]
	jz cos6	;if found go for deceleration
	inc di
	loop cos7
	
;check in buffUp
cos5:	mov di,00h
	cmp upSize,00h
	jz cos3
	mov cx,upSize
cos8:	cmp al,buffUp[di]
	jz cos6	;if found go for deceleration
	inc di
	loop cos8

cos3:	jmp x16

;door close key press operations
x15: 
	cmp trvDir,00h
	jz dor1
	
	cmp trvDir,01h
	jz dor3
	
	mov al,dest
	mov cl,4
	rol al,cl
	mov bl,elvPos
	or al,bl
	out pa,al
	mov al,02h
	out pc2,al
	jmp x16
	
dor3:	mov al,dest
	mov cl,4
	rol al,cl
	mov bl,elvPos
	or al,bl
	out pa,al
	mov al,01h
	out pc2,al
	jmp x16
	
dor1:	mov dest,00h
	mov elvPos,00h
	mov trvDir,00h
	jmp in0
	;mov al,elvPos
	;cmp al,dest
	;jz dor2
	;mov al,02h
	;out pc2,al
	;mov al,00h
	;mov cl,4
	;rol al,cl
	;mov bl,elvPos
	;or al,bl
	;out pa,al
	;jmp x16
dor2:	mov al,04h
	out pc2,al
	

x16:	jmp x0	
	
.exit
end