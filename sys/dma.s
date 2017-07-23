; Atari ST/e synclock demosystem
; June 6, 2011
;
; sys/dma.s
;
; Simple STe DMA sound sample sequencer


music_dma_loop:	equ	1				;Loop music sequence
smplength:	equ	171655				;Length of sample loop
smpvbl:		equ	343					;VBL's of sample loop - it's actually 342.9, so tiny bit of rounding
									;but gap is negligible and not noticeable in the audio
		
		section	text


music_dma_load:

		move.l	#music_dma_fn1,filename
		move.l	#smp1,filebuffer
		move.l	#smplength,filelength
		jsr	loader

		move.l	#music_dma_fn2,filename
		move.l	#smp2,filebuffer
		move.l	#smplength,filelength
		jsr	loader

		move.l	#music_dma_fn3,filename
		move.l	#smp3,filebuffer
		move.l	#smplength,filelength
		jsr	loader

		move.l	#music_dma_fn4,filename
		move.l	#smp4,filebuffer
		move.l	#smplength,filelength
		jsr	loader

		move.l	#music_dma_fn5,filename
		move.l	#smp5,filebuffer
		move.l	#smplength,filelength
		jsr	loader

		move.l	#music_dma_fn6,filename
		move.l	#smp6,filebuffer
		move.l	#smplength,filelength
		jsr	loader

		move.l	#music_dma_fn7,filename
		move.l	#smp7,filebuffer
		move.l	#smplength,filelength
		jsr	loader

		rts

music_dma_init:	move.l	music_seq,music_seq_dat
		move.l	music_seq+4,d0
		move.l	music_seq+8,d1

		move.b	d0,$ffff8907.w			;Start of sample
		lsr.l	#8,d0				;
		move.b	d0,$ffff8905.w			;
		lsr.l	#8,d0				;
		move.b	d0,$ffff8903.w			;

		move.b	d1,$ffff8913.w			;End of sample
		lsr.l	#8,d1				;
		move.b	d1,$ffff8911.w			;
		lsr.l	#8,d1				;
		move.b	d1,$ffff890f.w			;

		move.b	#%10000010,$ffff8921.w 		;25033Hz mono
		;move.b	#%10000001,$ffff8921.w 		;12517Hz mono
		rts


music_dma_play:
		subq.l	#1,.once
		bne.s	.no
		move.b	#%00000001,$ffff8901.w		;Start sample without loop
.no:


		subq.l	#1,music_seq_dat
		bgt.s	.done

	ifne	music_dma_loop
		move.l	music_seq_adr,a0
		cmp.l	#-1,12(a0)
		bne.s	.no_loop
		move.l	#music_seq-12,music_seq_adr
.no_loop:
	endc

		move.l	music_seq_adr,a0
		lea	12(a0),a0
		move.l	a0,music_seq_adr
		move.l	(a0)+,d0
		move.l	d0,music_seq_dat

		clr.b	$ffff8901.w			;kill sample playback

		move.b	3(a0),$ffff8907.w		;Start of sample
		move.b	2(a0),$ffff8905.w		;
		move.b	1(a0),$ffff8903.w		;

		move.b	7(a0),$ffff8913.w		;End of sample
		move.b	6(a0),$ffff8911.w		;
		move.b	5(a0),$ffff890f.w		;

		move.b	#%00000001,$ffff8901.w		;Start sample without loop

.done:		rts
.wait:		dc.w	4
.once:		dc.l	1

music_dma_exit:	clr.b	$ffff8901.w			;Kill sample playback
		rts




		section	data

; vbls,address,length

music_seq:
		dc.l	smpvbl,smp1,smp1+smplength
		dc.l	smpvbl,smp2,smp2+smplength
		dc.l	smpvbl,smp3,smp3+smplength
		dc.l	smpvbl,smp4,smp4+smplength
		dc.l	smpvbl,smp5,smp5+smplength
		dc.l	smpvbl,smp6,smp6+smplength
		dc.l	smpvbl,smp6,smp6+smplength		
		dc.l	smpvbl,smp7,smp7+smplength				
		dc.l	smpvbl,smp6,smp6+smplength
		dc.l	smpvbl,smp6,smp6+smplength		
		dc.l	smpvbl,smp7,smp7+smplength	
		dc.l	-1,smp0,smp0


music_seq_adr:	dc.l	music_seq
music_seq_dat:	dc.l	0

music_dma_fn0:	dc.b	'music\shaker00.dma',0
		even

music_dma_fn1:	dc.b	'music\shaker01.dma',0
		even

music_dma_fn2:	dc.b	'music\shaker02.dma',0
		even

music_dma_fn3:	dc.b	'music\shaker03.dma',0
		even

music_dma_fn4:	dc.b	'music\shaker04.dma',0
		even

music_dma_fn5:	dc.b	'music\shaker05.dma',0
		even

music_dma_fn6:	dc.b	'music\shaker06.dma',0
		even

music_dma_fn7:	dc.b	'music\shaker07.dma',0
		even

		section	bss

smp0:		ds.b 	smplength
smp1:		ds.b	smplength
smp2:		ds.b	smplength
smp3:		ds.b	smplength
smp4:		ds.b	smplength
smp5:		ds.b	smplength
smp6:		ds.b	smplength
smp7:		ds.b	smplength

		section	text
