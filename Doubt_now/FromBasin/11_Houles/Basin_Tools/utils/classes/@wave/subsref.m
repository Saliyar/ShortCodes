function b = subsref(s,index)
% b = subsref(s,index)
% @WAVE\SUBSREF Define () indexing for wave objects
%
if length(index) ~= 1
    error('Don''t come messing around in my wave data, use set and get instead')
end
%
switch index.type
    case '()'
        harmo = get(s,'harmo');
        ampli = get(s,'amplitude');
        phase = get(s,'phase');
        angle = get(s,'angle');
        if length(index.subs) == 1
            n = index.subs{:};
            if any(n > length(s))
                error('??? Index exceeds matrix dimensions.')
            end
            b = harmonic(harmo(n), ampli(n), phase(n), angle(n));
            if get(s,'dim') == 0
                b = convert2nondim(b,1);
            end
            b = wave(get(s,'T_repeat'),get(s,'f_samp'),b,get(s,'wavemaker'),...
                get(s,'control_law'));
            if strcmp(get(s,'type'), 'biflap')
                b = set(b, 'TF_type', get(s, 'TF_type'));
            end
        else
            error('Can''t deal with wave matrices yet')
        end
    case '{}'
        error('Can''t deal with wave cell arrays yet')
    otherwise
        error('This type of indexing is not provided for wave objects')
end
