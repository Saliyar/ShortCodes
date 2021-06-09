function hLine = add_horizontal(data, color, style, linewidth,noExcludeFromLegend)
%h = add_horizontal(data, color, style)
% ADD_HORIZONTAL adds horizontal lines on a plot
% this routine adds horizontal lines on a plot using the horizontal axis
% range. Color and style may be specified, the default being 'k--'
% The line is excluded from legend
%
% See also add_vertical
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
% ajoute des traits horizontaux
x_seg = get(gca, 'XLim');
hold on
for n=1:length(data)
    hLine = plot(x_seg, data(n) * [1,1], s, 'LineWidth', linewidth);
	 if ~noExcludeFromLegend
    set(get(get(hLine,'Annotation'),'LegendInformation'),...
    'IconDisplayStyle','off'); % Exclude line from legend
	    end
    set(hLine, 'Color', c, 'LineStyle', s); % Adjust style and color
end
hold off

