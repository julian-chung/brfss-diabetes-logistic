create or replace table analytical_dataset as
with base as (
    select
        -- These three are survey design variables, keeping them even though we won't use them in the primary analysis
        _PSU as psu,
        _STSTR as strata,
        _LLCPWT as llcp_weight,
        -- Raw outcome variable
        DIABETE4 as diabetes_raw,
        -- Demographic predictors
        _AGEG5YR as age_group_raw,
        SEXVAR as sex_raw,
        _RACE as race_raw,
        -- Social determinants
        _EDUCAG as education_raw,
        _INCOMG1 as income_raw,
        PERSDOC3 as has_provider_raw,
        -- clinical / behavioural predictors
        _BMI5CAT as bmi_cat_raw,
        _TOTINDA as phys_activity_raw,
        _SMOKER3 as smoking_raw,
        _RFDRHV9 as heavy_alcohol_raw,
        _MENT14D as mental_health_raw
    FROM brfss_raw
),

recoded as (
    select
        psu,
        strata,
        llcp_weight,
        case
            when diabetes_raw = 1 then 1
            when diabetes_raw in (3, 4) then 0
            else null -- 2, 7, 9 are all various forms of missingness so we set them to null
        end as diabetes,
        case
            when age_group_raw in (1, 2) then '18-34'
            when age_group_raw in (3, 4) then '35-44'
            when age_group_raw in (5, 6) then '45-54'
            when age_group_raw in (7, 8) then '55-64'
            when age_group_raw in (9, 10) then '65-74'
            when age_group_raw in (11, 12, 13) then '75+'
            else null
        end as age_group,
        case
            when sex_raw = 1 then 'Male'
            when sex_raw = 2 then 'Female'
            else null
        end as sex,
        -- Race/ethnicity: CDC combines race and Hispanic ethnicity into a single
        -- computed variable. Hispanic is its own category regardless of race.
        -- NH (Non-Hispanic) prefix is dropped for clarity for non-US readers.
        case
            when race_raw = 1 then 'White'
            when race_raw = 2 then 'Black'
            when race_raw = 3 then 'American Indian/Alaskan Native'
            when race_raw = 4 then 'Asian'
            when race_raw = 5 then 'Pacific Islander'
            when race_raw = 6 then 'Other/Multiracial'
            when race_raw = 7 then 'Hispanic'
            when race_raw = 8 then 'Other'
            else null
        end as race_ethnicity,
        case
            when education_raw = 1 then 'Did not graduate high school'
            when education_raw = 2 then 'High school graduate'
            when education_raw = 3 then 'Some college'
            when education_raw = 4 then 'College graduate'
            else null
        end as education,
        case
            when income_raw = 1 then '<$15k'
            when income_raw = 2 then '$15k-$25k'
            when income_raw = 3 then '$25k-$35k'
            when income_raw = 4 then '$35k-$50k'
            when income_raw = 5 then '$50k-$100k'
            when income_raw = 6 then '>$100k'
            else null
        end as income_group,
        case
            when has_provider_raw in (1, 2) then 1
            when has_provider_raw = 3 then 0
            else null
        end as has_provider,
        case
            when bmi_cat_raw = 1 then 'Underweight'
            when bmi_cat_raw = 2 then 'Normal'
            when bmi_cat_raw = 3 then 'Overweight'
            when bmi_cat_raw = 4 then 'Obese'
            else null
        end as bmi_category,
        case
            when phys_activity_raw = 1 then 1
            when phys_activity_raw = 2 then 0
            else null
        end as physically_active,
        case
            when smoking_raw = 1 then 'Current (daily)'
            when smoking_raw = 2 then 'Current (some days)'
            when smoking_raw = 3 then 'Former'
            when smoking_raw = 4 then 'Never'
            else null
        end as smoking_status,
        case
            when heavy_alcohol_raw = 1 then 0
            when heavy_alcohol_raw = 2 then 1
            else null
        end as heavy_drinker,
        case
            when mental_health_raw = 1 then '0 days'
            when mental_health_raw = 2 then '1-13 days'
            when mental_health_raw = 3 then '14+ days'
            else null
        end as mental_health_days
    from base
)
select * from recoded
where diabetes is not null;
