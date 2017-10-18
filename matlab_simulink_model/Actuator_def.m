%defines parameters for magtroquer actuators. based on those from clyde
%space.

%these parameters are used to calculate the current required to propduce a
%mag dipole. m=n*A*i. where m is the dipole, n is the number of turns in
%the coil, A is the area and i is the current. the product n*A is needed to
%relate m to i.

%clyde's Magtorquers have a max dipole of 0.06 Am^2 for a single 1U panel.
%Eirsat has 4 1U panels on each of its long faces and 2 on the smaller end
%faces.

%the max current which can be supplied to each dipole is 0.5 amps.

%the produce n*A can be found by dividing the max dipole by the max current

nAx=0.06*4/0.5;
nAy=0.06*4/0.5;
nAz=0.06*2/0.5;
nA=[nAx,nAy,nAz];