function theta = solve_inv_cum(type, u, s, theta_0, norm)
%
theta = theta_0;
error = 1;
while abs(error) > 1e-6
    switch type
        case {'cos2s', 'cos2n'}
            error = (norm * u - int_cos_2s(theta, s, theta_0)) / D(theta, s, theta_0, 'cos2s');
        case {'coss', 'cosn', 'cos_n', 'cos_s'}
            n = s;
            error = (norm * u - int_cos_n(theta, n, theta_0)) / D(theta, n, theta_0, 'cosn');
    end
    theta = error + theta;
end