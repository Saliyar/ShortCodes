function y = TF_wmk(wmk_type, k, d, TF_type, D, I, p_n, q_n, D_mn)
% y = TF_wmk(wmk_type, k, d, TF_type, D, I, p_n, q_n, D_mn)
%
% Transfer function of the wavemaker.
% Input arguments:
%   * wmk_type	is the wavemaker type among 'piston', 'monoflap', 'biflap' or 'dipole',
%               'hinged' is equivalent to 'monoflap'
%   * k			is the desired wavenumber,
%   * d			is the bottom hinge height in case of a flap wavemaker.
%   * TF_type   is the type of transfer function for the biflap wavemaker.
%   * D			is the height of the middle flap in case of a biflap wavemaker.
% These input args are required in nondimensionalised form.
% Output is the complex transfer function at wavenumber k for the
%   specified wavemaker.
%
if k == 0
    error('Input wavenumber is zero');
else
    % input checkings
    switch wmk_type
        case 'piston'
            % nothing to check !
        case 'piston_step'
            if nargin < 3
                error('Missing step height from bottom for piston_step case')
            end
        case {'monoflap', 'hinged'}
        case 'dipole'
            if nargin < 3
                error('Missing dipole depth from free surface')
            end
        otherwise
            if nargin < 4
                error('Missing hinge height from bottom and bottom paddle height')
            end
    end
    % warnings
    switch wmk_type
        case {'monoflap', 'hinged'}
            if d > 1
                warning('TF_wmk:hingeheightrange','Input hinge height ''d'' should be below 1')
            end
        case 'piston_step'
            if d > 1
                warning('TF_wmk:stepheightrange','Input step height ''d'' should be below 1')
            end
            if d < 0
                warning('TF_wmk:stepheightrange','Input step height ''d'' should be positive')
            end
        case 'piston'
        otherwise
            if d < 0 || d > 1
                warning('TF_wmk:hingeheightrange','Input hinge height ''d'' should be between 0 and 1')
            end
            if D < 0 || D > 1
                warning('TF_wmk:middlepaddlerange','height of the middle flap ''D'' should be between 0 and 1')
            end
            if d+D < 0 || d+D > 1
                warning('TF_wmk:paddlesrange','''d+D'' should be between 0 and 1')
            end
    end
    switch wmk_type
        case 'piston'
            tmp1 = sinh(k);
            tmp2 = 2.0*k;
            tmp  = -1i*(tmp2+sinh(tmp2))./(4*tmp1.*tmp1);
            y    = tmp;
        case 'piston_step'
            tmp1 = sinh(k);
            tmp2 = 2.0*k;
            tmp  = -1i./(4*tmp1).*(tmp2+sinh(tmp2))./(tmp1-sinh(k*d));
            y    = tmp;
        case {'monoflap', 'hinged'}
            tmp1 = k*(1-d);
            tmp2 = sinh(k);
            tmp3 = 2.0*k;
            if d >= 0 % standard flap
                tmp  = -1i*tmp1./(4*tmp2).*(tmp3+sinh(tmp3))./(tmp1.*tmp2-cosh(k)+cosh(k*d));
            else % hinge below ground
                tmp  = -1i*tmp1./(4*tmp2).*(tmp3+sinh(tmp3))./(tmp1.*tmp2-cosh(k)+1);
            end
            y    = tmp;
        case 'biflap'
            switch TF_type
                case 1
                    y    = TF_wmk('monoflap', k, d+D);
                    y(2) = 0;
                case 2
                    y = TF_wmk('monoflap', k, d) / (1-d);
                    y(2) =    D    * y(1);
                    y(1) = (1-d-D) * y(1);
                case 3
                    tmp0 = k*d;
                    tmp1 = k*D;
                    tmp2 = sinh(k);
                    tmp3 = 2.0*k;
                    tmp  = -1i*tmp1./(4*tmp2).*(tmp3+sinh(tmp3))./(tmp1.*tmp2-cosh(tmp1+tmp0)+cosh(tmp0));
                    y(2) = tmp;
                    y(1) = 0;
                case 5.1
                    y(1:2) = build_TF_B600_5_1(k, I, p_n, q_n);
                case 5.2
                    y(1:2) = build_TF_B600_5_23(k, 5.2, I, p_n, q_n, D_mn);
                case 5.3
                    y(1:2) = build_TF_B600_5_23(k, 5.3, I, p_n, q_n, D_mn);
                case 5.4
                    y(1:2) = build_TF_B600_5_4(k, I, p_n, q_n, D_mn);
            end
        case 'dipole'
            if k <= 12
                tmp1 = k .* k;
                tmp2 = k .* tanh(k);
                tmp3 = tmp2 .* tmp2;
                tmp  = (tmp1 - tmp3 + tmp2) ./ (2.0 * (tmp1 - tmp3) .* sqrt(tmp2) .* cosh(k) .* sinh(k.*(d+1)));
            else
                tmp1 = k .* k;
                tmp2 = k .* tanh(k);
                tmp  = tmp2 ./ (2.0 * exp(k .* d) .* tmp1);
            end
            y    = tmp;
        otherwise
            error('Unknown type of wavemaker')
    end
end
