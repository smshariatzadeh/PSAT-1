function [enables,prompts] = block_tg(a,object,values,enables,prompts)

% defines special operations of the device mask(used only for SIMULINK model)

type = str2num(values{1});

idxe = [8 9 10 11 12 13 14 15 16 17 18];

idx1 = [3 4 5 6 7 8 9 10];
idx2 = [3 4 5 6 7];
idx3 = [3 4 5 6 7 8 9 10 11 12 13 14 15 16];
idx4 = [3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18];
idx5 = [3 4 5 6 7 8 9 10 11 12];
idx6 = [3 4 5 6 7 8 9 10 11 12 13 14 15];

switch type
 case 1,
  prompts(idx1) = {'Droop R [p.u.]';...
                   'Maximum torque [p.u.]';...
                   'Minimum torque [p.u.]';...
                   'Governor Time Constant Ts [s]'; ...
                   'Servo Time Constant Tc [s]';...
                   'Transient gain time constant T3 [s]';...
                   'Power fraction time constant T4 [s]';...
                   'Reheat time constant T5 [s]'};
  enables(idxe) = {'on';  'on';  'on';  'off'; 'off'; 'off'; ...
                   'off'; 'off'; 'off'; 'off'; 'off'};
 case 2,
  prompts(idx2) = {'Droop R [p.u.]';...
                   'Maximum torque [p.u.]';...
                   'Minimum torque [p.u.]';...
                   'Pole Time Constant T2 [s]'; ...
                   'Zero Time Constant T1 [s]'};
  enables(idxe) = {'off'; 'off'; 'off'; 'off'; 'off'; 'off'; ...
                   'off'; 'off'; 'off'; 'off'; 'off'};   
 case 3,
  prompts(idx3) = {'Pilot valve droop [p.u.]'; ...
                   'Maximum gate opening [p.u.]';...
                   'Minimum gate opening [p.u.]';...
                   'Maximum gate opening rate vmax [p.u.]'; ...
                   'Minimum gate opening rate vmin [p.u.]';...
                   'Pilot valve time constant Tp [s]';...
                   'Dashpot time constant Tr [s]';...
                   'Permanent speed droop sigma [p.u./p.u.]';...
                   'Transient speed droop delta [p.u./p.u.]';...
                   'Water starting time Tw [s]';...
                   'Derivative of flow rate with respect to tubine head a11';...
                   'Derivative of flow rate with respect to gate position a13';...
                   'Derivative of torque with respect to tubine head a21';...
                   'Derivative of torque with respect to gate position a23'};
  enables(idxe) = {'on';  'on';  'on'; 'on';  'on';  'on'; ...
                   'on';  'on';  'on'; 'off'; 'off'};
case 4,
  prompts(idx4) = {'Pilot valve droop [p.u.]'; ...
                   'Maximum gate opening [p.u.]';...
                   'Minimum gate opening [p.u.]';...
                   'Maximum gate opening rate vmax [p.u.]'; ...
                   'Minimum gate opening rate vmin [p.u.]';...
                   'Pilot valve time constant Tp [s]';...
                   'Dashpot time constant Tr [s]';...
                   'Permanent speed droop sigma [p.u./p.u.]';...
                   'Transient speed droop delta [p.u./p.u.]';...
                   'Water starting time Tw [s]';...
                   'Derivative of flow rate with respect to tubine head a11';...
                   'Derivative of flow rate with respect to gate position a13';...
                   'Derivative of torque with respect to tubine head a21';...
                   'Derivative of torque with respect to gate position a23';...
                   'Proportional droop Kp [p.u./p.u.]';...
                   'Integral droop Ki [p.u./p.u.]'};
  enables(idxe) = {'on';  'on';  'on';  'on';  'on';  'on'; ...
                   'on';  'on';  'on';  'on';  'on'};
 case 5,
  prompts(idx5) = {'Servomotor droop [p.u.]'; ...
                   'Maximum gate opening [p.u.]';...
                   'Minimum gate opening [p.u.]';...
                   'Maximum gate opening rate vmax [p.u.]'; ...
                   'Minimum gate opening rate vmin [p.u.]';...
                   'Pilot valve time constant Tp [s]';...
                   'Water starting time Tw [s]';...
                   'Permanent speed droop sigma [p.u./p.u.]';...
                   'Proportional droop Kp [p.u./p.u.]';...
                   'Integral droop Ki [p.u./p.u.]'};
  enables(idxe) = { 'on';  'on';  'on';  'on';  'on';  'off'; ...
                   'off'; 'off'; 'off'; 'off'; 'off'}; 
 case 6,
  prompts(idx6) = {'Servomotor gain [p.u.]'; ...
                    'Maximum gate opening [p.u.]';...
                    'Minimum gate opening [p.u.]';...
                    'Maximum gate opening rate vmax [p.u.]'; ...
                    'Minimum gate opening rate vmin [p.u.]';...
                    'Pilot valve time constant Ta [s]';...
                    'Water starting time Tw [s]';...
                    'Transient speed droop beta [p.u./p.u.]';...
                    'Proportional droop Kp [p.u./p.u.]';...
                    'Integral droop Ki [p.u./p.u.]';
                    'Derivative droop Kd [p.u./p.u.]';
                    'Derivative droop time constant Td [s]';
                    'Permanent droop [p.u./p.u.]'};
  enables(idxe) = {'on'; 'on';  'on';  'on';  'on'; 'on'; ...
                   'on'; 'on'; 'off'; 'off'; 'off'};
end

