PROG	= yazecminer
OBJ	= jsmn/jsmn.o sha256/sha256.o equihash.o mainer.o
OBJ96	= jsmn/jsmn.o sha256/sha256.o eq96_5.o mainer.o
HDR	= blake2b.h sha256/sha256.h equihash.h
HDR96	= blake2b.h sha256/sha256.h eq96_5.h

BLAKE	= ref
#BLAKE	= sse
OBJ	+= blake2b-$(BLAKE)/blake2b.o
OBJ96	+= blake2b-$(BLAKE)/blake2b.o

CC	= gcc
CFLAGS	= -march=native -W -Wall -O3 -g -I.
#LDFLAGS = -static
#LDFLAGS += -lsocket -lnsl

$(PROG): $(OBJ)
	$(CC) $(LDFLAGS) -o $(PROG) $(OBJ)

yaz96: $(OBJ96)
	$(CC) $(LDFLAGS) -o yazecminer96 $(OBJ96)

$(OBJ): $(HDR)

$(OBJ96): $(HDR96)

clean:
	rm -f $(PROG) $(PROG)96 $(OBJ) $(OBJ96)
