% Preparation des essais SAS-BOS
% ******************************
%
% spectre de JONSWAP

function vspectre = vjonswap(frequence,tpic,hs,gamma,alpha)

g = 9.81;

cte = g^2/(2.0*pi)^4;

fpic = 1./tpic;


% calcul du spectre aux frequences specifiees

vspectre = zeros(size(frequence));

for k=1:length(frequence)

   f0 = frequence(k);

   if f0==0,   f0 = 1.0e-06;   end

   if f0<fpic,   sigma = 0.07;   end
   if f0>fpic,   sigma = 0.09;   end

   a1 = -1.25/(f0/fpic)^4;

   b1 = -0.5*((f0-fpic)/fpic/sigma)^2;

   vspectre(k) = cte/f0^5*exp(a1)*gamma^exp(b1);

end

vspectre = alpha*vspectre;



