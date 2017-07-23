; Sugar Shaker by DMG
;
; Title screen

nb_brows	equ 8
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
	jsr draw_logo
; ---
;do something here
	move.l	#screen_adr,a6

.clear_box:
  move.l	a6,a0
  move.l	#old_box1,a1
  move.w	(a1)+,d0	; Extremities of the box to clear.
  move.w	(a1)+,d1
  move.w	(a1)+,d2
  move.w	(a1)+,d3
  jsr	clear_4_bpl

.angles:
  subq.w	#$1,y_pos
  move.w	angle1,d0
  addq.w	#$5,d0
  and.w	#$ff,d0
  move.w	d0,angle1
  move.w	angle2,d1
  addq.w	#$2,d1
  and.w	#$ff,d1
  move.w	d1,angle2

.rotation:
  move.l	#object_brows,a0
  move.l	#new_coords,a1
  jsr	rotation

.calc_intensities:
  move.l	#new_coords,a0
  move.l	a0,a1
  move.l	#inverses,a2
  moveq.l	#nb_brows,d0
  subq.w	#$1,d0
  move.w	#159,d6	; For recentering.
  move.w	y_pos,d7
.one_brow:
  move.w	(a0)+,d1	; d1=x.
  move.w	(a0)+,d2	; d2=y.
  move.w	(a0)+,d3	; d3=z.
  add.w	#$100,d3	; d3=z+256.
  move.w	d3,d4
  adD.w	d1,d4
  add.w	d3,d3
  move.w	(a2,d3.w),d3	; d3=16384/(z+256).
  muls.w	d3,d1
  lsr.l	#$6,d1	; d1=x*256/(z+256).
  add.w	d6,d1	; Recenter.
  move.w	d1,(a1)+	; Save.
  muls.w	d3,d2
  lsr.l	#$6,d2	; d2=y*256/(z+256).
  add.w	d7,d2	; Recenter.
  move.w	d2,(a1)+	; Save.
  add.w	#80*2,d4	; d4=x+z+2*80.
  lsl.w	#$7,d4	; d4=intensity.
  move.w	#$a800,d1
  sub.w	d4,d1
  move.w	d1,(a1)+
  dbra	d0,.one_brow
  
.search_box:
  move.l	#new_coords,a0
  move.w	(a0)+,d0
  move.w	d0,d1	; x1=x2=first x.
  move.w	(a0)+,d2
  move.w	d2,d3	; y1=y2=first y.
  moveq.l	#nb_brows,d7
  subq.l	#$2,d7
.search:
  move.l	(a0)+,d4	; d4=x.
  move.w	(a0)+,d5	; d5=y.
  cmp.w	d0,d4	; x<x1?
  bge.s	.no_x1
  move.w	d4,d0
.no_x1:
  cmp.w	d1,d4	; x>x2?
  ble.s	.no_x2
  move.w	d4,d1
.no_x2:
  cmp.w	d2,d5	; y<y1?
  bge.s	.no_y1
  move.w	d5,d2
.no_y1:
  cmp.w	d3,d5	; y>y2?
  ble.s	.no_y2
  move.w	d5,d3
.no_y2:
  dbra	d7,.search
  move.l	#old_box1,a0
  movem.w	d0-3,(a0)	; Save the box.

.print_cube:
  move.l	a6,a0
  move.l	#object_faces,a2
  move.l	#new_coords,a3
  move.w	(a2)+,d7	; Nb of faces.
  subq.w	#$1,d7
.one_face:
  move.w	(a2)+,d6	; Nb of points for this face.
  move.w	d6,d0
  move.l	#face_coords,a1
  subq.l	#$1,d6
.one_coord:
  move.w	(a2)+,d1
  move.l	(a3,d1.w),(a1)+
  move.w	$4(a3,d1.w),(a1)+
  dbra	d6,.one_coord
.test_visibility:
  move.l	#face_coords,a1
  move.w	(a1)+,d1	; x1.
  move.w	(a1)+,d2	; y1.
  addq.w	#$2,a1
  move.w	(a1)+,d3	; x2.
  move.w	(a1)+,d4	; y2.
  addq.w	#$2,a1
  move.w	(a1)+,d5	; x3.
  move.w	(a1)+,d6	; y3.
  sub.w	d3,d1	; d1=x1-x2.
  sub.w	d4,d2	; d2=y1-y2.
  sub.w	d3,d5	; d5=x3-x2.
  sub.w	d4,d6	; d6=y3-y2.
  muls.w	d1,d6
  muls.w	d2,d5
  sub.l	d5,d6	; d6=(x1-x2)*(y3-y2)-(y1-y2)*(x3-x2).
  ble.s	.next_face
.visible:
  move.l	#face_coords,a1
  jsr	shaded_poly
.next_face:
  dbra	d7,.one_face

  move.l	a6,d0
  move.l	d0,d1
  swap.w	d0
  move.b	d0,$ffff8201.w
  swap.w	d0
  rol.w	#$8,d0
  move.b	d0,$ffff8203.w
  move.b	d1,$ffff820d.w

draw_logo:
		move.l	screen_adr,a0
	add.w	.ofs,a0
	lea	pi1_picture+34,a1

	move.w	#64-1,d7
.y:
	rept	200/4
	move.l	(a1)+,(a0)+
	endr

	dbra	d7,.y
	rts
.ofs:	dc.w	0


; *************************************************************************
; Routine which clears a box in 4 planes.
; Parameters:
;   a0.l = ramvideo adress.
;	d0.w = x1.
;	d1.w = x2.
;	d2.w = y1.
;	d3.w = y2.

clear_4_bpl:		; First see if the box is visible.
  movem.l	d0-3/a0-1,-(sp)
  tst.w	d3	; y2<0?
  blt.s	.end
  cmp.w	#199,d2	; y1>199.
  ble.s	.clipping
.end:
  movem.l	(sp)+,d0-3/a0-1
  rts
.clipping:
  tst.w	d2	; y1<0?
  bge.s	.no_clip_up
  moveq.l	#$0,d2	; Then y1=0.
.no_clip_up:
  cmp.w	#199,d3	; y2>199?
  ble.s	.no_clip_down
  move.w	#199,d3	; Then y2=199
.no_clip_down:
  sub.w	d2,d3	; d3=y2-y1=dy.
  addq.w	#$1,d3
  move.w	d3,$ffff8a38.w	; Lines per bit-block.
  move.l	#y_table,a1	
  add.w	d2,d2
  add.w	(a1,d2.w),a0	; a0 points on good line.
  move.w	#$fff0,d2
  and.w	d2,d0	; d0=x1 mod(16).
  and.w	d2,d1	; d1=x2 mod(16).
  add.w	#$10,d1	; d1=x2 mod(16)+16.
  sub.w	d0,d1	; d1=x2 mod(16)+16-x1 mod(16).
  lsr.w	#$1,d0
  add.w	d0,a0	; a0 points on good word.
  move.l	a0,$ffff8a32.w	; Dest adress.
  lsr.w	#$2,d1	; d2=nb of words.
  move.w	d1,$ffff8a36.w	; Words per line.
  move.w	#$2,$ffff8a2e.w ; Dest x inc.
  add.w	d1,d1
  move.w	#162,d3
  sub.w	d1,d3
  move.w	d3,$ffff8a30.w	; Dest y inc.
  moveq.l	#-1,d0
  move.l	d0,$ffff8a28.w	; Endmasks set to ones.
  move.w	d0,$ffff8a2c.w
  move.w	#$200,$ffff8a3a.w ; Fill with zeroes.
  move.b	#$c0,$ffff8a3c.w
  movem.l	(sp)+,d0-3/a0-1
  rts

dmg3_exit:

		rts

; *************************************************************************
; The interesting routines.

rotation:
  include	'sys/rotation.s'
  
shaded_poly:
  include	'sys/shade.s'

		section	data

sinus:
  incbin	'sys/sinus.xxx'

  even

.y_table:		; Table for y->y*160 conversions.
N set 0
 rept	200
  dc.w	N  
N set N+160
 endr
 
 	even

inverses:		; Table n->16384/n.
  incbin	'sys/inverses.xxx'

xmax_ad:		; Table of adresses for the jump.
N set 6
 rept	300
  dc.l	.xmax_line_end-N
N set N+6
 endr

xmin_ad:		; The same for the xmin tracking.
N set 6
 rept	300
  dc.l	.xmin_line_end-N
N set N+6
 endr

points_ad:		; Convert x->adress in the "core".
N set 0		; For the first 16 pixies.
 rept	16
  dc.l	.core+N
N set N+20
 endr
N set 0		; For the next ones.
 rept	15	; 240 points.
  dc.l	.core_2+000+N,.core_2+020+N
  dc.l	.core_2+040+N,.core_2+060+N
  dc.l	.core_2+080+N,.core_2+100+N
  dc.l	.core_2+120+N,.core_2+140+N
  dc.l	.core_2+160+N,.core_2+180+N
  dc.l	.core_2+200+N,.core_2+220+N
  dc.l	.core_2+240+N,.core_2+260+N
  dc.l	.core_2+280+N,.core_2+300+N
N set N+320+6
 endr
 
.endrouts_ad:		; Table for the endrouts adresses. 
  dc.l	.endrout_0,.endrout_1,.endrout_2,.endrout_3
  dc.l	.endrout_4,.endrout_5,.endrout_6,.endrout_7
  dc.l	.endrout_8,.endrout_9,.endrout_a,.endrout_b
  dc.l	.endrout_c,.endrout_d,.endrout_e,.endrout_f
  dc.l	.endrout_10,.endrout_11,.endrout_12,.endrout_13
  dc.l	.endrout_14,.endrout_15,.endrout_16,.endrout_17
  dc.l	.endrout_18,.endrout_19,.endrout_1a,.endrout_1b
  dc.l	.endrout_1c,.endrout_1d,.endrout_1e,.endrout_1f
   

		even
dmg3_lz7:	incbin	'stlow.dbl/sugar.lz7'
		even

super	dc.l	0


object_brows:		; Definition of the cube.
  dc.w	4,28*256
  dc.w	28*256,28*256
  dc.w	-28*256,28*256
  dc.w	-28*256,-28*256
  dc.w	28*256,-28*256
  dc.w	4,-28*256
  dc.w	28*256,28*256
  dc.w	-28*256,28*256
  dc.w	-28*256,-28*256
  dc.w	28*256,-28*256
  dc.w	0

object_faces:
  dc.w	6	; 6 faces, Clockwise cycle.
  dc.w	4,0*6,1*6,2*6,3*6
  dc.w	4,0*6,3*6,7*6,4*6
  dc.w	4,0*6,4*6,5*6,1*6
  dc.w	4,6*6,7*6,3*6,2*6
  dc.w	4,4*6,7*6,6*6,5*6
  dc.w	4,1*6,5*6,6*6,2*6

y_pos:  dc.w	250

y_table:		; Convert y->y*160.
N set 0
 rept	200
  dc.w	N
N set N+160
 endr

	even

		section bss
oldpal		ds.l	8

nb_lines_2_pass:	; This two vars are used for the clipping.
  ds.w	1
nb_lines_2_draw:
  ds.w	1
xmin_buffer:
  ds.l	300
  ds.l	300


angle1:		ds.w	1
angle2:		ds.w	1  
old_box1:	ds.w	4

new_coords:		; Coords after rotation.
  ds.w	21*3
face_coords:
  ds.w	21*3
  ds.w	21*3
  ds.w	21*3

reg_backup:	ds.l 1
dmg3_backup:			ds.w 14

	even


		section	text
