function alpha_n = calc_alpha_n(wave_info, n_evan, depth)
% alpha_n = calc_alpha_n(wave_info, n_evan, depth)
% Inputs
%   wave_info can be a info object, either in adim or dim version
%   but also a wave_2D object, or a frequency
%   n_evan is the desired number of evanescent modes
%   depth is optional, required if first argument is a dimensional (Hz)
%   frequency
% Output
%   alpha_n is a complex vector of wevenumber
%       alpha_n(1)=k is the progressive wavenumber (real)
%       alpha_n(2:n_evan+1)=-i|alpha_n| are the evanescent ones (imaginary)
%
alpha_n = zeros(1,n_evan+1);
%
if isa(wave_info,'info') || isa(wave_info,'wave')
    alpha_n(1) = get(wave_info,'wavenumber');
    f          = get(wave_info,'frequency');
    dim        = get(wave_info,'dim');
    depth      = get(wave_info,'depth');
else
    f = wave_info;
    if nargin < 3
        dim = 0;
        alpha_n(1) = wave_number(f);
    else
        dim = 1;
        alpha_n(1) = wave_number(f,depth);
    end
end
%
if dim == 0
    freq = f;
else
    freq  = f * sqrt(depth / 9.81);
end
% boundaries of the range of application of the asymptotic expansions
limit_order(1) = limit_9num(freq);
limit_order(2) = limit_79(freq);
limit_order(3) = limit_57(freq);
limit_order(4) = limit_35(freq);
limit_order(5) = limit_13(freq);
%
for n=2:n_evan+1
%     disp(num2str(n))
%     alpha_n(n) = - i * wave_number_evan(freq, n-1);
    if n < limit_order(1) % numerical solution
        alpha_n(n) = - i * wave_number_evan(freq, n-1);
    elseif n < limit_order(2) % asymptotic expansion at order 9
        alpha_n(n) = - i * eval_AD(9,freq,n-1);
    elseif n < limit_order(3) % asymptotic expansion at order 7
        alpha_n(n) = - i * eval_AD(7,freq,n-1);
    elseif n < limit_order(4) % asymptotic expansion at order 5
        alpha_n(n) = - i * eval_AD(5,freq,n-1);
    elseif n < limit_order(5) % asymptotic expansion at order 3
        alpha_n(n) = - i * eval_AD(3,freq,n-1);
    else % asymptotic expansion at order 1
        alpha_n(n) = - i * eval_AD(1,freq,n-1);
    end
end
if dim ~= 0
    alpha_n(2:n_evan+1) = alpha_n(2:n_evan+1) / depth;
end

function n_bound = limit_9num(freq)
% Range of application of an asymptotic expansion of order 9
%   obtained by a test (24th october 2006, cf page 9)
freq_test    = [0.08 0.17 0.25 0.34 0.42 0.51 0.59 0.68 0.76 0.85];
[val range]  = min(abs(freq_test-freq));
n_bound_test = [5 8 12 18 26 34 46 68 78 101 140];
n_bound = n_bound_test(range);

function n_bound = limit_79(freq)
% Range of application of an asymptotic expansion of order 7
%   obtained by a test (24th october 2006, cf page 9)
freq_test    = [0.08 0.17 0.25 0.34 0.42 0.51 0.59 0.68 0.76 0.85];
[val range]  = min(abs(freq_test-freq));
n_bound_test = [10 15 22 32 55 78 98 110 125 170 240];
n_bound = n_bound_test(range);

function n_bound = limit_57(freq)
% Range of application of an asymptotic expansion of order 5
%   obtained by a test (24th october 2006, cf page 9)
freq_test    = [0.08 0.17 0.25 0.34 0.42 0.51 0.59 0.68 0.76 0.85];
[val range]  = min(abs(freq_test-freq));
n_bound_test = [20 30 50 70 100 125 187 236 290 324 570];
n_bound = n_bound_test(range);

function n_bound = limit_35(freq)
% Range of application of an asymptotic expansion of order 3
%   obtained by a test (24th october 2006, cf page 9)
freq_test    = [0.08 0.17 0.25 0.34 0.42 0.51 0.59 0.68 0.76 0.85];
[val range]  = min(abs(freq_test-freq));
n_bound_test = [80 120 160 200 300 500 710 860 1100 2100 3100];
n_bound = n_bound_test(range);

function n_bound = limit_13(freq)
% Range of application of an asymptotic expansion of order 1
%   obtained by a test (24th october 2006, cf page 9)
freq_test    = [0.08 0.17 0.25 0.34 0.42 0.51 0.59 0.68 0.76 0.85];
[val range]  = min(abs(freq_test-freq));
n_bound_test = 5000 * ones(1,length(freq_test));
n_bound = n_bound_test(range);

function alpha = eval_AD(order,freq,n)
% Evaluating the asymptotic expansion of given order
%   up to order 9
npi     = n*pi;
alpha   = npi;
if order >= 1 % order 1
    oneonpi = 1.0 / npi;
    omega   = 2*pi*freq;
    omega2  = omega * omega;
    alpha   = alpha - omega2 * oneonpi;
end
if order >= 3 % order 3
    oneonpi2 = oneonpi .* oneonpi;
    oneonpi3 = oneonpi2 .* oneonpi;
    omega4   = omega2 * omega2;
    alpha    = alpha + omega4 / 3 * (omega2 - 3) * oneonpi3;
end
if order >= 5 % order 5
    oneonpi5 = oneonpi3 .* oneonpi2;
    omega6   = omega4 * omega2;
    alpha    = alpha - omega6 / 15 * (3*omega4 - 20*omega2 + 30) * oneonpi5;
end
if order >= 7 % order 7
    oneonpi7 = oneonpi5 .* oneonpi2;
    omega8   = omega4 * omega4;
    alpha    = alpha + omega8 / 105 * (15*omega6 - 161*omega4 + 525*omega2 - 525) * oneonpi7;
end
if order >= 9 % order 9
    omega10 = omega6 * omega4;
    alpha   = alpha - omega10 / 315 * (35*omega8 - 528*omega6 + 2744*omega4 - 5880*omega2 + 4410) * oneonpi7 * oneonpi2;
end
