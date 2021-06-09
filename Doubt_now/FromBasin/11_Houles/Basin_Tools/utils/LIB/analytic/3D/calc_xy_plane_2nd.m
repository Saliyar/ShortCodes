function F_xy = calc_xy_plane_2nd(pm,A_mnpq,k_mn,x,Ny,Ny_max,cosin)
% F_xy = calc_xy_plane(A_mnpq,k_mn,x,Ny)
% Evaluate a linear quantity in an horizontal plane.
% Inputs
%   A_mnpq is the modal amplitudes,
%   k_mn the corresponding wavenumbers,
%   x    vector of meah points in the x-direction
%   Ny   number of points in the y-direction
% We use a FFT in the transverse direction for the "cos(mu_n y)" so we need
% Nfft = 2(N-1) points if we want N transverse modes (think about Shannon). 
% More in details, we can note that Nfft is even (so one mode will have 
% only cosine wave), and we will have at index
% 1             constant mode
% 2:N-1         modes from 2 to N-1
% N             mode N (this is the mode without sine wave)
% N+1 to Nfft   the modes from N-1 to 2 (without conjugate as we want the 
% cosine functions)
% The first N cos modes in the FFT are the transverse modes of the basin.
% And we will use a length 2Ly so the first N points are N points between 0
% and Ly
%
x = make_it_row(x);
% number of points in the x-direction
Nx = length(x);
% number of vertical evanescent modes
dim_M = size(A_mnpq,1) - 1;
dim_P = size(A_mnpq,3) - 1;
% number  of transverse modes in the FFT
dim_N = 2 * (Ny - 1);
% This means that the y-direction vector must contain Ny = N points
% where N is the number of modes in the transverse direction
%
% building the big matrix
sum_x = zeros(Nx,Ny);
if nargin > 5
    Ny_calc = Ny_max;
else
    Ny_calc = Ny;
end
%  
if pm==1
    X(1,1,1,:)  = x;
    X           = repmat(X,[dim_M+1,dim_P+1,Ny_calc,1]);
    k2 = [];
    k2(1,:,:,1) = k_mn(:,1:Ny_calc);
    k2          = repmat(k2, [dim_M+1,1,1,Nx]);
    for n=1:Ny_calc
        k1 = zeros(dim_M+1,1,n,1);
        A  = zeros(dim_M+1,dim_P+1,n,1);
        for q=1:n
           k1(:,1,q,1) = k_mn(:,n-q+1);
           A(:,:,q,1)  = A_mnpq(:,n-q+1,:,q);
        end
        k1          = repmat(k1, [1,dim_P+1,1,Nx]);
%         A           = repmat(A, [1,1,1,Nx]);
%         B           = (k1+k2(:,:,1:n,:)) .* X(:,:,1:n,:);
%         B           = exp(- i * B);
%         A           = A .* B;
        A           = repmat(A, [1,1,1,Nx]) .* exp(- 1i * (k1+k2(:,:,1:n,:)) .* X(:,:,1:n,:));
        sum_x(:,n) = squeeze(sum(sum(sum(A,1),2),3));
    end
else
    X(1,1,1,:)  = x;
    X           = repmat(X,[dim_M+1,dim_P+1,Ny_calc,1]);
    k2 = [];
    k2(1,:,:,1) = k_mn(:,1:Ny_calc);
    k2          = repmat(k2, [dim_M+1,1,1,Nx]);
    ind = [(-(-Ny_calc+2:0)+2) 1:Ny_calc];
    for n=-Ny_calc+2:Ny_calc
        A  = zeros(dim_M+1,dim_P+1,Ny_calc,1);
        k1 = zeros(dim_M+1,1,Ny_calc,1);
        for q=max(1,-n+2):min(Ny_calc-n+1,Ny_calc)
            k1(:,1,q,1) = k_mn(:,n+q-1);
            A(:,:,q,1)  = A_mnpq(:,n+q-1,:,q);
        end
        k1 = repmat(k1, [1,dim_P+1,1,Nx]);
%         A           = repmat(A, [1,1,1,Nx]);
%         B           = (k1+k2) .* X;
%         B           = exp(- i * B);
%         A           = A .* B;
        A  = repmat(A, [1,1,1,Nx]) .* exp(- 1i * (k1+k2) .* X);
        sum_x(:,ind(n+Ny_calc-1)) = sum_x(:,ind(n+Ny_calc-1)) + squeeze(sum(sum(sum(A,3),2),1));
    end
end
% filling the remaining part for the FFT
sum_x(:,1)          = 2 * sum_x(:,1);  % constant mode
sum_x(:,Ny)         = 2 * sum_x(:,Ny); % last mode
sum_x(:,Ny+1:dim_N) = fliplr(sum_x(:,2:Ny-1)); % cause result is cosine waves
% summation over the transverse modes
if nargin < 7
    FT   = 0.5*(fft(sum_x, dim_N, 2));
elseif strcmp(cosin,'sin')
    FT   = 0.5*(fft(1i*sum_x, dim_N, 2));
end
% keeping
F_xy = FT(:, 1:Ny);
