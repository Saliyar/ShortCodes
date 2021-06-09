function b = subsref(s,index)
% b = subsref(s,index)
% @HARMONIC\SUBSREF Subscripted reference for an harmonic object.
%    B = SUBSREF(S,index) is called for the syntax S(X) when S is an
%    harmonic object.  index is a structure array with the fields:
%        type -- string containing '()', '{}', or '.' specifying the
%                subscript type.
%        subs -- Cell array or string containing the actual subscripts.
%    index might be build using substruct('()',{N}) where N is the array of
%    requested index
%
%    (please see also the pdf file classes.pdf on the objects designed in MatLab)
%
%     See also get, plus, display, rotate, times, convert2nondim,
%     convert2dim, length, isempty, uminus, minus
%
if length(index) ~= 1
    error('Don''t come messing around in my harmonic data, use set and get instead')
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
                b.dim = 0;
            end
        else
            error('Can''t deal with harmonic matrices yet')
        end
    otherwise
        error('This type of indexing is not provided for harmonic objects')
% TODO: Implement the {} and . indexing
end
