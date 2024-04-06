/*
	aos bazasi so'mda integratsiya qilingan.
	AOS da code ustuni klassifikatori mavjud. Bu klassifikator sohalar kesimini bildiradi.
	Klassifikatordan tashqari -1 kod = elektron tijorat, -2 = turizm hududida xizmat ko'rsatish faoliyatini bildiradi.
	Klassifikatori nol bo'lganda, faoliyat turini tanlanmagan hisoblanadi va bu hech qanday faoliyat turini kiritmagan bo'ladi.
	aos hisoboti joriy oy uchun keyingi oyning 15 sanasigacha topshiriladi.
	aos uchun oxirgi topshirilgan oy hisoblanadi.
	papka nomini global o'zgarmasga o'sgartirish kerak
*/

local papka "D:\06.04.2024\05.04.2024baza\AOS"
cd `papka'
capture mkdir "qushimcha"


import delimited "import469.csv", encoding(UTF-8) stringcols(_all) clear
save qushimcha/katalog, replace

import delimited "import469_indicators.csv", encoding(UTF-8) stringcols(_all) clear
save qushimcha/indicators, replace

import delimited "import469_indicators_activities.csv", encoding(UTF-8) stringcols(_all) clear
save qushimcha/indicators_activities, replace



use qushimcha/katalog, replace
destring period, replace force 
keep if periodtype == "M" & stateid == "30" & year == "2024" & period <=2
drop periodtype stateid year
collapse (max) period, by(tin)
save qushimcha/max_period, replace 
keep tin
duplicates drop
save qushimcha/tin, replace

// reporttype reportid siis_id
use qushimcha/katalog, replace
destring period reporttype, replace force
merge m:m tin period using "qushimcha\max_period.dta", keep(match) nogenerate
collapse (max) reporttype, by(tin period)
save qushimcha/max_reporttype, replace

use qushimcha/katalog, replace
destring period reporttype reportid, replace force
merge m:m tin period reporttype using "qushimcha\max_reporttype.dta", keep(match) nogenerate
collapse (max) reportid, by(tin period reporttype)
save qushimcha/max_reportid, replace

use qushimcha/katalog, replace
destring period reporttype reportid siis_id, replace force
merge m:m tin period reporttype reportid using "qushimcha\max_reportid.dta", keep(match) nogenerate
collapse (max) siis_id, by(tin period reporttype reportid)
tostring reportid, replace
save qushimcha/max_siis_id, replace


use qushimcha/max_siis_id, replace
keep tin siis_id
rename siis_id import469_id
tostring import469_id, replace
merge m:m import469_id using "qushimcha/indicators.dta", keep(match) keepusing(siis_id total010 total020) nogenerate
destring total010 total020, replace force
replace total010 = total010/1000
replace total020 = total020/1000
export excel tin total010 total020 using "aos.xlsx", sheet("jami (ming so'mda)") sheetreplace firstrow(variables)

keep tin siis_id
rename siis_id import469_indicators_id 

merge m:m import469_indicators_id using "qushimcha\indicators_activities.dta", keep(match) keepusing(code total010 total020) nogenerate
drop if code == "0"
destring total010 total020, replace force
egen total_row = rowtotal(total010 total020)
drop if total_row == 0


shell rmdir /s /q "qushimcha"