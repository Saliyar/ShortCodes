function pot_out = init_data_2D(pot_in)
% @POTENTIAL_2D/INIT_DATA_2D
% Every input data is in nondimensional form

n_evan    = get(pot_in, 'n_evan');
n_harmo   = get(pot_in, 'n_harmo');
%
wv        = get(pot_in,'wave');
%
pot_out   = pot_in;
%
for n = n_harmo:-1:1 % last element in harmo gives the longest evaluation time so it's done first
    wv_n       = wv(n);
    alpha_n    = calc_alpha_n(wv_n, n_evan);%
    [TF, TF_n] = calc_TF_TF_n(wv_n, alpha_n);
    pot_out.alpha_n(n,:) = alpha_n;
    pot_out.TF(n,:)      = TF;
    pot_out.TF_n(n,:,:)  = TF_n;
end
% Time-independent free modes
pot_out.sigma_n = - 1i * (0:n_evan) * pi;

