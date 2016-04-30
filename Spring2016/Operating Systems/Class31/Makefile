all: clean build execute
	
clean:
	
	rm -f *.out 
	
build: 
	
	gcc -o filesystem ext99.c disk.c
	
execute:
	./filesystem
	