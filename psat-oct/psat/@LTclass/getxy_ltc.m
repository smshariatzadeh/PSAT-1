function [x,y] = getxy_ltc(a,bus,x,y)

if ~a.n, return, end

h1 = ismember(a.bus1,bus);
h2 = ismember(a.bus2,bus);
h = find(h1+h2);

if ~isempty(h)
  x = [x; a.mc(h)];
  y = [y; a.md(h)];
end
