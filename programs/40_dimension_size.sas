/* Experiment 1: same fact, dimensions of very different sizes. */
%macro x1_country;
  %do rep=0 %to &MEASURED_RUNS;
    %drop_cas(x1_country)
    %bench_start
    proc fedsql sessref=&CAS_SESSION %plan_opts(&rep);
      create table &caslib..x1_country {options replace=true} as
      select o.OrderID,o.OrderDate,o.CustomerID,o.Country,o.ProductID,o.Quantity,c.Country_Name
      from &caslib..orders_raw o left join &caslib..country_thin c on o.Country=c.Country;
    quit;
    %bench_stop(experiment=Dimension size,candidate=COUNTRY_DIRECT,rep=&rep,measured=%eval(&rep>0))
  %end;
%mend;

%macro x1_product;
  %do rep=0 %to &MEASURED_RUNS;
    %drop_cas(x1_product)
    %bench_start
    proc fedsql sessref=&CAS_SESSION %plan_opts(&rep);
      create table &caslib..x1_product {options replace=true} as
      select o.OrderID,o.OrderDate,o.CustomerID,o.Country,o.ProductID,o.Quantity,p.Item,p.Manufacturer
      from &caslib..orders_raw o left join &caslib..product_thin p on o.ProductID=p.ProductID;
    quit;
    %bench_stop(experiment=Dimension size,candidate=PRODUCT_DIRECT,rep=&rep,measured=%eval(&rep>0))
  %end;
%mend;

%macro x1_customer;
  %do rep=0 %to &MEASURED_RUNS;
    %drop_cas(x1_customer)
    %bench_start
    proc fedsql sessref=&CAS_SESSION %plan_opts(&rep);
      create table &caslib..x1_customer {options replace=true} as
      select o.OrderID,o.OrderDate,o.CustomerID,o.Country,o.ProductID,o.Quantity,u.CustomerName
      from &caslib..orders_raw o left join &caslib..customer_thin u on o.CustomerID=u.CustomerID;
    quit;
    %bench_stop(experiment=Dimension size,candidate=CUSTOMER_DIRECT,rep=&rep,measured=%eval(&rep>0))
  %end;
%mend;
%x1_country
%x1_product
%x1_customer
