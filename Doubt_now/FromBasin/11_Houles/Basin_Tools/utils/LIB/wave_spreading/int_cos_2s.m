function I = int_cos_2s(theta, s, theta_0)
% integral between -pi and theta of cos((theta-theta_0)/2)^(2s)
%
I = (theta + pi) / 2;
%
v   = (theta - theta_0) / 2;
v_0 = (- pi  - theta_0) / 2;
for n=1:s
    I = (sin(v) .* cos(v).^(2*n-1) - sin(v_0) * cos(v_0)^(2*n-1) + (2*n-1) * I) / (2*n);
end
%
I = 2 * I;