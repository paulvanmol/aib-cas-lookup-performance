# Data schema

## ORDERS fact

| Column | Synthetic type | Role |
|---|---|---|
| `OrderID` | character | unique order-line identifier |
| `OrderDate` | SAS date | transaction date |
| `CustomerID` | numeric, `Z12.` format | customer key |
| `Country` | character(2) | country key |
| `ProductID` | numeric | product key |
| `Quantity` | numeric | measure |

## Dimensions

- `COUNTRYCODES`: `Country`, `Country_Name`
- `PRODUCTS`: `ProductID`, `Item`, `MadeIn`, `Manufacturer`
- `CUSTOMERS`: `CustomerID`, `Gender`, `FirstName`, `MI`, `LastName`, `StreetAddress`, `City`, `State`, `ZipCode`, `Country`, `Phone`, `Birthday`

The experiments prepare three thin dimensions:

- `COUNTRY_THIN`: `Country`, `Country_Name`
- `PRODUCT_THIN`: `ProductID`, `Item`, `Manufacturer`
- `CUSTOMER_THIN`: `CustomerID`, `CustomerName`

## Synthetic profiles

| Profile | Orders | Customers | Products | Countries | Intended use |
|---|---:|---:|---:|---:|---|
| `DEMO` | 100,000 | 10,000 | 70 | 17 | syntax/smoke testing |
| `WORKSHOP` | 2,000,000 | 200,000 | 700 | 17 | hands-on lab |
| `SOURCE_SCALE` | 14,846,132 | 1,099,519 | 700 | 17 | approximate documented scale |
| `CUSTOM` | configured values | configured values | configured values | 17 | site-specific testing |

All synthetic generation uses `RANDOM_SEED`, so a given configuration is repeatable.
