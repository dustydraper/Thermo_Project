%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define the parameters of the simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Geometry

geometry.h = 1;
geometry.l = 1;
    
% Number of degrees of freedom (number of nodes per length)

dimX = 30;
dimY = 30;

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


% Fluidparameters

nu = 1; % Water at 20 ?C, in mPa*s




