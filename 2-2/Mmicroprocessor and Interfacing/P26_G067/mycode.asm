.model tiny
.data
posOfElev db 00h	;00h,01h,02h,03h
elevDir db 00h	;00(stop),01,10h
destination db 00h	;0fh(rest),00,01,02,03
newDestination db ?

destBuffer db 8 dup (0fh)
bufferUp db 8 dup (0fh)
bufferDown db 8 dup (0fh)
destinationSize dw 0
upSize dw 0
downSize dw 0
accStatus db 00h

creg equ 06h
porta equ 00h
portb equ 02h
portc equ 04h

creg2 equ 16h
porta2 equ 10h
portb2 equ 12h
portc2 equ 14h

door_closed db 0bbh

up_ele db 0e7h,0ebh,0edh

down_ele db 0bdh,0beh,0eeh

inlift_ele db 0d7h,0dbh,0ddh,0deh

sensor_ele db 7eh,7dh,7bh



.code
.startup
;initialization
in0:	mov al,88h
	out creg,al

	mov al,80h
	out creg2,al

	mov al,00h
	out porta,al
	
	mov al,00h
	out portc2,al
;avoid key lockout
x0:	mov al,00h
	out portc,al
x1:	in al, portc
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
	out portc,al
x2:	in al,portc
	and al,0f0h
	cmp al,0f0h
	jz x2

	;call delay_20ms
	mov dx,4544d
jf9:	nop
	dec dx
	jnz jf9

	mov al,00h
	out portc,al
	in al,portc
	and al,0f0h
	cmp al,0f0h
	jz x2

;key press identification
	;column 1
	mov al,0eh
	mov bl,al
	out portc,al
	in al,portc
	and al,0f0h
	cmp al,0f0h
	jnz x3

	;column 2
	mov al,0dh
	mov bl,al
	out portc,al
	in al,portc
	and al,0f0h
	cmp al,0f0h
	jnz x3

	;column 3
	mov al,0bh
	mov bl,al
	out portc,al
	in al,portc
	and al,0f0h
	cmp al,0f0h
	jnz x3

	;column 4
	mov al,07h
	mov bl,al
	out portc,al
	in al,portc
	and al,0f0h
	cmp al,0f0h
	jz x2

;decode key
	;generate hex code
x3:	or al,bl

	;up key pressed
	mov cx,03h
	mov di,00h
x4:	cmp al,up_ele[di]
	jz x11
	inc di
	loop x4

	;down key pressed
	mov cx,03h
	mov di,00h
x5:	cmp al,down_ele[di]
	jz x12
	inc di
	loop x5

	;inlift key pressed
	mov cx,04h
	mov di,00h
x6:	cmp al,inlift_ele[di]
	jz x13
	inc di
	loop x6

	;sensor key pressed
	mov cx,03h
	mov di,00h
x7:	cmp al,sensor_ele[di]
	jz x14
	inc di
	loop x7

	jmp x15

;operate according to the key type pressed
;up key press operations
x11:	mov dl,elevDir
	cmp dl,00h
	jnz up6

	;if not moving
	mov ax,di
	cmp al,posOfElev
	jz up4
	mov destination,al
	mov cl,4
	rol al,cl
	mov bl,posOfElev
	or al,bl
	out porta,al
	;set traveling direction
	mov al,destination
	cmp al,posOfElev
	jle up3
	mov elevDir,01h	;move elv up
	mov al,01h
	out portc2,al
	jmp up5
up3:	mov elevDir,10h	;move elv down
	mov al,02h
	out portc2,al
	jmp up5
up4:	mov al,04h	;elv at pos, just open door
	out portc2,al	
	jmp up5	

	;if moving
up6:	mov ax,di
	mov di,00
	cmp upSize,00h
	jz igr1
	mov cx,upSize
up1:	cmp al,bufferUp[di]
	jz up5
	inc di
	loop up1
igr1:	mov bufferUp[di],al
	inc upSize
	
up5:	jmp x16

;down key press operations
	;if not moving

x12:	inc di
	mov dl,elevDir
	cmp dl,00h
	jnz dwn6
	
	;if not moving
	mov ax,di
	cmp al,posOfElev
	jz dwn4
	mov destination,al
	mov cl,4
	rol al,cl
	mov bl,posOfElev
	or al,bl
	out porta,al
	;set traveling direction
	mov al,destination
	cmp al,posOfElev
	jle dwn3
	mov elevDir,01h	;move elv up
	mov al,01h
	out portc2,al
	jmp dwn5
dwn3:	mov elevDir,10h	;move elv down
	mov al,02h
	out portc2,al
	jmp dwn5
dwn4:	mov al,04h	;elv at pos, just open door
	out portc2,al	
	jmp dwn5
	
	;if moving
dwn6:	mov ax,di
	mov di,00
	cmp downSize,00h
	jz igr2
	mov cx,downSize
dwn1:	cmp al,bufferDown[di]
	jz dwn5
	inc di
	loop dwn1
igr2:	mov bufferDown[di],al
	inc downSize
		
dwn5:	jmp x16

;inlift key press operations
x13:	cmp elevDir,00h
	jz inl1
	
	;if moving, check if floor requested is in queue
	;ckeck in bufferUp
	mov ax,di
	mov di,00h
	cmp upSize,00h
	jz inl7
	mov cx,upSize
inl5:	cmp al,bufferUp[di]
	jz inl2
	inc di
	loop inl5
inl7:
	;check in bufferDown
	mov di,00h
	cmp downSize,00h
	jz inl8
	mov cx,downSize
inl6:	cmp al,bufferDown[di]
	jz inl2
	inc di
	loop inl6
inl8:
	;check destination
	cmp al,destination
	jz inl2
	
	;check in destBuffer
	mov ax,di
	mov di,00
	cmp destinationSize,00h
	jz igr3
	mov cx,destinationSize
inl4:	cmp al,destBuffer[di]
	jz inl2
	inc di
	loop inl4
igr3:	mov destBuffer[di],al
	inc destinationSize
	jmp inl2
	
inl1:	mov ax,di
	cmp al,posOfElev
	jz inl2
	cmp al,posOfElev
	jg inl3
	mov elevDir,10h
	mov destination,al
	jmp inl2
inl3:	mov elevDir,01h
	mov destination,al
inl2:	jmp x16

;sensor key press operations
x14:	cmp di,00h
	jnz co1
;coarse sensor 1 pressed
	;check travelling direction
	cmp elevDir,01h
	jnz goDown
	
	;if travelling up
	;light coarse 1 led
	mov al,01h
	out portb2,al
	
	;check acceleration status
	cmp accStatus,00h
	jnz co3
	
	;if not accelerating
	;close 20% generator
	mov al,00h
	out portc2,al
	;start 30% generator
	mov al,01h
	out porta2,al
	
	;wait
	mov dx,56800d
jf8:	nop
	dec dx
	jnz jf8
	
	;start 40% generator
	mov al,04h
	out porta2,al
	
	;wait
	mov dx,56800d
jf7:	nop
	dec dx
	jnz jf7
	
	;start 50% generator
	mov al,10h
	out porta2,al
	mov accStatus,01h

;if travelling down
;see if needs deceleration
goDown:	mov al,posOfElev
	dec al
	;check with destination
	cmp al,destination
	jnz co4
	
	;deceleration required
co6:	;light coarse 1 led
	mov al,01h
	out portb2,al
	;start 40% generator
	mov al,08h
	out porta2,al
	
	;wait
	mov dx,56800d
jf6:	nop
	dec dx
	jnz jf6
	
	;start 30% generator
	mov al,02h
	out porta2,al
	
	;wait
	mov dx,56800d
jf5:	nop
	dec dx
	jnz jf5
	
	;stop 30% generator
	mov al,00h
	out porta2,al
	;start 20% generator
	mov al,02h
	out portc2,al
	mov accStatus,00h
	jmp co3
	
;check in destBuffer
co4:	mov di,00h
	cmp destinationSize,00h
	jz co5
	mov cx,destinationSize
co7:	cmp al,destBuffer[di]
	jz co6	;if found go for deceleration
	inc di
	loop co7
	
;check in bufferDown
co5:	mov di,00h
	cmp downSize,00h
	jz co3
	mov cx,downSize
co8:	cmp al,bufferDown[di]
	jz co6	;if found go for deceleration
	inc di
	loop co8

co3:	jmp x16

co1:	cmp di,01h
	jnz co2
;fine sensor pressed
	mov al,elevDir
	cmp al,01h
	jnz sen1

	;if moving up
	;update display
	inc posOfElev
	mov al,posOfElev
	mov bl,destination
	mov cl,4
	rol bl,cl
	or al,bl
	out porta,al

	;see if it has to stop
	mov al,posOfElev
	cmp al,destination
	jnz alt1

	;stop
	mov al,04h
	out portc2,al

	;update destination
	mov al,posOfElev
	mov newDestination,al

	;look in destBuffer
	mov dl,newDestination
	mov di,00h
	cmp destinationSize,00h
	jz igr4
	mov cx,destinationSize
p2:	cmp dl,destBuffer[di]
	jg p1
	mov dl,destBuffer[di]
	mov si,di
p1:	inc di
	loop p2
igr4:	mov newDestination,dl

	mov al,posOfElev
	cmp newDestination,al
	jz sen6	;not found in destBuffer
	
	;found in destBuffer
	;remove from destBuffer
	mov di,si
	mov cx,destinationSize
	dec cx
	cmp cx,00h
	jz ign5
p3:	mov al,destBuffer[di+1]
	mov destBuffer[di],al
	inc di
	cmp di,cx
	jnz p3
ign5:	mov destBuffer[di],0fh
	dec destinationSize
	mov al,newDestination
	mov destination,al
	jmp sen2

	;not found in destBuffer
	;look in bufferUp
sen6:	mov dl,newDestination
	mov di,00h
	cmp upSize,00h
	jz igr5
	mov cx,upSize
p5:	cmp dl,bufferUp[di]
	jg p4
	mov dl,bufferUp[di]
	mov si,di
p4:	inc di
	loop p5
igr5:	mov newDestination,dl

	mov al,posOfElev
	cmp newDestination,al
	jz sen7	;not found in bufferUp

	;found in bufferUp
	;remove from bufferUp
	mov di,si
	mov cx,upSize
	dec cx
	cmp cx,00h
	jz ign6
p6:	mov al,bufferUp[di+1]
	mov bufferUp[di],al
	inc di
	cmp di,cx
	jnz p6
ign6:	mov bufferUp[di],0fh
	dec upSize
	mov al,newDestination
	mov destination,al
	jmp sen2

	;not found in bufferUp
	;look in bufferDown
sen7:	mov dl,newDestination
	mov di,00h
	cmp downSize,00h
	jz igr6
	mov cx,downSize
p8:	cmp dl,bufferDown[di]
	jg p7
	mov dl,bufferDown[di]
	mov si,di
p7:	inc di
	loop p8
igr6:	mov newDestination,dl

	mov al,posOfElev
	cmp newDestination,al
	jz sen8	;not found in bufferDown

	;found in bufferDown
	;remove from bufferDown
	mov di,si
	mov cx,downSize
	dec cx
	cmp cx,00h
	jz ign7
p9:	mov al,bufferDown[di+1]
	mov bufferDown[di],al
	inc di
	cmp di,cx
	jnz p9
ign7:	mov bufferDown[di],0fh
	dec downSize
	mov al,newDestination
	mov destination,al
	jmp sen2

;no place up to go
sen8:	mov elevDir,10h	;go down now

	;look in destBuffer
	mov dl,newDestination
	mov di,00h
	cmp destinationSize,00h
	jz igr7
	mov cx,destinationSize
q2:	cmp dl,destBuffer[di]
	jl q1
	mov dl,destBuffer[di]
	mov si,di
q1:	inc di
	loop q2
igr7:	mov newDestination,dl

	mov al,posOfElev
	cmp newDestination,al
	jz ben6	;not found in destBuffer
	
	;found in destBuffer
	;remove from destBuffer
	mov di,si
	mov cx,destinationSize
	dec cx
	cmp cx,00h
	jz ign8
q3:	mov al,destBuffer[di+1]
	mov destBuffer[di],al
	inc di
	cmp di,cx
	jnz q3
ign8:	mov destBuffer[di],0fh
	dec destinationSize
	mov al,newDestination
	mov destination,al
	jmp sen2

	;not found in destBuffer
	;look in bufferUp
ben6:	mov dl,newDestination
	mov di,00h
	cmp upSize,00h
	jz igr8
	mov cx,upSize
q5:	cmp dl,bufferUp[di]
	jl q4
	mov dl,bufferUp[di]
	mov si,di
q4:	inc di
	loop q5
igr8:	mov newDestination,dl

	mov al,posOfElev
	cmp newDestination,al
	jz ben7	;not found in bufferUp

	;found in bufferUp
	;remove from bufferUp
	mov di,si
	mov cx,upSize
	dec cx
	cmp cx,00h
	jz ign9
q6:	mov al,bufferUp[di+1]
	mov bufferUp[di],al
	inc di
	cmp di,cx
	jnz q6
ign9:	mov bufferUp[di],0fh
	dec upSize
	mov al,newDestination
	mov destination,al
	jmp sen2

	;not found in bufferUp
	;look in bufferDown
ben7:	mov dl,newDestination
	mov di,00h
	cmp downSize,00h
	jz igr9
	mov cx,downSize
q8:	cmp dl,bufferDown[di]
	jl q7
	mov dl,bufferDown[di]
	mov si,di
q7:	inc di
	loop q8
igr9:	mov newDestination,dl

	mov al,posOfElev
	cmp al,newDestination
	jz ben8	;not found in bufferDown

	;found in bufferDown
	;remove from bufferDown
	mov di,si
	mov cx,downSize
	dec cx
	cmp cx,00h
	jz ign10
q9:	mov al,bufferDown[di+1]
	mov bufferDown[di],al
	inc di
	cmp di,cx
	jnz q9
ign10:	mov bufferDown[di],0fh
	dec downSize
	mov al,newDestination
	mov destination,al
	jmp sen2

;nowhere to go, rest
ben8:	mov al,newDestination
	mov destination,al
	mov elevDir,00h
	jmp sen2

;look in buffs
;look in destBuffer
alt1:	mov al,posOfElev
	mov di,00h
	cmp destinationSize,00h
	jz igr10
	mov cx,destinationSize
alt3:	cmp al,destBuffer[di]
	jz alt2
	inc di
	loop alt3
igr10:	jmp alt5

;found it? remove
alt2:	mov cx,destinationSize
	dec cx
	cmp cx,00h
	jz ign1
alt4:	mov al,destBuffer[di+1]
	mov destBuffer[di],al
	inc di
	cmp di,cx
	jnz alt4
ign1:	mov destBuffer[di],0fh
	dec destinationSize
	mov al,04h
	out portc2,al
	jmp sen2
	
;look in bufferUp
alt5:	mov al,posOfElev
	mov di,00h
	cmp upSize,00h
	jz igr11
	mov cx,upSize
alt7:	cmp al,bufferUp[di]
	jz alt6
	inc di
	loop alt7
igr11:	jmp sen2

;found it? remove
alt6:	mov cx,upSize
	dec cx
	cmp cx,00h
	jz ign2
alt8:	mov al,bufferUp[di+1]
	mov bufferUp[di],al
	inc di
	cmp di,cx
	jnz alt8
ign2:	mov bufferUp[di],0fh
	dec upSize
	mov al,04h
	out portc2,al
	jmp sen2



sen1:	
	;if moving down
	;update display
	dec posOfElev
	mov al,posOfElev
	mov bl,destination
	mov cl,4
	rol bl,cl
	or al,bl
	out porta,al

	;see if it has to stop
	mov al,posOfElev
	cmp al,destination
	jnz act1

	;stop
	mov al,04h
	out portc2,al

	;update destination
	mov al,posOfElev
	mov newDestination,al

	;look in destBuffer
	mov dl,newDestination
	mov di,00h
	cmp destinationSize,00h
	jz igr13
	mov cx,destinationSize
m2:	cmp dl,destBuffer[di]
	jl m1
	mov dl,destBuffer[di]
	mov si,di
m1:	inc di
	loop m2
igr13:	mov newDestination,dl

	mov al,posOfElev
	cmp newDestination,al
	jz sen3	;not found in destBuffer
	
	;found in destBuffer
	;remove from destBuffer
	mov di,si
	mov cx,destinationSize
	dec cx
	cmp cx,00h
	jz ign11
m3:	mov al,destBuffer[di+1]
	mov destBuffer[di],al
	inc di
	cmp di,cx
	jnz m3
ign11:	mov destBuffer[di],0fh
	dec destinationSize
	mov al,newDestination
	mov destination,al
	jmp sen2

	;not found in destBuffer
	;look in bufferUp
sen3:	mov dl,newDestination
	mov di,00h
	cmp upSize,00h
	jz igr14
	mov cx,upSize
m5:	cmp dl,bufferUp[di]
	jl m4
	mov dl,bufferUp[di]
	mov si,di
m4:	inc di
	loop m5
igr14:	mov newDestination,dl

	mov al,posOfElev
	cmp newDestination,al
	jz sen4	;not found in bufferUp

	;found in bufferUp
	;remove from bufferUp
	mov di,si
	mov cx,upSize
	dec cx
	cmp cx,00h
	jz ign12
m6:	mov al,bufferUp[di+1]
	mov bufferUp[di],al
	inc di
	cmp di,cx
	jnz m6
ign12:	mov bufferUp[di],0fh
	dec upSize
	mov al,newDestination
	mov destination,al
	jmp sen2

	;not found in bufferUp
	;look in bufferDown
sen4:	mov dl,newDestination
	mov di,00h
	cmp downSize,00h
	jz igr15
	mov cx,downSize
m8:	cmp dl,bufferDown[di]
	jl m7
	mov dl,bufferDown[di]
	mov si,di
m7:	inc di
	loop m8
igr15:	mov newDestination,dl

	mov al,posOfElev
	cmp newDestination,al
	jz sen5	;not found in bufferDown

	;found in bufferDown
	;remove from bufferDown
	mov di,si
	mov cx,downSize
	dec cx
	cmp cx,00h
	jz ign13
m9:	mov al,bufferDown[di+1]
	mov bufferDown[di],al
	inc di
	cmp di,cx
	jnz m9
ign13:	mov bufferDown[di],0fh
	dec downSize
	mov al,newDestination
	mov destination,al
	jmp sen2

;no place up to go
sen5:	mov elevDir,10h	;go down now

	;look in destBuffer
	mov dl,newDestination
	mov di,00h
	cmp destinationSize,00h
	jz igr16
	mov cx,destinationSize
n2:	cmp dl,destBuffer[di]
	jg n1
	mov dl,destBuffer[di]
	mov si,di
n1:	inc di
	loop n2
igr16:	mov newDestination,dl

	mov al,posOfElev
	cmp newDestination,al
	jz ben3	;not found in destBuffer
	
	;found in destBuffer
	;remove from destBuffer
	mov di,si
	mov cx,destinationSize
	dec cx
	cmp cx,00h
	jz ign14
n3:	mov al,destBuffer[di+1]
	mov destBuffer[di],al
	inc di
	cmp di,cx
	jnz n3
ign14:	mov destBuffer[di],0fh
	dec destinationSize
	mov al,newDestination
	mov destination,al
	jmp sen2

	;not found in destBuffer
	;look in bufferUp
ben3:	mov dl,newDestination
	mov di,00h
	cmp upSize,00h
	jz igr17
	mov cx,upSize
n5:	cmp dl,bufferUp[di]
	jg n4
	mov dl,bufferUp[di]
	mov si,di
n4:	inc di
	loop n5
igr17:	mov newDestination,dl

	mov al,posOfElev
	cmp newDestination,al
	jz ben4	;not found in bufferUp

	;found in bufferUp
	;remove from bufferUp
	mov di,si
	mov cx,upSize
	dec cx
	cmp cx,00h
	jz ign15
n6:	mov al,bufferUp[di+1]
	mov bufferUp[di],al
	inc di
	cmp di,cx
	jnz n6
ign15:	mov bufferUp[di],0fh
	dec upSize
	mov al,newDestination
	mov destination,al
	jmp sen2

	;not found in bufferUp
	;look in bufferDown
ben4:	mov dl,newDestination
	mov di,00h
	cmp downSize,00h
	jz igr18
	mov cx,downSize
n8:	cmp dl,bufferDown[di]
	jg n7
	mov dl,bufferDown[di]
	mov si,di
n7:	inc di
	loop n8
igr18:	mov newDestination,dl

	mov al,posOfElev
	cmp newDestination,al
	jz ben5	;not found in bufferDown

	;found in bufferDown
	;remove from bufferDown
	mov di,si
	mov cx,downSize
	dec cx
	cmp cx,00h
	jz ign16
n9:	mov al,bufferDown[di+1]
	mov bufferDown[di],al
	inc di
	cmp di,cx
	jnz n9
ign16:	mov bufferDown[di],0fh
	dec downSize
	mov al,newDestination
	mov destination,al
	jmp sen2

;nowhere to go, rest
ben5:	mov al,newDestination
	mov destination,al
	mov elevDir,00h
	jmp sen2
	
;look in buffs
;look in destBuffer
act1:	mov al,posOfElev
	mov di,00h
	cmp destinationSize,00h
	jz igr19
	mov cx,destinationSize
act3:	cmp al,destBuffer[di]
	jz act2
	inc di
	loop act3
igr19:	jmp act5

;found it? remove
act2:	mov cx,destinationSize
	dec cx
	cmp cx,00h
	jz ign3
act4:	mov al,destBuffer[di+1]
	mov destBuffer[di],al
	inc di
	cmp di,cx
	jnz act4
ign3:	mov destBuffer[di],0fh
	dec destinationSize
	mov al,04h
	out portc2,al
	jmp sen2
	
;look in bufferDown
act5:	mov al,posOfElev
	mov di,00h
	cmp downSize,00h
	jz igr21
	mov cx,downSize
act8:	cmp al,bufferDown[di]
	jz act6
	inc di
	loop act8
igr21:	jmp sen2

;found it? remove
act6:	mov cx,downSize
	dec cx
	cmp cx,00h
	jz ign4
act7:	mov al,bufferDown[di+1]
	mov bufferDown[di],al
	inc di
	cmp di,cx
	jnz act7
ign4:	mov bufferDown[di],0fh
	dec downSize
	mov al,04h
	out portc2,al


sen2:	jmp x16

;coarse sensor 2 pressed
;check for travelling direction
co2:	cmp elevDir,10h
	jnz goUp
	;if travelling down
	;light coarse 2 led
	mov al,02h
	out portb2,al
	
	;check acceleration status
	cmp accStatus,00h
	jnz cos3
	
	;if not accelerating
	;stop 20% generator
	mov al,00h
	out portc2,al
	;start 30% generator
	mov al,02h
	out porta2,al
	
	;wait
	mov dx,56800d
jf1:	nop
	dec dx
	jnz jf1
	
	;start 40% generator
	mov al,08h
	out porta2,al
	
	;wait
	mov dx,56800d
jf2:	nop
	dec dx
	jnz jf2
	
	;start 50% generator
	mov al,20h
	out porta2,al
	;update acceleration status
	mov accStatus,01h
	jmp cos3		

;if travelling up
goUp:	mov al,posOfElev
	inc al
	;check with destination
	cmp al,destination
	jnz cos4
	
	;deceleration required
cos6:	;light coarse 2 led
	mov al,02h
	out portb2,al
	;start 40% generator
	mov al,04h
	out porta2,al
	
	;wait
	mov dx,56800d
jf3:	nop
	dec dx
	jnz jf3
	
	;start 30% generator
	mov al,01h
	out porta2,al
	
	;wait
	mov dx,56800d
jf4:	nop
	dec dx
	jnz jf4
	
	;stop 30% generator
	mov al,00h
	out porta2,al
	;start 20% generator
	mov al,01h
	out portc2,al
	mov accStatus,00h
	jmp cos3
	
;check in destBuffer
cos4:	mov di,00h
	cmp destinationSize,00h
	jz cos5
	mov cx,destinationSize
cos7:	cmp al,destBuffer[di]
	jz cos6	;if found go for deceleration
	inc di
	loop cos7
	
;check in bufferUp
cos5:	mov di,00h
	cmp upSize,00h
	jz cos3
	mov cx,upSize
cos8:	cmp al,bufferUp[di]
	jz cos6	;if found go for deceleration
	inc di
	loop cos8

cos3:	jmp x16

;door close key press operations
x15: 
	cmp elevDir,00h
	jz dor1
	
	cmp elevDir,01h
	jz dor3
	
	mov al,destination
	mov cl,4
	rol al,cl
	mov bl,posOfElev
	or al,bl
	out porta,al
	mov al,02h
	out portc2,al
	jmp x16
	
dor3:	mov al,destination
	mov cl,4
	rol al,cl
	mov bl,posOfElev
	or al,bl
	out porta,al
	mov al,01h
	out portc2,al
	jmp x16
	
dor1:	mov destination,00h
	mov posOfElev,00h
	mov elevDir,00h
	jmp in0
	;mov al,posOfElev
	;cmp al,destination
	;jz dor2
	;mov al,02h
	;out portc2,al
	;mov al,00h
	;mov cl,4
	;rol al,cl
	;mov bl,posOfElev
	;or al,bl
	;out pa,al
	;jmp x16
dor2:	mov al,04h
	out portc2,al
	

x16:	jmp x0	
	
.exit
end