/* Verify the four Base SAS inputs, then load them as session tables. */
%macro assert_source(member);
  %if not %sysfunc(exist(lookup.&member)) %then %do;
    %put ERROR: Required source table LOOKUP.&member was not found in &ACTIVE_DATA_DIR.;
    %abort cancel;
  %end;
%mend;
%assert_source(orders)
%assert_source(countrycodes)
%assert_source(products)
%assert_source(customers)

proc casutil;
  load data=lookup.orders       casout="orders_raw"       outcaslib="&CASLIB" replace;
  load data=lookup.countrycodes casout="countrycodes_raw" outcaslib="&CASLIB" replace;
  load data=lookup.products     casout="products_raw"     outcaslib="&CASLIB" replace;
  load data=lookup.customers    casout="customers_raw"    outcaslib="&CASLIB" replace;
quit;

%table_details(orders_raw)
%table_details(countrycodes_raw)
%table_details(products_raw)
%table_details(customers_raw)
