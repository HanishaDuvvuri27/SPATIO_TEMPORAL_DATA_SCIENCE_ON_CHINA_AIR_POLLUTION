* Robustness add province dummy*day trends


* Analog of Table 3 part 1, tripe diff using non-hubei: neighbor vs. non-neighbor
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

gen days = doy(mdy(month,day,year))
replace days = days + 365 if year==2019
replace days = days + 365 + 365 if year==2020
egen provid = group(provorg)
sum provid
loc m=`r(max)'
forval i=1/`m' {
	
preserve
keep if provid==`i'
replace provorg="InnerMongolia" if provorg=="Inner Mongolia"
loc j= provorg[1]
restore

gen Trend`j'=0
replace Trend`j' = days if provid==`i'
}

keep if pollutant=="`p'"
drop if proven=="Hubei"
gen neighbor = proven=="HubeiNeighbor"
gen neighbor_post = neighbor*post
gen neighbor_cov = neighbor*cov
gen neighbor_post_cov = neighbor*post*cov

areg data post cov post_cov neighbor neighbor_post neighbor_cov neighbor_post_cov y2018 i.dow temp prcp wdsp Trend*, absorb(stationcode) cluster(stationcode)
est store est`p',title("`p'")

gen ldata = log(data)
areg ldata post cov post_cov neighbor neighbor_post neighbor_cov neighbor_post_cov y2018 i.dow temp prcp wdsp Trend*, absorb(stationcode) cluster(stationcode)
est store est`p'log,title("log(`p')")
}

estout estNO2log estSO2log estPM25log estO3log estCOlog ///
using "tableProvTrendDay3_nonHubei.tex", ///
keep(post post_cov neighbor_post_cov cov neighbor neighbor_post neighbor_cov y2018 *dow temp prcp wdsp Trend* _cons) ///
order(post post_cov neighbor_post_cov) ///
varlabel(post "Post" cov "Y2020" post_cov "Post $\times$ Y2020" neighbor "Neighbor" neighbor_post "Post $\times$ Neighbor" neighbor_cov "Y2020 $\times$ Neighbor" neighbor_post_cov "Post $\times$ Y2020 $\times$ Neighbor" y2018 "Y2018" temp "Temperature" prcp "Precipitation" wdsp "Wind speed" _cons "\_cons") ///
cells(b(star fmt(%8.3f %8.3f %8.3f %8.3f %9.3g)) se(par)) collabels(none) eqlabels(none) mlabels(none) ///
prefoot(\hline) stats(N r2, labels(Observations "R-square") fmt(%9.0f %9.3f) ) ///
style(tex) starlevels("$^{*}$" 0.1 "$^{**}$" 0.05 "$^{***}$" 0.01) replace





* Analog of Table 3 part 2, tripe diff using hubei and neighbor
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

gen days = doy(mdy(month,day,year))
replace days = days + 365 if year==2019
replace days = days + 365 + 365 if year==2020
egen provid = group(provorg)
sum provid
loc m=`r(max)'
forval i=1/`m' {
	
preserve
keep if provid==`i'
replace provorg="InnerMongolia" if provorg=="Inner Mongolia"
loc j= provorg[1]
restore

gen Trend`j'=0
replace Trend`j' = days if provid==`i'
}

keep if pollutant=="`p'"
drop if proven=="nonNeighbor"
gen neighbor = proven=="Hubei"
gen neighbor_post = neighbor*post
gen neighbor_cov = neighbor*cov
gen neighbor_post_cov = neighbor*post*cov

areg data post cov post_cov neighbor neighbor_post neighbor_cov neighbor_post_cov y2018 i.dow temp prcp wdsp Trend*, absorb(stationcode) cluster(stationcode)
est store est`p',title("`p'")

gen ldata = log(data)
areg ldata post cov post_cov neighbor neighbor_post neighbor_cov neighbor_post_cov y2018 i.dow temp prcp wdsp Trend*, absorb(stationcode) cluster(stationcode)
est store est`p'log,title("log(`p')")
}

estout estNO2log estSO2log estPM25log estO3log estCOlog ///
using "tableProvTrendDay3_HubeiNeighbor.tex", ///
keep(post post_cov neighbor_post_cov cov neighbor neighbor_post neighbor_cov y2018 *dow temp prcp wdsp Trend* _cons) ///
order(post post_cov neighbor_post_cov) ///
varlabel(post "Post" cov "Y2020" post_cov "Post $\times$ Y2020" neighbor "Hubei" neighbor_post "Post $\times$ Hubei" neighbor_cov "Y2020 $\times$ Hubei" neighbor_post_cov "Post $\times$ Y2020 $\times$ Hubei" y2018 "Y2018" temp "Temperature" prcp "Precipitation" wdsp "Wind speed" _cons "\_cons") ///
cells(b(star fmt(%8.3f %8.3f %8.3f %8.3f %9.3g)) se(par)) collabels(none) eqlabels(none) mlabels(none) ///
prefoot(\hline) stats(N r2, labels(Observations "R-square") fmt(%9.0f %9.3f) ) ///
style(tex) starlevels("$^{*}$" 0.1 "$^{**}$" 0.05 "$^{***}$" 0.01) replace









