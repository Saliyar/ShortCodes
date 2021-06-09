function [eta, slope] = eval_eta(wv_2D, time, x)
% eta = eval_eta(wv_2D, time x)
% @WAVED\EVAL_ETA evaluates the wave elevation at position x at time t for the wave object
% Inputs: 
%   wv_2D         is a wave object,
%   time          is a vector of given times at which the user wants to evaluate eta(x,t)
%   x (optional)  is a scalar and represent the position at which the user wants to evaluate the elevation
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
ampli = get(wv_2D,'ampli').';
omega = get(wv_2D,'omega').';
phase = get(wv_2D,'phase').';
if nargin <= 2
    if length(ampli) == 1
        eta = real(ampli * exp(1i*(omega * time + phase)));
    else
        eta = real(sum(ampli * ones(1,length(time)) .* exp(1i*(omega * time + phase * ones(1,length(time))))));
    end
else
    k = wave_number(get(wv_2D,'frequency').', get(wv_2D,'depth'));
    if length(ampli)*length(time) < 5e7
        eta = real(sum(ampli * ones(1,length(time)) .* exp(1i*(omega * time + (-k*x + phase) * ones(1,length(time))))));
    else
        eta = zeros(size(time));
        for n=1:length(ampli)
            eta = eta + ampli(n) * cos(omega(n) * time - k(n)*x + phase(n));
        end
    end
end