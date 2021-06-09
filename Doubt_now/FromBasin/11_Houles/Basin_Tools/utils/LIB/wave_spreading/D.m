function y = D(theta, s, theta_0, type)
% cos^2s (theta - theta_0)/2
% cos^s theta for |theta| < pi/2
if nargin < 4, type = 'cos2s'; end
theta = theta - theta_0;
switch type
    case {'cos2s', 'cos2n'}
        y = cos(theta/2).^(2*s);
    case {'coss', 'cosn', 'cos_n', 'cos_s'}
        y = zeros(size(theta));
        ind = find(theta < pi/2 & theta>-pi/2);
        y(ind) = cos(theta(ind)).^(s);
end
