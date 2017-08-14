function [x,y,s] = mask_ddsg(a,idx,orient,vals)

[xc,yc] = fm_draw('circle','Ddsg',orient);
[xh,yh] = fm_draw('helix','Ddsg',orient);

x = cell(27,1);
y = cell(27,1);
s = cell(27,1);

x{1} = xh-4;
y{1} = 3*yh;
s{1} = 'c';

x{2} = xc;
y{2} = yc;
s{2} = 'b';

x{3} = 1.4*xc;
y{3} = 1.4*yc;
s{3} = 'k';

x{4} = [0,-2];
y{4} = [0 0];
s{4} = 'k';

x{5} = [-2 -3 -3 -2 -2];
y{5} = [-1 -1 1 1 -1];
s{5} = 'k';

x{6} = [-3 -5];
y{6} = [0 0];
s{6} = 'k';

x{7} = [1.4 2.075];
y{7} = [0 0];
s{7} = 'k';

x{8} = [3.95 4.5];
y{8} = [0 0];
s{8} = 'k';

x{9} = 1.5*[ 0.3 0.3 -0.95 -0.95 0.3]+0.35;
y{9} = 0.5*[-1.7 2.7  2.7  -1.7 -1.7]-0.25;
s{9} = 'k';

x{10} = 1.5*[0 0.2]+3.5;
y{10} = 0.5*[0.5 0.5]-0.25;
s{10} = 'k';

x{11} = 1.5*[0 0]+3.5;
y{11} = 0.5*[-0.5 1.5]-0.25;
s{11} = 'm';

x{12} = 1.5*[0 -0.2]+3.5;
y{12} = 0.5*[-0.5 -0.5]-0.25;
s{12} = 'm';

x{13} = 1.5*[0 -0.65]+3.5;
y{13} = 0.5*[1.5 1.5]-0.25;
s{13} = 'm';

x{14} = 1.5*[-0.2 -0.2]+3.5;
y{14} = 0.5*[-1 0]-0.25;
s{14} = 'm';

x{15} = 1.5*[-0.2 -0.45]+3.5;
y{15} = 0.5*[-1 -0.5]-0.25;
s{15} = 'm';

x{16} = 1.5*[-0.2 -0.45]+3.5;
y{16} = 0.5*[0 -0.5]-0.25;
s{16} = 'm';

x{17} = 1.5*[-0.45 -0.45]+3.5;
y{17} = 0.5*[-1 0]-0.25;
s{17} = 'm';

x{18} = 1.5*[-0.2 -0.2]+3.5;
y{18} = 0.5*[2 1]-0.25;
s{18} = 'm';

x{19} = 1.5*[-0.45 -0.45]+3.5;
y{19} = 0.5*[2 1]-0.25;
s{19} = 'm';

x{20} = 1.5*[-0.45 -0.2]+3.5;
y{20} = 0.5*[2 1.5]-0.25;
s{20} = 'm';

x{21} = 1.5*[-0.45 -0.2]+3.5;
y{21} = 0.5*[1 1.5]-0.25;
s{21} = 'm';

x{22} = 1.5*[-0.65 -0.65]+3.5;
y{22} = 0.5*[-0.5 1.5]-0.25;
s{22} = 'm';

x{23} = 1.5*[-0.45 -0.65]+3.5;
y{23} = 0.5*[-0.5 -0.5]-0.25;
s{23} = 'm';

x{24} = 1.5*[-0.45 -0.65]+3.5;
y{24} = 0.5*[1.5 1.5]-0.25;
s{24} = 'm';

x{25} = 1.5*[-0.65 -0.85]+3.5;
y{25} = 0.5*[0.5 0.5]-0.25;
s{25} = 'm';

x{26} = 1.5*[-0.3 -0.3]+3.5;
y{26} = 0.5*[1.7 2.2]-0.25;
s{26} = 'm';

x{27} = 1.5*[-0.325 -0.275]+3.5;
y{27} = 0.5*[1.975 1.975]-0.25;
s{27} = 'm';

[x,y] = fm_maskrotate(x,y,orient);
