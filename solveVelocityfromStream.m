function [U,V] = solveVelocityfromStream( X, Y, PHI, boundary, SPEED, geometry)
% Back Solving the velocities from the stream function

[dimY,dimX] = size(X);
V= zeros(dimY,dimX);
U= zeros(dimY,dimX);
index = @(ii,jj) ii + (jj-1)*dimY;

l = geometry.l;
h = geometry.h;

delta_x = l/(dimX-1);
delta_y = h/(dimY-1);

for ii = 1:dimY
    % Middle points
        for jj = 1:dimX
            if(jj==1)
                V(ii,jj) = -(PHI(ii,jj+1)-PHI(ii,jj)) / delta_x;
                
            elseif(jj==dimX)
                V(ii,jj) = -(-PHI(ii,jj-1)+PHI(ii,jj)) / delta_x;
            else
            
            V(ii,jj) = -(-PHI(ii,jj-1)+PHI(ii,jj+1))/ (2*delta_x);
           
            end
        end
end

for ii = 1:dimY
    % Middle points
        for jj = 1:dimX
            if(ii==1)
                U(ii,jj) = -(-PHI(ii,jj)+PHI(ii+1,jj)) / delta_y;
                
            elseif(ii==dimY)
                U(ii,jj) = -(-PHI(ii-1,jj)+PHI(ii,jj)) / delta_y;
            else
            
                U(ii,jj) = -(-PHI(ii-1,jj)+PHI(ii+1,jj))/ (2*delta_y);
           
            end
        end
end

end

