function [ U, V, PHI, A,B,OMEGA] = solve( X, Y, boundary, SPEED, geometry )
%SOLVE Summary of this function goes here
%  Matrix is capital, vector is small

[dimY,dimX] = size(X);
index = @(ii,jj) ii + (jj-1)*dimY;

U = zeros(dimY,dimX);
V = zeros(dimY,dimX);

[ PHI,A,B ] = solveStream( X, Y, boundary, SPEED, geometry);

[U,V] = solveVelocityfromStream( X, Y, PHI, boundary, SPEED, geometry);

[OMEGA,A,b] =solveVorticityfromStream(PHI,U,V,SPEED,geometry);

[OMEGA_N] = timeIntegration(OMEGA,A,b);

end

