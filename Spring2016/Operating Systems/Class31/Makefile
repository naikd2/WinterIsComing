all: clean build execute
	
clean:
	
	rm -f *.out 
	rm -f DISK_0 
	
build: 
	
	gcc -o filesystem ext99.c disk.c
	
execute:
	./filesystem
	