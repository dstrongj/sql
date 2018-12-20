
##shows what does column_name, data_type, data_length that do not match from 2 tables in a database

(
select 'IN T1, NOT T2', column_name,data_type,data_length
from user_tab_columns
where table_name = 'T1'
MINUS
select 'IN T1, NOT T2', column_name,data_type,data_length
from user_tab_columns
where table_name = 'T2'
)
UNION ALL
(
select 'IN T2, NOT T1', column_name,data_type,data_length
from user_tab_columns
where table_name = 'vstappo.subscriber'
MINUS
select 'IN T2, NOT T1', column_name,data_type,data_length
from user_tab_columns
where table_name = 'T1'
);




##shows what does column_name, data_type, data_length that do not match from 2 tables in a database
select 
     a.column_name    || ' | ' b.column_name, 
     a.data_type      || ' | ' b.data_type, 
     a.data_length    || ' | ' b.data_length, 
     a.data_scale     || ' | ' b.data_scale, 
     a.data_precision || ' | ' b.data_precision
from 
     user_tab_columns a,
     user_tab_columns b
where 
     a.table_name = 'T1' 
and  b.table_name = 'T2'
and  ( 
       a.data_type      <> b.data_type     or 
       a.data_length    <> b.data_length   or 
       a.data_scale     <> b.data_scale    or 
       a.data_precision <> b.data_precision
     )
and a.column_name = b.column_name;

