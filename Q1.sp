full_adder

.protect

.lib 'rf018.l' TT
*import technology file

.unprotect

.option post=2
.global vdd
.param vdd=1.8
+trf=10p 



.subckt full_adder a_in b_in c_in sum cout

* a_not
mn_14	 a_not	 a_in	 0	 	0	    nch	 l=180n w=220n
mp_14	 vdd	 a_in	 a_not  vdd 	pch	 l=180n w=220n
* b_not
mn_15	 b_not	 b_in	 0	 	0	    nch	 l=180n w=220n
mp_15	 vdd	 b_in	 b_not  vdd 	pch	 l=180n w=220n
* c_not
mn_16	 c_not	 c_in	 0	 	0	    nch	 l=180n w=220n
mp_16	 vdd	 c_in	 c_not  vdd 	pch	 l=180n w=220n

* SUM PUN
mp_1   w_1	 a_not  vdd      vdd   pch l=180n  w=220n
mp_2   w_2	 b_in   vdd      vdd   pch l=180n  w=220n
mp_3   w_3   a_in   vdd      vdd   pch l=180n  w=220n
mp_4   w_1 	 c_not  w_2      vdd   pch l=180n  w=220n
mp_5   w_2   c_in   w_3      vdd   pch l=180n  w=220n
mp_6   sum	 a_in   w_1      vdd   pch l=180n  w=220n
mp_7   sum	 b_not  w_2      vdd   pch l=180n  w=220n
mp_8   sum   a_not  w_3      vdd   pch l=180n  w=220n
* SUM PDN
mn_1   sum	 a_not  w_4      0     nch l=180n  w=220n
mn_2   sum	 b_in   w_5      0     nch l=180n  w=220n
mn_3   sum	 a_in   w_6      0     nch l=180n  w=220n
mn_4   w_4 	 c_not  w_5      0     nch l=180n  w=220n
mn_5   w_5   c_in   w_6      0     nch l=180n  w=220n
mn_6   w_4	 a_in   0        0     nch l=180n  w=220n
mn_7   w_5	 b_not  0        0     nch l=180n  w=220n
mn_8   w_6	 a_not  0        0     nch l=180n  w=220n
*COUT PUN
mp_9   w_7	 a_not  vdd      vdd   pch l=180n  w=220n
mp_10  w_8	 a_in   vdd      vdd   pch l=180n  w=220n
mp_11  w_8	 c_not  w_7      vdd   pch l=180n  w=220n
mp_12  cout	 b_not  vdd      vdd   pch l=180n  w=220n
mp_13  cout	 a_not  vdd      vdd   pch l=180n  w=220n
*COUT PDN
mn_9   cout	 a_not  w_9      0     nch l=180n  w=220n
mn_10  cout	 a_in   w_10     0     nch l=180n  w=220n
mn_11  w_9	 c_not  w_10     0     nch l=180n  w=220n
mn_12  w_9 	 b_not  0        0     nch l=180n  w=220n
mn_13  w_10  a_not  0        0     nch l=180n  w=220n
* Load Caps
cl_sum 	 sum   0 4f
cl_cout cout 0 4f
.ends full_adder


vdd vdd	0	vdd


xfa_0 a_0 b_0 c_0 s_0 c_1 full_adder
xfa_1 a_1 b_1 c_1 s_1 c_2 full_adder
xfa_2 a_2 b_2 c_2 s_2 c_3 full_adder
xfa_3 a_3 b_3 c_3 s_3 c_4 full_adder



va0 a_0 0 0
va1 a_1 0 0
va2 a_2 0 0
va3 a_3 0 0

vb0 b_0 0 1.8
vb1 b_1 0 1.8
vb2 b_2 0 1.8
vb3 b_3 0 1.8


vin c_0 0 PULSE(0, 1.8, 0, 10p, 10p, 2.5n, 5n)
.TRAN 0.1p 20n
.measure TRAN tplh_cout TRIG v(c_0) val=0.9 RISE=1 TARG v(c_4) val=0.9 RISE=1
.measure TRAN tphl_cout TRIG v(c_0) val=0.9 FALL=1 TARG v(c_4) val=0.9 FALL=1
.measure tran tp_cout param='max(tplh_cout,tphl_cout)'
.measure TRAN tplh_sum TRIG v(c_0) val=0.9 RISE=1 TARG v(s_3) val=0.9 FALL=1
.measure TRAN tphl_sum TRIG v(c_0) val=0.9 FALL=1 TARG v(s_3) val=0.9 RISE=1
.measure tran tp_sum param='max(tplh_sum,tphl_sum)'


*tp
.measure tran tp param='max(tp_cout,tp_sum)'

* average power
.measure tran average_power avg power from=0n to='20n' 

* PDP
.measure tran pdp param='average_power*tp'


.end
