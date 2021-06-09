function alpha_n = wave_number_evan(freq, n, depth)
% WAVE_NUMBER_EVAN gives the wave number at given frequency 'freq' and depth
% through first order dispersion relation
%
%   k = WAVE_NUMBER_EVAN(FREQ, N) calculates the wave number assuming
%   dimensionless frequency
%   k = WAVE_NUMBER_EVAN(FREQ, N, DEPTH) uses the given depth and dimensionful
%   frequency
%

% Initialisation of variables
if nargin == 2
    gravity = 1;
    depth = 1;
else
    gravity = 9.81;
end
frequency  = freq * sqrt(depth / gravity);
%
n_row = size(n,1);
n_col = size(n,2);
%
rhs    = (2 .* pi .* frequency).^2;
eps    = 5.0e-13;
%
warning off MATLAB:fzero:UndeterminedSyntax
for p = 1:n_row
    for q = 1:n_col
        npi       = n(p,q) * pi;
        alpha_max = npi;
        tmp       = eps;
        alpha_min = npi - pi/2 + tmp;
        % starting point
        while disp_relation_evan(alpha_min,rhs) > 0
            tmp       = tmp / 2;
            alpha_min = alpha_min - tmp;
        end
        result(p, q) = abs(fzero(@disp_relation_evan, [alpha_min alpha_max],[],rhs));
        % abs value for low frequency values
    end
end
warning on MATLAB:fzero:UndeterminedSyntax
if nargout < 1 
    result ./ depth
else
    alpha_n = result ./ depth;
 end
%
%
%
function y = disp_relation_evan(k, rhs)
%DISP_RELATION_EVAN gives the dipersion relation at first order :
% k tan (k) + w^2
%
y = k .* tan(k) + rhs;