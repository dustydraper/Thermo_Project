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

[ U, V, PHI,A_vort,A_stream,B_vort,B_stream,OMEGA] = solve( X, Y, boundary, SPEED, geometry );
