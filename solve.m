function [ U, V, PHI,A_vorticity,B_vorticity,OMEGA_N]  = solve( X, Y, boundary, SPEED, geometry )
%SOLVE Summary of this function goes here
%  Matrix is capital, vector is small

[dimY,dimX] = size(X);
index = @(ii,jj) ii + (jj-1)*dimY;

U = zeros(dimY,dimX);
V = zeros(dimY,dimX);

l = geometry.l;
h = geometry.h;

delta_x = l/(dimX-1);
delta_y = h/(dimY-1);

dt = 0.0001;
tsteps = 100;
tend = tsteps*dt;
OMEGA = zeros(dimY,dimX);
OMEGA_N = zeros(dimY,dimX);

[ PHI, A_stream, B_stream ] = solveStream( X, Y, boundary, SPEED, geometry); % works properly

% This part is included so that the boundary velocities always stay the
% same. Here, they are initialised and remain untouched throughout the
% solveVelocityfromStream
for ii = 1:dimY
    for jj = 1:dimX
        if(ii==1)
            
%            U(ii,jj) = -(-PHI(ii,jj)+PHI(ii+1,jj)) / delta_y;
            U(ii,jj) = 0;
        elseif(ii==dimY)
%            U(ii,jj) = -(-PHI(ii-1,jj)+PHI(ii,jj)) / delta_y;
            U(ii,jj) = 0;
        end
    end
end

for ii = 1:dimY
    for jj = 1:dimX
        if(jj==1)
            V(ii,jj) = -(PHI(ii,jj+1)-PHI(ii,jj)) / delta_x;
            
        elseif(jj==dimX)
            V(ii,jj) = -(-PHI(ii,jj-1)+PHI(ii,jj)) / delta_x;
        end
    end
end

for  count = 0:dt:tend
    
    [U,V] = solveVelocityfromStream( X,PHI, geometry,U,V);
%     figure(1)
%     contour(U);
%     pause(.01);
    [A_vorticity,B_vorticity] =solveVorticityfromStream(PHI,U,V,SPEED,geometry);
    [OMEGA_N] = timeIntegration(OMEGA_N,A_vorticity,B_vorticity,dt);
%     [ PHI, A, B ] = backSolvePhi( U, V,X,Y, OMEGA_N, geometry);
    [PHI,B_vorticity] = solveStreamfromVorticity(OMEGA_N,geometry,A_stream, B_stream);
end



end

