function [ U, V, PHI,A_vorticity,A_stream,B_vorticity,B_stream,OMEGA_N]  = solve( X, Y, boundary, SPEED, geometry )
%SOLVE Summary of this function goes here
%  Matrix is capital, vector is small

[dimY,dimX] = size(X);
index = @(ii,jj) ii + (jj-1)*dimY;

U = zeros(dimY,dimX);
V = zeros(dimY,dimX);

dt = 0.0001;
tsteps = 100;
tend = tsteps*dt;
OMEGA_N = zeros(dimX,dimY);

[ PHI,A_stream,B_stream ] = solveStream( X, Y, boundary, SPEED, geometry); % works properly

for  count = 0:dt:tend
    
    [U,V] = solveVelocityfromStream( X, Y, PHI, boundary, SPEED, geometry); 
    pcolor(U)
    pause(.1);
    [OMEGA,A_vorticity,B_vorticity] =solveVorticityfromStream(PHI,U,V,SPEED,geometry);
    
    [OMEGA_N] = timeIntegration(OMEGA,A_vorticity,B_vorticity);
    
    [PHI,B_vorticity] = solveStreamfromVorticity(OMEGA_N,U,V,geometry,SPEED,A_stream, B_stream);

end


end

