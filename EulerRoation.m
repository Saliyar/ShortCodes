function EulerRoation(Px,Py,Pz,phi,theta,psi)

cosphi = cos(phi);
sinphi = sin(phi);
costheta = cos(theta);
sintheta = sin(theta);
cospsi = cos(psi);
sinpsi = sin(psi);

Rx=[1 0 0; ...
    0 cosphi -sinphi; ...
    0 sinphi cosphi];

Ry=[costheta 0 sintheta; ...
    0 1 0; ...
    -sintheta 0 costheta];

Rz=[cospsi -sinpsi 0; ...
    sinpsi cospsi 0; ...
    0 0 1];


[X;Y;Z]=Rz*Ry*Rx*[Px;Py;Pz]













end