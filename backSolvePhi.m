function [ PHI, A, B ] = backSolvePhi( U, V,X,Y, OMEGA, geometry)

[dimY,dimX] = size(OMEGA);
index = @(ii,jj) ii + (jj-1)*dimY;

l = geometry.l;
h = geometry.h;

delta_x = l/(dimX-1);
delta_y = h/(dimY-1);


U_new = zeros(dimY,dimX);
V_new = zeros(dimY,dimX);
B = zeros(dimY,dimX);
A = zeros(dimY*dimX);
PHI = zeros(dimY,dimX);


%make new U and V
% U
for i =1:dimY
    if(i==1) %NORTH
        for j=1:dimX
            U_new(i,j) = U(i,j);
        end
    elseif(i==dimY) %SOUTH
        for j=1:dimX
             U_new(i,j) = U(i,j);
        end
    end
end
for j =1:dimX
    if(j==1) %WEST
        for i=2:dimY-1
            U_new(i,j) =(OMEGA(i,j) + (V(i,j)-V(i,j+1))/delta_x )*X(i,j);
        end
    elseif(j==dimX) %EAST
        for i=2:dimY-1
            U_new(i,j) = (OMEGA(i,j) + (V(i,j-1)-V(i,j))/delta_x )*X(i,j);
        end
    end
end
for i =2:dimY-1
    for j =2:dimX-1
         U_new(i,j) = (OMEGA(i,j) + (V(i,j-1)-V(i,j+1))/(2*delta_x) )*X(i,j);
    end
end

% V
for i =1:dimY
    if(i==1) %NORTH
        for j=1:dimX
            V_new(i,j) = V(i,j);
        end
    elseif(i==dimY) %SOUTH
        for j=1:dimX
             V_new(i,j) = V(i,j);
        end
    end
end

for i =2:dimY-1
    for j =1:dimX
         V_new(i,j) = - (OMEGA(i,j) + (U(i-1,j)-U(i+1,j))/(2*delta_y) )*Y(i,j);
    end
end

% Filling B

for i =1:dimY
    if(i==1) %NORTH
        for j=1:dimX
            STREAM.north = SPEED.west.y*X(i,j) + SPEED.west.x*h + SPEED.west.x + SPEED.west.y;
            B(i,j)= STREAM.north;
        end
    elseif(i==dimY) %SOUTH
        for j=1:dimX
            STREAM.south = SPEED.west.y*X(i,j) + SPEED.west.x + SPEED.west.y;
            B(i,j)= STREAM.south;
        end
    end
end

for j =1:dimX
    if(j==1) %WEST
        for i=2:dimY-1
            STREAM.west =  SPEED.west.x*Y(i,j) + SPEED.west.x + SPEED.west.y;
            B(i,j)= STREAM.west;
        end
    elseif(j==dimX) %EAST
        for i=2:dimY-1
            
%             STREAM.east = SPEED.east.x*Y(i,j) + SPEED.east.x + SPEED.east.y;
%             B(i,j)= STREAM.east;
        end
    end
end
%middle

for i =2:dimY-1
    for j =2:dimX-1
        
    end
end


% Filling the A matrix
for ii = 1:dimY
    if ii == 1 % North Part
        for jj = 1:dimX
            A(index(ii,jj),index(ii,jj)) = 1;
        end
    elseif ii == dimY % South Part
        
        for jj = 1:dimX
            A(index(ii,jj),index(ii,jj)) = 1;
        end
        
    else % Middle points
        for jj = 2:(dimX-1)
            
            A(index(ii,jj),index(ii,jj)) = -2/(delta_x^2)-2/(delta_y^2);
            A(index(ii,jj),index(ii - 1,jj) ) = 1/(delta_y^2);
            A(index(ii,jj),index(ii + 1,jj) ) = 1/(delta_y^2);
            A(index(ii,jj),index(ii,jj+1) ) = 1/(delta_x^2);
            A(index(ii,jj),index(ii,jj-1) ) = 1/(delta_x^2);

        end
    end
end

for jj = 1:dimX
    if jj == 1 % West Part
        for ii = 1:(dimY-1)
            A(index(ii,jj),index(ii,jj)) = 1;
        end
    elseif jj == dimX % East Part
        
        for ii = 2:(dimY-1)
            A(index(ii,jj),index(ii,jj)) = 1/(delta_x^2);
            A(index(ii,jj),index(ii,jj-1)) = -2/(delta_x^2);
            A(index(ii,jj),index(ii,jj-2)) = 1/(delta_x^2);
        end
    end
end

PHI(:) = A\B;

end
