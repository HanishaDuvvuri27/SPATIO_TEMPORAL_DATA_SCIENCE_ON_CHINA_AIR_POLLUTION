set more off

*** add predicted values
loc P = "SO2 O3"
foreach p of loc P {

use panel20200321.dta, clear
keep if pollutant=="`p'"
drop if data==.
keep stationcode date
duplicates drop

bys stationcode: gen ndays=_n
bys stationcode: keep if ndays==_N
keep stationcode ndays
duplicates drop
keep if ndays==150
gen balanced=1
drop ndays

merge 1:m stationcode using panel20200321
keep if _merge==3
drop _merge

gen post = time>0
gen cov = year==2020
gen post_cov = post*cov
drop if year==2018
gen dow = dow(mdy(month,day,year))
encode stationcode,gen(stationid)
keep if pollutant=="`p'"

 
reg data post cov post_cov time if proven=="Hubei"
predict data_predictHubei
reg data post cov post_cov time if proven=="HubeiNeighbor"
predict data_predictHubeiNeighbor
reg data post cov post_cov time if proven=="nonNeighbor"
predict data_predictnonNeighbor

gen data_predict=.
replace data_predict = data_predictHubei if proven == "Hubei"
replace data_predict = data_predictHubeiNeighbor if proven == "HubeiNeighbor"
replace data_predict = data_predictnonNeighbor if proven == "nonNeighbor"

keep stationcode pollutant data_predict edate
save `p'predicted.dta, replace
}




use panel20200321.dta, clear

merge m:1 edate pollutant stationcode using SO2predicted
drop _merge
rename data_predict SO2_predict
merge m:1 edate pollutant stationcode using O3predicted
drop _merge
rename data_predict O3_predict

collapse (mean) data SO2_predict O3_predict, by(pollutant date proven)
gen year = floor(date/10000)
gen month = floor((date - year*10000)/100)
gen day = date - year*10000 - month*100
gen edate = mdy(month,day,year)
format edate %td

gen time=.
replace time= edate - mdy(1,24,2020) if year==2020
replace time= edate - mdy(2,4,2019) if year==2019
replace time= edate - mdy(2,15,2018) if year==2018


preserve
keep if pollutant=="O3"
sort year time
tw (line data time if year==2020&proven=="Hubei", lcolor(gs9)) ///
(line data time if year==2019&proven=="Hubei", lcolor(gs9) lpattern(dash)) ///
(line O3_predict time if year==2020&proven=="Hubei"&time<=0, lcolor(red)) ///
(line O3_predict time if year==2019&proven=="Hubei"&time<=0, lcolor(blue) lpattern(dash)) ///
(line O3_predict time if year==2020&proven=="Hubei"&time>0, lcolor(red)) ///
(line O3_predict time if year==2019&proven=="Hubei"&time>0, lcolor(blue) lpattern(dash) ///
legend(order(1 "Raw O{sub:3} concentration in 2020" 2 "Raw O{sub:3} concentration in 2019" 3 "Predicted O{sub:3} concentration in 2020" 4 "Predicted O{sub:3} concentration in 2019" )) ///
graphregion(color(white)) title("O{sub:3} in Hubei") ///
ytitle("O{sub:3} ({&mu}g/m{sup:3})") xtitle(days relative to Lunar New Year) xlabel(-21(7)28) ///
xline(0, lcolor(gs14)) xsize(7) ///
ylabel(0(20)80))
graph export O3_Hubei.pdf, replace

tw (line data time if year==2020&proven=="HubeiNeighbor", lcolor(gs9)) ///
(line data time if year==2019&proven=="HubeiNeighbor", lcolor(gs9) lpattern(dash)) ///
(line O3_predict time if year==2020&proven=="HubeiNeighbor"&time<=0, lcolor(red)) ///
(line O3_predict time if year==2019&proven=="HubeiNeighbor"&time<=0, lcolor(blue) lpattern(dash)) ///
(line O3_predict time if year==2020&proven=="HubeiNeighbor"&time>0, lcolor(red)) ///
(line O3_predict time if year==2019&proven=="HubeiNeighbor"&time>0, lcolor(blue) lpattern(dash) ///
legend(order(1 "Raw O{sub:3} concentration in 2020" 2 "Raw O{sub:3} concentration in 2019" 3 "Predicted O{sub:3} concentration in 2020" 4 "Predicted O{sub:3} concentration in 2019" )) ///
graphregion(color(white)) title("O{sub:3} in neighbors") ///
ytitle("O{sub:3} ({&mu}g/m{sup:3})") xtitle(days relative to Lunar New Year) xlabel(-21(7)28) ///
xline(0, lcolor(gs14)) xsize(7) ///
ylabel(0(20)80))
graph export O3_Neighbor.pdf, replace

tw (line data time if year==2020&proven=="nonNeighbor", lcolor(gs9)) ///
(line data time if year==2019&proven=="nonNeighbor", lcolor(gs9) lpattern(dash)) ///
(line O3_predict time if year==2020&proven=="nonNeighbor"&time<=0, lcolor(red)) ///
(line O3_predict time if year==2019&proven=="nonNeighbor"&time<=0, lcolor(blue) lpattern(dash)) ///
(line O3_predict time if year==2020&proven=="nonNeighbor"&time>0, lcolor(red)) ///
(line O3_predict time if year==2019&proven=="nonNeighbor"&time>0, lcolor(blue) lpattern(dash) ///
legend(order(1 "Raw O{sub:3} concentration in 2020" 2 "Raw O{sub:3} concentration in 2019" 3 "Predicted O{sub:3} concentration in 2020" 4 "Predicted O{sub:3} concentration in 2019" )) ///
graphregion(color(white)) title("O{sub:3} in non-neighbors") ///
ytitle("O{sub:3} ({&mu}g/m{sup:3})") xtitle(days relative to Lunar New Year) xlabel(-21(7)28) ///
xline(0, lcolor(gs14)) xsize(7) ///
ylabel(0(20)80))
graph export O3_nonNeighbor.pdf, replace
restore



preserve
keep if pollutant=="SO2"
sort year time
tw (line data time if year==2020&proven=="Hubei", lcolor(gs9)) ///
(line data time if year==2019&proven=="Hubei", lcolor(gs9) lpattern(dash)) ///
(line SO2_predict time if year==2020&proven=="Hubei"&time<=0, lcolor(red)) ///
(line SO2_predict time if year==2019&proven=="Hubei"&time<=0, lcolor(blue) lpattern(dash)) ///
(line SO2_predict time if year==2020&proven=="Hubei"&time>0, lcolor(red)) ///
(line SO2_predict time if year==2019&proven=="Hubei"&time>0, lcolor(blue) lpattern(dash) ///
legend(order(1 "Raw SO{sub:2} concentration in 2020" 2 "Raw SO{sub:2} concentration in 2019" 3 "Predicted SO{sub:2} concentration in 2020" 4 "Predicted SO{sub:2} concentration in 2019" )) ///
graphregion(color(white)) title("SO{sub:2} in Hubei") ///
ytitle("SO{sub:2} ({&mu}g/m{sup:3})") xtitle(days relative to Lunar New Year) xlabel(-21(7)28) ///
xline(0, lcolor(gs14)) xsize(7) ///
ylabel(0(5)25))
graph export SO2_Hubei.pdf, replace

tw (line data time if year==2020&proven=="HubeiNeighbor", lcolor(gs9)) ///
(line data time if year==2019&proven=="HubeiNeighbor", lcolor(gs9) lpattern(dash)) ///
(line SO2_predict time if year==2020&proven=="HubeiNeighbor"&time<=0, lcolor(red)) ///
(line SO2_predict time if year==2019&proven=="HubeiNeighbor"&time<=0, lcolor(blue) lpattern(dash)) ///
(line SO2_predict time if year==2020&proven=="HubeiNeighbor"&time>0, lcolor(red)) ///
(line SO2_predict time if year==2019&proven=="HubeiNeighbor"&time>0, lcolor(blue) lpattern(dash) ///
legend(order(1 "Raw SO{sub:2} concentration in 2020" 2 "Raw SO{sub:2} concentration in 2019" 3 "Predicted SO{sub:2} concentration in 2020" 4 "Predicted SO{sub:2} concentration in 2019" )) ///
graphregion(color(white)) title("SO{sub:2} in neighbors") ///
ytitle("SO{sub:2} ({&mu}g/m{sup:3})") xtitle(days relative to Lunar New Year) xlabel(-21(7)28) ///
xline(0, lcolor(gs14)) xsize(7) ///
ylabel(0(5)25))
graph export SO2_Neighbor.pdf, replace

tw (line data time if year==2020&proven=="nonNeighbor", lcolor(gs9)) ///
(line data time if year==2019&proven=="nonNeighbor", lcolor(gs9) lpattern(dash)) ///
(line SO2_predict time if year==2020&proven=="nonNeighbor"&time<=0, lcolor(red)) ///
(line SO2_predict time if year==2019&proven=="nonNeighbor"&time<=0, lcolor(blue) lpattern(dash)) ///
(line SO2_predict time if year==2020&proven=="nonNeighbor"&time>0, lcolor(red)) ///
(line SO2_predict time if year==2019&proven=="nonNeighbor"&time>0, lcolor(blue) lpattern(dash) ///
legend(order(1 "Raw SO{sub:2} concentration in 2020" 2 "Raw SO{sub:2} concentration in 2019" 3 "Predicted SO{sub:2} concentration in 2020" 4 "Predicted SO{sub:2} concentration in 2019" )) ///
graphregion(color(white)) title("SO{sub:2} in non-neighbors") ///
ytitle("SO{sub:2} ({&mu}g/m{sup:3})") xtitle(days relative to Lunar New Year) xlabel(-21(7)28) ///
xline(0, lcolor(gs14)) xsize(7) ///
ylabel(0(5)25))
graph export SO2_nonNeighbor.pdf, replace
restore


