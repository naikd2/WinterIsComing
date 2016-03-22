all: clean compile

clean:
	rm -f *.out

compile:
	cc cache.c -o a.out
	cc cacheLRU.c -o b.out

run fifo:
	rm -f *.out
	cc cache.c -o a.out
	./a.out

run lru:
	rm -f *.out
	cc cacheLRU.c -o b.out
	./b.out