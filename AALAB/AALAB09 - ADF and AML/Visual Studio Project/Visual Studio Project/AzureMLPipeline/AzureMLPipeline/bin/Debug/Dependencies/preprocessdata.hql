set hive.mapred.supports.subdirectories=true;
set mapred.input.dir.recursive=true;
set hive.optimize.listbucketing=false;
SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode = nonstrict;

-- Create the Raw CDR Table
drop table if exists GenCDRRaw; 
create external table GenCDRRaw (
   RecordType string,
   SystemIdentity string,
   FileNum string,
   SwitchNum string,
   CallingNum string,
   CallingIMSI string,
   CalledNum string,
   CalledIMSI string,
   CallDate string,
   CallTime string,
   TimeType string,
   CallPeriod string,
   CallingCellID string,
   CalledCellID string,
   ServiceType string,
   Transfer string,
   IMEI string,
   EndType string,
   IncomingTrunk string,
   OutgoingTrunk string,
   MSRN string,
   CalledNum2 string,
   FCIFlag string,
   DateTime string
)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
 STORED AS TEXTFILE 
LOCATION '${hiveconf:GenRawData}'
tblproperties ("skip.header.line.count"="1");

-- Create partitioned table
drop table if exists CallsPartitioned; 
create external table CallsPartitioned (   
   RecordType string,
   SystemIdentity string,
   FileNum string,
   SwitchNum string,
   CallingNum string,
   CallingIMSI string,
   CalledNum string,
   CalledIMSI string,
   CallDate string,
   CallTime string,
   TimeType string,
   CallPeriod int,
   CallingCellID string,
   CalledCellID string,
   ServiceType string,
   Transfer string,
   IMEI string,
   EndType string,
   IncomingTrunk string,
   OutgoingTrunk string,
   MSRN string,
   CalledNum2 string,
   FCIFlag string,
   DateTime string
) partitioned by ( year int, month int)
ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' 
 STORED AS TEXTFILE 
LOCATION '${hiveconf:CallsPartitioned}';


-- Insert into partitioned table
set hive.exec.dynamic.partition.mode=nonstrict;
INSERT OVERWRITE TABLE CallsPartitioned PARTITION( year , month) 
SELECT 
   RecordType,
   SystemIdentity,
   FileNum,
   SwitchNum,
   CallingNum,
   CallingIMSI,
   CalledNum,
   CalledIMSI,
   CallDate,
   CallTime,
   TimeType,
   cast(callperiod as int) as CallPeriod, 
   CallingCellID,
   CalledCellID,
   ServiceType,
   Transfer,
   IMEI,
   EndType,
   IncomingTrunk,
   OutgoingTrunk,
   MSRN string,
   CalledNum2,
   FCIFlag,
   DateTime,
  ${hiveconf:Year}, 
  ${hiveconf:Month}
FROM GenCDRRaw;
