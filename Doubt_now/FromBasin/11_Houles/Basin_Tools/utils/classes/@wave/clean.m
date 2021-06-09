function wave_in = clean(wave_in)
% wave_in = clean(wave_in)
% @WAVE/CLEAN clean a wave object
% Input:
%   wave_in is an object from wave class (cf. help wave)
%  (see also the pdf file classes.pdf on the objects designed in MatLab)
%
wave_in = wave(wave_in);
% Harmonic number (so that freq=harmo*f_base)
harmo = get(wave_in, 'harmo');
[harmo, permut] = sort(harmo);
harmo_work = harmo; % will be deleted
% Initialisation
wv_in = get(wave_in,'wave');
m = 1;
while ~isempty(harmo_work)
    % Components with the same frequency
    ind = find(harmo == harmo_work(1));
    % Collecting amplitude and phase
    temp = 0;
    for n=1:length(ind)
        temp = temp + get(wv_in(permut(ind(n))),'amplitude') .* exp(i * get(wv_in(permut(ind(n))),'phase'));
    end
     % Deleting the components with zero amplitude
    if abs(temp) ~= 0
        % Building the output wave
        wv_out(m) = harmonic(harmo_work(1), abs(temp), angle(temp), 0);
        m = m + 1;
    end
    % Deleting the current frequency that has been dealt with
    ind = find(harmo_work == harmo_work(1));
    for n=length(ind):-1:1
        harmo_work(ind(n)) = [];
    end
end
% Building the output wave
T_repeat = get(wave_in,'T_repeat');
f_samp   = get(wave_in,'f_samp');
wmk      = get(wave_in,'wavemaker');
%
wave_in = wave(T_repeat,f_samp,wv_out(1),wmk);
for n=2:length(wv_out)
    wave_in = wave(T_repeat,f_samp,wv_out(n),wmk) + wave_in;
end
