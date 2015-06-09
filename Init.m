
% Create mesh (2D MESH)
dimX = 20;                  % Number of nodes in x
dimY = 20;                  % Number of nodes in y
source = 0;
% Defining Boundary conditions

% Type
boundary.south = 'Dirichlet';
boundary.north = 'Dirichlet';
boundary.east  = 'Dirichlet';
boundary.west  = 'Dirichlet';

% Value for Dirichlet BC
VNorth = 10;
VSouth= 10;
VWest= 10;
VEast=10;
% ii gives the row, jj gives the column
l=15;
h=2.0*pi;
n = 50;
index = @(ii,jj) ii + (jj-1)*n;

delta_x = l/(n-1);
delta_y = h/(n-1);      % this is for the case of a rectangular and uniform mesh

x_vector = 0:delta_x:l;
y_vector = linspace(h,0,n);

[x_grid,y_grid] = meshgrid(x_vector,y_vector);


%-----------------------------------------------------------------------
% Defining the Constants

Gamma= 0.1;
U0 = 50.0;
dt=0.1;
tsteps = 500;

%-----------------------------------------------------------------------
% Defining Boundary conditions

b = zeros(n,n);

for ii = 1:n
    if ii == 1  % Construct north part
        switch boundary.north
            case 'Dirichlet'
                for jj = 2:(n)
                    b(index(ii,jj)) = VNorth;
                end
        end
    elseif ii == n  % Construct south part
        switch boundary.south
            case 'Dirichlet'
                for jj = 1:(n-1)
                    b(index(ii,jj)) = VSouth;
                end
            case 'Neumann'
                for jj = 1:(n-1)
                    b(index(ii,jj)) = beta;
                end
        end
    else
        for jj = 2:(n-1)
            b(index(ii,jj)) = source;
        end
    end
end

for jj = 1:n
    if jj == 1  % Construct west part
        switch boundary.west
            case 'Dirichlet'
                for ii = 1:(n-1)
                    b(index(ii,jj)) = VWest;
                end
        end
    elseif jj == n  %Construct east part
        switch boundary.east
            case 'Dirichlet'
                for ii = 2:(n)
                    b(index(ii,jj)) = VEast;
                end

        end
    end
end

%------------------------------------------------------------------------
% Constructing Matrix A;

A = zeros(n*n);

     a_e = (U0/(2*delta_x) - Gamma/(delta_x^2));
     a_p = 2*Gamma/(delta_x^2)+2*Gamma/(delta_y^2);
     a_w = -(U0/(2*delta_x) + Gamma/(delta_x^2));
     a_n = (U0/(2*delta_y) - Gamma/(delta_y^2));
     a_s = -(U0/(2*delta_y) + Gamma/(delta_y^2));
     
for ii = 1:n
    if ii == 1 % North Part
        switch boundary.north
            case 'Dirichlet'
                for jj = 2:n
                    A(index(ii,jj),index(ii,jj)) = 1;
                end
        end
    elseif ii == n % South Part
        switch boundary.south
            case 'Dirichlet'
                for jj = 1:(n-1)
                    A(index(ii,jj),index(ii,jj)) = 1;
                end
            case 'Neumann'
                for jj = 1:(n-1)
                    A(index(ii,jj),index(ii,jj)) = -Kval*(3/(2*delta_y));
                    A(index(ii,jj),index(ii,jj)-1) = Kval*4/(2*delta_y);
                    A(index(ii,jj),index(ii,jj)-2) = -Kval/(2*delta_y);
                end
        end
    else % Middle points
        for jj = 2:(n-1)
            A(index(ii,jj),index(ii,jj))     = a_p;
            A(index(ii,jj),index(ii,jj) - 1) = a_w;
            A(index(ii,jj),index(ii,jj) + 1) = a_e;
            A(index(ii,jj),index(ii,jj) - n) = a_s;
            A(index(ii,jj),index(ii,jj) + n) = a_n;
        end
    end
end

for jj = 1:n
    if jj == 1 % West Part (only Dirichlet)
        for ii = 1:(n-1)
            A(index(ii,jj),index(ii,jj)) = 1;
        end
    elseif jj == n % East Part
        switch boundary.east
            case 'Dirichlet'
                for ii = 2:(n)
                    A(index(ii,jj),index(ii,jj)) = 1;
                end
            case 'Robin'
                for ii = 2:(n)
                    A(index(ii,jj),index(ii,jj)) = (alpha + (Kval*3/2)/delta_x);
                    A(index(ii,jj),index(ii,jj)-n) = -Kval*(4/(2*delta_x));
                    A(index(ii,jj),index(ii,jj)-2*n) = Kval/(2*delta_x);
                end
        end
    end
end
omega = zeros(n);
omega(:,1)=sin(y_vector)+1;
% Check initial field:
surf(x_vector,y_vector,omega);
hold on;
pause(.5);
