function alpha = ajonswap(tpic,hs,gamma)

%Calcul du spectre JONSWAP, 1ere etape

g = 9.81;

cte = g^2/(2.0*pi)^4;

fpic = 1/tpic;

% calcul du spectre et normalisation

asf = 0.0;

fmin = 0.0;
fmax = fpic*10;

nbr = 201;

df = (fmax-fmin)/(nbr-1);

for k=1:nbr

   f0 = fmin + (k-1)*df;

   if f0==0,   f0 = 1.0e-06;   end

   if f0<fpic,   sigma = 0.07;   end
   if f0>fpic,   sigma = 0.09;   end

   a1 = -1.25/(f0/fpic)^4;

   b1 = -0.5*((f0-fpic)/fpic/sigma)^2;

   spectre = cte/f0^5*exp(a1)*gamma^exp(b1);

   if k==1 | k==nbr
      asf = asf+spectre/2;
   else
      asf = asf+spectre;
   end

end

asf = asf*df;

alpha = hs^2/16/asf;

