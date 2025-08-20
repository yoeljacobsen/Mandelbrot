
all: Mandelbrot

Mandelbrot: src/main.nim
	nim c -d:release src/main.nim

clean:
	rm -f Mandelbrot
