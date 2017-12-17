.model tiny
.data
elevator_position db 00h	;00h,01h,02h,03h
travel_direction db 00h	;00(stop),01,10h
destination db 00h	;0fh(rest),00,01,02,03
new_destination db ?

destination_buffer db 8 dup (0fh)
buffer_up db 8 dup (0fh)
buffer_down db 8 dup (0fh)
destination_size dw 0
up_size dw 0
down_size dw 0
accel_stat db 00h

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
in0:	mov al,88h   ; port c input
	out creg,al ;8255

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
x11:	mov dl,travel_direction
	cmp dl,00h
	jnz up6

	;if not moving
	mov ax,di
	cmp al,elevator_position
	jz up4
	mov destination,al
	mov cl,4
	rol al,cl
	mov bl,elevator_position
	or al,bl
	out pa,al
	;set traveling direction
	mov al,destination
	cmp al,elevator_position
	jle up3
	mov travel_direction,01h	;move elv up
	mov al,01h
	out pc2,al
	jmp up5
up3:	mov travel_direction,10h	;move elv down
	mov al,02h
	out pc2,al
	jmp up5
up4:	mov al,04h	;elv at pos, just open door
	out pc2,al	
	jmp up5	

	;if moving
up6:	mov ax,di
	mov di,00
	cmp up_size,00h
	jz igr1
	mov cx,up_size
up1:	cmp al,buffer_up[di]
	jz up5
	inc di
	loop up1
igr1:	mov buffer_up[di],al
	inc up_size
	
up5:	jmp x16

;down key press operations
	;if not moving

x12:	inc di
	mov dl,travel_direction
	cmp dl,00h
	jnz dwn6
	
	;if not moving
	mov ax,di
	cmp al,elevator_position
	jz dwn4
	mov destination,al
	mov cl,4
	rol al,cl
	mov bl,elevator_position
	or al,bl
	out pa,al
	;set traveling direction
	mov al,destination
	cmp al,elevator_position
	jle dwn3
	mov travel_direction,01h	;move elv up
	mov al,01h
	out pc2,al
	jmp dwn5
dwn3:	mov travel_direction,10h	;move elv down
	mov al,02h
	out pc2,al
	jmp dwn5
dwn4:	mov al,04h	;elv at pos, just open door
	out pc2,al	
	jmp dwn5
	
	;if moving
dwn6:	mov ax,di
	mov di,00
	cmp down_size,00h
	jz igr2
	mov cx,down_size
dwn1:	cmp al,buffer_down[di]
	jz dwn5
	inc di
	loop dwn1
igr2:	mov buffer_down[di],al
	inc down_size
		
dwn5:	jmp x16

;inlift key press operations
x13:	cmp travel_direction,00h
	jz inl1
	
	;if moving, check if floor requested is in queue
	;ckeck in buffer_up
	mov ax,di
	mov di,00h
	cmp up_size,00h
	jz inl7
	mov cx,up_size
inl5:	cmp al,buffer_up[di]
	jz inl2
	inc di
	loop inl5
inl7:
	;check in buffer_down
	mov di,00h
	cmp down_size,00h
	jz inl8
	mov cx,down_size
inl6:	cmp al,buffer_down[di]
	jz inl2
	inc di
	loop inl6
inl8:
	;check destination
	cmp al,destination
	jz inl2
	
	;check in destination_buffer
	mov ax,di
	mov di,00
	cmp destination_size,00h
	jz igr3
	mov cx,destination_size
inl4:	cmp al,destination_buffer[di]
	jz inl2
	inc di
	loop inl4
igr3:	mov destination_buffer[di],al
	inc destination_size
	jmp inl2
	
inl1:	mov ax,di
	cmp al,elevator_position
	jz inl2
	cmp al,elevator_position
	jg inl3
	mov travel_direction,10h
	mov destination,al
	jmp inl2
inl3:	mov travel_direction,01h
	mov destination,al
inl2:	jmp x16

;sensor key press operations
x14:	cmp di,00h
	jnz co1
;coarse sensor 1 pressed
	;check travelling direction
	cmp travel_direction,01h
	jnz goDown
	
	;if travelling up
	;light coarse 1 led
	mov al,01h
	out pb2,al
	
	;check acceleration status
	cmp accel_stat,00h
	jnz co3
	
	;if not accelerating
	;close 20% generator
	mov al,00h
	out pc2,al
	;start 30% generator
	;mov al,01h
	;out pa2,al
	
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
	
	;stop 40% generator
	mov al,00h
	out pa2,al

	;start 60% generator
	mov al,10h
	out pa2,al
	mov accel_stat,01h

;if travelling down
;see if needs deceleration
goDown:	mov al,elevator_position
	dec al
	;check with destination
	cmp al,destination
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
	;mov al,02h
	;out pa2,al
	
	;wait
	mov dx,56800d
jf5:	nop
	dec dx
	jnz jf5
	
	;stop 40% generator
	mov al,00h
	out pa2,al

	;stop 30% generator
	;mov al,00h
	;out pa2,al
	;start 20% generator
	mov al,02h
	out pc2,al
	mov accel_stat,00h
	jmp co3
	
;check in destination_buffer
co4:	mov di,00h
	cmp destination_size,00h
	jz co5
	mov cx,destination_size
co7:	cmp al,destination_buffer[di]
	jz co6	;if found go for deceleration
	inc di
	loop co7
	
;check in buffer_down
co5:	mov di,00h
	cmp down_size,00h
	jz co3
	mov cx,down_size
co8:	cmp al,buffer_down[di]
	jz co6	;if found go for deceleration
	inc di
	loop co8

co3:	jmp x16

co1:	cmp di,01h
	jnz co2
;fine sensor pressed
	mov al,travel_direction
	cmp al,01h
	jnz sen1

	;if moving up
	;update display
	inc elevator_position
	mov al,elevator_position
	mov bl,destination
	mov cl,4
	rol bl,cl
	or al,bl
	out pa,al

	;see if it has to stop
	mov al,elevator_position
	cmp al,destination
	jnz alt1

	;stop
	mov al,04h
	out pc2,al

	;update destination
	mov al,elevator_position
	mov new_destination,al

	;look in destination_buffer
	mov dl,new_destination
	mov di,00h
	cmp destination_size,00h
	jz igr4
	mov cx,destination_size
p2:	cmp dl,destination_buffer[di]
	jg p1
	mov dl,destination_buffer[di]
	mov si,di
p1:	inc di
	loop p2
igr4:	mov new_destination,dl

	mov al,elevator_position
	cmp new_destination,al
	jz sen6	;not found in destination_buffer
	
	;found in destination_buffer
	;remove from destination_buffer
	mov di,si
	mov cx,destination_size
	dec cx
	cmp cx,00h
	jz ign5
p3:	mov al,destination_buffer[di+1]
	mov destination_buffer[di],al
	inc di
	cmp di,cx
	jnz p3
ign5:	mov destination_buffer[di],0fh
	dec destination_size
	mov al,new_destination
	mov destination,al
	jmp sen2

	;not found in destination_buffer
	;look in buffer_up
sen6:	mov dl,new_destination
	mov di,00h
	cmp up_size,00h
	jz igr5
	mov cx,up_size
p5:	cmp dl,buffer_up[di]
	jg p4
	mov dl,buffer_up[di]
	mov si,di
p4:	inc di
	loop p5
igr5:	mov new_destination,dl

	mov al,elevator_position
	cmp new_destination,al
	jz sen7	;not found in buffer_up

	;found in buffer_up
	;remove from buffer_up
	mov di,si
	mov cx,up_size
	dec cx
	cmp cx,00h
	jz ign6
p6:	mov al,buffer_up[di+1]
	mov buffer_up[di],al
	inc di
	cmp di,cx
	jnz p6
ign6:	mov buffer_up[di],0fh
	dec up_size
	mov al,new_destination
	mov destination,al
	jmp sen2

	;not found in buffer_up
	;look in buffer_down
sen7:	mov dl,new_destination
	mov di,00h
	cmp down_size,00h
	jz igr6
	mov cx,down_size
p8:	cmp dl,buffer_down[di]
	jg p7
	mov dl,buffer_down[di]
	mov si,di
p7:	inc di
	loop p8
igr6:	mov new_destination,dl

	mov al,elevator_position
	cmp new_destination,al
	jz sen8	;not found in buffer_down

	;found in buffer_down
	;remove from buffer_down
	mov di,si
	mov cx,down_size
	dec cx
	cmp cx,00h
	jz ign7
p9:	mov al,buffer_down[di+1]
	mov buffer_down[di],al
	inc di
	cmp di,cx
	jnz p9
ign7:	mov buffer_down[di],0fh
	dec down_size
	mov al,new_destination
	mov destination,al
	jmp sen2

;no place up to go
sen8:	mov travel_direction,10h	;go down now

	;look in destination_buffer
	mov dl,new_destination
	mov di,00h
	cmp destination_size,00h
	jz igr7
	mov cx,destination_size
q2:	cmp dl,destination_buffer[di]
	jl q1
	mov dl,destination_buffer[di]
	mov si,di
q1:	inc di
	loop q2
igr7:	mov new_destination,dl

	mov al,elevator_position
	cmp new_destination,al
	jz ben6	;not found in destination_buffer
	
	;found in destination_buffer
	;remove from destination_buffer
	mov di,si
	mov cx,destination_size
	dec cx
	cmp cx,00h
	jz ign8
q3:	mov al,destination_buffer[di+1]
	mov destination_buffer[di],al
	inc di
	cmp di,cx
	jnz q3
ign8:	mov destination_buffer[di],0fh
	dec destination_size
	mov al,new_destination
	mov destination,al
	jmp sen2

	;not found in destination_buffer
	;look in buffer_up
ben6:	mov dl,new_destination
	mov di,00h
	cmp up_size,00h
	jz igr8
	mov cx,up_size
q5:	cmp dl,buffer_up[di]
	jl q4
	mov dl,buffer_up[di]
	mov si,di
q4:	inc di
	loop q5
igr8:	mov new_destination,dl

	mov al,elevator_position
	cmp new_destination,al
	jz ben7	;not found in buffer_up

	;found in buffer_up
	;remove from buffer_up
	mov di,si
	mov cx,up_size
	dec cx
	cmp cx,00h
	jz ign9
q6:	mov al,buffer_up[di+1]
	mov buffer_up[di],al
	inc di
	cmp di,cx
	jnz q6
ign9:	mov buffer_up[di],0fh
	dec up_size
	mov al,new_destination
	mov destination,al
	jmp sen2

	;not found in buffer_up
	;look in buffer_down
ben7:	mov dl,new_destination
	mov di,00h
	cmp down_size,00h
	jz igr9
	mov cx,down_size
q8:	cmp dl,buffer_down[di]
	jl q7
	mov dl,buffer_down[di]
	mov si,di
q7:	inc di
	loop q8
igr9:	mov new_destination,dl

	mov al,elevator_position
	cmp al,new_destination
	jz ben8	;not found in buffer_down

	;found in buffer_down
	;remove from buffer_down
	mov di,si
	mov cx,down_size
	dec cx
	cmp cx,00h
	jz ign10
q9:	mov al,buffer_down[di+1]
	mov buffer_down[di],al
	inc di
	cmp di,cx
	jnz q9
ign10:	mov buffer_down[di],0fh
	dec down_size
	mov al,new_destination
	mov destination,al
	jmp sen2

;nowhere to go, rest
ben8:	mov al,new_destination
	mov destination,al
	mov travel_direction,00h
	jmp sen2

;look in buffs
;look in destination_buffer
alt1:	mov al,elevator_position
	mov di,00h
	cmp destination_size,00h
	jz igr10
	mov cx,destination_size
alt3:	cmp al,destination_buffer[di]
	jz alt2
	inc di
	loop alt3
igr10:	jmp alt5

;found it? remove
alt2:	mov cx,destination_size
	dec cx
	cmp cx,00h
	jz ign1
alt4:	mov al,destination_buffer[di+1]
	mov destination_buffer[di],al
	inc di
	cmp di,cx
	jnz alt4
ign1:	mov destination_buffer[di],0fh
	dec destination_size
	mov al,04h
	out pc2,al
	jmp sen2
	
;look in buffer_up
alt5:	mov al,elevator_position
	mov di,00h
	cmp up_size,00h
	jz igr11
	mov cx,up_size
alt7:	cmp al,buffer_up[di]
	jz alt6
	inc di
	loop alt7
igr11:	jmp sen2

;found it? remove
alt6:	mov cx,up_size
	dec cx
	cmp cx,00h
	jz ign2
alt8:	mov al,buffer_up[di+1]
	mov buffer_up[di],al
	inc di
	cmp di,cx
	jnz alt8
ign2:	mov buffer_up[di],0fh
	dec up_size
	mov al,04h
	out pc2,al
	jmp sen2



sen1:	
	;if moving down
	;update display
	dec elevator_position
	mov al,elevator_position
	mov bl,destination
	mov cl,4
	rol bl,cl
	or al,bl
	out pa,al

	;see if it has to stop
	mov al,elevator_position
	cmp al,destination
	jnz act1

	;stop
	mov al,04h
	out pc2,al

	;update destination
	mov al,elevator_position
	mov new_destination,al

	;look in destination_buffer
	mov dl,new_destination
	mov di,00h
	cmp destination_size,00h
	jz igr13
	mov cx,destination_size
m2:	cmp dl,destination_buffer[di]
	jl m1
	mov dl,destination_buffer[di]
	mov si,di
m1:	inc di
	loop m2
igr13:	mov new_destination,dl

	mov al,elevator_position
	cmp new_destination,al
	jz sen3	;not found in destination_buffer
	
	;found in destination_buffer
	;remove from destination_buffer
	mov di,si
	mov cx,destination_size
	dec cx
	cmp cx,00h
	jz ign11
m3:	mov al,destination_buffer[di+1]
	mov destination_buffer[di],al
	inc di
	cmp di,cx
	jnz m3
ign11:	mov destination_buffer[di],0fh
	dec destination_size
	mov al,new_destination
	mov destination,al
	jmp sen2

	;not found in destination_buffer
	;look in buffer_up
sen3:	mov dl,new_destination
	mov di,00h
	cmp up_size,00h
	jz igr14
	mov cx,up_size
m5:	cmp dl,buffer_up[di]
	jl m4
	mov dl,buffer_up[di]
	mov si,di
m4:	inc di
	loop m5
igr14:	mov new_destination,dl

	mov al,elevator_position
	cmp new_destination,al
	jz sen4	;not found in buffer_up

	;found in buffer_up
	;remove from buffer_up
	mov di,si
	mov cx,up_size
	dec cx
	cmp cx,00h
	jz ign12
m6:	mov al,buffer_up[di+1]
	mov buffer_up[di],al
	inc di
	cmp di,cx
	jnz m6
ign12:	mov buffer_up[di],0fh
	dec up_size
	mov al,new_destination
	mov destination,al
	jmp sen2

	;not found in buffer_up
	;look in buffer_down
sen4:	mov dl,new_destination
	mov di,00h
	cmp down_size,00h
	jz igr15
	mov cx,down_size
m8:	cmp dl,buffer_down[di]
	jl m7
	mov dl,buffer_down[di]
	mov si,di
m7:	inc di
	loop m8
igr15:	mov new_destination,dl

	mov al,elevator_position
	cmp new_destination,al
	jz sen5	;not found in buffer_down

	;found in buffer_down
	;remove from buffer_down
	mov di,si
	mov cx,down_size
	dec cx
	cmp cx,00h
	jz ign13
m9:	mov al,buffer_down[di+1]
	mov buffer_down[di],al
	inc di
	cmp di,cx
	jnz m9
ign13:	mov buffer_down[di],0fh
	dec down_size
	mov al,new_destination
	mov destination,al
	jmp sen2

;no place up to go
sen5:	mov travel_direction,10h	;go down now

	;look in destination_buffer
	mov dl,new_destination
	mov di,00h
	cmp destination_size,00h
	jz igr16
	mov cx,destination_size
n2:	cmp dl,destination_buffer[di]
	jg n1
	mov dl,destination_buffer[di]
	mov si,di
n1:	inc di
	loop n2
igr16:	mov new_destination,dl

	mov al,elevator_position
	cmp new_destination,al
	jz ben3	;not found in destination_buffer
	
	;found in destination_buffer
	;remove from destination_buffer
	mov di,si
	mov cx,destination_size
	dec cx
	cmp cx,00h
	jz ign14
n3:	mov al,destination_buffer[di+1]
	mov destination_buffer[di],al
	inc di
	cmp di,cx
	jnz n3
ign14:	mov destination_buffer[di],0fh
	dec destination_size
	mov al,new_destination
	mov destination,al
	jmp sen2

	;not found in destination_buffer
	;look in buffer_up
ben3:	mov dl,new_destination
	mov di,00h
	cmp up_size,00h
	jz igr17
	mov cx,up_size
n5:	cmp dl,buffer_up[di]
	jg n4
	mov dl,buffer_up[di]
	mov si,di
n4:	inc di
	loop n5
igr17:	mov new_destination,dl

	mov al,elevator_position
	cmp new_destination,al
	jz ben4	;not found in buffer_up

	;found in buffer_up
	;remove from buffer_up
	mov di,si
	mov cx,up_size
	dec cx
	cmp cx,00h
	jz ign15
n6:	mov al,buffer_up[di+1]
	mov buffer_up[di],al
	inc di
	cmp di,cx
	jnz n6
ign15:	mov buffer_up[di],0fh
	dec up_size
	mov al,new_destination
	mov destination,al
	jmp sen2

	;not found in buffer_up
	;look in buffer_down
ben4:	mov dl,new_destination
	mov di,00h
	cmp down_size,00h
	jz igr18
	mov cx,down_size
n8:	cmp dl,buffer_down[di]
	jg n7
	mov dl,buffer_down[di]
	mov si,di
n7:	inc di
	loop n8
igr18:	mov new_destination,dl

	mov al,elevator_position
	cmp new_destination,al
	jz ben5	;not found in buffer_down

	;found in buffer_down
	;remove from buffer_down
	mov di,si
	mov cx,down_size
	dec cx
	cmp cx,00h
	jz ign16
n9:	mov al,buffer_down[di+1]
	mov buffer_down[di],al
	inc di
	cmp di,cx
	jnz n9
ign16:	mov buffer_down[di],0fh
	dec down_size
	mov al,new_destination
	mov destination,al
	jmp sen2

;nowhere to go, rest
ben5:	mov al,new_destination
	mov destination,al
	mov travel_direction,00h
	jmp sen2
	
;look in buffs
;look in destination_buffer
act1:	mov al,elevator_position
	mov di,00h
	cmp destination_size,00h
	jz igr19
	mov cx,destination_size
act3:	cmp al,destination_buffer[di]
	jz act2
	inc di
	loop act3
igr19:	jmp act5

;found it? remove
act2:	mov cx,destination_size
	dec cx
	cmp cx,00h
	jz ign3
act4:	mov al,destination_buffer[di+1]
	mov destination_buffer[di],al
	inc di
	cmp di,cx
	jnz act4
ign3:	mov destination_buffer[di],0fh
	dec destination_size
	mov al,04h
	out pc2,al
	jmp sen2
	
;look in buffer_down
act5:	mov al,elevator_position
	mov di,00h
	cmp down_size,00h
	jz igr21
	mov cx,down_size
act8:	cmp al,buffer_down[di]
	jz act6
	inc di
	loop act8
igr21:	jmp sen2

;found it? remove
act6:	mov cx,down_size
	dec cx
	cmp cx,00h
	jz ign4
act7:	mov al,buffer_down[di+1]
	mov buffer_down[di],al
	inc di
	cmp di,cx
	jnz act7
ign4:	mov buffer_down[di],0fh
	dec down_size
	mov al,04h
	out pc2,al


sen2:	jmp x16

;coarse sensor 2 pressed
;check for travelling direction
co2:	cmp travel_direction,10h
	jnz goUp
	;if travelling down
	;light coarse 2 led
	mov al,02h
	out pb2,al
	
	;check acceleration status
	cmp accel_stat,00h
	jnz cos3
	
	;if not accelerating
	;stop 20% generator
	mov al,00h
	out pc2,al
	;start 30% generator
	;mov al,02h
	;out pa2,al
	
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
	
	;stop 40% generator
	mov al,00h
	out pa2,al

	;start 60% generator
	mov al,20h
	out pa2,al
	;update acceleration status
	mov accel_stat,01h
	jmp cos3		

;if travelling up
goUp:	mov al,elevator_position
	inc al
	;check with destination
	cmp al,destination
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
	;mov al,01h
	;out pa2,al
	
	;wait
	mov dx,56800d
jf4:	nop
	dec dx
	jnz jf4
	
	;stop 30% generator
	;mov al,00h
	;out pa2,al
	
	;stop 40% generator
	mov al,00h
	out pa2,al

	;start 20% generator
	mov al,01h
	out pc2,al
	mov accel_stat,00h
	jmp cos3
	
;check in destination_buffer
cos4:	mov di,00h
	cmp destination_size,00h
	jz cos5
	mov cx,destination_size
cos7:	cmp al,destination_buffer[di]
	jz cos6	;if found go for deceleration
	inc di
	loop cos7
	
;check in buffer_up
cos5:	mov di,00h
	cmp up_size,00h
	jz cos3
	mov cx,up_size
cos8:	cmp al,buffer_up[di]
	jz cos6	;if found go for deceleration
	inc di
	loop cos8

cos3:	jmp x16

;door close key press operations
x15: 
	cmp travel_direction,00h
	jz dor1
	
	cmp travel_direction,01h
	jz dor3
	
	mov al,destination
	mov cl,4
	rol al,cl
	mov bl,elevator_position
	or al,bl
	out pa,al
	mov al,02h
	out pc2,al
	jmp x16
	
dor3:	mov al,destination
	mov cl,4
	rol al,cl
	mov bl,elevator_position
	or al,bl
	out pa,al
	mov al,01h
	out pc2,al
	jmp x16
	
dor1:	mov destination,00h
	mov elevator_position,00h
	mov travel_direction,00h
	jmp in0
	;mov al,elevator_position
	;cmp al,destination
	;jz dor2
	;mov al,02h
	;out pc2,al
	;mov al,00h
	;mov cl,4
	;rol al,cl
	;mov bl,elevator_position
	;or al,bl
	;out pa,al
	;jmp x16
dor2:	mov al,04h
	out pc2,al
	

x16:	jmp x0	
	
.exit
end
