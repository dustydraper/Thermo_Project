% Set convection velocity
U0 = 1.0;

% Discrete spacing in space
xend   = 15;
points_x = 40; 
dx     = xend / ( points_x - 1 );

yend   = 1.75 * pi;
points_y = 40; 
dy     = yend / ( points_y - 1 );

x = 0.0 : dx : xend;
y = 0.0 : dy : yend;
% Discrete spacing in time
% tstep = number of discrete timesteps
tsteps = 1000;
dt     = 0.1;
tend   = dt * tsteps;

% Initialise the solution (initial condition)
% Loop over grid points in space:
omega = zeros(points_x,points_y);

omega(:,1) = sin(y);


% Check initial field:
surf(x,y,omega);
hold on;
pause(3);
