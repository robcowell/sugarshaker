; Sugar Shaker by DMG
;
; white screen, red scroller


dmg2_init:	rts

dmg2_runtime_init:
		run_once				;Macro to ensure the runtime init only run once
		;lea dmg2_lz7,a0
		;lea pi1_picture,a1
		;jsr lz77

		jsr	black_pal
		jsr	clear_screens
		jsr	dmg2_draw_graphics

		rts


dmg2_main:
		bsr	dmg2_draw_graphics
		move.l	screen_adr,d0
		move.l	screen_adr2,screen_adr
		move.l	d0,screen_adr2
		
		rts

dmg2_vbl:	
		
		move.l  screen_adr,d0			;Set screenaddress
		lsr.w	#8,d0				;
		move.l	d0,$ffff8200.w			;

		movem.l	blackpal,d0-d7		;Set palette
		movem.l	d0-d7,$ffff8240.w		;
		
		lea	blackpal,a0		;Fade in palette
		lea	dmg2_lz7+2,a1		;
		jsr	component_fade			;

		rts

dmg2_draw_graphics:
		;Super-simple test effect

		move.l	screen_adr,a0
		add.w	.ofs,a0
		lea	dmg2_lz7+34,a1

		move.w	#64-1,d7
.y:
		rept	200
		move.l	(a1)+,(a0)+
		endr

		dbra	d7,.y

		;do something here		
		bsr Scrolling

		rts

.cnt:		dc.w	0
.ofs:		dc.w	0
.val:		dc.w	160

Scroll_ROX:
	lea	Buffer_scroll,a0
 rept	8
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	roxl	-(a0)
	lea	84(a0),a0
 endr
	rts

Scrolling:
	bsr	Scroll_ROX                   ; Move bloc of screen
	bsr	Scroll_ROX
	addi.b	#1,COMPTEUR              ; Test counter of text
	cmpi.b	#4,COMPTEUR
	bne.s	.put_scrolling
	clr.b	COMPTEUR
	movea.l	PTR_TEXTE,a0             ; New character
	moveq	#0,d0                      ; Test the end of the sentence
	move.b	(a0)+,d0
	tst.b	d0
	bpl.s	.not_end_text
	lea	TEXTE,a0                     ; Wrap sentence 
	move.b	(a0)+,d0                 ; Next character
.not_end_text:
	move.l	a0,PTR_TEXTE             ; Adjust pointer of the text
	lea	FONT8_8,a0                   ; Load font
	adda.w	d0,a0                    ; Seeking the character of the font
	lea	Adr_scroll,a1                ; Assign buffer to put character inside
	move.b	(a0),(a1)
	move.b	256(a0),42(a1)
	move.b	512(a0),84(a1)
	move.b	768(a0),126(a1)
	move.b	1024(a0),168(a1)
	move.b	1280(a0),210(a1)
	move.b	1536(a0),252(a1)
	move.b	1792(a0),294(a1)
.put_scrolling:
	lea	Line_scroll,a0
	movea.l	screen_adr,a1
	add.w	#160*191,a1                ; Add 180 lines to start at the end of the screen
	addq.w	#6,a1                    ; Add plane for the color
	moveq	#7,d0                      ; 7 lines copied
.loop:
a set 0
	rept 20
	move.w	(a0)+,a(a1)
a set a+8
	endr	
	lea	160(a1),a1
	addq.w	#2,a0
	dbf	d0,.loop
	rts
physique:				ds.l 2                           ; Number of screens declared
		section	data


dmg2_lz7:	incbin	'stlow.dbl/dino.pi1'
			even
FONT8_8:	incbin	'stlow.dbl/FONT8_8.DAT'
			
COMPTEUR:	dc.w	$0
PTR_TEXTE:	dc.l	TEXTE
TEXTE:
	dc.b	"This is our first full 68000 demo so "
	dc.b	"do not expect anything too earth-shattering"
	dc.b 	"                                           "
	dc.b	$FF,$0
	

		section bss
screenbuff:		ds.b 32000
dmg2_backup:			ds.w 14;
Line_scroll:			ds.b	20*2+1
Adr_scroll:				ds.b	1
Buffer_scroll:			ds.b	21*8*20


		section	text
