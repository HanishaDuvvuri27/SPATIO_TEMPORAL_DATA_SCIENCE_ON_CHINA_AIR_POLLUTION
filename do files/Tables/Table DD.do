set more off

* Table 2 double diff: all china, hubei, neighbor, non-neighbor

local C = "HubeiNeighborOther All"
foreach c of loc C {

loc P = "NO2 SO2 PM25 O3 CO"
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

merge m:1 provorg year month using provmon
keep if _merge==3
drop _merge

gen post = time>=0
gen cov = year==2020
gen post_cov = post*cov
gen y2018 = year==2018
gen dow = dow(mdy(month,day,year))
encode stationcode,gen(stationid)
keep if pollutant=="`p'"

if "`c'" =="HubeiNeighborOther" {
preserve
keep if proven=="Hubei"
areg data post cov post_cov y2018 i.dow temp prcp wdsp, absorb(stationcode) cluster(stationcode)
est store est`p'_Hubei,title("`p'")

gen ldata = log(data)
areg ldata post cov post_cov y2018 i.dow temp prcp wdsp, absorb(stationcode) cluster(stationcode)
est store est`p'log_Hubei,title("log(`p')")
restore

preserve
keep if proven=="HubeiNeighbor"
areg data post cov post_cov y2018 i.dow temp prcp wdsp, absorb(stationcode) cluster(stationcode)
est store est`p'_Neighbor,title("`p'")

gen ldata = log(data)
areg ldata post cov post_cov y2018 i.dow temp prcp wdsp, absorb(stationcode) cluster(stationcode)
est store est`p'log_Neighbor,title("log(`p')")
restore

preserve
keep if proven=="nonNeighbor"
areg data post cov post_cov y2018 i.dow temp prcp wdsp, absorb(stationcode) cluster(stationcode)
est store est`p'_nonNeighbor,title("`p'")

gen ldata = log(data)
areg ldata post cov post_cov y2018 i.dow temp prcp wdsp, absorb(stationcode) cluster(stationcode)
est store est`p'log_nonNeighbor,title("log(`p')")
restore
}

if "`c'" =="All" {
preserve
areg data post cov post_cov y2018 i.dow temp prcp wdsp, absorb(stationcode) cluster(stationcode)
est store est`p',title("`p'")

gen ldata = log(data)
areg ldata post cov post_cov y2018 i.dow temp prcp wdsp, absorb(stationcode) cluster(stationcode)
est store est`p'log,title("log(`p')")
restore
}

}
}

estout estNO2log estSO2log estPM25log estO3log estCOlog ///
using "table2_All.tex", ///
keep(post post_cov cov y2018 *dow temp prcp wdsp _cons) ///
order(post post_cov) ///
varlabel(post "Post" cov "Y2020" post_cov "Post $\times$ Y2020" y2018 "Y2018" temp "Temperature" prcp "Precipitation" wdsp "Wind speed" _cons "\_cons") ///
cells(b(star fmt(%8.3f %8.3f %8.3f %8.3f %9.3g)) se(par)) collabels(none) eqlabels(none) mlabels(none) ///
prefoot(\hline) stats(N r2, labels(Observations "R-square") fmt(%9.0f %9.3f) ) ///
style(tex) starlevels("$^{*}$" 0.1 "$^{**}$" 0.05 "$^{***}$" 0.01) replace

estout estNO2 estSO2 estPM25 estO3 estCO ///
using "tableLevel2_All.tex", ///
keep(post post_cov cov y2018 *dow temp prcp wdsp _cons) ///
order(post post_cov) ///
varlabel(post "Post" cov "Y2020" post_cov "Post $\times$ Y2020" y2018 "Y2018" temp "Temperature" prcp "Precipitation" wdsp "Wind speed" _cons "\_cons") ///
cells(b(star fmt(%8.3f %8.3f %8.3f %8.3f %9.3g)) se(par)) collabels(none) eqlabels(none) mlabels(none) ///
prefoot(\hline) stats(N r2, labels(Observations "R-square") fmt(%9.0f %9.3f) ) ///
style(tex) starlevels("$^{*}$" 0.1 "$^{**}$" 0.05 "$^{***}$" 0.01) replace

loc C="Hubei Neighbor nonNeighbor"
foreach c of loc C {
estout estNO2log_`c' estSO2log_`c' estPM25log_`c' estO3log_`c' estCOlog_`c' ///
using "table2_`c'.tex", ///
keep(post post_cov cov y2018 *dow temp prcp wdsp _cons) ///
order(post post_cov) ///
varlabel(post "Post" cov "Y2020" post_cov "Post $\times$ Y2020" y2018 "Y2018" temp "Temperature" prcp "Precipitation" wdsp "Wind speed" _cons "\_cons") ///
cells(b(star fmt(%8.3f %8.3f %8.3f %8.3f %9.3g)) se(par)) collabels(none) eqlabels(none) mlabels(none) ///
prefoot(\hline) stats(N r2, labels(Observations "R-square") fmt(%9.0f %9.3f) ) ///
style(tex) starlevels("$^{*}$" 0.1 "$^{**}$" 0.05 "$^{***}$" 0.01) replace


estout estNO2_`c' estSO2_`c' estPM25_`c' estO3_`c' estCO_`c' ///
using "tableLevel2_`c'.tex", ///
keep(post post_cov cov y2018 *dow temp prcp wdsp _cons) ///
order(post post_cov) ///
varlabel(post "Post" cov "Y2020" post_cov "Post $\times$ Y2020" y2018 "Y2018" temp "Temperature" prcp "Precipitation" wdsp "Wind speed" _cons "\_cons") ///
cells(b(star fmt(%8.3f %8.3f %8.3f %8.3f %9.3g)) se(par)) collabels(none) eqlabels(none) mlabels(none) ///
prefoot(\hline) stats(N r2, labels(Observations "R-square") fmt(%9.0f %9.3f) ) ///
style(tex) starlevels("$^{*}$" 0.1 "$^{**}$" 0.05 "$^{***}$" 0.01) replace
}



