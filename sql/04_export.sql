copy (select * from analytical_dataset)
to 'data/processed/analysis_dataset.parquet'
(format parquet);
