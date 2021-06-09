function [X, dot_X] = eval_X(wv_2D, time, TF_type)
% X = eval_X(wv_2D, time x)
% @WAVE\EVAL_X evaluates the wavemaker motion at time t for the wave object
% Inputs:
%   wv_2D         is a wave object,
%   time          is a vector of given times at which the user wants to evaluate X(t)
%   TF_type       is the transfer function
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%

% Going to nondimensional form
depth = get(wv_2D, 'depth');
wv_2D = convert2nondim(wv_2D);
if strcmp(get(wv_2D,'type'),'biflap')
    if nargin < 3
        TF_type = get(wv_2D, 'TF_type');
    else
        wv_2D = set(wv_2D, 'TF', TF_type);
    end
end
time  = time * sqrt(9.81 / depth);
%
n_harmo = length(wv_2D);
ampli   = get(wv_2D,'ampli').';
harmo   = get(wv_2D,'harmo').';
omega   = get(wv_2D,'omega').';
phase   = get(wv_2D,'phase').';
n_evan  = 20;
%
d        = get(wv_2D,'hinge_bottom');
D        = get(wv_2D,'middle_flap');
T_repeat = get(wv_2D,'T_repeat');
f_samp   = get(wv_2D,'f_samp');
wmk      = get(wv_2D,'wavemaker');
%
h_wait = init_wait_time_bar('Evaluating TF and omega');
for n1=n_harmo:-1:1 % last element in harmo gives the longest evaluation time so it's done first
    harmo_tmp   = harmonic(harmo(n1),ampli(n1),phase(n1)); % harmonic object
    harmo_tmp   = convert2nondim(harmo_tmp, 1);            % false conversion (for compatibility reasons)
    wv_2D_tmp   = wave(T_repeat,f_samp,harmo_tmp,wmk);     % wave object
    if strcmp(get(wv_2D_tmp,'type'),'biflap') % biflap wavemaker
        wv_2D_tmp = set(wv_2D_tmp, 'TF', TF_type);
    end
    omega(n1)   = get(wv_2D_tmp,'pulsation');
    wave_info   = info('pulsation', omega(n1));
    if strcmp(get(wv_2D_tmp,'type'),'biflap') && TF_type > 3
        alpha_n(1:n_evan+1)  = calc_alpha_n(wave_info, n_evan);
        [I, J_n]             = calc_I_J_n(alpha_n(1:n_evan+1), d, D);
        [p_n, q_n]           = calc_pn_qn(alpha_n(1:n_evan+1), I, J_n);
        D_mn                 = calc_D_mn(alpha_n(1:n_evan+1), omega(n1));
        TF(1:2,n1)           = TF_wmk(wv_2D_tmp, I, p_n, q_n, D_mn);
    else
        TF(1:2,n1)           = TF_wmk(wv_2D_tmp);
    end
    wait_time_bar(h_wait, 1-(n1-1)/n_harmo, 'Evaluating TF and omega')
end
close(h_wait)
% Wavemaker motion
if strcmp(get(wv_2D_tmp,'type'),'biflap') % biflap wavemaker
    X(1,:) = real(sum((ampli .* TF(1,:).') * ones(1,length(time)) .* exp(1i*(omega * time + phase * ones(1,length(time)))),1));
    X(2,:) = real(sum((ampli .* TF(2,:).') * ones(1,length(time)) .* exp(1i*(omega * time + phase * ones(1,length(time)))),1));
    dot_X(1,:) = real(sum((1i*omega.*ampli .* TF(1,:).') * ones(1,length(time)) .* exp(1i*(omega * time + phase * ones(1,length(time)))),1));
    dot_X(2,:) = real(sum((1i*omega.*ampli .* TF(2,:).') * ones(1,length(time)) .* exp(1i*(omega * time + phase * ones(1,length(time)))),1));
else
    X = real(sum((ampli .* TF(1,:).') * ones(1,length(time)) .* exp(1i*(omega * time + phase * ones(1,length(time)))),1)).';
    dot_X = real(sum((1i*omega.*ampli .* TF(1,:).') * ones(1,length(time)) .* exp(1i*(omega * time + phase * ones(1,length(time)))),1)).';
end
% Going back to dimensional form
X = X * depth;
dot_X = dot_X * sqrt(9.81 * depth);
%
