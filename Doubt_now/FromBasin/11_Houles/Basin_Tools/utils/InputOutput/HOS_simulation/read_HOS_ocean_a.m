%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%    Function read_HOS: read the data in the file
%%%%%%%%%%%%%%%%%%%    3d.dat in the case of unidirectional wavefield
%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [xlen,ylen,Hs,Tp,gamma,f_samp,grav,depth,n1,n2,kx,ky,a_eta,a_phis] = read_HOS_ocean_a

%READ PARAMETERS OF SIMULATION (number of time-steps, duration of simulations, geometric caracteristics...)
[xlen,ylen,Hs,Tp,gamma,T_stop,f_samp,grav,depth,n1,n2,M] = read_HOS_ocean_input('a_3d.dat', './');
if mod(n1,2) == 0, n1o2p1 = n1/2+1; else n1o2p1 = (n1+1)/2; end

    fid = fopen('a_3d.dat'); 

%creation of a variable zone = duration*sampling_frequency = number of samples
%zone is a vector of one line with T_stop * f_samp elements equals to T_stop * f_samp except the 1st which is 1. (Except if T_stop * f_samp=1, then it is [])
zone   = floor(T_stop * f_samp)+1;
if zone==1
    error('only one sample')
end
N_zone = zone;
zone(zone==1) = [];
zone(2:zone) = zone;
zone(1) = 1;
%skip 35 lines
for i=1:35
    fgets(fid);
end;

% Initialization
kx=zeros(n1o2p1,1);
ky=zeros(n2,1);
%
a_eta=zeros(n1o2p1,n2,length(zone));
a_phis=zeros(n1o2p1,n2,length(zone));

%READ THE VALUE OF DATA (x,y,eta,phis)

%INITIAL CASE (t=0)

%On recupere la variable data qui contient quatre colonnes (x,y,eta,phis).
%On extrait les valeurs x de la premiere colonne de data, celles de
%y de la deuxieme colonne par pas de n1(lie à l'ordre de representation des couples (n1,n2), ex: (1,a),(2,a),(3,a),(1,b),(2,b),(3,b),(1,c)...) et on les range sous forme de vecteurs.
%Puis on extrait les valeurs de eta de la troisieme colonne de data, et
%celles de phis de la quatrieme et on les range egalement sous forme de
%vecteurs.
data   = fscanf(fid, '%g %g %g %g %g %g \n', [6, n1o2p1*n2]).';
kx      = data(1:n1o2p1,1);
ky      = data(1:n1o2p1:n1o2p1*n2,2);
a_eta(:,:,1)  = reshape(data(:,3),n1o2p1,n2);
a_phis(:,:,1) = reshape(data(:,4),n1o2p1,n2);


%create the waiting bar
if length(zone) > 2
    h_wait_zone = waitbar(0,['Reading ' num2str(length(zone)) ' useful zones. Please wait...']);
end


%FOLLOWING TIME STEPS

%On saute une ligne, puis on recupere la variable data qui contient deux
%colonnes (eta, phis).
%On extrait les valeurs eta de la premiere colonne de data, et celles de
%phis de la deuxieme colonne et on les range sous forme de vecteurs

for n=2:length(zone)
    fgets(fid);
    data = fscanf(fid, '%g %g %g %g \n', [4, n1o2p1*n2]).';
    a_eta(:,:,n)  = reshape(data(:,1),n1o2p1,n2);
    a_phis(:,:,n) = reshape(data(:,2),n1o2p1,n2);
    %waiting bar progress...
    if length(zone) > 2
        waitbar(n/(length(zone)-1), h_wait_zone)
    end
end
if length(zone) > 2
    close(h_wait_zone)
end
%remove the first element of zone
zone = zone(2:end);

%CLOSE FILE

fclose(fid);

%SAVE NECESSARY DATA IN FILE
save('a_3d.mat', 'N_zone','xlen','ylen','Hs','Tp','gamma','T_stop','f_samp','grav','depth','n1','n2','kx','ky','a_eta','a_phis');
%
% % Extract Tmin, Tmax
% if Tmax > T_stop
%     error('Tmax is too large')
% end
% %
% T_analyse=Tmax-Tmin;
% %
% N_zone_local = floor((T_analyse) * f_samp)+1;
% zone_min = floor(Tmin * f_samp)+1;
% if N_zone_local==1
%     error('only one time-step')
% end
% %
% eta_t0(:,:) = eta(:,:,1);
% %
% eta(:,:,1:N_zone_local)  = eta(:,:,zone_min:zone_min+N_zone_local-1);
% phis(:,:,1:N_zone_local) = phis(:,:,zone_min:zone_min+N_zone_local-1);
% %
% eta(:,:,N_zone_local+1:end)  = [];
% phis(:,:,N_zone_local+1:end) = [];
