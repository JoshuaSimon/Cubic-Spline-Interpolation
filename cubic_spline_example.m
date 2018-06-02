% cubic_spline_example
% -----------------------------------------------------------------------
% Interpolate given data with a natural cubic spline.
%
% Created by Joshua Simon.
% Date: 02.06.2018
% -----------------------------------------------------------------------

% Data
X = [-2, -1, 1, 3, 4, 5];
Y = [2, 1, 3, 1, 0, 2];

% Interpolation
[XX,YY] = cubic_spline(X,Y,0,0,0.1);

% Plot
figure
plot(X,Y,'o',X,Y,'b--',XX,YY,'r')
legend('Data','Polygon','Cubic Spline')





