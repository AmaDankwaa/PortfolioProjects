****************************************************************
*URINALYSIS PROJECT
*AUTHOR: BERNICE AMEYAW
*12.10.2020*
****************************************************************

*making imported columns which are recognized as strings numbers since they contain only numbers
destring sex, replace
destring category, replace
destring urobilinogen, replace
destring blood, replace
destring bilirubin, replace
destring ketones, replace
destring glucose, replace
destring protein, replace
destring nitrite, replace
destring leukocytes, replace
destring creatininegl, replace
destring albumin, replace
destring pcrationeg, replace
destring acrationeg, replace
destring color, replace
destring appearance, replace
destring rtec, replace
destring acratio

*defining and labling variables
label define sex 0 "0 male" 1 "1 female"
label val sex sex

replace category = 8 if category ==0
label define category 1 "1 cyesis hypertension" 2 "2 cyesis & diabetes" 3 "3 cyesis, hypertension & diabetes" 4 "4 cyesis" 5 "5 diabetes & hypertension" 6 "6 diabetes" 7 "7 hypertension" 8 "8 unknown" 9 "9 cyesis & impaired glucose tolerance"
label val category category

label define urobilinogen 0 "0 normal" 1 "1 increased"
label val urobilinogen urobilinogen

label define blood 0 "0 negative" 1 "1 1+" 2 "2 2+" 3 "3 3+" 4 "4 trace"
label val blood blood

label define bilirubin 0 "0 negative" 1 "1 1+" 2 "2 2+" 3 "3 3+" 4 "4 trace"
label val bilirubin bilirubin

label define ketones 0 "0 negative" 1 "1 1+" 2 "2 2+" 3 "3 3+" 4 "4 trace"
label val ketones ketones

label define glucose 0 "0 negative" 1 "1 1+" 2 "2 2+" 3 "3 3+" 4 "4 trace"
label val glucose glucose

label define protein 0 "0 negative" 1 "1 1+" 2 "2 2+" 3 "3 3+" 4 "4 trace"
label val protein protein

label define leukocytes 0 "0 negative" 1 "1 1+" 2 "2 2+" 3 "3 3+" 4 "4 trace"
label val leukocytes leukocytes

label define appearance 0 "1 clear" 1 "2 cloudy"
label val appearance appearance

label define albumin 1 "1 >300mg/gcr"
label val albumin albumin

label define acrationeg 1 "1 >=300"
label val acrationeg acrationeg

label define pcrationeg 1 "1 >=0.5"
label val pcrationeg pcrationeg

label define color 1 "1 straw" 2 "2 light yellow" 3 "3 yellow" 4 "4 amber" 5 "5 dark brown" 6 "6 red" 7 "7 other"
label val color color

label define pcrationeg 1 "1 >=0.5"
label val pcrationeg pcrationeg

label define nitrite 0 "0 negative" 1 "1 positive"
label val nitrite nitrite

*generating age ranges for AGE and defining
generate ageranges = 1 if AGE < 5
replace ageranges = 2 if AGE >= 5 
replace ageranges = 3 if AGE >= 15 
replace ageranges = 4 if AGE >= 25 
replace ageranges = 5 if AGE >= 45 
replace ageranges = 6 if AGE >= 65

label define ageranges 1 "1 < 5yrs" 2 "2 5-14yrs" 3 "3 15-24yrs" 4 "4 25-44yrs" 5 "5 45-64yrs" 6 "6 >64yrs"
label values ageranges ageranges

*descriptive statistics
sum AGE
tab ageranges sex, row
tab category ageranges

*generating and defining albuminuria
generate albuminuria = 2 if albumin >= 0.15
replace albuminuria = 3 if albumin < 0.15
replace albuminuria = 1 if albumin == 1

label define albuminuria 1 "1 macroalbuminuria" 2 "2 microalbuminuria" 3 "3 normal"
label val albuminuria albuminuria

tab albuminuria
tab albuminuria sex, row

*relationship between albuminuria and leukocytes (leukocytes ie pyruvia is the disease and albuminuria is the exposure)
tab albuminuria leukocytes, row
*tab albuminuria leukocytes, chi (unless albuminuria and leukocytes are categorized into yes and no)

*nitrite prevalence, data in nitrite is wrong, use nitrie_n
label define nitrite_n 0 "0 negative" 1 "1 positive"
label val nitrite_n nitrite_n
tab nitrite_n
tab category nitrite_n

*tab ANC and Ph
generate pH_ranges = 1 if PH < 4.6
replace pH_ranges = 2 if PH >=4.6
replace pH_ranges = 3 if PH >8
label define pH_ranges 1 "1 acidic" 2 "2 normal" 3 "3 alkalinie"
label val pH_ranges pH_ranges

generate cyesis = 0 if category <= 4
replace cyesis = 1 if category > 4
replace cyesis = 0 if category == 9
label define cyesis 1 "1 no" 0 "0 yes"
lab val cyesis cyesis

tab cyesis pH_ranges, row

*tabulate protein, pc ratio, and ac ratio
tab proteinuria
tab albuminuria
tab pcrationeg
tab acrationeg
sum rtec

*generate pyuria to be if leukocytes is 3+
generate pyuria = 0 if leukocytes < 2
replace pyuria = 1 if leukocytes >= 2
replace pyuria = 0 if leukocytes >= 4
label define pyuria 0 "0 no" 1 "1 yes"
label val pyuria pyuria

*generate albuminuria yes for micro and macroalbuminuria
generate albuminuriayn = 0 if albuminuria > 2
replace albuminuriayn = 1 if  albuminuria <= 2
label define albuminuriayn 0 "0 no" 1 "1 yes"
lab val albuminuriayn albuminuriayn

cs pyuria albuminuriayn
logistic pyuria albuminuriayn

tab pyuria
drop pyuria


label drop cyesis


















graph bar (count), over (ageranges) over (sex) ytitle("Participants (%)") title("Gender Age Distribution Among Participants")

drop ageranges
















replace proteinuria = 1 if protein == 1
label define proteinuria 1 ">=" 2 "2 mild" 3 "3 normal"
label val nitrite nitrite

drop proteinuria


























