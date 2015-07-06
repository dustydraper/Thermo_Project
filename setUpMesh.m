function [ X, Y ] = setUpMesh( dimX, dimY, geometry )
%SETUPMESH 
%   Set up the mesh
l = geometry.l;
h = geometry.h;

x = linspace(0,l,dimX);

y = linspace(h/2,-h/2,dimY);

[X,Y] = meshgrid(x,y);

end

