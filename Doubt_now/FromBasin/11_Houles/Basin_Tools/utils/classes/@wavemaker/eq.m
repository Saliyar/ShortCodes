function c = eq(wmk1, wmk2)
%
eps = 1e-8;
%
test(1) = abs(get(wmk1,'depth')        - get(wmk2,'depth')) < eps;
test(2) = strcmp(get(wmk1,'type'),       get(wmk2,'type'));
test(3) = abs(get(wmk1,'hinge_bottom') - get(wmk2,'hinge_bottom')) < eps;
test(4) = abs(get(wmk1,'middle_flap')  - get(wmk2,'middle_flap')) < eps;
test(5) = strcmp(get(wmk1,'type_ramp'),  get(wmk2,'type_ramp'));
test(6) = abs(get(wmk1,'ramp')         - get(wmk2,'ramp')) < eps;
test(7) = abs(get(wmk1,'Ly')           - get(wmk2,'Ly')) < eps;
test(8) = get(wmk1,'n_paddles')       == get(wmk2,'n_paddles');
test(9) = get(wmk1,'dim')             == get(wmk2,'dim');

c = all(test);