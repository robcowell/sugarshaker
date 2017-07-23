; Sugar Shaker by DMG
;
; Demografica logo bounce screen


dmg1_init:	rts

dmg1_runtime_init:
		run_once				;Macro to ensure the runtime init only run once
		lea dmg1_lz7,a0
		lea pi1_picture,a1
		jsr lz77

		jsr	black_pal
		jsr	clear_screens

		move.l $120.w,savetb
		move.l #mytb,$120.w

		rts


dmg1_main:
		

		bsr	dmg1_draw_graphics
		move.l	screen_adr,d0
		move.l	screen_adr2,screen_adr
		move.l	d0,screen_adr2
		
		rts

dmg1_vbl:	
		
		move.l  screen_adr,d0			;Set screenaddress
		lsr.w	#8,d0				;
		move.l	d0,$ffff8200.w			;

		movem.l	blackpal,d0-d7		;Set palette
		movem.l	d0-d7,$ffff8240.w		;
		
		lea	blackpal,a0		;Fade in palette
		lea	pi1_picture+2,a1		;
		jsr	component_fade			;

		addq.w	#1,vblcount
		clr.w	raster_ofs

		move.w #$2700,sr ;Stop all interrupts
		clr.b $fffffa1b.w ;Timer B control (stop)
		bset #0,$fffffa07.w ;Interrupt enable A (Timer B)
		bset #0,$fffffa13.w ;Interrupt mask A (Timer B)
		move.b #1,$fffffa21.w ;Timer B data (number of scanlines to next interrupt)
		bclr #3,$fffffa17.w ;Automatic end of interrupt
		move.b #8,$fffffa1b.w ;Timer B control (event mode (HBL))
		move.w #$2300,sr 	;Interrupts back on
		
		rts

dmg1_draw_graphics:
		;Super-simple test effect

		move.l	screen_adr,a0
		add.w	.ofs,a0
		lea	pi1_picture+34,a1

		move.w	#64-1,d7
.y:
		rept	80
		move.l	(a1)+,(a0)+
		endr

		dbra	d7,.y

		cmp.w	#160,.cnt
		blt.s	.add
		neg.w	.val
		clr.w	.cnt
.add:	
		addq.w	#1,.cnt
		move.w	.val,d0
		add.w	d0,.ofs

		rts

.cnt:		dc.w	0
.ofs:		dc.w	0
.val:		dc.w	160

dmg1_exit:
		move.w	#$2700,sr			;Stop all interrupts
		move.l	savetb,$120.w			;Restore old Timer B
		clr.b	$fffffa1b.w			;Timer B control (Stop)
		move.w	#$2300,sr			;Interrupts back on

		move.w #$777,$ffff825e
		;jsr	black_pal
		jsr	clear_screens
		
		rts

mytb:	move.l	a0,-(sp)			;Save A0
		lea	rasters,a0			;Raster list
		add.w	raster_ofs,a0			;Raster list offset
		move.w	(a0),$ffff824e.w		;Set colour
		;move.w (a0),$ffff8240.w
		addq.w	#2,raster_ofs			;Next raster offset
		move.l	(sp)+,a0			;Restore A0
		bclr #0,$fffffa0f.w
		rte

		section	data
blackpal:
		dcb.w	16,$0000			;Black palette
rasters:
		rept 5
		dc.w $0,$888,$111,$999,$222,$AAA,$333,$BBB,$444,$CCC
 		dc.w $555,$DDD,$666,$EEE,$777,$FFF,$FFF,$777,$EEE,$666
  		dc.w $DDD,$555,$CCC,$444,$BBB,$333,$AAA,$AAA,$222,$999
  		dc.w $111,$888,$0,$0,$0,$0,$0,$0,$0,$0
  		endr
		
;rainbow:
;		dc.w $0,$800,$100,$900,$200,$A00,$300,$B00,$400,$C00
;  		dc.w $500,$D00,$600,$E00,$700,$F00,$F80,$F10,$F90,$F20
;  		dc.w $FA0,$F30,$FB0,$F40,$FC0,$F50,$FD0,$F60,$FE0,$F70
;		dc.w $FF0,$7F0,$EF0,$6F0,$DF0,$5F0,$CF0,$4F0,$BF0,$3F0
;  		dc.w $AF0,$2F0,$9F0,$1F0,$8F0,$F0,$F8,$F1,$F9,$F2
;  		dc.w $FA,$F3,$FB,$F4,$FC,$F5,$FD,$F6,$FE,$F7
;  		dc.w $FF,$7F,$EF,$6F,$DF,$5F,$CF,$4F,$BF,$3F
;  		dc.w $AF,$2F,$9F,$1F,$8F,$F,$80F,$10F,$90F,$20F
;  		dc.w $A0F,$30F,$B0F,$40F,$C0F,$50F,$D0F,$60F,$E0F,$70F
;  		dc.w $F0F,$F8F,$F1F,$F9F,$F2F,$FAF,$F3F,$FBF,$F4F,$FCF
;  		dc.w $F5F,$FDF,$F6F,$FEF,$F7F,$FFF,$777,$EEE,$666,$DDD
;  		dc.w $555,$CCC,$444,$BBB,$333,$A3A,$232,$939,$131,$138
;  		dc.w $130,$830,$30,$38,$31,$39,$32,$3A,$33,$3B
;  		dc.w $34,$3C,$35,$3D,$36,$3E,$37,$3F,$83F,$13F
;  		dc.w $93F,$23F,$A3F,$33F,$B3F,$43F,$C3F,$53F,$D3F,$63F
;  		dc.w $E3F,$73F,$F3F,$FA7,$F2E,$F96,$F9D,$F95,$F9C,$F94
;  		dc.w $F9B,$F93,$F9A,$F92,$F99,$F91,$F98,$F90,$F20,$FA0
;  		dc.w $F30,$FB0,$F40,$FC0,$F50,$FD0,$F60,$FE0,$F70,$FF0
;  		dc.w $FF8,$FF1,$FF9,$FF2,$FFA,$FF3,$FFB,$FF4,$FFC,$FF5
;  		dc.w $FFD,$FF6,$FFE,$FF7,$EEE,$555,$444,$333,$222,$111

dmg1_lz7:	incbin	'stlow.dbl/graffiti.lz7'
		even

		section bss
raster_ofs:	ds.w	1		
vblcount:	ds.w	1
pi1_picture:	ds.w 32034
savetb:		ds.l 	1


		section	text
