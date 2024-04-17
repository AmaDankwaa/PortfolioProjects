****************************************************************
*PROJECT: URINALYSIS FINAL - DATA FROM MR. HOMIAH
*AUTHOR: BERNICE AMEYAW
*DATE: 25/10/2023
****************************************************************

*defining and labling variables
label define SEX 0 "male" 1 "female"
label val SEX SEX

label define CATEGORY 1 "cyesis & hypertension" 2 "cyesis & diabetes" 3 "cyesis, hypertension & diabetes" 4 "cyesis only" 5 "diabetes & hypertension" 6 "diabetes only" 7 "hypertension only" 8 "8 unknown" 10 "cyesis & impaired glucose tolerance"
label val CATEGORY CATEGORY

label define UROBILINOGEN 0 "normal" 1 "1+" 2 "2+"
label val UROBILINOGEN UROBILINOGEN

label define BLOOD 0 "negative" 1 "1+" 2 "2+" 3 "3+" 4 "trace"
label val BLOOD BLOOD

label define BILIRUBIN 0 "negative" 1 "1+" 2 "2+" 3 "3+" 4 "trace"
label val BILIRUBIN BILIRUBIN

label define KETONES 0 "negative" 1 "1+" 2 "2+" 3 "3+" 4 "trace"
label val KETONES KETONES

label define GLUCOSE 0 "negative" 1 "1+" 2 "2+" 3 "3+" 4 "trace"
label val GLUCOSE GLUCOSE

label define PROTEIN 0 "negative" 1 "1+" 2 "2+" 3 "3+" 4 "trace"
label val PROTEIN PROTEIN

label define LEUKOCYTES 0 "negative" 1 "1+" 2 "2+" 3 "3+" 4 "trace"
label val LEUKOCYTES LEUKOCYTES

label define APPEARANCE 0 "clear" 1 "cloudy"
label val APPEARANCE APPEARANCE

label define ALBUMINgl 400 "OVER"
label val ALBUMINgl ALBUMINgl


*generating and defining albuminuria
generate ALBUMINURIA = 1 if AC < 30
replace ALBUMINURIA = 2 if AC >= 30
replace ALBUMINURIA = 3 if AC > 300
replace ALBUMINURIA = . if AC == .
label define ALBUMINURIA 1 "normal" 2 "mild albuminuria" 3 "overt albuminuria"
label val ALBUMINURIA ALBUMINURIA

*generating and defining high PC ratio
generate pc_use = 0 if PC <= 0.12
replace pc_use = 1 if PC > 0.12
replace pc_use = . if PC == .
label define pc_use 0 "normal" 1 "high PC"
label val pc_use pc_use

*generating and defining proteinuria
generate proteinuria = 0 if PC < 0.15
replace proteinuria = 1 if PC >= 0.15
replace proteinuria = 2 if PC > 0.5
replace proteinuria = . if PC == .
label define proteinuria 0 "normal" 1 "mild proteinuria" 2 "severe proteinuria"
label val proteinuria proteinuria

label define COLOR 1 "straw" 2 "light yellow" 3 "yellow" 4 "amber" 5 "dark brown" 6 "red" 7 "other"
label val COLOR COLOR

label define NITRITE 0 "negative" 1 "positive"
label val NITRITE NITRITE

*generating age ranges for AGE and defining
generate ageranges = 1 if AGE < 5
replace ageranges = 2 if AGE >= 5 
replace ageranges = 3 if AGE >= 15 
replace ageranges = 4 if AGE >= 25 
replace ageranges = 5 if AGE >= 45 
replace ageranges = 6 if AGE >= 65
replace ageranges = . if AGE == .

label define ageranges 1 "children under 5yrs" 2 "5-14yrs" 3 "15-24yrs" 4 "25-44yrs" 5 "45-64yrs" 6 ">64yrs"
label values ageranges ageranges

*generating and labling SG ranges
generate SG_label = 0 if SG < 1.005
replace SG_label = 1 if SG >= 1.005
replace SG_label = 2 if SG > 1.030
replace SG_label = . if SG == .
label define SG_label 0 "low" 1 "normal" 2 "high"
label values SG_label SG_label

label drop SG_label

*generating and labling ph ranges
generate ph_label = 0 if PH < 4.5
replace ph_label = 1 if PH >= 4.5
replace ph_label = 2 if PH > 5.0
replace ph_label = . if PH == .
label define ph_label 0 "acidic" 1 "normal" 2 "basic"
label values ph_label ph_label

*descriptive statistics
sum AGE
graph pie, over(CATEGORY) pl(_all percent)
tab CATEGORY, m
tab ALBUMINURIA, m
tab AC,m
tab ALBUMINURIA SG_label, 
tab ALBUMINURIA SEX, m cell
tab SEX, m
tab ageranges ALBUMINURIA, m
tab ageranges ALBUMINURIA, column
tab CATEGORY ALBUMINURIA
tab SEX ALBUMINURIA, column
tab var31 ALBUMINURIA, column

*correlation of two categorical data
tab ALBUMINURIA SG_label, chi2
tab ALBUMINURIA ph_label, chi2
tab ALBUMINURIA NITRITE, chi2
tab ALBUMINURIA LEUKOCYTES, chi2
tab ALBUMINURIA KETONES, chi2
tab ALBUMINURIA GLUCOSE, chi2
tab ALBUMINURIA COLOR, chi2
tab ALBUMINURIA APPEARANCE, chi2
tab ALBUMINURIA BLOOD, column
tab CATEGORY ALBUMINURIA, chi2
tab ALBUMINURIA BLOOD,chi2
tab ALBUMINURIA BILIRUBIN, chi2
tab ALBUMINURIA SEX, chi2
tab ALBUMINURIA ageranges, chi2


*adding cell makes it draw the percentage table using the overall total
tab CATEGORY ALBUMINURIA, chi2 cell

*if the continuous data SG was being used,
anova SG ALBUMINURIA


*generating and defining urine acidity
generate ph_acidity = 0 if PH <
log


***************************************
*13/11/2023
*redefining the population to unkown, cyesis, diabetes, and hypertension
generate CATEGORYNEW = 1 if CATEGORY == 1
replace CATEGORYNEW = 2 if CATEGORY == 2
replace CATEGORYNEW = 3 if CATEGORY == 3
replace CATEGORYNEW = 4 if CATEGORY == 4
replace CATEGORYNEW = 5 if CATEGORY == 5
replace CATEGORYNEW = 6 if CATEGORY == 6
replace CATEGORYNEW = 7 if CATEGORY == 7
replace CATEGORYNEW = 8 if CATEGORY == 8
replace CATEGORYNEW = 10 if CATEGORY == 10

label define CATEGORYNEW 1 "cyesis" 2 "cyesis" 3 "cyesis" 4 "cyesis" 5 "diabetes" 6 "diabetes" 7 "hypertension only" 8 "8 unknown" 10 "cyesis"
label val CATEGORYNEW CATEGORYNEW

*extracted new data definitiono from excel and labeled as var31
label define var31 1 "cyesis" 2 "diabetes" 3 "hypertension" 4 "unknown"
label val var31 var31

tab var31
tab var31 ALBUMINURIA, column

*obtaining pictorial views for the significant chi squares
graph bar (count), over(KETONES) by(ALBUMINURIA, total) 

graph bar (count), over(KETONES) by(ALBUMINURIA, total) bar(1, color(blue) lcolor(black) lwidth(thick)) bar(2, color(red) lcolor(black) lwidth(thick)) bar(3, color(green) lcolor(black) lwidth(thick))

graph bar, over (SG_label) over (ALBUMINURIA)
graph bar, over (NITRITE) over (ALBUMINURIA)
graph bar, over (LEUKOCYTES) over (ALBUMINURIA)
graph bar, over (KETONES) over (ALBUMINURIA)
graph bar, over (GLUCOSE) over (ALBUMINURIA)
graph bar, over (APPEARANCE) over (ALBUMINURIA)
graph bar, over (var31) over (ALBUMINURIA)
graph bar, over (BLOOD) over (ALBUMINURIA)

tab SG_label ALBUMINURIA, column
tab NITRITE ALBUMINURIA, column
tab LEUKOCYTES ALBUMINURIA, column
tab KETONES ALBUMINURIA, column
tab GLUCOSE ALBUMINURIA, column
tab APPEARANCE ALBUMINURIA, column
tab var31 ALBUMINURIA, column
tab BLOOD ALBUMINURIA, column

pwcorr SG_label ph_label NITRITE LEUKOCYTES KETONES GLUCOSE COLOR APPEARANCE BLOOD BILIRUBIN PROTEIN SEX ageranges var31 ALBUMINURIA, star(0.05)




















