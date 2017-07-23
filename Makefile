CC = /opt/vbcc/bin/vc
ASM = /opt/vbcc/bin/vasm
LD = /opt/vbcc/bin/vlink
CFLAGS	= -cpu=68000 -O1
ASMFLAGS = -m68000 -Felf -noesc -quiet -no-opt
LDFLAGS = -bataritos -tos-flags 7
LOADLIBES = 
LDLIBS =

PRG = sugar.tos
OBJ = sugar.o

.PHONY:	sugar.s	# always rebuild target

all : $(PRG)

install : $(all)
	mcopy -o sugar.tos e:sugar.tos
	sync

	

$(PRG):	$(OBJ)
	$(LD) $< $(LDFLAGS) -o $@
.c.o:
	$(CC) -c $(CFLAGS) $<
.s.o:
	$(ASM) $(ASMFLAGS) $< -o $@

sugar.o:	$(SRC)

clean:	
	rm -f $(PRG) $(OBJ)
