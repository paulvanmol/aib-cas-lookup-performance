/* Final head-to-head: no preparation versus reusable co-partitioned layout. */
%macro finalist(candidate=,orders=,customer=,out=);
  %do rep=0 %to &MEASURED_RUNS;
    %drop_cas(&out)
    %bench_start
    proc fedsql sessref=&CAS_SESSION %plan_opts(&rep);
      create table &caslib..&out {options replace=true} as
      select o.OrderID,o.OrderDate,o.CustomerID,o.Country,o.ProductID,o.Quantity,
             c.Country_Name,p.Item,p.Manufacturer,u.CustomerName
      from &caslib..&orders o
      left join &caslib..country_thin c on o.Country=c.Country
      left join &caslib..product_thin p on o.ProductID=p.ProductID
      left join &caslib..&customer u on o.CustomerID=u.CustomerID;
    quit;
    %bench_stop(experiment=Finalists,candidate=&candidate,rep=&rep,measured=%eval(&rep>0))
  %end;
%mend;
%finalist(candidate=LEAN_DIRECT,orders=orders_raw,customer=customer_thin,out=finalist_lean)
%finalist(candidate=PARTITIONED,orders=orders_by_customer,customer=customer_by_customer,out=finalist_partitioned)
