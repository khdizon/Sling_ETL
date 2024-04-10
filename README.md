# Sling_ETL


SQL scripts for EDW Tables

Version  | Date | Author | Notes |
:-------:|:----:|:-------|:-----:|
0.1 |4 April 2024| Ken Dizon | Initial version |
_________________________________________________________________________________

## ERD 
```
  SELECT table_name, column_name, data_type --COUNT(column_name)
  FROM information_schema.columns
  WHERE table_schema = 'edw_ott'
  --AND table_name = 'input_your_table';
```
