function [ XX,YY ] = cubic_spline( X,Y,C0,CN,hh )
% CUBIC_SPLINE: Cubic spline interpolation for given data X and Y.
%   
%   INPUT:
%   X: Given X data
%   Y: Given Y data
%   C0: boundary condition (C0 = 0: natural spline)
%   CN: boundary condition (CN = 0: natural spline)
%   hh: Increment for new x and y data
%
%   OUTPUT:
%   XX: New x data
%   YY: New y data
%
% -----------------------------------------------------------------------
%   Created by Joshua Simon. 
%   Date: 02.06.2018
% -----------------------------------------------------------------------


counter = 0;
index = 1;

% Get dimensions
n = max(size(X))-1;

% Calculate distance h
h = zeros(n,1);

for k = 1:n
    h(k) = X(k+1) - X(k);
    % Counting new x values 
    for j = X(k):hh:X(k+1)-hh       
        counter = counter +1;
    end
end

% Berechnung von mueh, lambda und delta
my = zeros(n-1,1);
lambda = zeros(n-1,1);
delta_vor = zeros(n,1);

for k = 1:n-1
    my(k) = h(k) / (h(k+1)+h(k));
    lambda(k) = h(k+1) / ( h(k+1)+h(k));
    delta_vor(k) = 6/(h(k+1)+h(k)) * ((Y(k+2)-Y(k+1))/h(k+1) - (((Y(k+1)-Y(k))/h(k))));
end

delta = [0;delta_vor];
my_mat = [my;0];
lambda_mat = [0;lambda];

% Assemble coefficients matrix S
S = 2*eye(n+1) + diag(my_mat,-1) + diag(lambda_mat,1);

% Solve system of linear equations
M = S\delta;
M(1) = C0;                                      %boundary condition
M(end) = CN;                                    %boundary condition

% Calculating coefficients of cubic spline
a = zeros(n,1);
b = zeros(n,1);
c = zeros(n,1);
d = zeros(n,1);

for k = 1:n
    a(k) = Y(k);
    b(k) = (Y(k+1)-Y(k))/h(k) - (h(k)/6) * (2*M(k)+M(k+1));
    c(k) = M(k)/2;
    d(k) = (M(k+1)-M(k))/(6*h(k));
end

% Cubic spline function
c_Spline = @(x,i) a(i) + b(i).*(x-X(i)) + c(i).*(x-X(i)).^2 + d(i).*(x-X(i)).^3;

XX = zeros(1,counter);
YY = zeros(1,counter);

% Assmeble new x and y data
for k = 1:n
    for j = X(k):hh:X(k+1)-hh
         XX(index) = j;
         YY(index) = c_Spline(j,k);
         index = index + 1;
    end
end

% Set last element of new data
XX = [XX,X(end)];
YY = [YY,c_Spline(X(end),n)];

end
