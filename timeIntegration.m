function [OMEGA_N] = timeIntegration(OMEGA,A,b)
dt = 0.001;
[dimY,dimX] = size(OMEGA);
OMEGA_N = zeros(dimX,dimY);
OMEGA_N(:) = OMEGA(:) + dt*(A * OMEGA(:) - b(:));

end