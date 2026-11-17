/* Compute reusable attributes once and prune dimensions before joins. */
data &caslib..customers_prep;
  length CustomerName $100;
  set &caslib..customers_raw;
  CustomerName=catx(' ',FirstName,MI,LastName);
run;

data &caslib..country_thin;
  set &caslib..countrycodes_raw(keep=Country Country_Name);
run;

data &caslib..product_thin;
  set &caslib..products_raw(keep=ProductID Item Manufacturer);
run;

data &caslib..customer_thin;
  set &caslib..customers_prep(keep=CustomerID CustomerName);
run;

%table_details(country_thin)
%table_details(product_thin)
%table_details(customer_thin)
