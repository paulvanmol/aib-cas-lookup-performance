/* Inspect schema, row counts, and key uniqueness before benchmarking. */
proc cas;
  table.columnInfo / table={caslib="&CASLIB",name="orders_raw"};
  table.columnInfo / table={caslib="&CASLIB",name="countrycodes_raw"};
  table.columnInfo / table={caslib="&CASLIB",name="products_raw"};
  table.columnInfo / table={caslib="&CASLIB",name="customers_raw"};
quit;

proc fedsql sessref=&CAS_SESSION;
  select 'orders_raw' as TableName, count(*) as CountRows from &caslib..orders_raw;
  select 'countrycodes_raw' as TableName, count(*) as CountRows from &caslib..countrycodes_raw;
  select 'products_raw' as TableName, count(*) as CountRows from &caslib..products_raw;
  select 'customers_raw' as TableName, count(*) as CountRows from &caslib..customers_raw;

  create table &caslib..dup_country {options replace=true} as
    select Country, count(*) as N from &caslib..countrycodes_raw group by Country having count(*)>1;
  create table &caslib..dup_product {options replace=true} as
    select ProductID, count(*) as N from &caslib..products_raw group by ProductID having count(*)>1;
  create table &caslib..dup_customer {options replace=true} as
    select CustomerID, count(*) as N from &caslib..customers_raw group by CustomerID having count(*)>1;
quit;

proc fedsql sessref=&CAS_SESSION;
  select 'dup_country' as CheckName, count(*) as DuplicateKeys from &caslib..dup_country;
  select 'dup_product' as CheckName, count(*) as DuplicateKeys from &caslib..dup_product;
  select 'dup_customer' as CheckName, count(*) as DuplicateKeys from &caslib..dup_customer;
quit;

proc sql noprint;
  select count(*) into :_dup_country trimmed from &caslib..dup_country;
  select count(*) into :_dup_product trimmed from &caslib..dup_product;
  select count(*) into :_dup_customer trimmed from &caslib..dup_customer;
quit;

%macro assert_unique_dimensions;
  %if &_dup_country ne 0 or &_dup_product ne 0 or &_dup_customer ne 0 %then %do;
    %put ERROR: A dimension key is not unique. COUNTRY=&_dup_country PRODUCT=&_dup_product CUSTOMER=&_dup_customer.;
    %abort cancel;
  %end;
%mend;
%assert_unique_dimensions
%put NOTE: Dimension key uniqueness checks passed.;
