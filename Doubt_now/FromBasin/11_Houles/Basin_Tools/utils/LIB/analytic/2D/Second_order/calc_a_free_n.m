function a_free_n = calc_a_free_n(D_mn, TF_n, omega, type )
% a_free_n = calc_a_free_n
% LIB\ANALYTIC\2D\SECOND_ORDER\CALC_A_FREE_n evaluates the second order
% free wave amplitude
% Inputs
% alpha_0   progressive wavenumber
% omega     pulsation
% A_bound   second order bound potential amplitude
%  (see also the pdf file potential.pdf on the second order potential theory)
%

n_evan = size(D_mn,1);
% % checking
% if n_evan ~= 1
%     TF_n = make_it_column(TF_n);
% end
%
col_one   = ones(n_evan,1);
%
% wave_info = info('pulsation', 2*omega);
% beta      = get(wave_info,'wavenumber');
beta      = wave_number(2*omega / (2*pi));
coeff     = (exp(beta) + exp(-beta))^2 / ((exp(2*beta) - exp(-2*beta))/2 + 2*beta);
TF_n_mat  = col_one * (TF_n(:,1) + TF_n(:,2)).';
%
if nargin == 3
    a_free_n  = coeff * sum(sum(D_mn .* TF_n_mat .* TF_n_mat.')) ;
else
    % Diagonal
    for m = 1:n_evan
        Dmm_am2(m) = D_mn(m,m) .* TF_n(m)^2;
    end
    beta = 1;
end
