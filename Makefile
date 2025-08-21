all: Mandelbrot

Mandelbrot: src/main.nim
	nim c -d:release --threads:on src/main.nim

clean:
	rm -f Mandelbrot