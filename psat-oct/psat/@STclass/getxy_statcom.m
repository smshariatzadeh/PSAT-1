function [x,y] = getxy_statcom(a,bus,x,y)

if ~a.n, return, end

h = find(ismember(a.bus,bus));

if ~isempty(h)
  x = [x; a.ist(h)];
  y = [y; a.vref(h)];
end
