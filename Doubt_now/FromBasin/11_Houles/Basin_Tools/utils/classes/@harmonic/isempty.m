function TF = isempty(A)
% TF = isempty(A)
% @HARMONIC/ISEMPTY True for empty for harmonic arrays
%
%    TF = ISEMPTY(A) returns true (1) if A is an empty harmonic and false (0)
%    otherwise. An empty harmonic has no elements, that is PROD(SIZE(A.harmo))==0.
%
%   (please see also the pdf file classes.pdf on the objects designed in MatLab)
%
%    See also harmonic, get, set, plus, display, rotate, times, convert2nondim,
%    convert2dim, length, uminus, minus
%
A = harmonic(A);
%
TF = 0;
if isempty(A.harmo)
    TF = 1;
end
if isempty(A.harmo) && A.n_harmo ~= 0
    error('harmonicisempty:mismatch','mismatch')
end