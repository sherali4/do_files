local papka "C:\Users\user\Desktop\tajriba"
cd `papka'

use 1-kb-jami

keep if bob == "3" & inlist(satr, "201", "224")

collapse g1, by (inn okpo satr)

destring satr, replace force

reshape wide g1, i(inn okpo) j(satr)

egen jami = rowtotal(g1201 g1224)

save tushum

use tushum, replace

merge m:m inn using "soliq_hajm.dta", keep(match)
drop _merge
rename hajm soliq_hajmi

gen farq = abs(jami - soliq_hajmi)

drop if farq <= 2
rename jami statistikada_hajmi
merge m:m inn using "katalog.dta", keep(master match)
drop _merge
export excel using "soliq_farqi.xlsx", sheet("tafovut") sheetreplace firstrow(variables)





use 1-kb-jami, replace

keep inn

duplicates drop

save jami_topshirganlar

use jami_topshirganlar, replace
merge m:m inn using "qat_iy_soliq.dta", keep(match)
drop _merge

merge m:m inn using "tushum.dta", keep(master match)
drop _merge

capture replace jami = 0 if missing( jami )


drop if jami > 100







