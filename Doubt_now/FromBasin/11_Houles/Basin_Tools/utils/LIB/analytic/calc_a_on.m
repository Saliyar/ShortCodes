function a_on = calc_a_on(I_n, k_on, k, theta, type, L_y, X_d)
% a_on = calc_a_on(I_n, k_on, k, theta, type, L_y, X_d)
%
n = length(k_on);
if strcmp(type,'serpent')
    a_on = cos(theta) * i*k ./ k_on .* I_n;
elseif  strcmp(type,'dalrymple')
    N = floor( k * L_y / pi);
    M = min([N+1,n]);
    a_on = I_n(1:M) .* exp((k_on(1:M) - i .* k .* cos(theta)) .* X_d);
    if (N+1 < n)
        a_on(N+2:n) = 0.0;
    end
elseif strcmp(type,'cercle')
    N = floor( k * L_y / pi);
    M = min([N+1,n]);
    a_on = I_n(1:M) .* exp((k_on(1:M) - i .* k .* cos(theta)) .* X_d); 
    if (N+1 < n)
        a_on(N+2:n) = 0.0;
    end
elseif  strcmp(type,'single_flap')
    a_on = exp(-i * k * sin(theta) * L_y) * cos(theta) * i*k ./ k_on .* I_n;
end
