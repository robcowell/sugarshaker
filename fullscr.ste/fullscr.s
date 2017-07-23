 ; Fullscreen template
; 224 byte linewidth (approx 408 usable pixels per line (screen is shifted about 8 pixels to the right))
; Works only on STe
;
; Double buffered screens
;
; September 3, 2011

		section	text

fullscr_ste_init:
		rts

fullscr_ste_runtime_init:
		run_once				;Macro to ensure the runtime init only run once
		jsr	black_pal
		jsr	clear_screens
		bsr	fullscr_ste_copy_pic
		bsr	fullscr_ste_code_copy
		rts


fullscr_ste_vbl:
		move.l  screen_adr,d0			;Set screenaddress
		lsr.w	#8,d0				;
		move.l	d0,$ffff8200.w			;

		movem.l	fullscr_ste_blackpal,d0-d7	;Set palette
		movem.l	d0-d7,$ffff8240.w		;

		lea	fullscr_ste_blackpal,a0		;Fade in palette
		lea	fullscr_ste_picture,a1		;
		jsr	component_fade			;

		move.l	screen_adr,d0			;Swap screens
		move.l	screen_adr2,screen_adr		;
		move.l	d0,screen_adr2			;

		move.w #$237,$ffff825a		; fix that damn blue
		
		rts

fullscr_ste_main:
		rts

fullscr_ste_ta:
		do_hardsync_top_border			;Macro to syncronize into exact cycle and remove top border

		;inits
		moveq	#2,d7				;D7 used for the overscan code
		dcb.w	66,$4e71			;Time for user to set up registers etc

		jsr	codebuf				;Run generated code
		jsr	black_pal			;Set colours black in case some emulator show >274 lines
		rts


fullscr_ste_normal_begin:
		;Code for scanlines 0-226 and 229-272
		move.b	d7,$ffff8260.w			;3 nops Left border
		move.w	d7,$ffff8260.w			;3 nops

		;----------
		; From here, we count nops
		; up to a total of 90 available
		move.l	screen_adr,a0		;5 nops
		jsr draw_double_helix		; Count the nops in rout, plus 4 for the jsr and 5 for the rts
		;----------

		; Subtract counted nops from the 90 we have available (plus some extra ones it seems...)
		dcb.w	90-5-72,$4e71				;90 nops = 360 cycles

		move.w	d7,$ffff820a.w			;3 Right border
		move.b	d7,$ffff820a.w			;3

		dcb.w	26,$4e71				; 26 nops = 104 cycles
fullscr_ste_normal_end:
		

fullscr_ste_lower_begin:
		;Code for scanline 227-228 (lower border special case)
		move.b	d7,$ffff8260.w			;3 Left border
		move.w	d7,$ffff8260.w			;3

		dcb.w	90,$4e71

		move.w	d7,$ffff820a.w			;3 Right border
		move.b	d7,$ffff820a.w			;3

		dcb.w	23,$4e71
		move.w	d7,$ffff820a.w			;3 left border

		;-----------------------------------

		move.b	d7,$ffff8260.w			;3 lower border
		move.w	d7,$ffff8260.w			;3
		move.b	d7,$ffff820a.w			;3

		dcb.w	87,$4e71

		move.w	d7,$ffff820a.w			;3 right border
		move.b	d7,$ffff820a.w			;3

		dcb.w	26,$4e71

fullscr_ste_lower_end:



fullscr_ste_copy_pic:
		;Copy picture to both workscreens
		move.l	screen_adr,a0
		lea	160(a0),a0

		move.l	screen_adr2,a1
		lea	160(a1),a1

		lea	fullscr_ste_picture+32,a2

		move.w	#273-1,d7
.y:		move.w	#416/2/4-1,d6
.x:
		move.l	(a2)+,d0
		move.l	d0,(a0)+
		move.l	d0,(a1)+

		dbra	d6,.x
		lea	224-208(a0),a0
		lea	224-208(a1),a1
		dbra	d7,.y
		rts


fullscr_ste_code_copy:
		;Copy code to the code buffer
		jsr	code_copy_reset			;Reset code copier variables

		move.l	#fullscr_ste_normal_begin,d0	;Copy the first 227 scanlines
		move.l	#fullscr_ste_normal_end,d1	;
		move.w	#227,d2				;
		jsr	code_copy			;

		move.l	#fullscr_ste_lower_begin,d0	;Copy the lower border special case (2 scanlines)
		move.l	#fullscr_ste_lower_end,d1	;
		moveq	#1,d2				;
		jsr	code_copy			;

		move.l	#fullscr_ste_normal_begin,d0	;Copy the last 44 scanlines = total 273 overscanned lines
		move.l	#fullscr_ste_normal_end,d1	;
		move.w	#44,d2				;
		jsr	code_copy			;

		jsr	code_copy_rts			;Make sure the code buffer does rts :)
		rts

draw_double_helix
	move.l	#0,d0					;12 cycles, 3 nops;

	add.w	#1,frame_number			;20 cycles, 5 nops (although somehow I had to add 1 extra, so 24 cycles, 6 nops);

	cmp.w	#5,frame_number			;16 cycles, 4 nops (another one - comes in at 5 nops!)
	blt	helix_animsheet_one			;12 cycles, 3 nops

	cmp.w	#10,frame_number		;16 cycles, 4 nops - 5!
	blt	helix_animsheet_two			;12 cycles, 3 nops

	cmp.w	#15,frame_number		;16 cycles, 4 nops
	blt	helix_animsheet_three		;12 cycles, 3 nops

	cmp.w	#20,frame_number		;16 cycles, 4 nops
	blt	helix_animsheet_four		;12 cycles, 3 nops

	cmp.w	#25,frame_number		;16 cycles, 4 nops
	blt	helix_animsheet_five		;12 cycles, 3 nops
;	
	cmp.w	#30,frame_number		;16 cycles, 4 nops
	blt	helix_animsheet_six			;12 cycles, 3 nops

;	move.w	#0,frame_number			;;16 cycles, 4 nops

helix_animsheet_one
	lea	frame_01,a1					;4 cycles, 1 nop
	add.w	#34,a1;					;12 cycles, 3 nops

;	move.w	frame_number,d0     	;12 cycles, 3 nops
;	lsl.w	#5,d0 					;n is odd, so 8+2(n-1) cycles...erm? 16, so 4 nops
;	add.w	d0,a1 					;8 2 nops
;	bra	actual_draw_helix_code      ;12 cycles, 3 nops 

helix_animsheet_two
;	lea	frame_02,a1
;	add.w	#34,a1;

;	move.w	frame_number,d0
;	sub.w	#5,d0
;	lsl.w	#5,d0
;	add.w	d0,a1
;	bra	actual_draw_helix_code;

helix_animsheet_three
;	lea	frame_03,a1
;	add.w	#34,a1;
;

;	move.w	frame_number,d0
;	sub.w	#10,d0
;	lsl.w	#5,d0
;	add.w	d0,a1
;	bra	actual_draw_helix_code;

helix_animsheet_four
;	lea	frame_04,a1
;	add.w	#34,a1;
;

;	move.w	frame_number,d0
;	sub.w	#15,d0
;	lsl.w	#5,d0
;	add.w	d0,a1
;	bra	actual_draw_helix_code;

helix_animsheet_five
;	lea	frame_05,a1
;	add.w	#34,a1;
;

;	move.w	frame_number,d0
;	sub.w	#20,d0
;	lsl.w	#5,d0
;	add.w	d0,a1
;	bra	actual_draw_helix_code;

helix_animsheet_six
;	lea	frame_06,a1
;	add.w	#34,a1;
;

;	move.w	frame_number,d0
;	sub.w	#25,d0
;	lsl.w	#5,d0
;	add.w	d0,a1
;	bra	actual_draw_helix_code;
;

;actual_draw_helix_code
;;Actual Drawing routine
;;Straight non-masked draw using movem.l;
;

	; 45 nops per repeat!!!
	;rept	200
;	movem.l	(a1),d0-d3		;4 longword  data registers is 16 words or 32 pixels across [44 cycles, 11 nops]
;	movem.l	d0-d3,(a0)		;Copy all 32 pixels to screen address [8+32, 40 cycles, 10 nops]
	;add.l	#160,a0 		;16 cycles, 4 nops
	;add.l	#160,a1 		;16 cycles, 4 nops
	;endr;

	rts 	;16 cycles, 4 nops

		section	data
		even
frame_number	ds.w	1			; The number of the current frame
		even
fullscr_ste_blackpal:
		dcb.w	16,$0000			;Black palette

		even
fullscr_ste_picture:
		incbin	'fullscr.ste/girl.4pl'		;416x273 four bitplanes and 32 byte palette at the start

frame_01	incbin	'stlow.dbl\HEL_FRME\FRAME_01.PI1'
frame_02	incbin	'stlow.dbl\HEL_FRME\FRAME_02.PI1'
frame_03	incbin	'stlow.dbl\HEL_FRME\FRAME_03.PI1'
frame_04	incbin	'stlow.dbl\HEL_FRME\FRAME_04.PI1'
frame_05	incbin	'stlow.dbl\HEL_FRME\FRAME_05.PI1'
frame_06	incbin	'stlow.dbl\HEL_FRME\FRAME_06.PI1'
		even

		section	text

