function out = getidx_bus(a,idx)

if idx == 0
  out = a.con(:,1);
else
  out = a.con(idx,1);
end
