function out = phase_velocity(frequency, wavenumber)
% phase_velocity(frequency, wavenumber)
% computes the phase velocity of gravity waves at specified frequency and wavenumber
%
% n_row = size(frequency,1);
% n_col = size(frequency,2);
% for n = 1:n_row
%     for m = 1:n_col
%         result(n,m) = 2 * pi* frequency(n,m) / wavenumber(n,m);
%     end
% end
result = 2 * pi * frequency ./ wavenumber;
if nargout < 1 
    result
else
    out = result;
end
