local kun $kun

local papka "C:\Users\user\Desktop\tajriba"

local katalog "C:\Users\user\Desktop\tajriba"

cd "`papka'\`kun'\csv"
use 1-kb-jami

duplicates drop inn okpo bob satr v6, force

save "zaprosga.dta", replace


keep inn okpo
duplicates drop

save "zapros_natijasi", replace



capture mkdir "boblar"
foreach var in 1 2 3 4 5 6 10 111 113 124 125 126 137 1410 15 16 17 {
    use "zaprosga.dta", replace
	keep if bob == "`var'"
	save "boblar/`var'-bob.dta"
}





capture {
	program drop razd
}




capture mkdir "satrlar"



program razd
	args bob satr gr
	use "boblar/`bob'-bob.dta", replace
	keep if satr == "`satr'"
	keep inn okpo bob satr `gr'
	rename `gr' miqdor
	drop if miqdor == . | miqdor == 0
	gen gr = "`gr'"
	order inn okpo bob satr gr miqdor
	save "satrlar/`bob'-`satr'-`gr'.dta", replace
	use "zapros_natijasi.dta", replace
	merge m:m inn okpo using "satrlar/`bob'-`satr'-`gr'.dta", keep(master match) keepusing(miqdor) nogenerate
	rename miqdor _`bob'_`satr'_`gr'
	save "zapros_natijasi.dta", replace
end



/*
program razd
	args bob satr gr
	use "baza.dta", replace
	keep if bob == "`bob'" & satr == "`satr'"
	keep inn okpo bob satr `gr'
	rename `gr' miqdor
	drop if miqdor == . | miqdor == 0
	gen gr = "`gr'"
	order inn okpo bob satr gr miqdor
	save "satrlar/`bob'-`satr'-`gr'.dta", replace
	use "topshirganlar.dta", replace
	merge m:m inn okpo using "satrlar/`bob'-`satr'-`gr'.dta", keep(master match) keepusing(miqdor) nogenerate
	rename miqdor _`bob'_`satr'_`gr'
	save "topshirganlar.dta", replace
end


*/

do tanlanma


merge m:m inn okpo using "katalog.dta", keep(master match)
gen soato4 = substr(soato, 1, 4)
gen soato7 = substr(soato, 1, 7)
order inn okpo soato4 soato7 name_rus oked

export excel using "zapros_natijasi.xlsx", sheet("korxonalar") sheetreplace firstrow(variables)





















