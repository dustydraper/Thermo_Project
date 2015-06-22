function [OMEGA,A,B] = solveVorticityfromStream(PHI,U,V,SPEED,geometry)
%WE MUST SOLVE VORTICTY EQN 

%RIGHT NOW WE ARE JUST FILLING BOUNDARY CONDITIONS
[dimY,dimX] = size(PHI);
index = @(ii,jj) ii + (jj-1)*dimY;

l = geometry.l;
h = geometry.h;

delta_x = l/(dimX-1);
delta_y = h/(dimY-1);

B = zeros(dimY,dimX);
A = zeros(dimY*dimX);
OMEGA = zeros(dimY,dimX);

% Filling B
% NORTH
for i =1:dimY
    if(i==1)
        for j=1:dimX
             B(i,j)= 4 * (PHI(i+1,j) - PHI(i,j) )/(delta_y^2);
        end
    elseif(i==dimY)
        %SOUTH
        for j=1:dimX
             B(i,j)= 4 * (PHI(i,j) - PHI(i-1,j) )/(delta_y^2);
        end
    end
end

for j =1:dimX
    if(j==1)
        %WEST
        for i=2:dimY-1
             dudy = (U(i,j+1)-U(i,j))/delta_y;
             B(i,j)= 4 * (PHI(i,j) - PHI(i,j+1) )/(delta_x^2) -(12 *SPEED.west.y*delta_x) - 2*dudy;
        end
    elseif(j==dimX)
        %EAST
        for i=2:dimY-1
             B(i,j) = 0;

        end
    end
end

for ii = 2:(dimY-1)
    for jj = 2:(dimX-1)
        B(ii,jj) = -2*(1/delta_x^2 + 1/delta_y^2);
        B(ii,jj-1) = 1/delta_x^2;
        B(ii,jj+1) = 1/delta_x^2;
        B(ii+1,jj) = 1/delta_y^2;
        B(ii-1,jj) = 1/delta_y^2;
    end
end


% Filling the A matrix

for ii = 1:dimY
    if ii == 1 % North Part
        for jj = 2:dimX
            A(index(ii,jj),index(ii,jj)) = 1;
            A(index(ii,jj),index(ii+1,jj)) = 4/3;
            A(index(ii,jj),index(ii+2,jj)) = -1/3;
        end
    elseif ii == dimX % South Part
        
        for jj = 1:(dimY)
            A(index(ii,jj),index(ii,jj)) = 1;
            A(index(ii,jj),index(ii-1,jj)) = 4/3;
            A(index(ii,jj),index(ii-2,jj)) = -1/3;
        end
        
    else % Middle points
        for jj = 2:(dimX-1)
            
            A(index(ii,jj),index(ii,jj)) = 1;

        end
    end
end

for jj = 1:dimX
    if jj == 1 % West Part (INLET) signs?
        for ii = 1:(dimY-1)
            A(index(ii,jj),index(ii,jj)) = 1;
            A(index(ii,jj),index(ii,jj+1)) = -4/3;
            A(index(ii,jj),index(ii,jj+2)) = 1/3;
        end
    elseif jj == dimX % East Part
        
        for ii = 2:(dimY-1)
            A(index(ii,jj),index(ii,jj)) = 1;
            A(index(ii,jj),index(ii,jj-1)) = -4/3;
            A(index(ii,jj),index(ii,jj-2)) = 1/3;
        end
    end
end

OMEGA(:) = A\B(:);


end
