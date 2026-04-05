create or replace view brfss_raw as
select * from read_parquet('data/raw/LLCP2024.parquet');

select count(*) as n_rows from brfss_raw;
