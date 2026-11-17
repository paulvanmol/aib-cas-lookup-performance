/* Compute reusable attributes once and prune dimensions before joins. */
data mycas.customers_prep;
  length CustomerName $100;
  set mycas.customers_raw;
  CustomerName=catx(' ',FirstName,MI,LastName);
run;

data mycas.country_thin;
  set mycas.countrycodes_raw(keep=Country Country_Name);
run;

data mycas.product_thin;
  set mycas.products_raw(keep=ProductID Item Manufacturer);
run;

data mycas.customer_thin;
  set mycas.customers_prep(keep=CustomerID CustomerName);
run;

%table_details(country_thin)
%table_details(product_thin)
%table_details(customer_thin)
