# Package

version       = "0.1.0"
author        = "Yoel Jacobsen"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir = "src"


# Dependencies

requires "nim >= 1.6.14"
requires "nigui" : "/home/yoel/Development/Nim/Mandelbrot/NiGui"

bin = @["main"]
binDir = "bin"
backend = "c"
