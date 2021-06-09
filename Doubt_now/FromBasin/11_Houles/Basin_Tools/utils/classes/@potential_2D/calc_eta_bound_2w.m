function [eta_prog, eta_evan] = calc_eta_bound_2w(pot_2D, x, time)
% [eta_prog, eta_evan] = calc_eta_bound_2w(pot_2D, x, time)
% @POTENTIAL_2D\CALC_ETA_BOUND_2W evaluates the 2nd order bound wave elevation at position x 
% at time t for the potential_2D object
% Inputs: 
%   pot_2D        is a potential_2D object,
%   time          is a vector of given times at which the user wants to evaluate eta(x,t)
%   x             is a vector and represent the horizontal position at which the user wants to evaluate the elevation
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
x = make_it_column(x);
%
ampli = get(pot_2D,'ampli').';
omega = get(pot_2D,'omega').';
phase = get(pot_2D,'phase').';
%
a = ampli .* exp(1i*phase);
%
eta_prog = zeros(length(x), length(time));
eta_evan  = zeros(length(x), length(time));
for m=1:length(omega)
    alpal = ones(pot_2D.n_evan+1,1)*pot_2D.alpha_n(m,:) + pot_2D.alpha_n(m,:).'*ones(1,pot_2D.n_evan+1);
    A_bound_mn = calc_A_bound_mn(pot_2D.alpha_n(m,:), squeeze(pot_2D.TF_n(m,:,:)), omega(m));
    a_mn       = (3 * omega(m)^4 - pot_2D.alpha_n(m,:).' * pot_2D.alpha_n(m,:)) / (4*omega(m)^2);
    a_mn       = a_mn .* (sum(pot_2D.TF_n(m,:,:),3).' * sum(pot_2D.TF_n(m,:,:),3));
    a_mn       = a_mn + A_bound_mn;
    % progressive wave
    emikx  = exp(-1i*alpal(1,1)*x);
    temp   = a(m)^2 * a_mn(1,1) * emikx;
    for t=1:length(time)
        eta_prog(:,t) = eta_prog(:,t) + temp .* exp(2*1i*omega(m)*time(t));
    end
    % evanescent components
    a_mn(1,1) = 0;
    temp = zeros(size(x));
    for nx=1:length(x)
        temp(nx) = sum(sum(a_mn .*  exp(-1i*alpal*x(nx))));
    end
%     for p = 1:pot_2D.n_evan+1
%         for n = 1:pot_2D.n_evan+1
%             emikx       = exp(-1i*alpal(p,n)*x);
%             temp        = temp + a_mn(p,n) * emikx;
%         end
%     end
    temp = a(m)^2 * temp;
    for t=1:length(time)
        eta_evan(:,t) = eta_evan(:,t) + temp .* exp(2*1i*omega(m)*time(t));
    end
end
%
eta_prog = real(eta_prog);
eta_evan = real(eta_evan);
