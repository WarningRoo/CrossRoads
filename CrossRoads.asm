assume	cs:code, ss:stack, ds:time

time	segment
	db	6 dup(0)
time	ends

stack	segment
	db	16 dup(0)
stack	ends

code	segment
start:	mov	ax, time
	mov	ds, ax

	mov	ax, stack
	mov	ss, ax
	mov	sp, 8

	mov	ax, 0B800H
	mov	es, ax

	mov	al, 0
	out	70H, al
	in	al, 71H
	mov	bl, al
	mov	cl, 4
	shr	bl, cl
	mov	bh, al
	mov	al, 10
	mul	bl
	mov	dl, al

	mov	al, bh
	and	al, 00001111B
	add	dl, al
	mov	ds:[0], dl			;��ʼ��ʱ��
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov	bx, 10*160+0*2
	call	clear

	mov	cx, 2
RoadPrintH:
	push	cx
	mov	cx, 71
EachRoadH:
	mov	word ptr es:[bx], 2402H

	cmp	cx, 25
	jne	RoadH1
	add	bx, 20
	jmp	RoadH2
RoadH1:	add	bx, 2

RoadH2:	loop	EachRoadH

	pop	cx
	add	bx, 4*160
	loop	RoadPrintH			;��ӡ���е�·
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov	bx, 0*160+45*2
	mov	cx, 2
RoadPrintS1:
	push	cx
	mov	cx, 20
EachRoadS:
	mov	es:[bx], 2402H
	cmp	cx, 10
	jne	RoadS1
	add	bx, 6*160
	loop	EachRoadS
RoadS1:	add	bx, 160
	loop	EachRoadS
	pop	cx
	mov	bx, 0*160+46*2
	loop	RoadPrintS1

	mov	bx, 0*160+56*2
	mov	cx, 2
RoadPrintS2:
	push	cx
	mov	cx, 20
EachRoadS2:
	mov	es:[bx], 2402H
	cmp	cx, 10
	jne	RoadS2
	add	bx, 6*160
	loop	EachRoadS2
RoadS2:	add	bx, 160
	loop	EachRoadS2
	pop	cx
	mov	bx, 0*160+57*2
	loop	RoadPrintS2
;	mov	bx, 16*160+112
;	mov	es:[bx], 2420H
						;��ӡ���е�·
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov	cx, 243EH
	mov	bx, 16*160+58*2
	mov	es:[bx], cx
	mov	es:[bx+2], cx
	mov	es:[bx+160], cx
	mov	es:[bx+160+2], cx
	mov	cx, 243CH
	mov	bx, 8*160+43*2
	mov	es:[bx], cx
	mov	es:[bx+2], cx
	mov	es:[bx+160], cx
	mov	es:[bx+160+2], cx		
	
	mov	cx, 4C76H
	mov	bx, 16*160+41*2
	mov	es:[bx], cx
	mov	es:[bx+2], cx
	mov	es:[bx+4], cx
	mov	es:[bx+6], cx
	mov	cx, 4C5EH
	mov	bx, 9*160+58*2
	mov	es:[bx], cx
	mov	es:[bx+2], cx
	mov	es:[bx+4], cx
	mov	es:[bx+6], cx			;��ʾ��ʼָʾ��
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov	dh, 12
	mov	dl, 0
	mov	byte ptr ds:[3], 0
	mov	byte ptr ds:[4], 50

	mov	di, 1				
	mov	byte ptr ds:[5], 1		;��ʼ����ʻ���ε���ʼ�кš��к�,����ʼ��ʻ����
	mov	cx, 2420H
	mov	ah, 0
	mov	al, 0
	mov	bx, 0

MovingCar:
	cmp	ah, 0
	jne	movingcar3

	cmp	di, 1
	jne	movingcar0
	inc	dl
;	inc	dl
	jmp	movingcar1
movingcar0:
	dec	dl				;ͨ���ж�diֵ�����ж�dlӦ�������Ǽ�
;	dec	dl

movingcar1:
	cmp	dl, 0
	jne	movingcar2
	mov	di, 1
	jmp	movingcar3
movingcar2:
	cmp	dl, 79
	jne	movingcar3
	mov	di, 0				;����diָʾ����������ʻ����


movingcar3:
	cmp	al, 0
	jne	stop
	cmp	byte ptr ds:[5], 1
	jne	movingcar4
	inc	byte ptr ds:[3]
	jmp	movingcar5
movingcar4:
	dec	byte ptr ds:[3]			;ͨ��ds:5�жϲ���ds:3�������������

movingcar5:
	cmp	byte ptr ds:[3], 0
	jne	movingcar6
	mov	byte ptr ds:[5], 1
	jmp	stop
movingcar6:
	cmp	byte ptr ds:[3], 25
	jne	stop
	mov	byte ptr ds:[5], 0			;����ds:[5]ָʾ���г�������ʻ����

stop:	
	call	show_carS
	call	show_carH
	call	display
	call	timeP					;si, ax, bx
	call	timeshow

	cmp	dl, 42					;0��ʾ������ʻ��1��ʾ��Ҫͣ��
	jne	stop0
	cmp	ch, 4CH
	jne	jianceweizhi0				;ah=0��alδ֪����Ϊλ��δ֪��ֻҪλ��ȷ��al������1
	cmp	di, 1
	jne	shezhi0					;ah=0��al=0
	mov	ah, 1
	mov	al, 0					;ah=1��al=0
	jmp	MovingCar
stop0:	cmp	dl, 58
	jne	jiancequanbu0				;	ah=0,alδ֪����Ϊλ�ã�ָʾ�ƶ�δ֪
	cmp	ch, 4CH
	jne	jianceweizhi0				;	ah=0, alδ֪����Ϊλ��δ֪,ֻҪλ��ȷ��al������1
	cmp	di, 0
	jne	shezhi0				;ah=0,al=0
	mov	ah, 1
	mov	al, 0
	jmp	MovingCar			;�ܽ�					;ah=1,al=0


jiancequanbu0:
	cmp	byte ptr ds:[3], 8
	jne	jiancequanbu1			;ah=0,alδ֪���������λ��
	cmp	ch, 24H
	jne	shezhi0				;ah=0, al=0
	cmp	byte ptr ds:[5], 1
	jne	shezhi0				;ȫ������������ʻ			;ah=0, al=0
	mov	ah, 0
	mov	al, 1				;ah=0��al=1
	jmp	MovingCar

jiancequanbu1:
	cmp	byte ptr ds:[3], 16
	jne	shezhi0				;ȫ������������ʻ			;ah=0, al=0
	cmp	ch, 24H
	jne	shezhi0				;ȫ������������ʻ			;ah=0, al=0
	cmp	byte ptr ds:[5], 0
	jne	shezhi0				;ȫ������������ʻ			;ah=0, al=0
	mov	ah, 0
	mov	al, 1
	jmp	MovingCar			;�ܽ�

jianceweizhi0:
	cmp	byte ptr ds:[3], 10
	jne	jianceweizhi1
	cmp	byte ptr ds:[5], 1
	jne	shezhi0				;ȫ������ͨ��				;ah=0, al=0
	mov	ah, 0
	mov	al, 1
	jmp	MovingCar;�ܽ�

jianceweizhi1:
	cmp	byte ptr ds:[3], 15
	jne	shezhi0				;ȫ������ͨ��				;ah=0, al=0
	cmp	byte ptr ds:[5], 0
	jne	shezhi0				;ȫ������ͨ��				;ah=0, al=0
	mov	ah, 0
	mov	al, 1									;ah=0, al=1
	jmp	MovingCar			;�ܽ�

shezhi0:
	mov	ah, 0
	mov	al, 0
	jmp	MovingCar			;�ܽ�

;getall:	cmp	ah, 0
;	jne	���º��г���ֹͣ��
;	cmp	al, 0
;	jne

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov	ax, 4C00H
	int	21H
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;���ƣ��ӳ���ʾ����
;������dx�洢��16λ��ax�洢��16λ������Խ���ӳ�ʱ��Խ��
;���أ���
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pause:	push	dx
	push	ax
	
	mov	dx, 0FFFFH
	mov	ax, 0FFFFH

pauseL:	sub	ax, 1
	sbb	dx, 0
	cmp	ax, 0
	jne	pauseL
	cmp	dx, 0
	jne	pauseL

	pop	ax
	pop	dx
	ret

display:
	push	dx
	push	ax

	mov	dx, 1
	mov	ax, 0

sss:	sub	ax, 1
	sbb	dx, 0
	cmp	ax, 0
	jne	sss
	cmp	dx, 0
	jne	sss

	pop	ax
	pop	dx
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;���ƣ�����
;��������
;���أ���
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
clear:	push	bx
	push	cx
	
	mov	bx, 0
	mov	cx, 2000
ssss:	mov	word ptr es:[bx], 0020H
	add	bx, 2
	loop	ssss

	pop	cx
	pop	bx
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;���ƣ�Print a car
;������dh��ds:3��������ʾ���кţ�dl��ds:4��������ʾ���к�,di��ds:5��ָʾ������ʻ����
;���أ���
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
show_carS:
	push	ax
	push	bx
	push	cx
	push	dx
	push	ds
	push	es
	push	si

	mov	ax, 0B800H
	mov	es, ax

	mov	dh, ds:[3]
;	dec	dh
	mov	dl, ds:[4]

	mov	ah, 2
	mov	bh, 0
	int	10H

	mov	ah, 9
	mov	al, 1
	mov	bl, 24H
	mov	cx, 3
	int	10H

	inc	dh
	mov	ah, 2
	mov	bh, 0
	int	10H

	mov	ah, 9
	mov	al, 1
	mov	bl, 24H
	mov	cx, 3
	int	10H

	sub	dh, 2
	mov	al, 160
	mul	dh
	mov	si, ax
	mov	al, 2
	mul	dl
	add	si, ax

	cmp	byte ptr ds:[5], 1
	jne	show_carS1
	mov	word ptr es:[si], 0020H
	add	si, 2
	mov	word ptr es:[si], 0020H
	add	si, 2
	mov	word ptr es:[si], 0020H
	jmp	show_carS2
show_carS1:
	mov	word ptr es:[si+3*160], 0020H
	add	si, 2
	mov	word ptr es:[si+3*160], 0020H
	add	si, 2
	mov	word ptr es:[si+3*160], 0020H

show_carS2:
	pop	si
	pop	es
	pop	ds
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ret

show_carH:
	push	ax
	push	bx
	push	cx
	push	dx
	push	ds
	push	si
	push	di

	mov	ax, 0B800H
	mov	ds, ax

	mov	ah, 2
	mov	bh, 0
	int	10H

	mov	ah, 9
	mov	al, 1
	mov	bl, 24H
	mov	cx, 3
	int	10H

	mov	ah, 2
	mov	bh, 0
	inc	dh
	int	10H

	mov	ah, 9
	int	10H
	
	dec	dh
	mov	al, 160
	mul	dh
	mov	si, ax
	mov	al, 2
	mul	dl
	add	si, ax

	cmp	di, 1
	jne	show_carH1
	mov	word ptr [si-2], 0020H
	add	si, 160
	mov	word ptr [si-2], 0020H
	jmp	show_carH2
show_carH1:
	mov	word ptr [si+6], 0020H
	add	si, 160
	mov	word ptr [si+6], 0020H

show_carH2:
	pop	di
	pop	si
	pop	ds
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;���ƣ�time
;���ܣ�ÿ��5��ı�һ��ָʾ��״̬��������һ��cxֵ��Ϊ�Ƿ�ͨ��·�ڵ�ָʾ
;������cx��ǰָʾ����ɫ��1��ʾ��ɫ��0��ʾ��ɫ
;���أ�cx״̬
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
timeP:	push	ax
	push	es
	push	ds
	push	bx
	push	dx

	mov	ax, 0B800H	;��0B800H�Դ�ε�ַд��es�Ĵ����д��á�
	mov	es, ax

	mov	ax, time
	mov	ds, ax

	push	cx
	mov	al, 0
	out	70H, al
	in	al, 71H
	mov	bl, al
	mov	cl, 4
	shr	bl, cl

	mov	bh, al
	mov	al, 10
	mul	bl
	mov	dl, al
	mov	al, bh
	and	al, 00001111B
	add	dl, al
	mov	ds:[1], dl		;��ǰʱ��ds:[1]

	cmp	dl, 0
	jne	time6
	mov	ah, 60D
	sub	ah, ds:[0]
	mov	ds:[2], ah		;ds:[2]�д������һ�������µĲ�ֵ
	mov	byte ptr ds:[0], 0
	mov	dl, ah
	jmp	time7

time6:	sub	dl, ds:[0]
	cmp	byte ptr ds:[2], 0
	je	time7
	add	dl, ds:[2]
	mov	byte ptr ds:[2], 0

time7:	pop	cx
	cmp	dl, 2
	jne	time0
	mov	bh, [si+1]
	mov	[si], bh


	cmp	ch, 24H
	jne	time5

	mov	cx, 245EH
	mov	bx, 9*160+58*2
	mov	es:[bx], cx
	mov	es:[bx+2], cx
	mov	es:[bx+4], cx
	mov	es:[bx+6], cx

	mov	cx, 2476H
	mov	bx, 16*160+41*2
	mov	es:[bx], cx
	mov	es:[bx+2], cx
	mov	es:[bx+4], cx
	mov	es:[bx+6], cx

	mov	cx, 4C3EH
	mov	bx, 16*160+58*2
	mov	es:[bx], cx
	mov	es:[bx+2], cx
	mov	es:[bx+160], cx
	mov	es:[bx+160+2], cx

	mov	cx, 4C3CH
	mov	bx, 8*160+43*2
	mov	es:[bx], cx
	mov	es:[bx+2], cx
	mov	es:[bx+160], cx
	mov	es:[bx+160+2], cx
time0:	jmp	time4
time5:	mov	cx, 4C5EH
	mov	bx, 9*160+58*2
	mov	es:[bx], cx
	mov	es:[bx+2], cx
	mov	es:[bx+4], cx
	mov	es:[bx+6], cx
	
	mov	cx, 4C76H
	mov	bx, 16*160+41*2
	mov	es:[bx], cx
	mov	es:[bx+2], cx
	mov	es:[bx+4], cx
	mov	es:[bx+6], cx

	mov	cx, 243EH
	mov	bx, 16*160+58*2
	mov	es:[bx], cx
	mov	es:[bx+2], cx
	mov	es:[bx+160], cx
	mov	es:[bx+160+2], cx

	mov	cx, 243CH
	mov	bx, 8*160+43*2
	mov	es:[bx], cx
	mov	es:[bx+2], cx
	mov	es:[bx+160], cx
	mov	es:[bx+160+2], cx

time4:	pop	dx
	pop	bx
	pop	ds
	pop	es
	pop	ax
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;���ƣ�timeshow
;���ܣ���ʾ��ǰʱ��
;��������
;���أ���
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
timeshow:
	push	ax
	push	es
	push	di
	push	cx
	push	bx

	mov	ax, 0B800H
	mov	es, ax

	mov	al, 24H
	mov	di, 24*160+1
	mov	cx, 17
s1:	mov	es:[di], al
	inc	di
	inc	di
	loop	s1

	mov	bx, 24*160
;----------------------------------------
;���ϴ����Ȱ��м�һ�е�ǰ��ɫ�ĳ���ɫ����
;----------------------------------------
;-----------------------------------------
;	��ʾ���
;-----------------------------------------
	mov	al, 9
	out	70H, al
	in	al, 71H
	mov	ah, al
	mov	cl, 4
	shr	ah, cl
	and	al, 00001111B
	add	ah, 30h
	add	al, 30h
	mov	byte ptr es:[bx], ah
	mov	byte ptr es:[bx+2], al
	mov	al, '/'
	mov	byte ptr es:[bx+4], al

;-----------------------------------------
;	��ʾ�·�
;-----------------------------------------
	mov	al, 8
	out	70H, al
	in	al, 71H
	mov	ah, al
	mov	cl, 4
	shr	ah, cl
	and	al, 00001111B
	add	ah, 30H
	add	al, 30H
	mov	byte ptr es:[bx+6], ah
	mov	byte ptr es:[bx+8], al
	mov	al, '/'
	mov	byte ptr es:[bx+10], al

;-----------------------------------------
;	��ʾ����
;-----------------------------------------
	mov	al, 7
	out	70H, al
	in	al, 71H
	mov	ah, al
	mov	cl, 4
	shr	ah, cl
	and	al, 00001111B
	add	ah, 30H
	add	al, 30H
	mov	byte ptr es:[bx+12], ah
	mov	byte ptr es:[bx+14], al
	mov	al, ' '
	mov	byte ptr es:[bx+16], al

;-----------------------------------------
;	��ʾСʱ
;-----------------------------------------
	mov	al, 4
	out	70H, al
	in	al, 71H
	mov	ah, al
	mov	cl, 4
	shr	ah, cl
	and	al, 00001111B
	add	ah, 30H
	add	al, 30H
	mov	byte ptr es:[bx+18], ah
	mov	byte ptr es:[bx+20], al
	mov	al, ':'
	mov	byte ptr es:[bx+22], al

;-----------------------------------------
;	��ʾ����
;-----------------------------------------
	mov	al, 2
	out	70H, al
	in	al, 71H
	mov	ah, al
	mov	cl, 4
	shr	ah, cl
	and	al, 00001111B
	add	ah, 30H
	add	al, 30H
	mov	byte ptr es:[bx+24], ah
	mov	byte ptr es:[bx+26], al
	mov	al, ':'
	mov	byte ptr es:[bx+28], al

;-----------------------------------------
;	��ʾ����
;-----------------------------------------
	mov	al, 0
	out	70H, al
	in	al, 71H
	mov	ah, al
	mov	cl, 4
	shr	ah, cl
	and	al, 00001111B
	add	ah, 30H
	add	al, 30H
	mov	byte ptr es:[bx+30], ah
	mov	byte ptr es:[bx+32], al
	
;-------------------------------------------------
;	ȫ����ʾ��Ͻ���ѭ������
;-------------------------------------------------

	pop	bx
	pop	cx
	pop	di
	pop	es
	pop	ax
	ret

code	ends
end	start
;���:	1.Ҫѧ�ᶨ����ų��������������ڳ���Դ��Ŀɶ���
;	2.Ҫѧ���������еģ�ϵͳ�ڲ���ĳЩ����������ʵ��ĳЩ���ܣ������ж���ָʾ����ɫ��ʱ����Ƽ���ʹ��ϵͳʱ�ӵ����ڱ仯��ʵ�֡���Ȼ������ŷŵ���İ취�ô���
;	3.����