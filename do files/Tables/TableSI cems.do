set more off

* 1) CEMS concentration
loc P = "NOX SO2"
foreach p of loc P {

use allair_firmLNY_balanced.dta, clear
keep if pollutant=="`p'"
gen year=year(edate)

gen post = time>=0
gen cov = year==2020
gen post_cov = post*cov
egen firmid = group(firm_name provorg)

preserve
keep if provorg=="Hubei"
reg concentration post cov post_cov i.firmid i.dow, cluster(firmid)
est store est`p'_Hubei,title("`p'")

gen lconcentration = log(concentration)
reg lconcentration post cov post_cov i.firmid i.dow, cluster(firmid)
est store est`p'log_Hubei,title("log(`p')")
restore

preserve
keep if provorg!="Hubei"
reg concentration post cov post_cov i.firmid i.dow, cluster(firmid)
est store est`p'_nonHubei,title("`p'")

gen lconcentration = log(concentration)
reg lconcentration post cov post_cov i.firmid i.dow, cluster(firmid)
est store est`p'log_nonHubei,title("log(`p')")
restore

reg concentration post cov post_cov i.firmid i.dow, cluster(firmid)
est store est`p'_all,title("`p'")

gen lconcentration = log(concentration)
reg lconcentration post cov post_cov i.firmid i.dow, cluster(firmid)
est store est`p'log_all,title("log(`p')")
}




* 2) # firms
loc P = "NOX SO2"
foreach p of loc P {

use `p'nfirms.dta, clear
keep if pollutant=="`p'"

gen post = time>=0
gen cov = year==2020
gen post_cov = post*cov


preserve
keep if provorg=="Hubei"
reg nfirms post cov post_cov i.provid i.dow, cluster(provid)
est store est`p'N_Hubei,title("`p'")
restore

preserve
keep if provorg!="Hubei"
reg nfirms post cov post_cov i.provid i.dow, cluster(provid)
est store est`p'N_nonHubei,title("`p'")
restore

reg nfirms post cov post_cov i.provid i.dow, cluster(provid)
est store est`p'N_all,title("`p'")

}



loc C="all Hubei nonHubei"
foreach c of loc C {
estout estNOXN_`c' estNOX_`c' estNOXlog_`c' estSO2N_`c' estSO2_`c' estSO2log_`c' ///
using "CEMSdoublediff_`c'.tex", ///
keep(post post_cov cov *dow _cons) ///
order(post post_cov) ///
varlabel(post "Post" cov "Y2020" post_cov "Post $\times$ Y2020" _cons "\_cons") ///
cells(b(star fmt(%8.3f %8.3f %8.3f %8.3f %9.3g)) se(par)) collabels(none) eqlabels(none) mlabels(none) ///
prefoot(\hline) stats(N r2, labels(Observations "R-square") fmt(%9.0f %9.3f) ) ///
style(tex) starlevels("$^{*}$" 0.1 "$^{**}$" 0.05 "$^{***}$" 0.01) replace
}

