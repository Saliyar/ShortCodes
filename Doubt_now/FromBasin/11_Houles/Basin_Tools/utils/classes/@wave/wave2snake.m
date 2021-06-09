function wv_out = wave2snake(wv_in, X_d)
% wv_out = wave2snake(wv_in)
% @WAVE/WAVE2SNAKE create a wave with elaborated method (Dalrymple or
% restricted for instance)
% wv_in     a wave object (regular or irregular)
%
% See also WAVE, GET, SET, DISPLAY
%
dim   = get(wv_in,'dim');
wv_in = convert2nondim(wv_in);
%
T_r = get(wv_in, 'T_repeat');
f_s = get(wv_in, 'f_samp');
wmk = get(wv_in, 'wavemaker');
%
method = get(wv_in, 'law');
if strcmp(method, 'snake')
    if nargin < 2
        error('Missing X_d')
    else
        % Dalrymplizing a snake-principle wave
        wv_in = wave(T_r,f_samp,get(wv_in,'harmo'),wmk,control_law(0,'dalrymple',X_d));
    end
end
M = length(wv_in);
wv_exp = convert2nondim(wave());
h_wait = waitbar(0,['Please wait (', method, ' method)']);
for m = M:-1:1
    waitbar(1-m/M, h_wait);
    % wv_m = wv_in(m);
    % for an "unknown" reason (I thought), I need to force Matlab
    % to use the overloaded subsref
    % The reason is explained in the subsref
    wv_m = subsref(wv_in, substruct('()', {m}));
    %
    k     = get(wv_m, 'k');
    pot   = potential_3D(wv_m, 0, calc_N_1(k, get(wv_in, 'L_y'))+1);
    a_0n  = get(pot, 'a_0n');
    % selection of relevant a_0n
    % above a given fraction of maximum value for instance
    harmo = get(pot, 'harmo');
    mu_n  = get(pot, 'mu_n');
    for n = min(length(a_0n)-1, get(pot, 'N_1')):-1:1
        theta_n   = asin(mu_n(n+1)/k) * 180 / pi; % rad to degrees
        tmp_harmo = harmonic(harmo, abs(a_0n(n+1))/2, angle(a_0n(n+1)), theta_n);
        tmp_harmo = convert2nondim(tmp_harmo, 1); % false conversion (for compatibility reasons)
        wv_exp    = wv_exp + wave(T_r, f_s, tmp_harmo, wmk);
        tmp_harmo = harmonic(harmo, abs(a_0n(n+1))/2, angle(a_0n(n+1)), -theta_n);
        tmp_harmo = convert2nondim(tmp_harmo, 1); % false conversion (for compatibility reasons)
        wv_exp    = wv_exp + wave(T_r, f_s, tmp_harmo, wmk);
    end
    %
    tmp_harmo = harmonic(harmo, abs(a_0n(1)), angle(a_0n(1)));
    tmp_harmo = convert2nondim(tmp_harmo, 1); % false conversion (for compatibility reasons)
    wv_exp = wv_exp + wave(T_r, f_s, tmp_harmo, wmk);
end
close(h_wait);
if dim
    wv_exp = convert2dim(wv_exp, get(wmk, 'depth'));
end
wv_out = wv_exp;
