    function [PHI,B] = solveStreamfromVorticity(OMEGA,geometry,A,B)
[dimY,dimX] = size(OMEGA);
index = @(ii,jj) ii + (jj-1)*dimY;

l = geometry.l;
h = geometry.h;

delta_x = l/(dimX-1);
delta_y = h/(dimY-1);

PHI = zeros(dimY,dimX);

% Filling B
% Center

for ii = 2:(dimY-1)
    for jj = 2:(dimX-1)
        B(ii,jj)=OMEGA(ii,jj);
    end
end


% Filling the A matrix

for ii = 2:(dimY-1)
    for jj = 2:(dimX-1)
        %now using E-W and N-S
        A(index(ii,jj),index(ii,jj))   = -2/delta_x^2 - 2/delta_y^2 ;
        A(index(ii,jj),index(ii - 1,jj) ) = 1/(delta_y^2);
        A(index(ii,jj),index(ii + 1,jj) ) = 1/(delta_y^2);
        A(index(ii,jj),index(ii,jj+1) ) = 1/(delta_x^2);
        A(index(ii,jj),index(ii,jj-1) ) = 1/(delta_x^2);
        
    end
end



PHI(:) = A\B(:);
end