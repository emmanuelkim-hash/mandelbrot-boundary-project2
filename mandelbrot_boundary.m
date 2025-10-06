%=====================================================================
% mandelbrot_boundary.m
%   • Visualises the Mandelbrot set
%   • Extracts boundary points along vertical lines for x in [-2, 1]
%   • Fits a polynomial of order 15 to boundary points
%   • Computes the arc-length of the fitted curve
%   • Saves the polynomial coefficients and length
%=====================================================================

%% --------------------------------------------------------------------
% 1. Visualise the Mandelbrot set
% This section creates a grid over the complex plane and computes the
% escape-time for each point to visualize the Mandelbrot set. It's helpful
% for verifying the fractal function actually works.
% --------------------------------------------------------------------
x = linspace(-2, 1, 500);          % real axis limits
y = linspace(-1.5, 1.5, 500);      % imaginary axis limits
[X, Y] = meshgrid(x, y);
C = X + 1i*Y;                      % complex grid

% Escape-time matrix: applies the fractal function to each point in the grid
M = arrayfun(@fractal, C);

% Display the visualization
figure;
imshow(M, []);                     % auto-scale the color map
title('Mandelbrot Set');
colormap(jet);
colorbar;                          % shows the color scale for iteration counts

%% --------------------------------------------------------------------
% 2. Locate boundary points along vertical lines for x in [-2, 1]
% Here, we probe along vertical lines (fixed x, varying y) to find where
% the Mandelbrot set boundary crosses, using bisection on the indicator
% function. We use 103 points to meet the requirement of at least 103.
% --------------------------------------------------------------------
xVals   = linspace(-2, 1, 103);    % probing positions along real axis
boundary = zeros(size(xVals));     % will store the y-values of boundary points

for k = 1:numel(xVals)
    % Define the indicator: +1 outside (diverges), -1 inside (bounded)
    fn = @(y) (fractal(xVals(k) + 1i * y) > 0) * 2 - 1;
    % Bisection from y=0 (usually inside) to y=1.5 (outside)
    boundary(k) = bisection(fn, 0, 1.5);
end

%% --------------------------------------------------------------------
% 3. Fit a polynomial of order 15 to the boundary points
% Filter out invalid (NaN) points and trim to the interesting part of the
% fractal, avoiding flat tails on the sides. Then fit a high-order poly.
% --------------------------------------------------------------------
valid = ~isnan(boundary) & xVals >= -2 & xVals <= 0.25;  % hand-tuned range
p = polyfit(xVals(valid), boundary(valid), 15);             % degree 15

% For plotting, evaluate the poly on a finer grid
xFit = linspace(min(xVals(valid)), max(xVals(valid)), 200);
yFit = polyval(p, xFit);

% Plot the data points and the fit to check how well it approximates
figure;
plot(xVals(valid), boundary(valid), 'o', ...
     'MarkerFaceColor', 'b', 'DisplayName', 'Boundary points');
hold on;
plot(xFit, yFit, '-', 'LineWidth', 1.5, 'DisplayName', 'Polynomial fit (order 15)');
xlabel('Real part (x)');
ylabel('Imaginary part (y)');
title('Boundary Approximation along y');
legend('Location', 'best');
grid on;
hold off;

%% --------------------------------------------------------------------
% 4. Compute the arc-length of the fitted polynomial
% Calculate the curve length over the fitted range
% --------------------------------------------------------------------

arcLength = poly_len(p, min(xVals(valid)), max(xVals(valid)));
fprintf('Approximated boundary length: %.4f\n', arcLength);

%% --------------------------------------------------------------------
% 5. Save results
% --------------------------------------------------------------------
save('mandelbrot_results.mat', 'p', 'arcLength');

%=====================================================================
%                     LOCAL FUNCTION DEFINITIONS
%=====================================================================

% ---------------------------------------------------------------------
% 1) Escape-time test for a single complex point
% This function iterates z = z^2 + c up to 100 times. If |z| stays <=2,
% it's considered inside (return 0); else return the iteration count.
% ---------------------------------------------------------------------
function it = fractal(c)
    maxIter = 100;
    z = 0;
    it = 0;
    while abs(z) <= 2 && it < maxIter
        z = z^2 + c;
        it = it + 1;
    end
    if it == maxIter
        it = 0;  % inside the set
    end
end

% ---------------------------------------------------------------------
% 2) Bisection solver
% Finds root of fn_f in [s, e] using bisection. Checks for sign change first
% to avoid invalid intervals. Returns NaN if no sign change or issues.
% ---------------------------------------------------------------------
function m = bisection(fn_f, s, e)
    tol = 1e-6;
    maxIter = 100;
    iter = 0;
    fs = fn_f(s);
    fe = fn_f(e);
    if fs * fe >= 0 || isnan(fs) || isnan(fe)
        m = NaN;  % no boundary in this interval
        return;
    end
    while (e - s) > tol && iter < maxIter
        m = (s + e)/2;
        fm = fn_f(m);
        if abs(fm) < tol
            return;  % good enough
        elseif fm > 0
            e = m;  % narrow to left
        else
            s = m;  % narrow to right
        end
        iter = iter + 1;  % prevent infinite loop
    end
end

% ---------------------------------------------------------------------
% 3) Arc-length of a polynomial
% Computes integral from s to e of sqrt(1 + (dy/dx)^2) dx, where dy/dx
% is the derivative of the poly p. Uses MATLAB's integral for numerics.
% ---------------------------------------------------------------------
function l = poly_len(p, s, e)
    dp = polyder(p);                              % get derivative coeffs
    integrand = @(x) sqrt(1 + polyval(dp, x).^2); % arc length element
    l = integral(integrand, s, e);                % numerical integration
end