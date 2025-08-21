import nigui
import complex
import chroma
import threadpool

type
  Palette* = enum
    Palette1
    Palette2
    Palette3
    Palette4 # Corresponds to the one in GUI.png

proc getColor(m: int, max_iter: int, palette: Palette): nigui.Color =
  case palette:
  of Palette1:
    if m == max_iter:
      result = nigui.rgb(0, 0, 0) # Black
    else:
      let c = (m * 255 div max_iter).uint8
      result = nigui.rgb(c, c, c) # Grayscale
  of Palette2:
    if m == max_iter:
      result = nigui.rgb(0, 0, 0)
    else:
      let c = (m * 10).uint8
      result = nigui.rgb(c, c div 2, c div 4)
  of Palette3:
    if m == max_iter:
      result = nigui.rgb(0, 0, 0)
    else:
      let c = (m * 5).uint8
      result = nigui.rgb(c, c * 2, c * 3)
  of Palette4:
    # This palette attempts to mimic the one in GUI.png
    if m == max_iter:
      result = nigui.rgb(0, 0, 0) # Black for points inside the set
    else:
      let
        hue = (m mod 256).float * 360.0 / 256.0
        saturation = 1.0
        value = 1.0 # Always full value for points outside the set
      let hsvColor = hsv(hue, saturation, value)
      let rgbColor: chroma.Color = color(hsvColor)
      result = nigui.rgb((rgbColor.r * 255).uint8, (rgbColor.g * 255).uint8, (rgbColor.b * 255).uint8)

proc mandelbrot(c: Complex[float64], max_iter: int): int =
  var z = complex(0.0, 0.0)
  for i in 0..max_iter:
    if z.abs > 2.0:
      return i
    z = z * z + c
  return max_iter # Corrected: return max_iter if loop completes

var
  minX: float64 = -2.5
  maxX: float64 = 1.0
  minY: float64 = -1.0
  maxY: float64 = 1.0
  maxIter: int = 255
  currentPalette: Palette = Palette4 # Default to Palette4

var
  isDragging: bool = false
  startX, startY: int # Mouse down coordinates
  endX, endY: int     # Mouse up/current coordinates for drawing rectangle

const
  ImageWidth = 800 # Use a separate constant for image dimensions
  ImageHeight = 600

var
  mandelbrotControl: Control # Forward declaration for global access
  pixelChannel: Channel[seq[nigui.Color]] # Channel for inter-thread communication
  currentImagePixels: seq[nigui.Color] # Stores the latest calculated pixels for drawing

# Procedure to calculate Mandelbrot set pixels in a separate thread
proc calculateMandelbrotAsync(minX, maxX, minY, maxY: float64, maxIter: int, palette: Palette) =
  var pixels = newSeq[nigui.Color](ImageWidth * ImageHeight)
  let rangeX = maxX - minX
  let rangeY = maxY - minY

  for py in 0..<ImageHeight:
    for px in 0..<ImageWidth:
      let x0 = minX + (rangeX * float(px) / float(ImageWidth))
      let y0 = minY + (rangeY * float(py) / float(ImageHeight))
      let c = complex(x0, y0)
      let m = mandelbrot(c, maxIter)
      pixels[py * ImageWidth + px] = getColor(m, maxIter, palette)

  pixelChannel.send(pixels) # Send calculated pixels to the main thread via channel

# Triggers the Mandelbrot calculation in a separate thread
proc drawMandelbrot(canvas: Canvas) =
  spawn calculateMandelbrotAsync(minX, maxX, minY, maxY, maxIter, currentPalette)

proc main() =
  app.init()

  pixelChannel.open() # Open the channel for communication
  currentImagePixels = newSeq[nigui.Color](ImageWidth * ImageHeight) # Initialize pixel buffer

  var window = newWindow("Mandelbrot set explorer")
  window.width = ImageWidth
  window.height = ImageHeight

  var mainContainer = newLayoutContainer(Layout_Horizontal)
  window.add(mainContainer)

  # Left side: Image display area
  mandelbrotControl = newControl()
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
  var paletteComboBox = newComboBox(@["Palette 1", "Palette 2", "Palette 3", "Palette 4"])
  paletteComboBox.index = 3 # Selects "Palette 4"
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

  # Mouse event handling for zooming and zoom out
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
      let newMinX = minX + (maxX - minX) * min(startX, endX).float / ImageWidth.float
      let newMaxX = minX + (maxX - minX) * max(startX, endX).float / ImageWidth.float
      let newMinY = minY + (maxY - minY) * min(startY, endY).float / ImageHeight.float
      let newMaxY = minY + (maxY - minY) * max(startY, endY).float / ImageHeight.float

      minX = newMinX
      maxX = newMaxX
      minY = newMinY
      maxY = newMaxY

      mandelbrotControl.forceRedraw() # Redraw with new zoom
    elif event.button == MouseButton_Right: # Zoom out with right click
      minX = -2.5
      maxX = 1.0
      minY = -1.0
      maxY = 1.0
      mandelbrotControl.forceRedraw()

  # Drawing event handler for the Mandelbrot control
  mandelbrotControl.onDraw = proc(event: DrawEvent) =
    # Draw the stored pixels from the last completed calculation
    for py in 0..<ImageHeight:
      for px in 0..<ImageWidth:
        event.control.canvas.setPixel(px, py, currentImagePixels[py * ImageWidth + px])

    # Draw selection rectangle if dragging
    if isDragging:
      event.control.canvas.lineColor = nigui.rgb(255, 255, 255) # White rectangle
      event.control.canvas.drawRectOutline(min(startX, endX), min(startY, endY),
                                      abs(endX - startX), abs(endY - startY))

    # Trigger calculation if not already calculating (e.g., on initial draw or after zoom/palette change)
    # A more robust solution would involve a state machine to prevent multiple calculations
    drawMandelbrot(event.control.canvas) # This now only spawns the async calculation

  # Event handler for palette ComboBox
  paletteComboBox.onChange = proc(event: ComboBoxChangeEvent) =
    case paletteComboBox.index:
    of 0: currentPalette = Palette1
    of 1: currentPalette = Palette2
    of 2: currentPalette = Palette3
    of 3: currentPalette = Palette4
    else: discard
    mandelbrotControl.forceRedraw()

  # Timer to check for new pixel data from the channel
  # This timer runs on the main GUI thread and safely updates the UI
  var timer = startRepeatingTimer(100, proc(event: TimerEvent) =
    let (dataAvailable, receivedPixels) = pixelChannel.tryRecv() # Attempt to receive pixels from worker thread
    if dataAvailable:
      currentImagePixels = receivedPixels # Store the received pixels
      mandelbrotControl.forceRedraw() # Trigger redraw of the Mandelbrot control
  )

  window.show()
  app.run()

main()