%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the parameters of the simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Geometry

geometry.h = 4;
geometry.l = 8;
%geometry.flow = 'const'; 
    
geometry.flow = 'poiseuille';

% Number of degrees of freedom (number of nodes per length)

dimX = 30;
dimY = 30;

dy = geometry.h/(dimY-1);

% Boundary conditions (Only Dirichlet applied in Session 03) 

boundary.south = 'Dirichlet';
boundary.north = 'Dirichlet';
boundary.east = 'Dirichlet';
boundary.west = 'Dirichlet';

% Values for Dirichlet BC

SPEED.north.x = 0;
SPEED.north.y = 0;

SPEED.east.x = 10;
SPEED.east.y = 0;

SPEED.south.x = 0;
SPEED.south.y = 0;

SPEED.west.x = 10;
SPEED.west.y = 0;
%pousielle flow
SPEED.west.p = zeros(dimY,1);
for i=0:dimY-1
    y = dy*i;
    SPEED.west.p(i+1)= -(y-geometry.h)*(y)*4*SPEED.west.x/(geometry.h^2);
end
% Fluidparameters

nu = 0; % Water at 20 ?C, in mPa*s




