function [A,B] = solveVorticityfromStream(PHI,U,V,SPEED,geometry)
%WE MUST SOLVE VORTICTY EQN 
nu =1.0;
[dimY,dimX] = size(PHI);
index = @(ii,jj) ii + (jj-1)*dimY;

l = geometry.l;
h = geometry.h;

delta_x = l/(dimX-1);
delta_y = h/(dimY-1);

B = zeros(dimY,dimX);
A = zeros(dimY*dimX);
%OMEGA = zeros(dimY,dimX);

% Filling B

for i =1:dimY
    if(i==1) % NORTH
        for j=1:dimX
             B(i,j)= (PHI(i+1,j)-PHI(i,j))/(delta_y^2)-U(i,j)/delta_y;
        end
    elseif(i==dimY)
        %SOUTH
        for j=1:dimX
             B(i,j)= (PHI(i-1,j)-PHI(i,j))/(delta_y^2)+U(i,j)/delta_y;
        end
    end
end

for j =1:dimX
    if(j==1)
        %WEST
        for i=2:dimY-1
             dudy = (U(i+1,j)-U(i-1,j))/(2*delta_y);
             B(i,j)= (PHI(i,j+1)-PHI(i,j))/(delta_x^2) + V(i,j)/delta_x + (1/2)*dudy;
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
%         B(ii,jj) = -2*(1/delta_x^2 + 1/delta_y^2);
%         B(ii,jj-1) = 1/delta_x^2;
%         B(ii,jj+1) = 1/delta_x^2;
%         B(ii+1,jj) = 1/delta_y^2;
%         B(ii-1,jj) = 1/delta_y^2;
          B(ii,jj)= 0;
    end
end


% Filling the A matrix

for ii = 1:dimY
    if ii == 1 % North Part
        for jj = 1:dimX
            A(index(ii,jj),index(ii,jj)) = 1/3;
            A(index(ii,jj),index(ii+1,jj)) = 1/6;
            %A(index(ii,jj),index(ii+2,jj)) = -1/12;
        end
    elseif ii == dimY % South Part
        
        for jj = 1:(dimX)   % Watch out with the signs here, because you use a backward scheme, you cannot use the exact same formula as in the book (2.16)
                            % This only works for the forward scheme.
            A(index(ii,jj),index(ii,jj)) = -2/3;
            A(index(ii,jj),index(ii-1,jj)) = 1/6;
           % A(index(ii,jj),index(ii-2,jj)) =    1/12;
        end
        
    else % Middle points
        for jj = 2:(dimX-1)
            %now using E-W and N-S
            A(index(ii,jj),index(ii,jj))   =  2*nu*(1/delta_x^2 +1/delta_y^2);
            A(index(ii,jj),index(ii,jj-1)) = - U(ii,jj)/(2*delta_x) -  nu*(1/delta_x^2);
            A(index(ii,jj),index(ii,jj+1)) =   U(ii,jj)/(2*delta_x) -  nu*(1/delta_x^2);
            A(index(ii,jj),index(ii-1,jj)) =  -V(ii,jj)/(2*delta_y)  - nu*(1/delta_y^2);
            A(index(ii,jj),index(ii+1,jj)) =   V(ii,jj)/(2*delta_y) -  nu*(1/delta_y^2);

        end
    end
end

for jj = 1:dimX
    if jj == 1 % West Part (INLET) signs?
        for ii = 2:(dimY-1)
            A(index(ii,jj),index(ii,jj)) = 1/3;
            A(index(ii,jj),index(ii,jj+1)) = 1/6;
            %A(index(ii,jj),index(ii,jj+2)) = -1/12;
        end
    elseif jj == dimX % East Part
        
        for ii = 2:(dimY-1)
            A(index(ii,jj),index(ii,jj)) = 1;
            A(index(ii,jj),index(ii,jj-1)) = -1;
            %A(index(ii,jj),index(ii,jj-2)) = 1/3;
        end
    end
end

end
