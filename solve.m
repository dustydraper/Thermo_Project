function [ U, V, PHI] = solve( X, Y, boundary, SPEED, geometry )
%SOLVE Summary of this function goes here
%  Matrix is capital, vector is small

[dimY,dimX] = size(X);
index = @(ii,jj) ii + (jj-1)*dimY;

U = zeros(dimY,dimX);
V = zeros(dimY,dimX);

[ PHI ] = solveStream( X, Y, boundary, SPEED, geometry);


end

