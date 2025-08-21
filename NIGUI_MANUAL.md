# NiGui Manual

This manual provides a comprehensive overview of the NiGui GUI toolkit for Nim, based on the official examples.

## 1. Basic Application Structure

A typical NiGui application follows this structure:

```nim
import nigui

app.init() # Initialize the NiGui application

var window = newWindow("Window Title") # Create a new window
window.width = 800
window.height = 600

# Add controls or containers to the window
# window.add(someControlOrContainer)

window.show() # Make the window visible
app.run() # Start the application event loop
```

*   `app.init()`: Must be called once at the beginning of your application.
*   `newWindow(title: string)`: Creates a new top-level window. A window can contain only one control or container directly.
*   `window.width`, `window.height`: Set the dimensions of the window. Use `.scaleToDpi` for DPI scaling.
*   `window.iconPath`: Set the window icon.
*   `window.add(control: Control)`: Adds a control or container to the window.
*   `window.show()`: Makes the window visible. Controls are visible by default.
*   `app.run()`: Starts the main event loop. The application runs until all windows are disposed or `app.quit()` is called.

## 2. Controls

NiGui provides various built-in controls:

### 2.1 Button

```nim
var button = newButton("Click Me")
container.add(button)

button.onClick = proc(event: ClickEvent) =
  echo "Button clicked!"
```
*   `newButton(text: string)`: Creates a new button.
*   `onClick`: Event handler for button clicks.

### 2.2 Checkbox

```nim
var checkbox = newCheckbox("Enable Feature")
checkbox.checked = true # Set initial state
container.add(checkbox)
```
*   `newCheckbox(text: string)`: Creates a new checkbox.
*   `checked`: Boolean property to get/set the checked state.

### 2.3 ComboBox (Dropdown)

```nim
var comboBox = newComboBox(@["Option 1", "Option 2", "Option 3"])
comboBox.index = 1 # Select "Option 2" (0-based index)
# Or: comboBox.value = "Option 2"
container.add(comboBox)

comboBox.onChange = proc(event: ComboBoxChangeEvent) =
  echo "Selected: " & comboBox.value & " (Index: " & $comboBox.index & ")"
```
*   `newComboBox(options: seq[string])`: Creates a new combobox with given options.
*   `index`: Get/set the 0-based index of the selected item.
*   `value`: Get/set the string value of the selected item.
*   `onChange`: Event handler for selection changes.

### 2.4 Label

```nim
var label = newLabel("Hello, NiGui!")
container.add(label)
```
*   `newLabel(text: string)`: Creates a new static text label.
*   `text`: Get/set the label's text.

### 2.5 ProgressBar

```nim
var progressBar = newProgressBar()
progressBar.value = 0.75 # Set progress (0.0 to 1.0)
container.add(progressBar)
```
*   `newProgressBar()`: Creates a new progress bar.
*   `value`: Float property (0.0 to 1.0) to set the progress.

### 2.6 TextBox (Single-line input)

```nim
var textBox = newTextBox("Initial Text")
textBox.text = "New Text"
container.add(textBox)
```
*   `newTextBox(initialText: string)`: Creates a new single-line text input.
*   `text`: Get/set the text content.

### 2.7 TextArea (Multi-line input)

```nim
var textArea = newTextArea("Line 1\pLine 2") # \p for new line
textArea.addLine("Another line")
container.add(textArea)
```
*   `newTextArea(initialText: string)`: Creates a new multi-line text input.
*   `addLine(text: string)`: Appends a new line of text.

### 2.8 Control (Generic Drawable Control)

`Control` is a fundamental building block for custom drawing.

```nim
var myControl = newControl()
myControl.widthMode = WidthMode_Fill
myControl.heightMode = HeightMode_Fill
window.add(myControl)

myControl.onDraw = proc(event: DrawEvent) =
  let canvas = event.control.canvas
  canvas.areaColor = rgb(30, 30, 30)
  canvas.fill()
  canvas.lineColor = rgb(255, 255, 255)
  canvas.drawRectOutline(10, 10, 50, 50)
```
*   `newControl()`: Creates a generic control that can be drawn upon.
*   `onDraw`: Event handler triggered when the control needs to be redrawn. Provides a `canvas` object.
*   `forceRedraw()`: Forces a control to redraw itself.

## 3. Layouts

NiGui uses layout containers to arrange controls.

### 3.1 LayoutContainer

```nim
var container = newLayoutContainer(Layout_Vertical)
# container.padding = 10
# container.spacing = 5
# container.frame = newFrame("Container Frame")
window.add(container)
```
*   `newLayoutContainer(layoutType: LayoutType)`: Creates a container that automatically arranges its children.
    *   `Layout_Vertical`: Arranges controls vertically.
    *   `Layout_Horizontal`: Arranges controls horizontally.
*   `padding`: Space between the container's border and its children.
*   `spacing`: Space between child controls.
*   `frame`: Adds a visual frame with a title around the container.

### 3.2 WidthMode and HeightMode

These properties control how controls resize within their parent container.

*   `WidthMode_Auto`, `HeightMode_Auto`: Control's size is determined by its content.
*   `WidthMode_Fill`, `HeightMode_Fill`: Control fills the available space in its dimension.
*   `WidthMode_Expand`, `HeightMode_Expand`: Control expands to take up extra space, distributing it among other expanding controls.

### 3.3 Alignment

For `LayoutContainer`s:

*   `xAlign`: Horizontal alignment (`XAlign_Left`, `XAlign_Center`, `XAlign_Right`, `XAlign_Spread`).
*   `yAlign`: Vertical alignment (`YAlign_Top`, `YAlign_Center`, `YAlign_Bottom`, `YAlign_Spread`).

### 3.4 Fixed Layout

You can manually position controls by adding them to a generic `Container` and setting their `x`, `y`, `width`, `height` properties. This bypasses automatic layout.

```nim
var container = newContainer() # Not a LayoutContainer
window.add(container)

var button = newButton("Fixed Button")
container.add(button)
button.x = 50
button.y = 100
button.width = 150
button.height = 40
```

## 4. Event Handling

NiGui uses event handlers (procedures) to respond to user interactions.

*   `onClick`: For `Button`s, `Checkbox`es.
*   `onChange`: For `ComboBox`es.
*   `onDraw`: For `Control`s (for custom drawing).
*   `onMouseButtonDown`, `onMouseMove`, `onMouseButtonUp`: For mouse interactions on controls.
*   `onKeyDown`: For keyboard events on windows or controls.
*   `onCloseClick`: For handling window close events.

## 5. Drawing on Canvas

The `canvas` object (available in `onDraw` events) provides drawing primitives.

*   `canvas.areaColor = rgb(r, g, b)`: Sets the fill color.
*   `canvas.fill()`: Fills the entire canvas with `areaColor`.
*   `canvas.setPixel(x, y, color)`: Sets a single pixel.
*   `canvas.lineColor = rgb(r, g, b)`: Sets the line color.
*   `canvas.drawRectArea(x, y, width, height)`: Draws a filled rectangle.
*   `canvas.drawRectOutline(x, y, width, height)`: Draws a rectangle outline.
*   `canvas.drawLine(x1, y1, x2, y2)`: Draws a line.
*   `canvas.textColor = rgb(r, g, b)`: Sets the text color.
*   `canvas.fontSize = size`: Sets the font size.
*   `canvas.fontFamily = "Arial"`: Sets the font family.
*   `canvas.drawText(text, x, y)`: Draws text.
*   `canvas.drawTextCentered(text)`: Draws text centered on the control.
*   `canvas.getTextWidth(text)`: Gets the width of the text.
*   `canvas.getTextLineHeight()`: Gets the height of a single line of text.
*   `canvas.drawImage(image, x, y)`: Draws an `Image` object.
*   `canvas.drawImage(image, x, y, size)`: Draws an `Image` object scaled.

## 6. Image Handling

```nim
var image = newImage()
image.loadFromFile("path/to/image.png") # Load from file
image.resize(200, 200) # Resize the image
image.saveToPngFile("output.png") # Save to PNG
```
*   `newImage()`: Creates an empty image object.
*   `loadFromFile(path: string)`: Loads an image from a file.
*   `resize(width, height)`: Resizes the image.
*   `saveToPngFile(path: string)`: Saves the image to a PNG file.

## 7. Dialogs

NiGui provides common file dialogs and message boxes.

### 7.1 Message Boxes

```nim
window.alert("This is an alert message.")
let result = window.msgBox("Do you want to proceed?", "Confirmation", "Yes", "No")
# result will be 1 for "Yes", 2 for "No", etc.
```
*   `window.alert(message: string)`: Displays a simple alert box.
*   `window.msgBox(message: string, title: string, buttons: varargs[string])`: Displays a message box with custom buttons and returns the index of the clicked button (1-based).

### 7.2 File Dialogs

```nim
import nigui/filedialog

# Open File Dialog
var openDialog = newOpenFileDialog()
openDialog.title = "Select a file"
openDialog.multiple = true # Allow multiple selection
openDialog.run()
for file in openDialog.files:
  echo "Selected: " & file

# Save File Dialog
var saveDialog = newSaveFileDialog()
saveDialog.title = "Save as..."
saveDialog.defaultName = "document.txt"
saveDialog.run()
if saveDialog.file != "":
  echo "Save path: " & saveDialog.file

# Select Directory Dialog
var dirDialog = newSelectDirectoryDialog()
dirDialog.title = "Select a directory"
dirDialog.run()
if dirDialog.selectedDirectory != "":
  echo "Selected directory: " & dirDialog.selectedDirectory
```
*   `newOpenFileDialog()`, `newSaveFileDialog()`, `newSelectDirectoryDialog()`: Create dialog instances.
*   `title`, `multiple`, `defaultName`, `directory`, `startDirectory`: Common properties.
*   `run()`: Displays the dialog.
*   `files` (Open), `file` (Save), `selectedDirectory` (Select Directory): Get results.

## 8. Threading

NiGui allows updating controls from other threads using `app.queueMain`.

```nim
import nigui
import threadpool # For creating threads

proc updateProgressBar(pbar: ProgressBar) =
  # This proc runs in a separate thread
  for i in 1..100:
    app.queueMain(proc() = pbar.value = i.float / 100.0) # Update GUI on main thread
    sleep(50) # Simulate work

# In main proc:
var pbar = newProgressBar()
container.add(pbar)
spawn updateProgressBar(pbar) # Start thread
```
*   `app.queueMain(proc)`: Queues a procedure to be executed on the main GUI thread. Essential for thread-safe GUI updates.
*   `createThread`, `spawn`: Nim's threading mechanisms.

## 9. Custom Controls

You can create custom controls by subclassing `ControlImpl` or existing controls like `Button`.

```nim
type CustomButton* = ref object of Button

method handleDrawEvent(control: CustomButton, event: DrawEvent) =
  let canvas = event.control.canvas
  canvas.areaColor = rgb(55, 55, 55)
  canvas.drawRectArea(0, 0, control.width, control.height)
  canvas.drawTextCentered(control.text)

# Constructor
proc newCustomButton*(text = ""): CustomButton =
  result = new CustomButton
  result.init()
  result.text = text
```
*   `handleDrawEvent`: Override to define custom drawing logic.
*   `handleClickEvent`: Override for custom click handling.
*   `init()`: Call the parent's `init()` method.

## 10. Timers

```nim
var timer: Timer
var counter = 0

proc timerCallback(event: TimerEvent) =
  echo "Timer fired! Counter: " & $counter
  counter.inc()

# Start a one-shot timer (fires once after 1000ms)
timer = startTimer(1000, timerCallback)

# Start a repeating timer (fires every 500ms)
timer = startRepeatingTimer(500, timerCallback)

# Stop the timer
timer.stop()
```
*   `startTimer(intervalMs: int, callback: proc(event: TimerEvent))`: Starts a one-shot timer.
*   `startRepeatingTimer(intervalMs: int, callback: proc(event: TimerEvent))`: Starts a repeating timer.
*   `timer.stop()`: Stops a running timer.

## 11. DPI Scaling

Use `.scaleToDpi` to ensure your UI scales correctly on high-DPI displays.

```nim
window.width = 600.scaleToDpi
```

## 12. Error Handling

*   **Widget Errors:** NiGui may log errors to the console if widgets are used incorrectly (e.g., adding multiple controls to a window without a container). The application might continue running.
*   **Unhandled Exceptions:** Unhandled exceptions in event handlers can crash the application. It's good practice to use `try...except` blocks for critical operations.
