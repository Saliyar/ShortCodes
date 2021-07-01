function [W_evan] = calc_W_bound_indep(pot_2D, x, z)
% [W_evan] = calc_W_bound_indep(pot_2D, x, z)
% @POTENTIAL_2D\CALC_W_BOUND_INDEP evaluates the 2nd order free wave velocities at position x,z at time t for the potential_2D object
% Inputs: 
%   pot_2D  is a potential_2D object,
%   x       is a vector and represent the horizontal position at which the user wants to evaluate the elevation
%   z       is a vector and represent the vertical   position at which the user wants to evaluate the elevation
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
x = make_it_row(x);
z = make_it_column(z);
%
ampli = get(pot_2D,'ampli').';
omega = get(pot_2D,'omega').';
phase = get(pot_2D,'phase').';
%
a = ampli .* exp(i*phase);
%
W_evan = zeros(length(z), length(x));
for m=1:length(omega)
    temp = zeros(length(z), length(x));
%     B_0n = calc_B_0n(omega(m), pot_2D.alpha_n(m,:), pot_2D.TF_n(m,:,1)+pot_2D.TF_n(m,:,2));
%     for n = 2:pot_2D.n_evan+1
%         alpha_m_bar = conj(pot_2D.alpha_n(m,n));
%         kmalpha     = pot_2D.alpha_n(m,1) - alpha_m_bar; 
%         Fmz         = F(-1,kmalpha,z);
%         emikx       = exp(-i*kmalpha*x);
%         temp        = temp + kmalpha * B_0n(n) * Fmz * emikx;
%     end
    B_mn = calc_B_mn(omega(m), pot_2D.alpha_n(m,:), pot_2D.TF_n(m,:,1)+pot_2D.TF_n(m,:,2));
    for p = 1:pot_2D.n_evan+1
        for n = 1:p-1
%         for n = 1:pot_2D.n_evan+1
            kmalpha     = pot_2D.alpha_n(m,p) - conj(pot_2D.alpha_n(m,n));
            Fmz         = F(-1,kmalpha,z);
            emikx       = exp(-i*kmalpha*x);
            temp        = temp + kmalpha * B_mn(p,n) * Fmz * emikx;
        end
        kmalpha     = pot_2D.alpha_n(m,p) - conj(pot_2D.alpha_n(m,p));
        Fmz         = F(-1,kmalpha,z);
        emikx       = exp(-i*kmalpha*x);
        temp        = temp + kmalpha * B_mn(p,p) * Fmz * emikx / 2;
    end
    temp   = i * a(m) * conj(a(m)) * temp;
    W_evan = W_evan + temp;
end
%
W_evan = real(W_evan);