/* Experiment 3: wide raw dimensions versus required columns only. */
%macro x3_wide;
  %do rep=0 %to &MEASURED_RUNS;
    %drop_cas(x3_wide)
    %bench_start
    proc fedsql sessref=&CAS_SESSION %plan_opts(&rep);
      create table mycas.x3_wide {options replace=true} as
      select o.OrderID,o.OrderDate,o.CustomerID,o.Country,o.ProductID,o.Quantity,
             c.Country_Name,p.Item,p.MadeIn,p.Manufacturer,
             u.Gender,u.FirstName,u.MI,u.LastName,u.StreetAddress,u.City,u.State,
             u.ZipCode,u.Country as CustomerCountry,u.Phone,u.Birthday
      from mycas.orders_raw o
      left join mycas.countrycodes_raw c on o.Country=c.Country
      left join mycas.products_raw p on o.ProductID=p.ProductID
      left join mycas.customers_raw u on o.CustomerID=u.CustomerID;
    quit;
    %bench_stop(experiment=Column pruning,candidate=WIDE_RAW,rep=&rep,measured=%eval(&rep>0))
  %end;
%mend;

%macro x3_lean;
  %do rep=0 %to &MEASURED_RUNS;
    %drop_cas(x3_lean)
    %bench_start
    proc fedsql sessref=&CAS_SESSION %plan_opts(&rep);
      create table mycas.x3_lean {options replace=true} as
      select o.OrderID,o.OrderDate,o.CustomerID,o.Country,o.ProductID,o.Quantity,
             c.Country_Name,p.Item,p.Manufacturer,u.CustomerName
      from mycas.orders_raw o
      left join mycas.country_thin c on o.Country=c.Country
      left join mycas.product_thin p on o.ProductID=p.ProductID
      left join mycas.customer_thin u on o.CustomerID=u.CustomerID;
    quit;
    %bench_stop(experiment=Column pruning,candidate=LEAN_PREPARED,rep=&rep,measured=%eval(&rep>0))
  %end;
%mend;
%x3_wide
%x3_lean
%table_details(x3_wide)
%table_details(x3_lean)
