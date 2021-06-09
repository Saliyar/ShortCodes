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
if length(k)>1
    error('works only for k scalar')
end
if k == 0
    error('Input wavenumber is zero');
else
    % input checkings
    switch wmk_type
        case 'piston'
            % nothing to check !
        case {'monoflap', 'hinged'}
            if nargin < 3
                error('Missing hinge height from bottom for monoflap case')
            end
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
% % adapt so that it work with vector k
%             if (k<30)
%                 y    = tmp;
%             else
%                 y = -1i/2.0;
%             end
        for ii=1:length(k)
            if(k(ii)<100)
                tmp1 = sinh(k(ii));
                tmp2 = 2.0*k(ii);
                tmp  = -i*(tmp2+sinh(tmp2))./(4*tmp1.*tmp1);
            else
                tmp  = -i*1/2;
            end
            if(k(ii)==0)
                tmp = 0.0;
            end
            y(ii)   = tmp;
        end
        case {'monoflap', 'hinged'}
            tmp1 = k*(1-d);
            tmp2 = sinh(k);
            tmp3 = 2.0*k;
            if d >= 0 % standard flap
                tmp  = -1i*tmp1./(4*tmp2).*(tmp3+sinh(tmp3))./(tmp1.*tmp2-cosh(k)+cosh(k*d));
            else % hinge below ground
                tmp  = -1i*tmp1./(4*tmp2).*(tmp3+sinh(tmp3))./(tmp1.*tmp2-cosh(k)+1);
            end
%             if (tmp1 < 30)
%                 y    = tmp;
%             else
%                 y    = -1i/3.0;
%             end
% % adapt so that it work with vector k
%             if (min(tmp1,k*d)<30)
%                 y = tmp;
%             else
%                 y =-1i/2.0;
%             end
            for ii=1:length(k)
                if(k(ii)<100)
                    if(k(ii)*d<100)
                        tmp1 = k(ii)*(1-d);
                        tmp2 = sinh(k(ii));
                        tmp3 = 2.0*k(ii);
                        tmp  = -i*tmp1./(4*tmp2).*(tmp3+sinh(tmp3))./(tmp1.*tmp2-cosh(k(ii))+cosh(k(ii)*d));
                    else
                        tmp1 = k(ii)*(1-d);
                        tmp  = -i*tmp1./(2*tmp1-2+2*exp(-tmp1));
                    end
                else
                    if(k(ii)*d<100)
                        tmp1 = k(ii)*(1-d);
                        tmp  = -i*tmp1./(2*tmp1-2+2*exp(-tmp1));
                    else
                        tmp  = -i*1/2;
                    end
                end
                if(k(ii)==0)
                    tmp = 0.0;
                end
                y(ii)   = tmp;
            end
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
                    tmp  = -i*tmp1./(4*tmp2).*(tmp3+sinh(tmp3))./(tmp1.*tmp2-cosh(tmp1+tmp0)+cosh(tmp0));
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
