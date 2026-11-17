data lookup.countrycodes;
  length Country $2 Country_Name $40;
  infile datalines dlm='|' truncover;
  input Country $ Country_Name :$40.;
  cards;
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