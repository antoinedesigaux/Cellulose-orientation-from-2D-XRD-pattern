extension = ".dat"
image = ARG1.extension
# data ranges
set xra [0.15:0.26]
set yra [-pi:pi]
set zra [0:1000]
# parameters for the (110) lattice planes of cellulose
a1 = 1
b1 = .1667
c1 = .01
# parameters for the (1-10) lattice planes of cellulose
a2 = 1
b2 = .1852
# parameters for the (200) lattice planes of cellulose
a3 = 4
b3 = .2512
# parameters for the rubber peak
ar = 10
br = .225
cr = .03 
# parameters for the azimutal fit of cellulose
by = @ARG2
b = 1 
# modified pi-periodic von Mises distribution for the azimutal fit 
rho(x) = 4*sqrt(sqrt(b*b)/(2*pi))*(exp(sqrt(b*b)*(cos(2*(x-by))+1))/erfi(sqrt(2*sqrt(b*b))))
# gaussian function for the radial fit 
g(x,a,b,c) = a**2 * exp(-((x-b)/c)**2)
g1(x) = g(x,a1,b1,c1) + g(x,a2,b2,c1) + g(x,a3,b3,c1)
# surface function
p(x,y) = g1(x)*rho(y) + g(x,ar,br,cr)
# fit
set fit logfile "fitlog_fondlin_correction_azimut_gasser2006/fit".ARG1.".log"
set fit quiet
fit p(x,y) + m0+m1*x image every 2 binary format="%float%float%float" using 1:2:($3*(1+.05*cos($2*2)+0.02*cos($2))) via m0, m1
fit p(x,y) + m0+m1*x image binary format="%float%float%float" using 1:2:($3*(1+.05*cos($2*2)+0.02*cos($2))) via by
fit p(x,y) + m0+m1*x image every 2 binary format="%float%float%float" using 1:2:($3*(1+.05*cos($2*2)+0.02*cos($2))) via m0, m1, a1, a2, a3, ar
fit p(x,y) + m0+m1*x image every 2 binary format="%float%float%float" using 1:2:($3*(1+.05*cos($2*2)+0.02*cos($2))) via cr
fit p(x,y) + m0+m1*x image binary format="%float%float%float" using 1:2:($3*(1+.05*cos($2*2)+0.02*cos($2))) via by
fit p(x,y) + m0+m1*x image every 2 binary format="%float%float%float" using 1:2:($3*(1+.05*cos($2*2)+0.02*cos($2))) via m0, m1, a1, a2, a3, ar, by, cr
# fit of the dispersion parameters on the azimutal direction
fit p(x,y) + m0+m1*x image binary format="%float%float%float" using 1:2:($3*(1+.05*cos($2*2)+0.02*cos($2))) via b
fit p(x,y) + m0+m1*x image binary format="%float%float%float" using 1:2:($3*(1+.05*cos($2*2)+0.02*cos($2))) via m0, m1, a1, a2, a3, ar, by, cr, b
# output
set print "parameters_fondlin_correction_azimut_gasser2006/para3peaks".ARG1
print 'codename+image ', 'a1 ', 'b1 ', 'c1 ', 'a2 ', 'b2 ', 'a3 ', 'b3 ', 'ar ', 'br ', 'cr ', 'by ', 'by_err ', 'by_degree ', 'b ', 'b_err ', 'm0 ', 'm1 '
print ARG0, @ARG1, a1**2, b1, c1, a2**2, b2, a3**2, b3, ar**2, br, cr, by, by_err, by*180/pi, b, b_err, m0, m1
