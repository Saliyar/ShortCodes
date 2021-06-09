function TF_n = calc_TF_n(alpha_n, TF, J_n)
% TF_n = calc_TF_n(alpha_n, TF, J_n)
% LIB\ANALYTIC\2D\LINEAR\CALC_TF_N evaluates the evanescent transfer
% functions TF_n for a bi-flap wavemaker
% Inputs
%     alpha_n     vector of progressive and evanescent wavenumbers
%     TF          trnasfer function
%     J_n         vertical integrals

%% checking
alpha_n = make_it_column(alpha_n);
%
%% progressive mode
TF_n(1,1) = 1;
TF_n(1,2) = 0;
%
%% evanescent modes
n_evan       = length(alpha_n)-1;
if n_evan ~= 0
    n            = 1:n_evan;
    Fm_alpha_n_0 = F(-1,alpha_n(n+1),0);
    TF_n(n+1,1)  = i * TF(1) .* Fm_alpha_n_0 .*  J_n(n,4)           ./ J_n(n,1);
    TF_n(n+1,2)  = i * TF(2) .* Fm_alpha_n_0 .* (J_n(n,2)+J_n(n,3)) ./ J_n(n,1);
end
