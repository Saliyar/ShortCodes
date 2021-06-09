function y = TF_wmk(wv, I, p_n, q_n, D_mn)
% y = TF_wmk(wv, I, p_n, q_n, D_mn)
% @WAVE\TF_WMK Evaluates the transfer function for all the basins, 
% including the B600 bi-flap wavemaker
% Inputs:
%   wv  is a wave object,
%
if get(wv, 'dim')
    wv = convert2nondim(wv);
end
%
k  = get(wv, 'wavenumber');
d  = get(wv, 'hinge_bottom');
%
switch get(wv, 'type')
    case {'piston' }
        y(1) = TF_wmk('piston', k);
        y(2) = 0;
    case {'piston_step' }
        y(1) = TF_wmk('piston_step', k, d);
        y(2) = 0;
    case {'monoflap', 'hinged'}
        y(1) = TF_wmk('monoflap', k, d);
        y(2) = 0;
    case 'biflap' % {1,2,3,4,5.1,5.2,5.3,5.4}
        switch get(wv, 'TF_type')
            case 0
                error('TF type hasn''t been set yet for the input wave object')
            case {1,2,3}
                y = TF_wmk('biflap', k, d, get(wv, 'TF_type'), get(wv, 'middle_flap'));
            otherwise
                y = TF_wmk('biflap', k, d, get(wv, 'TF_type'), get(wv, 'middle_flap'), I, p_n, q_n, D_mn);
        end
    otherwise
        error('Unknown TF type')
end