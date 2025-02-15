function [x,y,s] = mask_cac(a,idx,orient,vals)

[xc,yc] = fm_draw('C','Cac',orient);

x = cell(5,1);
y = cell(5,1);
s = cell(5,1);

x{1} = [1 0 0 1 1];
y{1} = [1 1 0 0 1];
s{1} = 'k';

x{2} = [0.35 0.5 0.65];
y{2} = [0.2 0.8 0.2];
s{2} = 'r';

x{3} = [0.4 0.6];
y{3} = [0.4 0.4];
s{3} = 'r';

x{4} = 0.1+0.2*xc;
y{4} = 0.5+0.6*yc;
s{4} = 'r';

x{5} = 0.7+0.2*xc;
y{5} = 0.5+0.6*yc;
s{5} = 'r';

