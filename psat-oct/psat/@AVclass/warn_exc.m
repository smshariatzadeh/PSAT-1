function warn_exc(a,idx,msg)

global Bus

fm_disp(fm_strjoin('Warning: AVR #',int2str(idx), ...
	       ' at bus #',Bus.names(a.bus(idx)),msg))