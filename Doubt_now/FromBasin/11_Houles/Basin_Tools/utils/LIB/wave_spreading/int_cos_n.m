function I = int_cos_n(theta, n, theta_0)
% integral between -pi/2 and theta of (cos(theta-theta_0))^n
% Wallis integrals
%
if mod(n,2) % odd number
    I = sin(theta-theta_0) + sin(pi/2+theta_0);
    I = recurrence_cos_n(I, n, 3, theta, theta_0);
else % even number
    I = pi/2+theta;
    I = recurrence_cos_n(I, n, 2, theta, theta_0);
end

function I = recurrence_cos_n(I_ini, n, n_start, theta, theta_0)
I = I_ini;
for m=n_start:2:n
    I = (cos(theta-theta_0)^(m-1)*sin((theta-theta_0)) + cos(pi/2+theta_0)^(m-1)*sin(pi/2+theta_0))/m + (m-1)/m * I;
end
%     for m=3:2:n
%         I = (cos(theta-theta_0)^(m-1)*sin((theta-theta_0)) + cos(pi/2+theta_0)^(m-1)*sin(pi/2+theta_0))/m + (m-1)/m * I;
%     end
