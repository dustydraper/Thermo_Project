function [ U, V, PHI,A_vorticity,B_vorticity,OMEGA_N]  = solve( X, Y, boundary, SPEED, geometry )
%SOLVE Summary of this function goes here
%  Matrix is capital, vector is small

[dimY,dimX] = size(X);
index = @(ii,jj) ii + (jj-1)*dimY;


l = geometry.l;
h = geometry.h;

delta_x = l/(dimX-1);
delta_y = h/(dimY-1);

dt = 0.0001;
tsteps = 10;
tend = tsteps*dt;
switch geometry.flow
    case 'const'
        U = zeros(dimY,dimX);
        V = zeros(dimY,dimX);
        OMEGA_N = zeros(dimY,dimX);
    case 'poiseuille'
        U = zeros(dimY,dimX);
        V = zeros(dimY,dimX);
        for j=1:dimX
            U(:,j) = SPEED.west.p;
        end
        
        
        for i=1:dimY
            for j=1:dimX
                if(i==1) %North
                    OMEGA_N(i,j) = -(U(i+1,j)-U(i,j) )/delta_y;
                elseif(i==dimY)%South
                    OMEGA_N(i,j) = -(U(i,j)-U(i-1,j) )/delta_y;
                elseif(i>1 && i<dimY) %internal
                    OMEGA_N(i,j) = -(U(i+1,j)-U(i-1,j) )/(2*delta_y);
                end
            end
        end
end

 %add source
 OMEGA_N(round(dimY/3),round(dimX/4))=1;
 OMEGA_N(round(2*dimY/3),round(dimX/4))=-1;


[ PHI, A_stream, B_stream ] = solveStream( X, Y, boundary, SPEED, geometry,OMEGA_N); % works properly

% This part is included so that the boundary velocities always stay the
% same. Here, they are initialised and remain untouched throughout the
% solveVelocityfromStream

% for ii = 1:dimY
%     for jj = 1:dimX
%         if(ii==1)
%
%             U(ii,jj) = -(-PHI(ii,jj)+PHI(ii+1,jj)) / delta_y;
% %             U(ii,jj) = 0;
%         elseif(ii==dimY)
%             U(ii,jj) = -(-PHI(ii-1,jj)+PHI(ii,jj)) / delta_y;
% %             U(ii,jj) = 0;
%         end
%     end
% end
%
% for ii = 1:dimY
%     for jj = 1:dimX
%         if(jj==1)
%             V(ii,jj) = -(PHI(ii,jj+1)-PHI(ii,jj)) / delta_x;
%
%         elseif(jj==dimX)
%             V(ii,jj) = -(-PHI(ii,jj-1)+PHI(ii,jj)) / delta_x;
%         end
%     end
% end

loop = 0;
for  count = 0:dt:tend
    
    [U,V] = solveVelocityfromStream( X,PHI, geometry);
    [A_vorticity,B_vorticity] =solveVorticityfromStream(PHI,U,V,SPEED,geometry);
    [OMEGA_N] = timeIntegration(OMEGA_N,A_vorticity,B_vorticity,dt);
    [PHI,B_vorticity] = solveStreamfromVorticity(OMEGA_N,geometry,A_stream, B_stream);
    
    
    subplot(3,2,1)
    pcolor(X,Y,U);
    shading interp;
    
    subplot(3,2,2)
    contour(X,Y,U);
    
    subplot(3,2,3)
    pcolor(X,Y,OMEGA_N);
    shading interp;
    
    subplot(3,2,4)
    contour(X,Y,OMEGA_N);
    
    subplot(3,2,5)
    contour(X,Y,PHI);
    shading interp;
    
    
    
    
    
    drawnow;
    filename = 'Vorticity.gif';
    frame = getframe(gcf);
    im = frame2im(frame);
    [imind,cm]= rgb2ind(im,8);
    if loop==0
        imwrite(imind,cm,filename,'gif','Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append','Delaytime',0);
    end
    
    loop =loop +1;
    
end




end

