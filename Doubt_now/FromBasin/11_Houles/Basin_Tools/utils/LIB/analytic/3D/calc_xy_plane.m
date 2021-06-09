function F_xy = calc_xy_plane(A_mn,k_mn,x,Ny,cosin)
% F_xy = calc_xy_plane(A_mn,k_mn,x,Ny)
% Evaluate a linear quantity in an horizontal plane.
% Inputs
%   A_mn is the modal amplitudes, 
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
dim_M = size(A_mn,1) - 1; % the first row of A_mn is where the progressive modes are located
% number  of transverse modes in the FFT
dim_N = 2 * (Ny - 1);
% This means that the y-direction vector must contain Ny = N+1 points
% where N is the number of modes in the transverse direction
%
% building the big matrix
M(1,:,:) = ones(Ny,1) * x;
M        = repmat(M,[dim_M+1,1,1]);
M        = repmat(A_mn,[1,1,Nx]) .* exp(- repmat(1i * k_mn,[1,1,Nx]) .* M); 
%
% summation over the vertical modes
sum_x = permute(squeeze(sum(M, 1)),[2, 1]);
% filling the remaining part for the FFT
sum_x(:,1)          = 2 * sum_x(:,1);  % constant mode
sum_x(:,Ny)         = 2 * sum_x(:,Ny); % last mode
sum_x(:,Ny+1:dim_N) = fliplr(sum_x(:,2:Ny-1)); % cause result is cosine waves
% summation over the transverse modes
if nargin < 5
    FT   = 0.5*(fft(sum_x, dim_N, 2));
elseif strcmp(cosin,'sin')
    FT   = 0.5*(fft(i*sum_x, dim_N, 2));
end
% keeping 
F_xy = FT(:, 1:Ny);
