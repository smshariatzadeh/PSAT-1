function warn_cac(a,idx,msg)

global Bus

fm_disp(fm_strjoin('Warning: Central Area Controller #',int2str(idx), ...
	       ' at bus #',Bus.names(a.bus(idx)),msg))