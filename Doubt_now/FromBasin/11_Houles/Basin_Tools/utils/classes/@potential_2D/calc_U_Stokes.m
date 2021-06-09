function U_Stokes = calc_U_Stokes(pot_2D, x)
% U_Stokes = calc_U_Stokes(pot_2D, x)
% @POTENTIAL_2D\CALC_U_Stokes evaluates the 2nd order Stokes drift at position x for the potential_2D object
% Inputs:
%   pot_2D  is a potential_2D object,
%   x       is a vector and represent the horizontal position at which the user wants to evaluate the elevation
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
x = make_it_row(x);
%
ampli = get(pot_2D,'ampli').';
omega = get(pot_2D,'omega').';
phase = get(pot_2D,'phase').';
%
a = ampli .* exp(i*phase);
%
U_Stokes = zeros(1,length(x));
for m=1:length(omega)
    temp = zeros(1,length(x));
    for p = 1:pot_2D.n_evan+1
        TF_p        = pot_2D.TF_n(m,p,1) + pot_2D.TF_n(m,p,2);
        for n = 1:pot_2D.n_evan+1
            alphamalpha = pot_2D.alpha_n(m,p) - conj(pot_2D.alpha_n(m,n));
            emikx       = exp(-i*alphamalpha*x);
            TF_n        = pot_2D.TF_n(m,n,1) + pot_2D.TF_n(m,n,2);
            temp        = temp + TF_p * conj(TF_n) * (pot_2D.alpha_n(m,p) + conj(pot_2D.alpha_n(m,n))) * emikx;
        end
    end
    temp     = a(m) * conj(a(m)) * temp / (4 * omega(m));
    U_Stokes = U_Stokes + temp;
end
%
U_Stokes = real(U_Stokes);
