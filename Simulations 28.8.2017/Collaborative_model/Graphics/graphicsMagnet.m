% graphicsMagnetic

alt = 400e3;
scale = 10000;


th = [0:0.05:pi];
phi = [-pi:0.05:pi];
th_sl = pi/3*ones(size(phi));
N = length(th)*length(phi)
x = zeros(N,1);
y = x;
z = x;
Bx = x;
By = x;
Bz= x;

k = 1;
for  j = 1:length(phi)
    for i = 1:length(th)
        lat = pi/2 - th(i);
        lon = phi(i);
        x(k)=sin(th(i))*cos(phi(j));
        y(k)=sin(th(i))*sin(phi(j));
        z(k)=cos(th(i));
        [Bx(k), By(k), Bz(k)] = IGRF11(lon, lat, 400e3, 10, 1e-9, 6371, igrf_G, igrf_H, 'ECEF');
        k = k+1;
    end
end

quiver3(x,y,z,Bx*scale,By*scale,Bz*scale);
%streamline(x,y,z,Bx,By,Bz,x_sl,y_sl,z_sl);