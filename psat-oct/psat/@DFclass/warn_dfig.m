function warn_dfig(a,idx,msg)

global Bus

fm_disp(fm_strjoin('Warning: DFIG <',int2str(idx), ...
	       '> at bus <',Bus.names(a.bus(idx)),'>: ',msg))
