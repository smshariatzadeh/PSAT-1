function a = add_svc(a,data)

global Bus

a.n = a.n + length(data(1,:));
a.con = [a.con; data];
[a.bus,a.vbus] = getbus_bus(Bus,a.con(:,1));
