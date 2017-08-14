function [x,y] = getxy_busfreq(a,bus,x,y)

if ~a.n, return, end

h = find(ismember(a.bus,bus));

if ~isempty(h)
  x = [x; a.x(h); a.w(h)];
end
