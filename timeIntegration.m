function [OMEGA_N] = timeIntegration(OMEGA,A,b)
dt = 0.01;
tsteps = 1000;
tend = tsteps*dt;
[dimY,dimX] = size(OMEGA);
OMEGA_N = zeros(dimX,dimY);
    for count = 1:dt:tend
        OMEGA_N(:) = OMEGA(:) + dt*(A * OMEGA(:) - b(:));
        pcolor(OMEGA_N)
        pause(0.03)
        OMEGA = OMEGA_N;
        count
    end
end