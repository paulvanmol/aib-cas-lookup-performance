/* Experiment 4: co-partition the large fact and customer dimension. */
%bench_start
proc cas;
  table.partition /
    table={caslib="&CASLIB",name="orders_raw",groupBy={{name="CustomerID"}}},
    casout={caslib="&CASLIB",name="orders_by_customer",replace=true};
quit;
%bench_stop(experiment=Partitioning,candidate=BUILD_ORDERS_PARTITION,phase=PREP,rep=1,measured=1)

%bench_start
proc cas;
  table.partition /
    table={caslib="&CASLIB",name="customer_thin",groupBy={{name="CustomerID"}}},
    casout={caslib="&CASLIB",name="customer_by_customer",replace=true};
quit;
%bench_stop(experiment=Partitioning,candidate=BUILD_CUSTOMER_PARTITION,phase=PREP,rep=1,measured=1)

proc cas;
  table.tableDetails / caslib="&CASLIB",name="orders_by_customer",level="partition";
  table.tableDetails / caslib="&CASLIB",name="customer_by_customer",level="partition";
quit;

%macro x4_partitioned;
  %do rep=0 %to &MEASURED_RUNS;
    %drop_cas(x4_partitioned)
    %bench_start
    proc fedsql sessref=&CAS_SESSION %plan_opts(&rep);
      create table &caslib..x4_partitioned {options replace=true} as
      select o.OrderID,o.OrderDate,o.CustomerID,o.Country,o.ProductID,o.Quantity,
             c.Country_Name,p.Item,p.Manufacturer,u.CustomerName
      from &caslib..orders_by_customer o
      left join &caslib..country_thin c on o.Country=c.Country
      left join &caslib..product_thin p on o.ProductID=p.ProductID
      left join &caslib..customer_by_customer u on o.CustomerID=u.CustomerID;
    quit;
    %bench_stop(experiment=Partitioning,candidate=PARTITIONED_JOIN,rep=&rep,measured=%eval(&rep>0))
  %end;
%mend;
%x4_partitioned
