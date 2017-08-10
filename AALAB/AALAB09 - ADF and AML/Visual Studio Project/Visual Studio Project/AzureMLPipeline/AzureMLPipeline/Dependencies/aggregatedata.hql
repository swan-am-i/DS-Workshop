set hive.mapred.supports.subdirectories=true;
set mapred.input.dir.recursive=true;
set hive.optimize.listbucketing=false;
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode = nonstrict;

-- Create the Raw CDR Table
drop table if exists DimCustomer; 
create external table DimCustomer  (
  Age int,
  AnnualIncome BigInt,
  CallDropRate Double,
  CallFailureRate Double,
  CallingNum String,
  CustomerID Int,
  CustomerSuspended String,
  Education String,
  Gender String,
  HomeOwner String,
  MaritalStatus String,
  MonthlyBilledAmount Int,
  NoAdditionalLines Int,
  NumberOfComplaints Int,
  NumberOfMonthUnpaid Int, 
  NumDaysContractEquipmentPlanExpiring Int,
  Occupation String,
  PenaltyToSwitch Int,
  State String,
  TotalMinsUsedInLastMonth Int,
  UnpaidBalance Int, 
  UsesInternetService String,
  UsesVoiceService String, 
  PercentageCallOutsideNetwork Double,
  Churn Int
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
 STORED AS TEXTFILE 
LOCATION '${hiveconf:CustomerData}'
tblproperties ("skip.header.line.count"="1");

ALTER TABLE CallsPartitioned ADD IF NOT EXISTS PARTITION(year=${hiveconf:Year}, month=${hiveconf:Month});

select count(*)
from CallsPartitioned cp
WHERE cp.Year = ${hiveconf:Year} 
AND cp.Month = ${hiveconf:Month};

select count(*)
from CallsPartitioned;

drop table if exists AggregatedData; 
create external table AggregatedData  (   
   CallingNum string,   
   Totalcallduration int,
   AvgCallduration int
) partitioned by ( year int, month int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
 STORED AS TEXTFILE
LOCATION '${hiveconf:AggregatedData}';

 -- Generate aggregated data
INSERT OVERWRITE TABLE AggregatedData PARTITION(year=${hiveconf:Year} , month=${hiveconf:Month}) 
SELECT 
   CallingNum, 
   sum(callperiod) as Totalcallduration, 
   avg(callperiod) as AvgCallduration
FROM CallsPartitioned cp
WHERE cp.Year = ${hiveconf:Year} 
AND cp.Month = ${hiveconf:Month} 
GROUP BY  CallingNum;

set hive.exec.dynamic.partition.mode=nonstrict;
drop table if exists Customer360 ; 
create external table Customer360   (   
  Age int,
  AnnualIncome BigInt,
  CallDropRate Double,
  CallFailureRate Double,
  CallingNum String,
  CustomerID Int,
  CustomerSuspended String,
  Education String,
  Gender String,
  HomeOwner String,
  MaritalStatus String,
  MonthlyBilledAmount Int,
  NoAdditionalLines Int,
  NumberOfComplaints Int,
  NumberOfMonthUnpaid Int, 
  NumDaysContractEquipmentPlanExpiring Int,
  Occupation String,
  PenaltyToSwitch Int,
  State String,
  TotalMinsUsedInLastMonth Int,
  UnpaidBalance Int, 
  UsesInternetService String,
  UsesVoiceService String, 
  PercentageCallOutsideNetwork Double,
  Totalcallduration int,
  AvgCallduration int
) partitioned by ( year int, month int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
STORED AS TEXTFILE 
LOCATION '${hiveconf:Customer360}';


INSERT OVERWRITE TABLE Customer360 
PARTITION(year, month) 
select 
  c.Age,
  c.AnnualIncome,
  c.CallDropRate,
  c.CallFailureRate,
  c.CallingNum,
  c.CustomerID,
  c.CustomerSuspended,
  c.Education,
  c.Gender,
  c.HomeOwner,
  c.MaritalStatus,
  c.MonthlyBilledAmount,
  c.NoAdditionalLines,
  c.NumberOfComplaints,
  c.NumberOfMonthUnpaid, 
  c.NumDaysContractEquipmentPlanExpiring,
  c.Occupation,
  c.PenaltyToSwitch,
  c.State,
  c.TotalMinsUsedInLastMonth,
  c.UnpaidBalance, 
  c.UsesInternetService,
  c.UsesVoiceService, 
  c.PercentageCallOutsideNetwork,
  a.Totalcallduration int,
  a.AvgCallduration int,
  a.Year,
  a.Month
FROM AggregatedData a, DimCustomer c 
WHERE a.CallingNum = c.CallingNum
AND a.Year = ${hiveconf:Year} 
AND a.Month = ${hiveconf:Month} 

