/* Reset local timing evidence. Warm-ups are retained but marked Measured=0. */
data work.benchmark_runs;
  length Experiment $40 Candidate $64 Phase $8 Notes $240;
  format Timestamp e8601dt26.3 ElapsedSec 14.3;
  stop;
run;
