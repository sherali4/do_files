clear all
gen inn = ""
gen okpo = ""
gen bob = ""
gen satr = ""
gen gr = ""
gen miqdor = .

save long, replace

capture mkdir ustunlar



capture {
	program drop ustun
}

program ustun
	args grafa
	use baza, clear
	keep inn okpo bob satr `grafa'
	rename `grafa' miqdor
	gen gr = "`grafa'"
	order inn okpo bob satr gr miqdor
	save "bob/`grafa'"
	use long, replace
	append using "bob/`grafa'" 
	save long, replace
end

	local i = 1
while `i' <= 8 {
    generate number`i' = `i'
    ustun g`i'
	local i = `i' + 1
}





