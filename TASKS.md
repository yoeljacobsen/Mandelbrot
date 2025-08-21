# Mandelbrot Set Explorer Tasks

This document lists the tasks required to develop the Mandelbrot set explorer, as outlined in the `SPEC.md` file.

## Phase 1: Core Functionality

-   [x] **Project Setup:**
    -   [x] Initialize a new Nim project.
    -   [ ] Create a Makefile for building the project.
    -   [ ] Create and maintain a README.md file.
    -   [x] Set up a basic project structure with `src` and `tests` directories.
    -   [x] Create a NiGui manual (`NIGUI_MANUAL.md`) based on local examples.
-   [ ] **Mandelbrot Logic:**
    -   [ ] Implement the core Mandelbrot set calculation logic.
    -   [ ] Create a data structure to store the generated Mandelbrot set data.
-   [ ] **GUI Implementation (based on GUI.png):**
    -   [ ] Choose and set up a GUI library (NiGui).
    -   [ ] Create the main window with a title "Mandelbrot set explorer".
    -   [ ] Implement the main layout with an image display area on the left and a control panel on the right.
    -   [ ] **Control Panel Elements:**
        -   [ ] "Iterations" label and input field.
        -   [ ] "Zoom factor" label and input field.
        -   [ ] "Palette" label and dropdown (ComboBox).
        -   [ ] "Normalized" checkbox.
        -   [ ] "Refresh" button.
        -   [ ] "Back" button.
        -   [ ] "Save Image" button.
        -   [ ] "Save Config" button.
        -   [ ] "Home" button.
        -   [ ] Readout labels for "Re:", "Im:", "Width:", "Height:", "Zoom:", "Threads:", "Precision:".
    -   [ ] **Image Display Area:**
        -   [ ] Implement drawing functionality to render the Mandelbrot set.

## Phase 2: User Interaction

-   [ ] **Zooming:**
    -   [ ] Implement mouse selection to define a zoom region.
    -   [ ] Update the view to the selected region.
-   [ ] **Panning:**
    -   [ ] Implement click-and-drag mouse functionality for panning.
    -   [ ] Update the view based on the panning action.
-   [ ] **Iteration Control:**
    -   [ ] Connect the "Iterations" input field to the Mandelbrot calculation.

## Phase 3: Visuals and Usability

-   [ ] **Color Palettes:**
    -   [ ] Implement a selection of color palettes.
    -   [ ] Connect the "Palette" dropdown to switch between palettes.
-   [ ] **Status Bar:**
    -   [ ] Add a status bar to display information like coordinates and zoom level.
-   [ ] **Reset and Save:**
    -   [ ] Implement the "Home" button to go back to the initial view.
    -   [ ] Implement the "Save Image" button to save the current view as a PNG image.
    -   [ ] Implement the "Save Config" button to save the current configuration.

## Phase 4: Performance and Refinements

-   [ ] **Performance Optimization:**
    -   [ ] Profile the application to identify performance bottlenecks.
    -   [ ] Implement multi-threading to speed up the Mandelbrot calculation.
-   [ ] **Code Refactoring:**
    -   [ ] Review and refactor the code for clarity, efficiency, and maintainability.
    -   [ ] Add comments and documentation to the code.

## Phase 5: Future Enhancements

-   [ ] **Arbitrary-Precision Arithmetic:**
    -   [ ] Integrate a library for arbitrary-precision arithmetic.
    -   [ ] Update the Mandelbrot calculation to use high-precision numbers.
-   [ ] **Julia Set Mode:**
    -   [ ] Implement the logic for generating Julia sets.
    -   [ ] Add a UI element to switch between Mandelbrot and Julia set modes.
-   [ ] **History:**
    -   [ ] Implement a history mechanism to store previous views.
    -   [ ] Add "Back" and "Forward" buttons to the GUI.
-   [ ] **Configuration Files:**
    -   [ ] Implement saving and loading of application settings to a configuration file.
