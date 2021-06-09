function b = subsasgn(s,index,val)
%@WAVE\SUBSASGN Subscripted assignment for a categorical array.
%
%    A = SUBSASGN(A,S,B) is called for the syntax A(I)=B.  S is a structure
%    array with the fields:
%        type -- string containing '()' specifying the subscript type.
%                Only parenthesis subscripting is allowed.
%        subs -- Cell array or string containing the actual subscripts.
% @WAVE\SUBSASGN Define () assignment for wave objects
%
if length(index) ~= 1
    error('Don''t come messing around in my wave data, use set and get instead')
end
%
if length(index.subs) ~= 1
    error('Can''t deal with wave matrices yet')
end
%
if ~isa(val,'wave')
    error('Wrong third input argument type')
end
%
if get(s,'dim') ~= get(val,'dim')
    error('Different dimensional property')
end
switch index.type
    case '()'
        harmo    = get(s,'harmonic');
        wmk      = get(s,'wavemaker');
        claw     = get(s,'control');
        T_repeat = get(s,'T_repeat');
        f_samp   = get(s,'f_samp');
        n        = index.subs{:};
        harmo(n) = get(val,'harmonic');
        wmk(n)   = get(val,'amplitude');
        phase(n) = get(val,'phase');
        angle(n) = get(val,'angle');
        b = harmonic(harmo, ampli, phase, angle);
        if get(s,'dim') == 0
            b.dim = 0;
        end
    otherwise
        error('Indexing not provided for harmonic objects')
end
