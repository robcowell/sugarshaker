; Atari ST/e synclock demosystem
; August 30, 2011
;
; sys/sndh.s
;
; Simple SNDH-player (50 Hz)

		section text

music_sndh_init:
		
		lea music_sndh_file,a0
		lea depack,a1
		bsr ice_decrunch

		moveq	#1,d0
		jsr	depack
		rts

music_sndh_exit:
		jsr	depack+4

		lea	$ffff8800.w,a0
		move.l	#$08000000,(a0)
		move.l	#$09000000,(a0)
		move.l	#$0a000000,(a0)
		rts

music_sndh_play:
		jsr	depack+8
		rts

		section data

music_sndh_file:
		;incbin	'music/pigsend.snd'			;No timer fx
		;incbin	'music/chipshit.sndh'
		incbin 'music/apex.snd'
		;incbin	'music/ice2.snd'			;Has timer fx
		;incbin 'music/ltc08.snd'
		even

depack	ds.b 80000


