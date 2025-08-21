import nigui
import complex

proc mandelbrot(c: Complex[float64], max_iter: int): int =
  var z = complex(0.0, 0.0)
  for i in 0..max_iter:
    if z.abs > 2.0:
      return i
    z = z * z + c
  return max_iter

var
  minX: float64 = -2.5
  maxX: float64 = 1.0
  minY: float64 = -1.0
  maxY: float64 = 1.0
  maxIter: int = 255

var
  isDragging: bool = false
  startX, startY: int # Mouse down coordinates
  endX, endY: int     # Mouse up/current coordinates for drawing rectangle

const
  Width = 800
  Height = 600

proc drawMandelbrot(canvas: Canvas) =
  let rangeX = maxX - minX
  let rangeY = maxY - minY
  for px in 0..<Width:
    for py in 0..<Height:
      let x0 = minX + (rangeX * float(px) / float(Width))
      let y0 = minY + (rangeY * float(py) / float(Height))
      let c = complex(x0, y0)
      let m = mandelbrot(c, maxIter) # Use max_iter = 255
      let color = if m == 255:
        rgb(0, 0, 0) # Black for points inside the set
      else:
        # Simple grayscale based on iteration count
        rgb(m.uint8, m.uint8, m.uint8)
      canvas.setPixel(px, py, color)

proc main() =
  app.init()

  var window = newWindow("Mandelbrot set explorer")
  window.width = 800
  window.height = 600

  var mainContainer = newLayoutContainer(Layout_Horizontal)
  window.add(mainContainer)

  # Left side: Image display area
  var mandelbrotControl = newControl()
  mandelbrotControl.widthMode = WidthMode_Expand
  mandelbrotControl.heightMode = HeightMode_Fill
  mainContainer.add(mandelbrotControl)

  # Right side: Control panel
  var controlPanel = newLayoutContainer(Layout_Vertical)
  controlPanel.width = 200 # Adjust as needed
  controlPanel.heightMode = HeightMode_Fill
  mainContainer.add(controlPanel)

  # Iterations
  var iterationsLabel = newLabel("Iterations")
  controlPanel.add(iterationsLabel)
  var iterationsTextBox = newTextBox($maxIter)
  controlPanel.add(iterationsTextBox)

  # Zoom factor
  var zoomFactorLabel = newLabel("Zoom factor")
  controlPanel.add(zoomFactorLabel)
  var zoomFactorTextBox = newTextBox("1.4142") # Placeholder value
  controlPanel.add(zoomFactorTextBox)

  # Palette
  var paletteLabel = newLabel("Palette")
  controlPanel.add(paletteLabel)
  var paletteComboBox = newComboBox(@["1", "2", "3", "4"]) # Placeholder options
  paletteComboBox.index = 3 # Selects "4"
  controlPanel.add(paletteComboBox)

  # Normalized checkbox
  var normalizedCheckbox = newCheckbox("Normalized")
  normalizedCheckbox.checked = true
  controlPanel.add(normalizedCheckbox)

  # Buttons
  var refreshButton = newButton("Refresh")
  controlPanel.add(refreshButton)
  var backButton = newButton("Back")
  controlPanel.add(backButton)
  var saveImageButton = newButton("Save Image")
  controlPanel.add(saveImageButton)
  var saveConfigButton = newButton("Save Config")
  controlPanel.add(saveConfigButton)
  var homeButton = newButton("Home")
  controlPanel.add(homeButton)

  # Readout Labels
  controlPanel.add(newLabel("Re: -1.344662847231080")) # Placeholder
  controlPanel.add(newLabel("Im: 0.049957895942731")) # Placeholder
  controlPanel.add(newLabel("Width: 1.5625000E-2")) # Placeholder
  controlPanel.add(newLabel("Height: 1.5625000E-2")) # Placeholder
  controlPanel.add(newLabel("Zoom: 256.0000")) # Placeholder
  controlPanel.add(newLabel("Threads: 4")) # Placeholder
  controlPanel.add(newLabel("Precision: double-float")) # Placeholder

  # Integrate existing mouse event handling for zooming
  mandelbrotControl.onMouseButtonDown = proc(event: MouseEvent) =
    if event.button == MouseButton_Left:
      isDragging = true
      startX = event.x
      startY = event.y

  mandelbrotControl.onMouseMove = proc(event: MouseEvent) =
    if isDragging:
      endX = event.x
      endY = event.y
      mandelbrotControl.forceRedraw() # Redraw to show selection rectangle

  mandelbrotControl.onMouseButtonUp = proc(event: MouseEvent) =
    if event.button == MouseButton_Left and isDragging:
      isDragging = false
      endX = event.x
      endY = event.y

      # Calculate new complex coordinates based on selected rectangle
      let newMinX = minX + (maxX - minX) * min(startX, endX).float / Width.float
      let newMaxX = minX + (maxX - minX) * max(startX, endX).float / Width.float
      let newMinY = minY + (maxY - minY) * min(startY, endY).float / Height.float
      let newMaxY = minY + (maxY - minY) * max(startY, endY).float / Height.float

      minX = newMinX
      maxX = newMaxX
      minY = newMinY
      maxY = newMaxY

      mandelbrotControl.forceRedraw() # Redraw with new zoom

  mandelbrotControl.onDraw = proc(event: DrawEvent) =
    drawMandelbrot(event.control.canvas)
    if isDragging:
      event.control.canvas.lineColor = rgb(255, 255, 255) # White rectangle
      event.control.canvas.drawRectOutline(min(startX, endX), min(startY, endY),
                                      abs(endX - startX), abs(endY - startY))

  window.show()
  app.run()

main()
