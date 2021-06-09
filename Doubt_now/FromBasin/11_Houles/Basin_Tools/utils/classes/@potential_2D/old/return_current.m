function U = return_current(pot_2D)
% U = return_current(pot_2D)
% @POTENTIAL_2D\RETURN_CURRENT evaluates the return current associated to
% the wave components in the potential_2D object

ampli = get(pot_2D,'ampli');
omega = get(pot_2D,'omega');
k     = get(pot_2D,'wavenumber');
%
U = - k .* ampli ./ (2*omega);
