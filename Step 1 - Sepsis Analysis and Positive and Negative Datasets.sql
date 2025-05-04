--------------------------------------------------------------------------------------------------------
---------------------------------  SEPSIS ANALYSIS -------------------------------------------------------
----------------------------------------------------------------------------------------------------------

/*
 diagnoses_icd: This table contains diagnosis codes (ICD-9 or ICD-10) associated with patient admissions. 
Specific diagnosis codes related to sepsis (e.g., septicemia, severe sepsis, septic shock) can help identify patients with confirmed or suspected sepsis.;
 */

select * from diagnoses_icd di 
select * from d_icd_diagnoses did 
where did.long_title like '%septicemia%'
/*9050	77181	NB septicemia [sepsis]	Septicemia [sepsis] of newborn
11404	99592	Severe sepsis	Severe sepsis
13564	67020	Puerperal sepsis-unsp	Puerperal sepsis, unspecified as to episode of care or not applicable
13565	67022	Puerprl sepsis-del w p/p	Puerperal sepsis, delivered, with mention of postpartum complication
13566	67024	Puerperl sepsis-postpart	Puerperal sepsis, postpartum condition or complication*/

SELECT subject_id, hadm_id, icd9_code
FROM diagnoses_icd
WHERE icd9_code LIKE '99591%' -- Sepsis
   OR icd9_code LIKE '99592%' -- Severe sepsis
   OR icd9_code LIKE '78552%' -- Septic shock

select * from d_icd_diagnoses did 
where icd9_code LIKE '99591%' -- Sepsis
   OR icd9_code LIKE '99592%' -- Severe sepsis
   OR icd9_code LIKE '78552%' -- Septic shock
   
select di.icd9_code, p.expire_flag , count(distinct p.subject_id) from patients p 
inner join diagnoses_icd di on di.subject_id = p.subject_id 
where icd9_code LIKE '99591%' -- Sepsis
   OR icd9_code LIKE '99592%' -- Severe sepsis
   OR icd9_code LIKE '78552%' -- Septic shock
group by di.icd9_code, p.expire_flag 

select p.* from patients p 
inner join diagnoses_icd di on di.subject_id = p.subject_id 
where icd9_code LIKE '99591%' -- Sepsis
   OR icd9_code LIKE '99592%' -- Severe sepsis
   OR icd9_code LIKE '78552%' -- Septic shock
order by p.dob desc

select diagnosis,count(*) from admissions a
where diagnosis like '%SEPSIS%'
group by diagnosis
order by 1 desc;

select count(distinct subject_id) from admissions a
where diagnosis like '%SEPSIS%'
;--1633

select count(distinct a.subject_id) from admissions a
inner join diagnoses_icd di on di.subject_id = a.subject_id and di.hadm_id = a.hadm_id 
--where diagnosis like '%SEPSIS%'
where icd9_code LIKE '99591%' -- Sepsis
   OR icd9_code LIKE '99592%' -- Severe sepsis
   OR icd9_code LIKE '78552%' -- Septic shock
;--4689

select count(distinct a.subject_id) from patients p
inner join admissions a on a.subject_id = p.subject_id
inner join diagnoses_icd di on di.subject_id = a.subject_id and di.hadm_id = a.hadm_id 
inner join labevents l on l.subject_id = a.subject_id and l.hadm_id =a.hadm_id
inner join d_labitems dl on dl.itemid = l.itemid 
--where diagnosis like '%SEPSIS%' --1627
where icd9_code LIKE '99591%' -- Sepsis
   OR icd9_code LIKE '99592%' -- Severe sepsis
   OR icd9_code LIKE '78552%' -- Septic shock
--4685
   
select * from patients p
inner join admissions a on a.subject_id = p.subject_id
inner join diagnoses_icd di on di.subject_id = a.subject_id and di.hadm_id = a.hadm_id 
inner join d_icd_diagnoses did on did.icd9_code = di.icd9_code 
inner join labevents l on l.subject_id = a.subject_id and l.hadm_id =a.hadm_id
inner join d_labitems dl on dl.itemid = l.itemid 
where diagnosis like '%SEPSIS%' --1627
--where icd9_code LIKE '99591%' -- Sepsis
--   OR icd9_code LIKE '99592%' -- Severe sepsis
--   OR icd9_code LIKE '78552%' -- Septic shock
--4685
and expire_flag = 1
and p.subject_id = 357

select distinct short_title from patients p
inner join admissions a on a.subject_id = p.subject_id
inner join diagnoses_icd di on di.subject_id = a.subject_id and di.hadm_id = a.hadm_id 
inner join d_icd_diagnoses did on did.icd9_code = di.icd9_code 
inner join labevents l on l.subject_id = a.subject_id and l.hadm_id =a.hadm_id
inner join d_labitems dl on dl.itemid = l.itemid 
--where diagnosis like '%SEPSIS%' --1627
where di.icd9_code LIKE '99591%' -- Sepsis
   OR di.icd9_code LIKE '99592%' -- Severe sepsis
   OR di.icd9_code LIKE '78552%' -- Septic shock
--4685
;

select distinct dl."label",l.charttime ,l.value ,l.valuenum ,l.valueuom ,l.flag  from patients p
inner join admissions a on a.subject_id = p.subject_id
inner join diagnoses_icd di on di.subject_id = a.subject_id and di.hadm_id = a.hadm_id 
inner join d_icd_diagnoses did on did.icd9_code = di.icd9_code 
inner join labevents l on l.subject_id = a.subject_id and l.hadm_id =a.hadm_id
inner join d_labitems dl on dl.itemid = l.itemid 
where diagnosis like '%SEPSIS%' --1627
--where icd9_code LIKE '99591%' -- Sepsis
--   OR icd9_code LIKE '99592%' -- Severe sepsis
--   OR icd9_code LIKE '78552%' -- Septic shock
--4685
and expire_flag = 1
and p.subject_id = 357
order by 
dl."label" 
,l.charttime desc

select * from chartevents c 
inner join d_items di on di.itemid = c.itemid 
where c.subject_id = 357

-- 1. Identify the top features for SEPSIS prediction
--heart rate, temperature, white blood cell (WBC) count, SBP, age, DBP, and RR are the six most ranked features

select * from d_items di where itemid in (
211, 220045  -- Heart Rate (beats per minute)
,676,678 -- Temperature (Celsius),Temperature (Fahrenheit)
,442,455,6701 -- Systolic Blood Pressure (SBP):Non-Invasive Blood Pressure systolic,Invasive Blood Pressure systolic, Arterial Blood Pressure systolic
,8368,8440,8441,8555 -- Diastolic Blood Pressure (DBP):Non-Invasive Blood Pressure diastolic,Invasive Blood Pressure diastolic,Invasive Blood Pressure mean,Arterial Blood Pressure diastolic
,618,220210 -- Respiratory Rate (RR)
) order by "label"  

select * from d_labitems where itemid in (51300,51301) -- White Blood Cell (WBC) Count:(WBC) (cells/uL), (WBC) (cells/mm^3)

-- 2.Identify the positive and negative SEPSIS subjects
select p.expire_flag ,di.icd9_code,count(distinct p.subject_id) from patients p
inner join admissions a on a.subject_id = p.subject_id
inner join diagnoses_icd di on di.subject_id = a.subject_id and di.hadm_id = a.hadm_id 
inner join d_icd_diagnoses did on did.icd9_code = di.icd9_code 
inner join labevents l on l.subject_id = a.subject_id and l.hadm_id =a.hadm_id
inner join d_labitems dl on dl.itemid = l.itemid 
where lower(diagnosis) not like lower('%SEPSIS%') --1627
and (
	di.icd9_code LIKE '99591%' -- Sepsis
   	OR di.icd9_code LIKE '99592%' -- Severe sepsis
  	OR di.icd9_code LIKE '78552%' -- Septic shock
   )
--4685
--and expire_flag = 1
--and p.subject_id = 357
group by p.expire_flag ,di.icd9_code
order by p.expire_flag ,di.icd9_code
/* SEPSIS
0	78552	165
0	99591	73
0	99592	219
1	78552	306
1	99591	85
1	99592	385
*/
/* NO-SEPSIS
0	78552	572
0	99591	471
0	99592	910
1	78552	1233
1	99591	497
1	99592	1906
 */
-- 3.Identify the positive SEPSIS subjects feature values

select p.subject_id ,ROUND((cast(a.admittime as date) - cast(p.dob as date))/365.242) as age,ce.charttime ,ce.itemid,ce.value ,ce.valuenum ,ce.valueuom  from patients p
inner join admissions a on a.subject_id = p.subject_id
--inner join icustays i on i.subject_id = a.subject_id and i.hadm_id = a.hadm_id 
inner join chartevents ce on ce.subject_id = a.subject_id and ce.hadm_id = a.hadm_id 
--inner join labevents l on l.subject_id = a.subject_id and l.hadm_id =a.hadm_id
where diagnosis = 'SEPSIS' --1627
and ( 
ce.itemid in(
211, 220045  -- Heart Rate (beats per minute)
,676,678 -- Temperature (Celsius),Temperature (Fahrenheit)
,442,455,6701 -- Systolic Blood Pressure (SBP):Non-Invasive Blood Pressure systolic,Invasive Blood Pressure systolic, Arterial Blood Pressure systolic
,8368,8440,8441,8555 -- Diastolic Blood Pressure (DBP):Non-Invasive Blood Pressure diastolic,Invasive Blood Pressure diastolic,Invasive Blood Pressure mean,Arterial Blood Pressure diastolic
,618,220210 -- Respiratory Rate (RR)
) 
--or l.itemid in (51300,51301) -- White Blood Cell (WBC) Count:(WBC) (cells/uL), (WBC) (cells/mm^3))
)
order by p.subject_id ,a.admittime ,ce.charttime 
--,l.charttime 

-- 3.1.Feature: Age
create table subjects_age as 
(select p.subject_id ,ROUND((cast(a.min_admittime as date) - cast(p.dob as date))/365.242) as age from patients p
inner join (select a.subject_id,min(admittime) as min_admittime from admissions a group by a.subject_id) a
on a.subject_id = p.subject_id
order by p.subject_id)

select p.subject_id ,ROUND((cast(a.min_admittime as date) - cast(p.dob as date))/365.242) as age from patients p
inner join (select a.subject_id,min(admittime) as min_admittime from admissions a where diagnosis != 'SEPSIS' group by a.subject_id) a
on a.subject_id = p.subject_id
order by p.subject_id 

select case when lower(diagnosis) not like '%sepsis%' then 'NO SEPSIS' else 'SEPSIS' end as diag, count(distinct a.subject_id) from subjects_age sa
join admissions a on a.subject_id = sa.subject_id
where age > 64
group by case when lower(diagnosis) not like '%sepsis%' then 'NO SEPSIS' else 'SEPSIS' end
;
/* 
 NO SEPSIS	19581
SEPSIS	950
 */
-- 3.2.Feature: chartevents
--select lab_category,count(*) from(
--select count(distinct subject_id) from(
select a.subject_id,a.hadm_id,ce.charttime 
,case when ce.itemid in (211, 220045) then 'Heart Rate'
	when ce.itemid in (676,678) then 'Temperature (Fahrenheit)'
	when ce.itemid in (442) then 'Non-Invasive Blood Pressure systolic'
	when ce.itemid in (455) then 'Invasive Blood Pressure systolic'
	when ce.itemid in (6701) then 'Arterial Blood Pressure systolic'
	when ce.itemid in (8368) then 'Non-Invasive Blood Pressure diastolic'
	when ce.itemid in (8440) then 'Invasive Blood Pressure diastolic'
	when ce.itemid in (8441) then 'Invasive Blood Pressure mean'
	when ce.itemid in (8555) then 'Arterial Blood Pressure diastolic'
	when ce.itemid in (618,220210) then 'Respiratory Rate (RR)'
end as lab_category
,case when ce.itemid in (676) then (ce.valuenum * 9/5) + 32 else ce.valuenum end as lab_valuenum
,ce.valueuom  from admissions a
inner join chartevents ce on ce.subject_id = a.subject_id and ce.hadm_id = a.hadm_id
inner join subjects_age sa on sa.subject_id = a.subject_id
--where diagnosis = 'SEPSIS'
where lower(diagnosis) not like '%sepsis%'
and ce.itemid in(
211, 220045  -- Heart Rate (beats per minute)
,676,678 -- Temperature (Celsius),Temperature (Fahrenheit)
,442,455,6701 -- Systolic Blood Pressure (SBP):Non-Invasive Blood Pressure systolic,Invasive Blood Pressure systolic, Arterial Blood Pressure systolic
,8368,8440,8441,8555 -- Diastolic Blood Pressure (DBP):Non-Invasive Blood Pressure diastolic,Invasive Blood Pressure diastolic,Invasive Blood Pressure mean,Arterial Blood Pressure diastolic
,618,220210 -- Respiratory Rate (RR)
) 
and sa.age > 64
--and ce.value != cast(ce.valuenum as varchar)
order by a.subject_id ,a.admittime ,ce.charttime
--) a
--group by lab_category
--order by lab_category;

/*Arterial Blood Pressure diastolic	755
Arterial Blood Pressure systolic	759
Heart Rate	174971
Invasive Blood Pressure diastolic	60
Invasive Blood Pressure mean	56677
Invasive Blood Pressure systolic	56891
Non-Invasive Blood Pressure diastolic	60328
Non-Invasive Blood Pressure systolic	73
Respiratory Rate (RR)	168049
Temperature (Fahrenheit)	31868*/


-- 3.3.Feature: labevents - WBC
--select lab_category,count(*) from(
--select count(distinct subject_id) from(
select a.subject_id,a.hadm_id,le.charttime 
,case when le.itemid in (51300) then 'WBC Count (cells/uL)'
	when le.itemid in (51301) then 'White Blood Cells (cells/mm^3)'
end as lab_category
,le.valuenum as lab_valuenum
,le.valueuom  from admissions a
inner join labevents le on le.subject_id = a.subject_id and le.hadm_id = a.hadm_id
inner join subjects_age sa on sa.subject_id = a.subject_id
--where diagnosis = 'SEPSIS'
where lower(diagnosis) not like '%sepsis%'
and le.itemid in(
--51300 not many records, hence excluding this
51301 -- White Blood Cell (WBC) Count:(WBC) (cells/uL), (WBC) (cells/mm^3)
) 
and sa.age > 64
order by a.subject_id ,a.admittime ,le.charttime
--) a
--group by lab_category
--order by lab_category;

/*POSITIVE
WBC Count (cells/uL)	5
White Blood Cells (cells/mm^3)	8198*/

/* NEGATIVE
WBC Count (cells/uL)	36
White Blood Cells (cells/mm^3)	274991*/