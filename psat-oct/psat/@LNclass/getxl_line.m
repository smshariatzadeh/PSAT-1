function xl = getxl_line(a,idx)

xl = [];

if ~a.n, return, end
if isempty(idx), return, end

xl = a.con(idx,9); 
