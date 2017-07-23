********************************************************
* Created with and by : STARGENST (C) 1992 Digi Tallis *
*        Written by : Maguay (Starfield routine)       *
*               And : Ormolu (Stargenst)               *
********************************************************

star_rout
        lea     star_cnts,a2
        lea     star_offs,a3
        lea     del_stars,a0
        rept    100
        move.l  (a0)+,a1
        clr.w   (a1)
        endr
        lea     del_stars,a0
        clr.l   d0
        move.w  num_stars,d0    
starlp1
        lea     star_data,a1
        add.l   (a3),a1
        clr.l   d1
        add.l   (a2),a1
        cmpi.w  #0,(a1)
        bne.s   plot_a_star
        clr.l   (a2)
        bra.s   next_star
plot_a_star
        move.l  screen_adr,a4
        add.w   (a1)+,a4
        clr.l   d1
        move.w  (a1),d1
        or.w    d1,(a4)
next_star
        addq.l  #4,(a2)
        addq.l  #4,a2
        addq.l  #4,a3
        move.l  a4,(a0)+
        dbra    d0,starlp1
        rts



num_stars
        dc.w     99
star_cnts
        dc.l     16, 24, 68, 36, 96, 80, 52, 32
        dc.l     56, 52, 24, 100, 88, 20, 28, 100
        dc.l     64, 28, 60, 12, 48, 96, 48, 76
        dc.l     4, 100, 100, 0, 80, 4, 0, 24
        dc.l     48, 80, 40, 20, 28, 76, 76, 32
        dc.l     52, 12, 64, 32, 20, 68, 32, 88
        dc.l     24, 56, 68, 72, 60, 88, 84, 60
        dc.l     52, 0, 44, 4, 52, 60, 4, 92
        dc.l     24, 100, 76, 92, 80, 0, 20, 12
        dc.l     44, 64, 100, 84, 16, 32, 52, 16
        dc.l     36, 72, 88, 56, 12, 76, 48, 88
        dc.l     96, 36, 96, 80, 56, 56, 64, 8
        dc.l     76, 100, 60, 96, 80, 64, 28, 80
star_offs
        dc.l     0, 140, 348, 524, 664, 824, 1016, 1128
        dc.l     1348, 1532, 1764, 1896, 2108, 2252, 2440, 2576
        dc.l     2724, 2892, 3024, 3208, 3368, 3548, 3752, 3888
        dc.l     4068, 4276, 4512, 4688, 4876, 5048, 5296, 5408
        dc.l     5612, 5772, 5948, 6084, 6220, 6348, 6504, 6712
        dc.l     6880, 7028, 7232, 7348, 7528, 7648, 7900, 8084
        dc.l     8288, 8432, 8664, 8844, 8960, 9088, 9308, 9524
        dc.l     9688, 9944, 10124, 10252, 10372, 10584, 10784, 10964
        dc.l     11120, 11304, 11528, 11736, 11912, 12092, 12308, 12464
        dc.l     12592, 12840, 12976, 13152, 13376, 13568, 13752, 13936
        dc.l     14148, 14320, 14444, 14600, 14796, 14956, 15160, 15380
        dc.l     15588, 15764, 15964, 16152, 16304, 16548, 16700, 16848
        dc.l     17020, 17188, 17332, 17480, 17616, 17836, 0, 0
del_stars
        rept    100
        dc.l    $78000
        endr
star_data
        incbin  'stlow.dbl/star.bin'
        even
