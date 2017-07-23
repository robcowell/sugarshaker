; Sugar Shaker by DMG
;
; DNA twist screen


dmg5_init:	rts

dmg5_runtime_init:
		run_once				;Macro to ensure the runtime init only run once
		
		jsr lzdepack

		jsr	black_pal
		jsr	clear_screens
		jsr dmg5_drawlogo
		jsr	dmg5_draw_graphics
		
		rts

lzdepack:
		lea dmg5_lz7,a0
		lea pi1_picture,a1
		jsr lz77

		lea frame1lz7,a0
		lea frame_01,a1
		jsr lz77

		lea frame2lz7,a0
		lea frame_02,a1
		jsr lz77

		lea frame3lz7,a0
		lea frame_03,a1
		jsr lz77

		lea frame4lz7,a0
		lea frame_04,a1
		jsr lz77

		lea frame5lz7,a0
		lea frame_05,a1
		jsr lz77

		lea frame6lz7,a0
		lea frame_06,a1
		jsr lz77

		rts

dmg5_main:
		bsr	dmg5_draw_graphics	
		rts

dmg5_vbl:	
		
		move.l  screen_adr,d0			;Set screenaddress
		lsr.w	#8,d0				;
		move.l	d0,$ffff8200.w			;

		movem.l	blackpal,d0-d7		;Set palette
		movem.l	d0-d7,$ffff8240.w		;
		
		lea	blackpal,a0		;Fade in palette
		lea	pi1_picture+2,a1		;
		jsr	component_fade			;

		
		rts

do_palette5:
		move.l	#$ff8240,a2		; move first palettee entry into a2
		move.w	#15,d7 			; counter for going through palettee

.color_loop5
		move.w	(a1)+,d0 		; palette address into d0
		move.w	d0,(a2)+
		dbra	d7,.color_loop5

		rts

dmg5_draw_graphics:
		

		move.l screen_adr,a0
		jsr draw_double_helix		
		
		rts

dmg5_drawlogo:
		move.l	screen_adr,a0
		add.w	ofs5,a0
		lea	pi1_picture+34,a1

		move.w	#64-1,d7
.y:
		rept	200
		move.l	(a1)+,(a0)+
		endr

		dbra	d7,.y

ofs5:		dc.w	0
		rts

draw_double_helix
	move.l	#0,d0	;Clear d0

	add.w	#1,frame_number

	cmp.w	#5,frame_number
	blt	helix_animsheet_one

	cmp.w	#10,frame_number
	blt	helix_animsheet_two

	cmp.w	#15,frame_number
	blt	helix_animsheet_three

	cmp.w	#20,frame_number
	blt	helix_animsheet_four

	cmp.w	#25,frame_number
	blt	helix_animsheet_five
	
	cmp.w	#30,frame_number
	blt	helix_animsheet_six

	move.w	#0,frame_number

helix_animsheet_one
	lea	frame_01,a1
	add.w	#34,a1

	move.w	frame_number,d0
	lsl.w	#5,d0
	add.w	d0,a1
	bra	actual_draw_helix_code

helix_animsheet_two
	lea	frame_02,a1
	add.w	#34,a1

	move.w	frame_number,d0
	sub.w	#5,d0
	lsl.w	#5,d0
	add.w	d0,a1
	bra	actual_draw_helix_code

helix_animsheet_three
	lea	frame_03,a1
	add.w	#34,a1


	move.w	frame_number,d0
	sub.w	#10,d0
	lsl.w	#5,d0
	add.w	d0,a1
	bra	actual_draw_helix_code

helix_animsheet_four
	lea	frame_04,a1
	add.w	#34,a1


	move.w	frame_number,d0
	sub.w	#15,d0
	lsl.w	#5,d0
	add.w	d0,a1
	bra	actual_draw_helix_code

helix_animsheet_five
	lea	frame_05,a1
	add.w	#34,a1


	move.w	frame_number,d0
	sub.w	#20,d0
	lsl.w	#5,d0
	add.w	d0,a1
	bra	actual_draw_helix_code

helix_animsheet_six
	lea	frame_06,a1
	add.w	#34,a1


	move.w	frame_number,d0
	sub.w	#25,d0
	lsl.w	#5,d0
	add.w	d0,a1
	bra	actual_draw_helix_code


actual_draw_helix_code
;Actual Drawing routine
;Straight non-masked draw using movem.l


	rept	200
	movem.l	(a1),d0-d7		;8 longword  data registers is 16 words or 64 pixels across
	movem.l	d0-d7,(a0)		;Copy all 64 pixels to screen address
	add.l	#160,a0
	add.l	#160,a1
	endr

	rts

		section	data
;frame_01	incbin	'stlow.dbl\HEL_FRME\FRAME_01.PI1'
;frame_02	incbin	'stlow.dbl\HEL_FRME\FRAME_02.PI1'
;frame_03	incbin	'stlow.dbl\HEL_FRME\FRAME_03.PI1'
;frame_04	incbin	'stlow.dbl\HEL_FRME\FRAME_04.PI1'
;frame_05	incbin	'stlow.dbl\HEL_FRME\FRAME_05.PI1'
;frame_06	incbin	'stlow.dbl\HEL_FRME\FRAME_06.PI1'

frame1lz7	incbin	'stlow.dbl\HEL_FRME\FRAME_01.lz7'
frame2lz7	incbin	'stlow.dbl\HEL_FRME\FRAME_02.lz7'
frame3lz7	incbin	'stlow.dbl\HEL_FRME\FRAME_03.lz7'
frame4lz7	incbin	'stlow.dbl\HEL_FRME\FRAME_04.lz7'
frame5lz7	incbin	'stlow.dbl\HEL_FRME\FRAME_05.lz7'
frame6lz7	incbin	'stlow.dbl\HEL_FRME\FRAME_06.lz7'

frame_number	ds.l	1			; The number of the current frame		
		even
dmg5_lz7:	incbin	'stlow.dbl/girl320.lz7'
		even

		section bss

dmg5_backup:			ds.w 14
frame_01 				ds.b 32034
frame_02 				ds.b 32034
frame_03 				ds.b 32034
frame_04 				ds.b 32034
frame_05 				ds.b 32034
frame_06 				ds.b 32034
						ds.b 256



		section	text
