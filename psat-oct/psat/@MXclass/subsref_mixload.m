function b = subsref_mixload(a,index)

switch index(1).type
 case '.'
  switch index(1).subs
   case 'con'
    if length(index) == 2
      b = a.con(index(2).subs{:});
    else
      b = a.con;
    end
   case 'u'
    if length(index) == 2
      b = a.u(index(2).subs{:});
    else
      b = a.u;
    end
   case 'bus'
    b = a.bus;
   case 'n'
    b = a.n;
   case 'dat'
    b = a.dat;
   case 'x'
    b = a.x;
   case 'y'
    b = a.y;
   case 'ncol'
    b = a.ncol;
   case 'format'
    b = a.format;
  end
end
