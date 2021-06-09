function alpha_n = calc_alpha_n_old(wave_info, n_evan)
% alpha_n = calc_alpha_n(wave_info, n_evan)
% Inputs
%   wave_info is a wave object, either in adim or dim version
%   n_evan is the desired number of evanescent modes
% Output
%   alpha_n is a complex vector of wevenumber
%       alpha_n(1)=k is the progressive wavenumber (real)
%       alpha_n(2:n_evan+1)=-i|alpha_n| are the evanescent ones (imaginary)
%
alpha_n(1) = get(wave_info,'wavenumber');
f          = get(wave_info,'frequency');
adim       = get(wave_info,'adim');
%
if adim == 1
    freq = f;
else
    depth = get(wave_info,'depth');
    freq  = f * sqrt(depth / 9.81);
end
%
for n=2:n_evan+1
    alpha_n(n) = - i * wave_number_evan(freq, n-1);
end
if adim ~= 1
    alpha_n(2:n_evan+1) = alpha_n(2:n_evan+1) / depth;
end
