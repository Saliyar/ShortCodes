function X = eval_X_3D(wv, time, y)
% X = eval_X_3D(wv, time, y)
% @WAVE\EVAL_X_3D evaluates the wavemaker motion at time t for the wave object
% Inputs:
%   wv            is a wave object,
%   time          is a vector of given times at which the user wants to evaluate X(t)
%   y             is an optional vector of transverse paddle positions
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
c_law     = get(wv,'control_law');
n_paddles = get(c_law, 'active_paddles');
if n_paddles == 0
    warning('wave:continuous', 'continuous wavemaker')
end
if strcmp(get(wv, 'law'), 'Dalrymple') || strcmp(get(wv, 'law'), 'dalrymple')  || strcmp(get(wv, 'law'), 'restricted')
    wv = wave2snake(wv);
end
if get(wv,'dim') == 1
    % Going to nondimensional form
    depth = get(wv, 'depth');
    wv_2D = convert2nondim(wv);
    time  = time * sqrt(9.81 / depth);
else
    wv_2D = wv;
end
%
n_harmo = length(wv_2D);
ampli   = get(wv_2D,'ampli').';
harmo   = get(wv_2D,'harmo').';
omega   = get(wv_2D,'omega').';
k       = get(wv_2D,'k').';
phase   = get(wv_2D,'phase').';
theta   = get(wv_2D,'angle').' * pi/180;
%
T_repeat = get(wv_2D,'T_repeat');
f_samp   = get(wv_2D,'f_samp');
wmk      = get(wv_2D,'wavemaker');
%
TF = zeros(2,n_harmo);
for n1=n_harmo:-1:1 % last element in harmo gives the longest evaluation time so it's done first
    harmo_tmp   = harmonic(harmo(n1),ampli(n1),phase(n1),theta(n1)); % wave object
    harmo_tmp   = convert2nondim(harmo_tmp, 1); % false conversion (for compatibility reasons)
    wv_2D_tmp   = wave(T_repeat,f_samp,harmo_tmp,wmk); % wave object
    TF(1:2,n1)  = TF_wmk(wv_2D_tmp);
end
% Wavemaker flap position
if nargin < 3
    N_B = get(wmk,'n_paddles');
    for n = 1:N_B
        y(n) = (n - 1/2) * get(wmk,'L_y') / N_B;
    end
else
    N_B = length(y);
end
% Wavemaker motion
X = zeros(N_B, length(time));
for n = 1:N_B 
    X(n,:) = real(sum((ampli .* TF(1,:).' .* cos(theta)) * ones(1,length(time)) .* exp(1i*(omega * time + (- k .* y(n) .* sin(theta) - phase) * ones(1,length(time)))),1));
end
if get(wv,'dim') == 1
    % Going back to dimensional form
    X = X * depth;
end
%