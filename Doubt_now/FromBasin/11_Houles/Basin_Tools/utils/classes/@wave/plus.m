function wv = plus(wave1,wave2)
% wv = plus(wave1,wave2)
% @WAVE/PLUS Implement the + (addition) operator for two wave waves
% Inputs:
%   wave1 and wave2  are objects from wave class (cf. help wave)
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
wave1 = wave(wave1);
wave2 = wave(wave2);
%
% Checking compatibility
if (~isempty(wave1) && ~isempty(wave2))
    if wave1.wavemaker ~= wave2.wavemaker
        error('Different wavemakers when adding waves')
    end
    %
    if get(wave1,'f_samp') ~= get(wave2,'f_samp')
        error('Different sampling frequencies when adding waves')
    end
    %
    if get(wave1,'TF_type') ~= get(wave2,'TF_type')
        error('Different transfer functions when adding waves')
    end
end
%
n_repeat_1 = get(wave1,'n_repeat');
n_repeat_2 = get(wave2,'n_repeat');
mult       = pow2(abs(n_repeat_1-n_repeat_2));
if n_repeat_1 < n_repeat_2
    T_repeat = get(wave2,'T_repeat');
    wv_temp = set(get(wave1,'wave'),'harmo',mult .* get(wave1,'harmo')) + get(wave2,'wave');
else
    T_repeat = get(wave1,'T_repeat');
    wv_temp = set(get(wave2,'wave'),'harmo',mult .* get(wave2,'harmo')) + get(wave1,'wave');
end
%
if isempty(wave1)
    wv = wave(T_repeat, get(wave2, 'f_samp'), wv_temp, wave2.wavemaker);
else
    wv = wave(T_repeat, get(wave1, 'f_samp'), wv_temp, wave1.wavemaker);
end