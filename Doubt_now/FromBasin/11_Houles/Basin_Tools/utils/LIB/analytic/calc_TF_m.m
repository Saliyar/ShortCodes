function TF_m = calc_TF_m(alpha_m, TF, d, ind)
% TF_m = calc_TF_m(alpha_m, TF, d, ind)
%
if nargin > 3
    if ind == 1
        TF_m    = TF * 4.0 * sin(alpha_m) ./ ((1.0-d) * alpha_m) .* ...
            ((1.0-d) * alpha_m .* sin(alpha_m) + cos(alpha_m)) ./ (2.0 * alpha_m + sin(2.0 * alpha_m));
    elseif ind == 2
        TF_m    = TF * 4.0 * sin(alpha_m) ./ ((1.0-d) * alpha_m) .* ...
            (- cos(d * alpha_m)) ./ (2.0 * alpha_m + sin(2.0 * alpha_m));
    end
else
    TF_m    = TF * 4.0 * sin(alpha_m) ./ ((1.0-d) * alpha_m) .* ...
            ((1.0-d) * alpha_m .* sin(alpha_m) + cos(alpha_m) - cos(d * alpha_m)) ./ (2.0 * alpha_m + sin(2.0 * alpha_m));
end
TF_m(1) = 1.0;