clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   The main function is used to solve the complete problem.
%   vorticity equation = 
%   D(omega)/Dt = v*grad(omega) = (omega*grad)v + nu*laplace(omega)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Init

[ X, Y ] = setUpMesh( dimX, dimY, geometry );

[ U, V, PHI,A,B,OMEGA] = solve( X, Y, boundary, SPEED, geometry );
