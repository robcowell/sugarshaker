; Sugar Shaker by DMG
;
; Title screen



dmg3_init:	rts

dmg3_runtime_init:
		run_once				;Macro to ensure the runtime init only run once
		lea dmg3_lz7,a0
		lea pi1_picture,a1
		jsr lz77
		jsr	black_pal
		jsr	clear_screens
		
		rts


dmg3_main:
		bsr	dmg3_draw_graphics
		move.l	screen_adr,d0
		move.l	screen_adr2,screen_adr
		move.l	d0,screen_adr2	
		rts

dmg3_vbl:	
		
		move.l  screen_adr,d0			;Set screenaddress
		lsr.w	#8,d0				;
		move.l	d0,$ffff8200.w			;

		movem.l	blackpal,d0-d7		;Set palette
		movem.l	d0-d7,$ffff8240.w		;
		
		lea	blackpal,a0		;Fade in palette
		lea	pi1_picture+2,a1		;
		jsr	component_fade			;

		
		rts

do_palette:
		move.l	#$ff8240,a2		; move first palettee entry into a2
		move.w	#15,d7 			; counter for going through palettee

.color_loop
		move.w	(a1)+,d0 		; palette address into d0
		move.w	d0,(a2)+
		dbra	d7,.color_loop

		rts

dmg3_draw_graphics:
	
; --- ORIGINAL
	move.l	screen_adr,a0
	add.w	.ofs,a0
	lea	pi1_picture+34,a1

	move.w	#64-1,d7
.y:
	rept	200/4
	move.l	(a1)+,(a0)+
	endr

	dbra	d7,.y
; ---
;do something here
	bsr	draw_spiral
		rts
.ofs:	dc.w	0

draw_spiral:
	;move.l	#0,d0	;Clear d0

	addq.w	#1,frame_number

	cmp.w	#2,frame_number
	lea spiral0,a4
	blt	print_grafic

	cmp.w	#4,frame_number
	lea spiral1,a4
	blt	print_grafic

	cmp.w	#6,frame_number
	lea spiral2,a4
	blt	print_grafic

	cmp.w	#8,frame_number
	lea spiral3,a4
	blt	print_grafic

	cmp.w	#10,frame_number
	lea spiral4,a4
	blt	print_grafic
	
	cmp.w	#12,frame_number
	lea spiral5,a4
	blt	print_grafic

	cmp.w	#14,frame_number
	lea spiral6,a4
	blt	print_grafic

	cmp.w	#16,frame_number
	lea spiral7,a4
	blt	print_grafic

	cmp.w	#18,frame_number
	lea spiral8,a4
	blt	print_grafic

	cmp.w	#20,frame_number
	lea spiral9,a4
	blt	print_grafic

	cmp.w	#22,frame_number
	lea spiral10,a4
	blt	print_grafic
	
	cmp.w	#24,frame_number
	lea spiral11,a4
	blt	print_grafic

	cmp.w	#26,frame_number
	lea spiral12,a4
	blt	print_grafic

	cmp.w	#28,frame_number
	lea spiral13,a4
	blt	print_grafic

	cmp.w	#30,frame_number
	lea spiral14,a4
	blt	print_grafic

	move.w	#0,frame_number

	rts

dmg3_exit:

		rts

*******************
* CUSTOM ROUTINES *
*******************
print_grafic	;print a grafic from NEO cut buffer
		;move.l (a4),(a0)
		move.l	screen_adr,a1	;get present screen base
		add.w #12288,a1	;start plot at 0,128
		add.w #80,a1
		move.w	#$80-1,d1	;grafic is $80 lines deep
		
.loop	
		rept 8		;128 pixels wide, 8 words
		move.l	(a4)+,(a1)+	;move 2 planes
		move.l	(a4)+,(a1)+	;move next 2 planes
		endr

		;illegal

		add.w	#96,a1	;add to screen to goto start of next line down

		dbf	d1,.loop
		
		move.w	frame_number,d0
		addq.w	#1,d0
		
		rts


spiral0: include 'stlow.dbl/spiral/0.S'
	even
spiral1: include 'stlow.dbl/spiral/1.S'
	even
spiral2: include 'stlow.dbl/spiral/2.S'
	even
spiral3: include 'stlow.dbl/spiral/3.S'
	even
spiral4: include 'stlow.dbl/spiral/4.S'
	even
spiral5: include 'stlow.dbl/spiral/5.S'
	even
spiral6: include 'stlow.dbl/spiral/6.S'
	even
spiral7: include 'stlow.dbl/spiral/7.S'
	even
spiral8: include 'stlow.dbl/spiral/8.S'
	even
spiral9: include 'stlow.dbl/spiral/9.S'
	even
spiral10: include 'stlow.dbl/spiral/10.S'
	even
spiral11: include 'stlow.dbl/spiral/11.S'
	even
spiral12: include 'stlow.dbl/spiral/12.S'
	even
spiral13: include 'stlow.dbl/spiral/13.S'
	even
spiral14: include 'stlow.dbl/spiral/14.S'
	even



		section	data
		
		even
dmg3_lz7:	incbin	'stlow.dbl/sugar.lz7'
		even
FCNT:	DC.W	0

		section bss

reg_backup:		ds.l 1

dmg3_backup:			ds.w 14

	even


		section	text
