/* Compare row/quantity signatures and count missing enrichment values. */
proc fedsql sessref=&CAS_SESSION;
  create table &caslib..validation_summary_cas {options replace=true} as
  select 'x3_lean' as TableName,count(*) as CountRows,sum(Quantity) as QuantityTotal,
         sum(case when Country_Name is null then 1 else 0 end) as MissingCountry,
         sum(case when Item is null then 1 else 0 end) as MissingProduct,
         sum(case when CustomerName is null then 1 else 0 end) as MissingCustomer
  from &caslib..x3_lean
  union all
  select 'finalist_lean',count(*),sum(Quantity),
         sum(case when Country_Name is null then 1 else 0 end),
         sum(case when Item is null then 1 else 0 end),
         sum(case when CustomerName is null then 1 else 0 end)
  from &caslib..finalist_lean
  union all
  select 'finalist_partitioned',count(*),sum(Quantity),
         sum(case when Country_Name is null then 1 else 0 end),
         sum(case when Item is null then 1 else 0 end),
         sum(case when CustomerName is null then 1 else 0 end)
  from &caslib..finalist_partitioned
  union all
  select 'result_standard',count(*),sum(Quantity),
         sum(case when Country_Name is null then 1 else 0 end),
         sum(case when Item is null then 1 else 0 end),
         sum(case when CustomerName is null then 1 else 0 end)
  from &caslib..result_standard
  union all
  select 'result_dvr',count(*),sum(Quantity),
         sum(case when Country_Name is null then 1 else 0 end),
         sum(case when Item is null then 1 else 0 end),
         sum(case when CustomerName is null then 1 else 0 end)
  from &caslib..result_dvr
  union all
  select 'result_compressed',count(*),sum(Quantity),
         sum(case when Country_Name is null then 1 else 0 end),
         sum(case when Item is null then 1 else 0 end),
         sum(case when CustomerName is null then 1 else 0 end)
  from &caslib..result_compressed;
quit;

data work.validation_summary;
  set &caslib..validation_summary_cas;
run;

proc sql;
  create table work.validation_checked as
  select a.*,
         case when a.CountRows=b.CountRows and a.QuantityTotal=b.QuantityTotal then 1 else 0 end as SignatureMatchesBaseline
  from work.validation_summary a,
       (select CountRows,QuantityTotal from work.validation_summary where TableName='x3_lean') b;
quit;

proc print data=work.validation_checked noobs; run;
%put NOTE: SignatureMatchesBaseline must be 1 for every row.;
%put NOTE: Missing counts are expected to be zero for synthetic data.;
