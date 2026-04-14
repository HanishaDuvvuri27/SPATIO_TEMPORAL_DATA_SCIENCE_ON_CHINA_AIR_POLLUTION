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

keep stationcode provorg proven
duplicates drop
tab provorg
tab proven
}
