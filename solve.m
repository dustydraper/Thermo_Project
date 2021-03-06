function [ U, V, PHI,A_vorticity,B_vorticity,OMEGA_N]  = solve( X, Y, boundary, SPEED, geometry )
%SOLVE Summary of this function goes here
%  Matrix is capital, vector is small

[dimY,dimX] = size(X);
index = @(ii,jj) ii + (jj-1)*dimY;


l = geometry.l;
h = geometry.h;

delta_x = l/(dimX-1);
delta_y = h/(dimY-1);

dt = 0.001;
tsteps = 1000;
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
 source = 50;
 OMEGA_N(round(dimY/3),round(dimX/4))=source;
 OMEGA_N(round(dimY/3)+1,round(dimX/4))=source;
 OMEGA_N(round(dimY/3)-1,round(dimX/4))=source;
 OMEGA_N(round(dimY/3),round(dimX/4)+1)=source;
 OMEGA_N(round(dimY/3),round(dimX/4)-1)=source;
 OMEGA_N(round(dimY/3)+1,round(dimX/4)+1)=source;
 OMEGA_N(round(dimY/3)-1,round(dimX/4)-1)=source;
 OMEGA_N(round(dimY/3)-1,round(dimX/4)+1)=source;
 OMEGA_N(round(dimY/3)+1,round(dimX/4)-1)=source;
 
 OMEGA_N(round(2*dimY/3),round(dimX/4))=-source;
 OMEGA_N(round(2*dimY/3)+1,round(dimX/4))=-source;
 OMEGA_N(round(2*dimY/3)-1,round(dimX/4))=-source;
 OMEGA_N(round(2*dimY/3),round(dimX/4)-1)=-source;
 OMEGA_N(round(2*dimY/3),round(dimX/4)+1)=-source;
 OMEGA_N(round(2*dimY/3)+1,round(dimX/4)+1)=-source;
 OMEGA_N(round(2*dimY/3)-1,round(dimX/4)-1)=-source;
 OMEGA_N(round(2*dimY/3)+1,round(dimX/4)-1)=-source;
 OMEGA_N(round(2*dimY/3)-1,round(dimX/4)+1)=-source;


[ PHI, A_stream, B_stream ] = solveStream( X, Y, boundary, SPEED, geometry,OMEGA_N); 

loop = 0;
for  count = 0:dt:1
    
    [U,V] = solveVelocityfromStream( X,PHI, geometry);
    [A_vorticity,B_vorticity] =solveVorticityfromStream(PHI,U,V,SPEED,geometry);
    [OMEGA_N] = timeIntegration(OMEGA_N,A_vorticity,B_vorticity,dt);
    if count < .4
        OMEGA_N(round(dimY/3),round(dimX/4))=source;
        OMEGA_N(round(dimY/3)+1,round(dimX/4))=source;
        OMEGA_N(round(dimY/3)-1,round(dimX/4))=source;
        OMEGA_N(round(dimY/3),round(dimX/4)+1)=source;
        OMEGA_N(round(dimY/3),round(dimX/4)-1)=source;
        OMEGA_N(round(dimY/3)+1,round(dimX/4)+1)=source;
        OMEGA_N(round(dimY/3)-1,round(dimX/4)-1)=source;
        OMEGA_N(round(dimY/3)-1,round(dimX/4)+1)=source;
        OMEGA_N(round(dimY/3)+1,round(dimX/4)-1)=source;
        
        OMEGA_N(round(2*dimY/3),round(dimX/4))=-source;
        OMEGA_N(round(2*dimY/3)+1,round(dimX/4))=-source;
        OMEGA_N(round(2*dimY/3)-1,round(dimX/4))=-source;
        OMEGA_N(round(2*dimY/3),round(dimX/4)-1)=-source;
        OMEGA_N(round(2*dimY/3),round(dimX/4)+1)=-source;
        OMEGA_N(round(2*dimY/3)+1,round(dimX/4)+1)=-source;
        OMEGA_N(round(2*dimY/3)-1,round(dimX/4)-1)=-source;
        OMEGA_N(round(2*dimY/3)+1,round(dimX/4)-1)=-source;
        OMEGA_N(round(2*dimY/3)-1,round(dimX/4)+1)=-source;
    end
    [PHI,B_vorticity] = solveStreamfromVorticity(OMEGA_N,geometry,A_stream, B_stream);
    
if rem(loop,10) == 0    

    pcolor(X,Y,OMEGA_N);
    title(count);
    drawnow;
    filename = 'pouisselle_10000.gif';
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    frame = getframe(gcf);
    im = frame2im(frame);
    [imind,cm]= rgb2ind(im,8);
    if loop==0
        imwrite(imind,cm,filename,'gif','Loopcount',inf);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append','Delaytime',0);
    end
end
    loop =loop +1;
    
end




end

