function pot_3D = potential_3D(wv, n_vertical, n_transverse, n_vertical_free, n_transverse_free)
% pot_3D = potential_3D(wv, n_vertical, n_transverse)
% @POTENTIAL_3D\POTENTIAL_3D class constructor.
%   n_vertical       is the number of vertical modes to use
%   n_transverse     is the number of transverse modes to use
%
% See also get, set, display, calc_eta_lin, calc_ampli_lin, init_data,
% calc_UVW_lin, calc_eta_lin2, calc_U_lin, calc_V_lin, calc_W_lin,
% calc_eta_bound, calc_eta_free, eval_a_mn_free, eval_a_0n_free,
% init_data_3D
%
switch nargin
    case 0
        pot_3D.n_transverse  = -1;
        % Linear
        pot_3D.N_1   = 0;
        pot_3D.mu_n  = [];
        pot_3D.I_n   = [];
        pot_3D.I_n_j = [];
        pot_3D.k_0n  = [];
        pot_3D.k_mn  = [];
        pot_3D.a_0n  = [];
        pot_3D.A_0n  = [];
        pot_3D.TF_mn = [];
        % Second order
        pot_3D.n_vertical_free   = 0;
        pot_3D.n_transverse_free = 0;
        pot_3D.N_2               = 0;
        pot_3D.beta_m            = [];
        pot_3D.gamma_mn          = [];
        pot_3D.a_0n_free         = [];
        % telling matlab wv the class of the build object
        pot_3D = class(pot_3D,'potential_3D', potential_2D());
    case 1
        if isa(wv, 'potential_3D')
            pot_3D = init_data_3D(wv);
        else
            error('Wrong type of input argument')
        end
    case {3,5}
        pot_2D = potential_2D(wv, n_vertical);
        if isempty(n_transverse)
            pot_3D.n_transverse = -1;
        else
            pot_3D.n_transverse = n_transverse;
        end
        pot_3D.N_1   = 0;
        pot_3D.mu_n  = [];
        pot_3D.I_n   = [];
        pot_3D.I_n_j = [];
        pot_3D.k_0n  = [];
        pot_3D.k_mn  = [];
        pot_3D.a_0n  = [];
        pot_3D.A_0n  = [];
        pot_3D.TF_mn = [];
        % Second order
        if nargin == 5
            if isempty(n_vertical_free)
                pot_3D.n_vertical_free = 0;
            else
                pot_3D.n_vertical_free = n_vertical_free;
            end
            if isempty(n_transverse_free)
                pot_3D.n_transverse_free = 10;
            else
                pot_3D.n_transverse_free = n_transverse_free;
            end
        else
            pot_3D.n_vertical_free   = 0;
            pot_3D.n_transverse_free = 0;
        end
        pot_3D.N_2           = 0;
        pot_3D.beta_m        = [];
        pot_3D.gamma_mn      = [];
        pot_3D.a_0n_free     = [];
        % telling matlab wv the class of the build object
        pot_3D       = class(pot_3D,'potential_3D', potential_2D(pot_2D));
        % Evaluating useful data
        pot_3D       = init_data_3D(pot_3D);
    otherwise
        error('Wrong number of input arguments')
end
%
