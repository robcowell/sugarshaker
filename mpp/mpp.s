; Zerkmann MPP template
; 416x273 image resolution, 48+6 colours per scanline
; First scanline trashed due to hardsync setup
;
; Double buffered screens
;
; Feb 13 2016

		section	text

mpp_init:
		rts

mpp_runtime_init:
		run_once				;Macro to ensure the runtime init only run once
		jsr	black_pal
		jsr	clear_screens
		bsr	mpp_copy_pic
		bsr	mpp_code_copy
		rts


mpp_vbl:
		move.l  screen_adr,d0			;Set screenaddress
		lsr.w	#8,d0				;
		move.l	d0,$ffff8200.w			;

		move.l	screen_adr,d0			;Swap screens
		move.l	screen_adr2,screen_adr		;
		move.l	d0,screen_adr2			;
		rts

mpp_main:
		rts

mpp_ta:
		do_hardsync				;Macro to syncronize into exact cycle

		;inits
		dcb.w	35,$4e71			;Zzz..

		lea	mpp_picture+32000,a0	;3 Palette data
		lea	$ffff8240.w,a1			;2
		move.l	a1,a2				;1

		jsr	codebuf				;Run generated code
		move.w	#$2300,sr
		rts


mpp_begin:
		rept	8
		move.l	(a0)+,(a2)+			;5*8
		endr

		dcb.w	5,$4e71

		move.l	a1,a2				;1
		move.l	a1,a3				;1
		move.l	a1,a4				;1

		rept	8
		move.l	(a0)+,(a3)+			;5*8
		endr

		rept	8
		move.l	(a0)+,(a4)+			;5*8
		endr
mpp_end:



mpp_copy_pic:
		;Copy picture to both workscreens
		move.l	screen_adr,a0
		move.l	screen_adr2,a1
		lea	mpp_picture,a2

		move.w	#200-1,d7
.y:		move.w	#320/2/4-1,d6
.x:
		move.l	(a2)+,d0
		move.l	d0,(a0)+
		move.l	d0,(a1)+

		dbra	d6,.x
		dbra	d7,.y
		rts


mpp_code_copy:
		;Copy code to the code buffer
		jsr	code_copy_reset			;Reset code copier variables

		move.l	#mpp_begin,d0		;Copy all mpp scanlines
		move.l	#mpp_end,d1			;
		move.w	#199,d2				;
		jsr	code_copy			;

		jsr	code_copy_rts			;Make sure the code buffer does rts :)
		rts


		section	data

mpp_picture:
		incbin	'mpp/winter.mpp'		;Spectrum 512/4096 unpacked image
		even

		section	text

