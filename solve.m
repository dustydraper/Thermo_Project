% Explicit Euler:
%----------------
%
% phinew is phi at new time level
% phinew must be written back to phi for new timestep
%
% Loop over timesteps:
for i = 1 : tsteps
    
omega(:) = omega(:) + dt*A*omega(:) - dt*b(:);

  % Plot transported wave for each timestep
  surf(x_vector,y_vector, omega);
  hold off;
  pause(0.001);

end