function [OMEGA] = timeIntegration(OMEGA,A,b,dt)
[dimY,dimX] = size(OMEGA);
OMEGA_N = zeros(dimY,dimX);
OMEGA_N(:) = OMEGA(:) + dt*(A * OMEGA(:) - b(:));
OMEGA = OMEGA_N;

end