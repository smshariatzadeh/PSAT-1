function idx = psidx_supply(a,k)

global Bus

idx = sparse(a.bus,[1:a.n],k,Bus.n,a.n);

