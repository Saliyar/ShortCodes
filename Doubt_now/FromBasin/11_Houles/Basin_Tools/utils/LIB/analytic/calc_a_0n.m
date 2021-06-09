function a_0n = calc_a_0n(I_n, k_0n, k, theta, type, L_y, X_d)
% a_0n = calc_a_0n(I_n, k_0n, k, theta, type, L_y, X_d)
%
if strcmp(type,'snake')
    a_0n = cos(theta) * k ./ k_0n .* I_n;
%     N_1 = floor( k * L_y / pi);
%     n = length(k_0n);
%     if (N_1+1 < n)
%         a_0n(N_1+2:n) = 0.0;
%     end
elseif strcmp(type,'dalrymple')
    N_1 = floor(k * L_y / pi);
    n = length(k_0n);
    a_0n = zeros(1,n);
    M = min(N_1+1,n);
%     M = n;
    a_0n(1:M) = I_n(1:M) .* exp(i*(k_0n(1:M) - k .* cos(theta)) .* X_d);
elseif  strcmp(type,'single_flap')
    a_0n = exp(-i * k * sin(theta) * L_y) * cos(theta) * k ./ k_0n .* I_n;
end
