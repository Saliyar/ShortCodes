function y = size(A)
% y = size(A)
% @HARMONIC/SIZE Size of harmonic object.
%  
%   SIZE(A) returns the size of harmonic object array,
%   A. It is equivalent to MAX(SIZE(A.harmo)).  
%
%   (please see also the pdf file classes.pdf on the objects designed in MatLab)
%
%    See also harmonic, get, set, plus, display, rotate, times, convert2nondim,
%    convert2dim, isempty, uminus, minus, length
%
y = A.n_harmo;