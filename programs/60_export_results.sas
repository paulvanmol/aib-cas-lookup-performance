/* Produce detailed timings, medians, validation, and partition break-even evidence. */
proc sql;
  create table work.benchmark_summary as
  select Experiment,Candidate,Phase,
         count(*) as Runs,
         median(ElapsedSec) as MedianElapsedSec format=14.3,
         min(ElapsedSec) as MinElapsedSec format=14.3,
         max(ElapsedSec) as MaxElapsedSec format=14.3
  from work.benchmark_runs
  where Measured=1
  group by Experiment,Candidate,Phase
  order by Experiment,Candidate,Phase;
quit;

proc sql;
  create table work.partition_break_even as
  select prep.PrepSeconds,base.BaselineSeconds,part.PartitionedSeconds,
         case when part.PartitionedSeconds < base.BaselineSeconds
              then prep.PrepSeconds/(base.BaselineSeconds-part.PartitionedSeconds)
              else . end as BreakEvenRuns format=14.2,
         base.BaselineSeconds as Cost1Baseline,
         prep.PrepSeconds+part.PartitionedSeconds as Cost1Partitioned,
         5*base.BaselineSeconds as Cost5Baseline,
         prep.PrepSeconds+5*part.PartitionedSeconds as Cost5Partitioned,
         20*base.BaselineSeconds as Cost20Baseline,
         prep.PrepSeconds+20*part.PartitionedSeconds as Cost20Partitioned
  from (select sum(MedianElapsedSec) as PrepSeconds
        from work.benchmark_summary
        where Experiment='Partitioning' and Phase='PREP') prep,
       (select MedianElapsedSec as BaselineSeconds
        from work.benchmark_summary
        where Experiment='Finalists' and Candidate='LEAN_DIRECT' and Phase='QUERY') base,
       (select MedianElapsedSec as PartitionedSeconds
        from work.benchmark_summary
        where Experiment='Finalists' and Candidate='PARTITIONED' and Phase='QUERY') part;
quit;

proc export data=work.benchmark_runs
  outfile="&PROJECT_ROOT/results/benchmark_runs.csv" dbms=csv replace;
run;
proc export data=work.benchmark_summary
  outfile="&PROJECT_ROOT/results/benchmark_summary.csv" dbms=csv replace;
run;
proc export data=work.validation_checked
  outfile="&PROJECT_ROOT/results/validation_summary.csv" dbms=csv replace;
run;
proc export data=work.partition_break_even
  outfile="&PROJECT_ROOT/results/partition_break_even.csv" dbms=csv replace;
run;

proc print data=work.benchmark_summary noobs; run;
proc print data=work.partition_break_even noobs; run;
