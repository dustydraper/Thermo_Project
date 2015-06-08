% Explicit Euler:
%----------------
%
% phinew is phi at new time level
% phinew must be written back to phi for new timestep
%
% Loop over timesteps:
for i = 1 : tsteps

  % Periodic boundary conditions at x=0:
  omeganew(:,1) = omega(:,1)-U0*dt*(omega(:,2)-omega(:,points-1))/(2*dx);
 

  % Loop over grid points in space:
  for j = 2 : points_x - 1

      omeganew(:,j) = omega(:,j)-U0*dt*(omega(:,j+1)-omega(:,j-1))/(2*dx);

  end

  % Periodic boundary conditions at x=2*pi:
  omeganew(:,points_x) = omega(:,points_x)-U0*dt*(omega(:,2)-omega(:,points_x-1))/(2*dx);
 
  % Write new field back to old field:
  omega = omeganew;



  % Plot transported wave for each timestep
  surf(x,y, omega);
  hold off;
  pause(0.003);

end