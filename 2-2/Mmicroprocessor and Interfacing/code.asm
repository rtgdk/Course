#make_bin#

#LOAD_SEGMENT=FFFFh#
#LOAD_OFFSET=0000h#

#CS=0000h#
#IP=0000h#

#DS=0000h#
#ES=0000h#

#SS=0000h#
#SP=FFFEh#

#AX=0000h#
#BX=0000h#
#CX=0000h#
#DX=0000h#
#SI=0000h#
#DI=0000h#
#BP=0000h#

; add your code here
         jmp     x
         db     509 dup(0)

;IVT entry for 80H
;there are 15 interrupt service routines in the program         
    dw     t_isr0
        dw     0000
	dw     t_isr1
        dw     0000
	dw     t_isr2
        dw     0000
	dw     t_isr3
        dw     0000
	dw     t_isr4
        dw     0000
	dw     t_isr5
        dw     0000
	dw     t_isr6
        dw     0000
	dw     t_isr7_0
        dw     0000
	dw     t_isr7_1
        dw     0000
	dw     t_isr7_2
        dw     0000	
	dw     t_isr7_3
        dw     0000	
	dw     t_isr7_4
        dw     0000
	dw     t_isr7_5
	dw     0000
	dw     t_isr7_6
        dw     0000
        db     452 dup(0)
;main program
          
x:    sti 
; intialize ds, es,ss to start of RAM
          mov       ax,0200h
          mov       ds,ax
          mov       es,ax
          mov       ss,ax
          mov       sp,0FFFEH
;initializing 8255
	porta	equ	00h
	portb	equ	02h
	portc	equ	04h
	cr_8255	equ	06h
	mov	al,81h ; changed from 10001000 to 10000001
	out	cr_8255,al
	mov	al,0
	out	portb,al	;so that the LED of the lift displays 0
	mov	al,0fh ;setting pc7 =dir to 1 by default
	out	cr_8255,al
	mov	al,0dh;setting pc6=stop to 1 by default
	out	cr_8255,al
;initializing 8253
	cnt0	equ	08h
	cnt1	equ	0ah
	cnt2	equ	0ch
	cr_8253	equ	0eh
	;loading value to get 20% duty cycle at the start
	;initializing counter0
	mov	al,36h
	out	cr_8253,al
	mov	al,00h           ;changed from0a8
	out	cnt0,al
	mov	al,06h           ; changed from 61
	out	cnt0,al
	;initializing counter1
	mov	al,76h
	out	cr_8253,al
	mov	al,0ah
	out	cnt1,al
	mov	al,0
	out	cnt1,al
	;initializing counter2
	mov	al,0b2h
	out	cr_8253,al
	mov	al,08h
	out	cnt2,al
	mov	al,0
	out	cnt2,al  
	;initializing 8259 master
	;the addresses for 8259 master are 10h and 12h
	mov	al,00010001b ; because cascaded
	out	10h,al
	mov	al,80h	
	out	12h,al
	mov	al,80h
	out	12h,al
	mov	al,03h
	out	12h,al
	mov	al,0
	out	12h,al ;not masking any interrupt
	;initializing 8259 slave
	;addresses here are 18h and 1ah
	mov	al,11h
	out	18h,al
	mov	al,80h
	out	1ah,al
	mov	al,07h
	out	1ah,al 
	mov	al,03h
	out	1ah,al
	mov	al,0
	out	1ah,al ;not masking any interrupt
x1: jmp x1  ;waiting for interrupt
	
;Interrupt service routines


t_isr0:		;called whenever coarse sensor1 is pressed
	;checking the value of the DIR to see if lift goes up or down
	in	al,portc
	and	al,1 ;to check value of pc7=DIR
	jz	a0
	;DIR =1 so lift is going up, thus at CS1, 20% to 60%, steps of 20%
	mov	al,0b2h
	out	cr_8253,al
	mov	cl,8
a4:	mov	al,cl
	out	cnt2,al
	mov	al,0
	out	cnt2,al
	dec	cl
	dec cl
	cmp	cl,4
	jne	a4
	jmp	a3
	
	
a0: 	;DIR=0 so lift is going down, thus at CS1, 60% to 20%
	mov	al,0b2h
	out	cr_8253,al
	mov	cl,4
a1:	mov	al,cl
	out	cnt2,al
	mov	al,0
	out	cnt2,al	
	inc	cl
	inc cl
	cmp	cl,8
	jne	a1
a3:	
	iret


t_isr1: ;called whenever coarse sensor2 is pressed	
	;checking the value of the DIR to see if lift goes up or down
	in	al,portc
	and	al,1 ;to check value of pc7=DIR
	jz	b0
	;DIR =1 so lift is going up, thus at CS2, 60% to 20%, steps of 20%
	mov	al,0b2h
	out	cr_8253,al
	mov	cl,4
b1:	mov	al,cl
	out	cnt2,al
	mov	al,0
	out	cnt2,al	
	inc	cl
	inc cl
	cmp	cl,8
	jne	b1
	jmp	b3
	
b0:	;DIR=0 so lift is going down, thus at CS2, 20% to 60% steps of 20%
	mov	al,0b2h
	out	cr_8253,al
	mov	cl,8
b4:	mov	al,cl
	out	cnt2,al
	mov	al,0
	out	cnt2,al
	dec	cl
	dec cl
	cmp	cl,4
	jne	b4
b3:
	iret
t_isr2: ;called whenever ground floor button is pressed
	;checking which floor the lift is currently on
	in	al,portc
	and	al,0fh ;masking the upper bits
	cmp	al,0 ;checking if the lift is at floor 0 or not
	je	c1
	;checking if door is closed; if closed, CLOSED (PC5) would be set
	in	al,portc
	and	al,20h ;masking all except PC5
	jz	c1
	;setting direction to 0
	mov	al,0eh ;setting DIR=pc7 to 0 meaning the lift will go down now
	out	cr_8255,al
	;storing the floor value in portb
	mov	al,0
	out	portb,al
	;making the lift move, done by setting STOP to 0
	mov	al,0ch
	out	cr_8255,al
	;resetting the door close pin
	;PC5 will be set to 0
	mov	al,00001010b
	out	cr_8255,al
c1:	
	iret
t_isr3: ; called whenever floor1 is pressed
	;checking which floor the lift is currently on
	in	al,portc
	and	al,0fh ;masking the upper bits
	cmp	al,1 ; checking if the lift is already at floor 1 or not
	je	d1
	mov ah,al
	;checking if door is closed; if closed, CLOSED (PC5) would be set
	in	al,portc
	and	al,20h ;masking all except PC5
	jz	d1
	;checking if the lift is at ground floor
	cmp	ah,0
	je	d2
	;setting direction to 0
	mov	al,0eh ;setting DIR=pc7 to 0 meaning the lift will go down now
	out	cr_8255,al
	;making the lift move, done by setting STOP to 0
	mov	al,0ch
	out	cr_8255,al
	;resetting the door close pin
	;PC5 will be set to 0
	mov	al,0ah
	out	cr_8255,al
	jmp	d1
d2:
	;this segment is executed if lift is at floor 0
	;setting direction to 1
	mov	al,0fh ;setting DIR=pc7 to 1 so lift goes up
	out	cr_8255,al
	;making the lift move, done by setting STOP to 0
	mov	al,0ch
	out	cr_8255,al
	;resetting the door close pin
	;PC5 will be set to 0
	mov	al,0ah
	out	cr_8255,al
d1:	
	iret	
t_isr4: ;called when floor 2 is pressed from the lift
	;checking which floor the lift is currently on
	in	al,portc
	and	al,0fh ;masking the upper bits
	cmp	al,2 ; checking if the lift is already at floor 2 or not
	je	e1
	;check if the lift is at floor 3
	cmp	al,3
	jne	e2
	;setting DIR to 0 so that the lift moves down
	mov	al,0eh ;setting DIR=pc7 to 0 meaning the lift will go down now
	out	cr_8255,al
	
e2:	;setting DIR to 1 so that the lift moves up
	mov	al,0fh ;lift will now move up
	out	cr_8255,al
	
e1:	;making the lift move, done by setting STOP to 0
	mov	al,0ch
	out	cr_8255,al
	;resetting the door close pin
	;PC5 will be set to 0
	mov	al,0ah
	out	cr_8255,al
	
	iret
	
t_isr5: ;called when floor 3 is pressed
	;checking which floor the lift is currently on
	in	al,portc
	and	al,0fh ;masking the upper bits
	cmp	al,3 ; checking if the lift is already at floor 3 or not
	je	f1
	;since the lift is not at floor 3, it has to be at a lower floor, hence DIR has to be reset
	mov	al,0eh ; lift will move down
	out	cr_8255,al
	;making lift move; so, setting stop to 0
	mov	al,0ch
	out	cr_8255,al
	;resetting the door close pin
	;PC5 will be set to 0
	mov	al,0ah
	out	cr_8255,al
f1:
	iret
t_isr6: ;called whenever door close is pressed
	;PC5 will be set to 1
	mov	al,0bh
	out	cr_8255,al
	iret
t_isr7_0: ; called when the up button at floor 0 is pressed
	;checking which floor the lift is in
	in	al,portc
	and	al,0fh ;masking the upper bits
	cmp	al,0 ;to check if the lift is already at floor 0 or not
	je	g1
	;storing 0 in portb because the lift will move to that location
	mov	al,0
	out	portb,al
	;setting DIR to 0 so that the lift will move down
	mov	al,0eh
	out	cr_8255,al
	;setting STOP to 0
	mov	al,0ch
	out	cr_8255,al
	;resetting the door close pin
	;PC5 will be set to 0
	mov	al,0ah
	out	cr_8255,al
	;storing 0 in portb because the lift will move to that location
	mov	al,0
	out	portb,al
	
g1:	iret
t_isr7_1: ;called when up button at floor 1 is pressed
	;checking which floor the lift is in
	in	al,portc
	and	al,0fh ;masking the upper bits
	cmp	al,1 ;to check if the lift is already at floor 1 or not
	je	h1
	;checking if lift is at 0; if yes, then DIR=1
	cmp	al,0
	jne	h1
	;setting DIR to 1
	mov	al,0fh
	out	cr_8255,al
	;setting STOP to 0
	mov	al,0ch
	out	cr_8255,al
	;resetting the door close pin
	;PC5 will be set to 0
	mov	al,0ah
	out	cr_8255,al
	;storing 1 in portb because the lift will move to that location
	mov	al,1
	out	portb,al
h1:	iret
t_isr7_2: ;called when up button at floor 2 is pressed
	;checking which floor the lift is in
	in	al,portc
	and	al,0fh ;masking the upper bits
	cmp	al,2
	je	i1
	;checking if lift is at floor 3; if yes, then nothing happens because lift is moving down
	cmp	al,3
	je	i1
	;lift is at either floor 0 or 1
	;setting DIR to 1
	mov	al,0fh
	out	cr_8255,al
	;setting STOP to 0
	mov	al,0ch
	out	cr_8255,al
	;resetting the door close pin
	;PC5 will be set to 0
	mov	al,0ah
	out	cr_8255,al
	;storing 2 in portb because the lift will move to that location
	mov	al,2
	out	portb,al
i1:
	iret
t_isr7_3: ;called when DOWN1 is pressed
	;checking which floor the lift is in
	in	al,portc
	and	al,0fh ;masking the upper bits
	cmp	al,1
	je	j1
	;checking if the lift is at floor 0, if yes, nothing happens because lift will be moving up
	cmp	al,0
	je	j1
	;lift is now at either floor 2 or 3
	;setting DIR to 0 so that lift will come down	
	mov	al,0eh
	out	cr_8255,al
	;setting STOP to 0
	mov	al,0ch
	out	cr_8255,al
	;resetting the door close pin
	;PC5 will be set to 0
	mov	al,0ah
	out	cr_8255,al
	;storing 1 in portb because lift will move to that location
	mov	al,1
	out	portb,al

j1:	iret		
t_isr7_4: ;called when DOWN2 is pressed
	;checking which floor the lift is in
	in	al,portc
	and	al,0fh ;masking the upper bits
	cmp	al,2
	je	k1
	;checking if lift is at floor 3; if yes, then lift will move down, else no
	cmp	al,3
	je	k1
	;setting DIR to 0 so that lift will come down	
	mov	al,0eh
	out	cr_8255,al
	;setting STOP to 0
	mov	al,0ch
	out	cr_8255,al
	;resetting the door close pin
	;PC5 will be set to 0
	mov	al,0ah
	out	cr_8255,al
	;storing 2 in portb so that lift moves to that location
	mov	al,2
	out	portb,al
k1:	
	iret	
t_isr7_5: ; called when DOWN3 is pressed
	;checking which floor the lift is in
	in	al,portc
	and	al,0fh ;masking the upper bits
	cmp	al,3
	je	l1
	;since the lift is not at floor 3, it will only come to floor 3 if it as at rest, ie floor 0
	;checking if lift is at floor 0 or not
	cmp	al,0
	jne	l1
	;setting DIR to 1 so that lift comes up	
	mov	al,0fh
	out	cr_8255,al
	;setting STOP to 0
	mov	al,0ch
	out	cr_8255,al
	;resetting the door close pin
	;PC5 will be set to 0
	mov	al,0ah
	out	cr_8255,al
	;storing 3 in portb so that lift moves there
	mov	al,3
	out	portb,al
l1: 	iret
	
t_isr7_6: ; called when any fine sensor is pressed
	;this ISR basically checks whether the lift's current floor and the intended destination are the same
	; if yes, it sets the STOP bit to 1
	in	al,portb 
	mov	 ah,al
	in	al,portc
	and	al,0fh ;masking the upper bits
	cmp	al,ah
	jne	nostop
	mov	al,0dh ; setting the STOP = pc6 to 1 so lift will stop
	out	cr_8255,al	
	;as the lift has stopped, it will automatically start moving towards the ground floor unless another button is pressed
	;setting direction to 0
	mov	al,0eh ;setting DIR=pc7 to 0 meaning the lift will go down now
	out	cr_8255,al
	;setting STOP to 0 so that lift moves down
	mov	al,0ch ; setting the STOP = pc6 to 1 so lift will stop
	out	cr_8255,al
	;resetting the door close pin; only when DOOR CLOSE is pressed again will the lift move now
	;PC5 will be set to 0
	mov	al,0ah
	out	cr_8255,al
nostop:
	iret