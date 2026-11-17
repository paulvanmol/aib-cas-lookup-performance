/* Deterministic synthetic data with the documented lookup schema. */
%macro create_synthetic_data;
%if %upcase(&DATA_MODE) ne SYNTHETIC %then %do;
  %put NOTE: DATA_MODE is not SYNTHETIC; generator skipped.;
%end;
%else %do;

data lookup.countrycodes;
  length Country $2 Country_Name $40;
  infile datalines dlm='|' truncover;
  input Country $ Country_Name :$40.;
  datalines;
AD|Andorra
AE|United Arab Emirates
AF|Afghanistan
AU|Australia
BE|Belgium
BR|Brazil
CA|Canada
CH|Switzerland
DE|Germany
ES|Spain
FR|France
GB|United Kingdom
IN|India
JP|Japan
NL|Netherlands
SE|Sweden
US|United States
;
run;

data lookup.products;
  length Item $48 MadeIn $2 Manufacturer $40;
  array cc[17] $2 _temporary_ ('AD','AE','AF','AU','BE','BR','CA','CH','DE','ES','FR','GB','IN','JP','NL','SE','US');
  do ProductID=1 to &PRODUCT_ROWS;
    Item=cats('Workshop Item ',put(ProductID,z4.));
    MadeIn=cc[1+mod(ProductID-1,dim(cc))];
    Manufacturer=cats('Manufacturer ',put(1+mod(ProductID-1,35),z2.));
    output;
  end;
run;

data lookup.customers;
  length Gender $1 FirstName $20 MI $1 LastName $24 StreetAddress $60 City $30
         State $2 ZipCode $10 Country $2 Phone $16;
  format CustomerID z12. Birthday date9.;
  array fn[12] $20 _temporary_ ('Alex','Amira','Chris','Daniel','Elena','Fatima','George','Hana','Ivan','Julia','Kofi','Lina');
  array ln[12] $24 _temporary_ ('Adams','Bauer','Costa','Dubois','Evans','Fischer','Garcia','Hassan','Ivanov','Jansen','Khan','Laurent');
  array cc[17] $2 _temporary_ ('AD','AE','AF','AU','BE','BR','CA','CH','DE','ES','FR','GB','IN','JP','NL','SE','US');
  array st[12] $2 _temporary_ ('AL','AR','AZ','CA','CO','FL','GA','IL','MA','NY','TX','WA');
  do CustomerID=1 to &CUSTOMER_ROWS;
    Gender=ifc(mod(CustomerID,2)=0,'F','M');
    FirstName=fn[1+mod(CustomerID-1,dim(fn))];
    MI=byte(65+mod(CustomerID,26));
    LastName=ln[1+mod(floor((CustomerID-1)/12),dim(ln))];
    StreetAddress=cats(100+mod(CustomerID,9800),' Workshop Avenue');
    City=cats('City ',put(1+mod(CustomerID,250),z3.));
    State=st[1+mod(CustomerID-1,dim(st))];
    ZipCode=put(10000+mod(CustomerID,89999),z5.);
    Country=cc[1+mod(CustomerID-1,dim(cc))];
    Phone=cats(200+mod(CustomerID,700),'-',put(mod(CustomerID*37,1000),z3.),'-',put(mod(CustomerID*97,10000),z4.));
    Birthday='01JAN1927'd+mod(CustomerID,80*365);
    output;
  end;
run;

data lookup.orders;
  length OrderID $32 Country $2;
  format OrderDate yymmdd10. CustomerID z12.;
  array cc[17] $2 _temporary_ ('AD','AE','AF','AU','BE','BR','CA','CH','DE','ES','FR','GB','IN','JP','NL','SE','US');
  call streaminit(&RANDOM_SEED);
  do _row=1 to &ORDER_ROWS;
    OrderDate='01JAN2023'd+floor(rand('uniform')*730);
    CustomerID=1+floor(rand('uniform')*&CUSTOMER_ROWS);
    ProductID=1+floor(rand('uniform')*&PRODUCT_ROWS);
    Country=cc[1+mod(CustomerID-1,dim(cc))];
    Quantity=1+floor(rand('uniform')*5);
    OrderID=cats(put(OrderDate,yymmddn8.),'_',put(CustomerID,z12.),'_',put(_row,z7.));
    output;
  end;
  drop _row;
run;

proc datasets library=lookup;
  contents data=countrycodes; contents data=products;
  contents data=customers; contents data=orders;
quit;
%end;
%mend;
%create_synthetic_data
