Below is a complete README.md you can copy‑and‑paste directly into the root of your GitHub repository.

# Mandelbrot Set Boundary Analysis  

`mandelbrot_boundary.m` – a MATLAB script that visualises the Mandelbrot set, extracts its boundary along vertical slices, fits a high‑order polynomial to those points, estimates the curve’s arc length, and saves the results.

---

## Table of Contents
- [Overview](#overview)  
- [Requirements](#requirements)  
- [Installation](#installation)  
- [Running the Script](#running-the-script)  
- [Outputs](#outputs)  
- [Code Structure](#code-structure)  
- [Important Notes](#important-notes)  
- [Limitations](#limitations)  
- [License](#license)  
- [Contact / Issues](#contact--issues)  

---

## Overview
The script performs five main tasks:

1. **Visualisation** – Generates a coloured image of the Mandelbrot set on a rectangular region of the complex plane using the classic escape‑time algorithm.  
2. **Boundary Extraction** – Scans 103 evenly spaced vertical lines (fixed real part, varying imaginary part) and uses a bisection search to locate the set’s edge on each line.  
3. **Polynomial Fitting** – Fits a 15th‑order polynomial to all valid boundary points that lie within a hand‑tuned window (`x ∈ [-2, 0.25]`).  
4. **Arc‑Length Computation** – Numerically integrates the derivative of the fitted polynomial to obtain an estimate of the boundary’s length.  
5. **Result Saving** – Writes the polynomial coefficients and the computed arc length to `mandelbrot_results.mat`.

---

## Requirements
| Item | Minimum Version |
|------|-----------------|
| **MATLAB** | R2018b (or newer) |
| **Toolboxes** | None – only core MATLAB functions are used (`linspace`, `meshgrid`, `arrayfun`, `imshow`, `polyfit`, `polyval`, `polyder`, `integral`, …) |
| **External Files** | None |

---

## Installation
1. Clone or download this repository.  
2. Ensure the file `mandelbrot_boundary.m` resides in your MATLAB working folder (or add its location to the MATLAB path).

```bash
git clone https://github.com/<your-username>/mandelbrot-boundary-analysis.git
cd mandelbrot-boundary-analysis
```
---

## Running the Script
Open MATLAB, navigate to the folder containing the script, and execute:

mandelbrot_boundary
The script will:

Open Figure 1 – a colour‑coded rendering of the Mandelbrot set (jet colormap).
Open Figure 2 – blue circles marking the extracted boundary points together with the smooth polynomial fit.
Print the estimated arc length to the Command Window.
Save mandelbrot_results.mat (containing the polynomial coefficients p and the scalar arcLength) in the same directory.

---

## Outputs
Figures

Figure 1: Full Mandelbrot set visualisation.
Figure 2: Extracted boundary points + polynomial curve.
Console Message (example)

Approximated boundary length: 2.9766 (or some other value)
MAT‑file – mandelbrot_results.mat

p – 16‑element vector of polynomial coefficients (order 15).
arcLength – numeric estimate of the curve’s length.

---

## Code Structure
Section	Description
1. Visualisation	Builds a grid over x ∈ [-2, 1], y ∈ [-1.5, 1.5] and applies the escape‑time test.
2. Boundary Extraction	Runs a bisection routine on each vertical line to locate the set’s edge.
3. Polynomial Fitting	Performs a 15th‑order polyfit on points within x ∈ [-2, 0.25].
4. Arc‑Length Calculation	Uses polyder and integral to compute the length of the fitted curve.
5. Result Saving	Persists p and arcLength to mandelbrot_results.mat.
Helper Functions (at the end of the file)

fractal(c) – Escape‑time computation for a single complex point.
bisection(fn, s, e) – Classic bisection root‑finder used for boundary localisation.
poly_len(p, s, e) – Evaluates the arc length of a polynomial between limits s and e.

---

## Important Notes
Search Interval – The script assumes the boundary lies between y = 0 and y = 1.5. Lines that do not intersect the set in this range will produce NaN entries.
Bisection Tolerance – Stops when the interval width falls below 1e‑6 or after 100 iterations, ensuring convergence without excessive runtime.
Performance – Escape‑time calculations and numerical integration are CPU‑intensive. Expect a few seconds on a modern laptop; higher resolutions will increase runtime.

---

## Limitations
A 15th‑order polynomial cannot capture every fine detail of the fractal edge; the reported arc length is an approximation.
The hand‑tuned x‑range ([-2, 0.25]) works well for the main cardioid and bulb but may need adjustment for other regions.
The script currently fixes the vertical search window to y ∈ [0, 1.5]; modifying this requires editing the source.

---

## License
This project is released under the MIT License. Feel free to use, modify, and distribute the code, provided the original copyright notice is retained.

--- 

## Contact / Issues
If you encounter bugs, have questions, or would like to suggest improvements, please open an issue on the repository or contact the author directly.

