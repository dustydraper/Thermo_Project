function [ PHI ] = solveStream( X, Y, boundary, SPEED, geometry)


%SOLVESTREAM Solves the continuity equation in terms of the streamline
[dimY,dimX] = size(X);
index = @(ii,jj) ii + (jj-1)*dimY;

l = geometry.l;
h = geometry.h;

delta_x = l/(dimX-1);
delta_y = h/(dimY-1);

B = zeros(dimY,dimX);
A = zeros(dimY*dimX);
PHI = zeros(dimY,dimX);

% Filling B

for i =1:dimY
    if(i==1)
        for j=1:dimX
            STREAM.north = SPEED.west.y*X(i,j) + SPEED.west.x*h + SPEED.west.x + SPEED.west.y;
            B(i,j)= STREAM.north;
        end
    elseif(i==dimY)
        for j=1:dimX
            STREAM.south = SPEED.west.y*X(i,j) + SPEED.west.x + SPEED.west.y;
            B(i,j)= STREAM.south;
        end
    end
end

for j =1:dimX
    if(j==1)
        for i=2:dimY-1
            STREAM.west =  SPEED.west.x*Y(i,j) + SPEED.west.x + SPEED.west.y;
            B(i,j)= STREAM.west;
        end
    elseif(j==dimX)
        for i=2:dimY-1
            STREAM.east = 0;
            B(i,j)= STREAM.east;
        end
    end
end


% Filling the A matrix

for ii = 1:dimY
    if ii == 1 % North Part
        for jj = 2:dimX
            A(index(ii,jj),index(ii,jj)) = 1;
        end
    elseif ii == dimX % South Part
        
        for jj = 1:(dimY-1)
            A(index(ii,jj),index(ii,jj)) = 1;
        end
        
    else % Middle points
        for jj = 2:(dimX-1)
            A(index(ii,jj),index(ii,jj)) = -2/(delta_x^2)-2/(delta_y^2);
            A(index(ii,jj),index(ii,jj) - 1) = 1/(delta_x^2);
            A(index(ii,jj),index(ii,jj) + 1) = 1/(delta_x^2);
            A(index(ii,jj),index(ii,jj) - dimX) = 1/(delta_y^2);
            A(index(ii,jj),index(ii,jj) + dimX) = 1/(delta_y^2);
        end
    end
end

for jj = 1:dimX
    if jj == 1 % West Part
        for ii = 1:(dimY-1)
            A(index(ii,jj),index(ii,jj)) = 1;
        end
    elseif jj == dimX % East Part
        
        for ii = 2:(dimY)
            A(index(ii,jj),index(ii,jj)) = 1/(delta_x^2);
            A(index(ii,jj),index(ii,jj) - 1) = -2/(delta_x^2);
            A(index(ii,jj),index(ii,jj) - 2) = 1/(delta_x^2);
        end
    end
end

PHI(:) = A\B(:);

end






