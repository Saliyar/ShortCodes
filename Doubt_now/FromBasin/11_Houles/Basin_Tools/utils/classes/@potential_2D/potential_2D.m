function pot_2D = potential_2D(wv, n_evan, n_evan_free)
% POTENTIAL_2D class constructor.
%   pot_2D = potential_2D(wv) returns a potential_2D object with a
%       default number of evanescent modes.
%   pot_2D = potential_2D(wv, n_evan) returns a potential_2D object
%       with the specified number of evanescent modes.
%
% See also get, set, init_data_2D, calc_eta_lin, calc_ampli_lin, display, calc_UW_free_indep
% calc_UW_bound_indep, calc_U_Stokes, calc_UW_lin, calc_eta_bound_indep,
% calc_UW_bound_2w, calc_eta_free, calc_eta_bound_2w, calc_return_current,
% calc_UW_free_2w, 
%
n_evan_default = 100;
%
switch nargin
    case {0}
        pot_2D.n_evan  = n_evan_default;
        % Linear
        pot_2D.alpha_n = [];
        pot_2D.TF      = [];
        pot_2D.TF_n    = [];
        % Second order
        pot_2D.sigma_n = [];
        pot_2D.n_evan_free = 0;
        pot_2D.free = wave();
        % telling matlab wv the class of the build object
        pot_2D = class(pot_2D,'potential_2D', wave());
    case {1}
        if isa(wv, 'potential_2D')
            pot_2D = init_data_2D(wv);
        elseif isa(wv, 'wave')
            pot_2D = potential_2D(wv,n_evan_default);
        else
            error('Wrong type of input argument')
        end
    case {2,3}
        if isempty(n_evan)
            pot_2D.n_evan = n_evan_default;
        else
            pot_2D.n_evan = n_evan;
        end
        pot_2D.alpha_n = [];
        pot_2D.TF      = [];
        pot_2D.TF_n    = [];
        % Second order
        pot_2D.sigma_n = [];
        if nargin == 2
            pot_2D.n_evan_free = 0;
            wv_free            = '';
        else
            if isempty(n_evan_free)
                pot_2D.n_evan_free = n_evan_default;
            else
                pot_2D.n_evan_free = n_evan_free;
            end
            wv_free = eval_free_waves(wv, n_evan);
            wv_free = convert2nondim(wv_free);
        end
        pot_2D.free = wv_free;
        % telling matlab wv the class of the build object
        pot_2D      = class(pot_2D,'potential_2D',convert2nondim(wv));
        % Evaluating useful data
        pot_2D      = init_data_2D(pot_2D);
    otherwise
        error('Wrong number of input arguments')
end
%
