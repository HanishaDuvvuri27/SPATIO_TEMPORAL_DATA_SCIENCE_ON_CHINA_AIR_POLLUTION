set more off

use panel20200321.dta, clear

collapse (mean) data, by(pollutant date proven)
gen year = floor(date/10000)
gen month = floor((date - year*10000)/100)
gen day = date - year*10000 - month*100
gen edate = mdy(month,day,year)
format edate %td
replace pollutant="PM25" if pollutant=="PM2.5"

gen time=.
replace time= edate - mdy(1,24,2020) if year==2020
replace time= edate - mdy(2,4,2019) if year==2019
replace time= edate - mdy(2,15,2018) if year==2018



preserve
keep if pollutant=="SO2"
sort year time

tw (line data time if year==2020&proven=="Hubei", lcolor(red)) ///
(line data time if year==2019&proven=="Hubei", lcolor(blue) lpattern(dash) ///
legend(label(1 "SO{sub:2} concentration in 2020") label(2 "SO{sub:2} concentration in 2029")) ///
graphregion(color(white)) title("SO{sub:2} in Hubei") ///
ytitle("SO{sub:2} ({&mu}g/m{sup:3})") xtitle(days relative to Lunar New Year) xlabel(-21(7)28) ///
xline(0, lcolor(gs10)) xsize(7) ///
ylabel(0(5)25))
graph export SO2_Hubei.pdf, replace

tw (line data time if year==2020&proven=="HubeiNeighbor", lcolor(red)) ///
(line data time if year==2019&proven=="HubeiNeighbor", lcolor(blue) lpattern(dash) ///
legend(label(1 "SO{sub:2} concentration in 2020") label(2 "SO{sub:2} concentration in 2029")) ///
graphregion(color(white)) title("SO{sub:2} in neighbors") ///
ytitle("SO{sub:2} ({&mu}g/m{sup:3})") xtitle(days relative to Lunar New Year) xlabel(-21(7)28) ///
xline(0, lcolor(gs10)) xsize(7) ///
ylabel(0(5)25))
graph export SO2_Neighbor.pdf, replace

tw (line data time if year==2020&proven=="nonNeighbor", lcolor(red)) ///
(line data time if year==2019&proven=="nonNeighbor", lcolor(blue) lpattern(dash) ///
legend(label(1 "SO{sub:2} concentration in 2020") label(2 "SO{sub:2} concentration in 2029")) ///
graphregion(color(white)) title("SO{sub:2} in non-neighbors") ///
ytitle("SO{sub:2} ({&mu}g/m{sup:3})") xtitle(days relative to Lunar New Year) xlabel(-21(7)28) ///
xline(0, lcolor(gs10)) xsize(7) ///
ylabel(0(5)25))
graph export SO2_nonNeighbor.pdf, replace
restore


preserve
keep if pollutant=="O3"
sort year time

tw (line data time if year==2020&proven=="Hubei", lcolor(red)) ///
(line data time if year==2019&proven=="Hubei", lcolor(blue) lpattern(dash) ///
legend(label(1 "O{sub:3} concentration in 2020") label(2 "O{sub:3} concentration in 2019")) ///
graphregion(color(white)) title("O{sub:3} in Hubei") ///
ytitle("O{sub:3} ({&mu}g/m{sup:3})") xtitle(days relative to Lunar New Year) xlabel(-21(7)28) ///
xline(0, lcolor(gs10)) xsize(7) ///
ylabel(0(20)80))
graph export O3_Hubei.pdf, replace

tw (line data time if year==2020&proven=="HubeiNeighbor", lcolor(red)) ///
(line data time if year==2019&proven=="HubeiNeighbor", lcolor(blue) lpattern(dash) ///
legend(label(1 "O{sub:3} concentration in 2020") label(2 "O{sub:3} concentration in 2019")) ///
graphregion(color(white)) title("O{sub:3} in neighbors") ///
ytitle("O{sub:3} ({&mu}g/m{sup:3})") xtitle(days relative to Lunar New Year) xlabel(-21(7)28) ///
xline(0, lcolor(gs10)) xsize(7) ///
ylabel(0(20)80))
graph export O3_Neighbor.pdf, replace

tw (line data time if year==2020&proven=="nonNeighbor", lcolor(red)) ///
(line data time if year==2019&proven=="nonNeighbor", lcolor(blue) lpattern(dash) ///
legend(label(1 "O{sub:3} concentration in 2020") label(2 "O{sub:3} concentration in 2019")) ///
graphregion(color(white)) title("O{sub:3} in non-neighbors") ///
ytitle("O{sub:3} ({&mu}g/m{sup:3})") xtitle(days relative to Lunar New Year) xlabel(-21(7)28) ///
xline(0, lcolor(gs10)) xsize(7) ///
ylabel(0(20)80))
graph export O3_nonNeighbor.pdf, replace
restore

