function out = isdelta_dfig(a,idx)

global Settings

out = 0;

if ~a.n, return, end

if Settings.hostver > 7
  out = ~isempty(find(a.u.*a.theta_p == idx,1));
else
  out = ~isempty(find(a.u.*a.theta_p == idx));
end
