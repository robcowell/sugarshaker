; Sugar Shaker by DMG
;
; End screen


dmg6_init:	rts

dmg6_runtime_init:
		run_once				;Macro to ensure the runtime init only run once
		
		lea dmg6_lz7,a0
		lea pi1_picture,a1
		jsr lz77

		jsr	black_pal
		jsr	clear_screens
		
		jsr	dmg6_draw_graphics
		
		rts


		rts

dmg6_main:
		bsr	dmg6_draw_graphics
		move.l	screen_adr,d0
		move.l	screen_adr2,screen_adr
		move.l	d0,screen_adr2

		rts

dmg6_vbl:	
		
		move.l  screen_adr,d0			;Set screenaddress
		lsr.w	#8,d0				;
		move.l	d0,$ffff8200.w			;

		movem.l	blackpal,d0-d7		;Set palette
		movem.l	d0-d7,$ffff8240.w		;
		
		lea	blackpal,a0		;Fade in palette
		lea	pi1_picture+2,a1		;
		jsr	component_fade			;

		
		rts

do_palette6:
		move.l	#$ff8240,a2		; move first palettee entry into a2
		move.w	#15,d7 			; counter for going through palettee

.color_loop6
		move.w	(a1)+,d0 		; palette address into d0
		move.w	d0,(a2)+
		dbra	d7,.color_loop6

		rts

dmg6_draw_graphics:
		
		move.l	screen_adr,a0
		add.w	ofs6,a0
		lea	pi1_picture+34,a1

		move.w	#64-1,d7
.y:
		rept	200
		move.l	(a1)+,(a0)+
		endr

		dbra	d7,.y

ofs6:		dc.w	0		
		rts

		section	data

dmg6_lz7:	incbin	'stlow.dbl/fin.lz7'
		even

		section bss

dmg6_backup:			ds.w 14

		section	text
