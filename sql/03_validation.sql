select count(*) from analytical_dataset;
select
    diabetes,
    count(*) as n,
    round(100.0 * count(*) / sum(count(*)) over (), 2) as pct
from analytical_dataset
group by diabetes
order by diabetes;

select
    count(*) filter (where age_group is null) as miss_age,
    count(*) filter (where sex is null) as miss_sex,
    count(*) filter (where race_ethnicity is null) as miss_race,
    count(*) filter (where education is null) as miss_education,
    count(*) filter (where income_group is null) as miss_income,
    count(*) filter (where bmi_category is null) as miss_bmi,
    count(*) filter (where physically_active is null) as miss_activity,
    count(*) filter (where smoking_status is null) as miss_smoking,

    count(*) filter (where heavy_drinker is null) as miss_alcohol,
    count(*) filter (where has_provider is null) as miss_provider,
    count(*) filter (where mental_health_days is null) as miss_mh
from analytical_dataset;

select bmi_category, diabetes, count(*) as n
from analytical_dataset
where bmi_category is not null
group by bmi_category, diabetes
order by bmi_category, diabetes;
