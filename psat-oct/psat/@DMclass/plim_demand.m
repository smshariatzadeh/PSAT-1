function [pmax,pmin] = plim_demand(a)

if ~a.n
  pmax = [];
  pmin = [];
  return
end

pmax = a.u.*a.con(:,5) + 1e-8*(~a.u);
pmin = a.u.*a.con(:,6);
