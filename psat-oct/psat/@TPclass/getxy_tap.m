function [x,y] = getxy_tap(a,bus,x,y)

if ~a.n, return, end

h = find(ismember(a.bus,bus));

if ~isempty(h)
  x = [x; a.m(h)];
end
