function warn_sofc(a,idx,msg)

global Bus

fm_disp(fm_strjoin('Warning: SOFC #',int2str(idx),' at bus <', ...
               Bus.names(a.bus(idx)),'>: ',msg))