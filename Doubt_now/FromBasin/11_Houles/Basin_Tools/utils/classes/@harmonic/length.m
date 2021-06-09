function y = length(A)
% y = length(A)
% @HARMONIC/LENGTH Length of harmonic object.
%  
%   LENGTH(A) returns the length of harmonic object array,
%   A. It is equivalent to MAX(SIZE(A.harmo)).  
%
%   (please see also the pdf file classes.pdf on the objects designed in MatLab)
%
%    See also harmonic, get, set, plus, display, rotate, times, convert2nondim,
%    convert2dim, isempty, uminus, minus
%
y = A.n_harmo;