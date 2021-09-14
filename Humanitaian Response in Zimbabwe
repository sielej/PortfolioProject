y]
     --updating table to correct a typo in 'country' column

UPDATE WeeklyBackup
SET Country = 'Zimbabwe'
WHERE Country = 'zimbambwe'

--1
--looking at lead organizatons activities in various districts in zimbabwe

select lead_organization, country, province, district
from WeeklyBackup
group by lead_organization, country, province, district
order by Lead_Organization asc

--2
--looking at individuals targeted and individuals reached by various lead groups

select sum(No_of_Individual_Targeted) as IndividualsTargeted, sum(Total_No_of_Individuals_Reached) as IndividualsReached
from WeeklyBackup

--3
--looking at activities by sub-cluster

select sub_cluster, count(Response_Activity) as numberofactivities
from WeeklyBackup
group by sub_cluster

--4
--looking at activities per district

select district, count(Response_Activity) as ResponseActivityPerDistrict
from WeeklyBackup
group by district

--5
--looking at status of response activities
select status, count(status) as statuscount
from WeeklyBackup
group by status


--looking at the number of each gender and age that were reached

select Lead_Organization, No_of_Girls_Reached, No_of_Boys_Reached, No_of_Women_Reached, No_of_Men_Reached
from WeeklyBackup
where No_of_Men_Reached is not null
group by Lead_Organization, No_of_Girls_Reached, No_of_Boys_Reached, No_of_Women_Reached, No_of_Men_Reached
