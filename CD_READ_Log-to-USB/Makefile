all: cdlog.pce


CFLAGS =-S -raw

%.pce: %.asm
	pceas $(CFLAGS) $(SRC) $(LIBS) $< >$@.map

clean:
	rm -f *.pce *.lst *.sym *.s *.iso *.map
