vasm -m68000 -Felf -noesc -quiet -no-opt %1.s -o %1.o
vlink -bataritos -tos-flags 7 %1.o -o %1.tos
