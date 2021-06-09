function hLine = add_vertical(data, color, style, linewidth,noExcludeFromLegend)
%h = add_vertical(data, color, style)
% ADD_VERTICAL adds vertical lines on a plot
% this routine adds vertical lines on a plot using the vertical axis
% range. Color and style may be specified, the default being 'k--'
% The line is excluded from legend
%
% See also add_horizontal
%

if nargin<5
    noExcludeFromLegend = false;
end

if nargin < 4
    linewidth = 1;
end
if nargin < 3
    s = '--';
else
    s = style;
end
if nargin < 2
    c = [0 0 0];
else
    c = color;
end

% ajoute des traits verticaux
y_seg = get(gca, 'YLim');
hold on
for n=1:length(data)
    hLine = plot(data(n) * [1,1], y_seg, 'LineWidth', linewidth);
    if ~noExcludeFromLegend
    set(get(get(hLine,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','off'); % Exclude line from legend
    end
    set(hLine, 'Color', c, 'LineStyle', s); % Adjust style and color
end
hold off
