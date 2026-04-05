# Data Dictionary

**Study:** Logistic Regression: Social Determinants of Diabetes Diagnosis in U.S. Adults
**Data source:** CDC BRFSS 2024 (LLCP2024.XPT)
**Last updated:** 2026-04-05
**Maintained by:** Julian Chung

---

## Notes

- `raw_name` = original SAS variable name in LLCP2024.XPT
- `clean_name` = name in `data/processed/analysis_dataset.parquet`
- CDC computed variables are prefixed with `_` in the raw file
- Missing value codes: 7 = Don't know, 9 = Refused (set to NULL in SQL stage)

---

## Survey Design Variables

| clean_name    | raw_name  | type    | description                               |
|---------------|-----------|---------|-------------------------------------------|
| `psu`         | `_PSU`    | numeric | Primary sampling unit                     |
| `strata`      | `_STSTR`  | numeric | Stratum                                   |
| `llcp_weight` | `_LLCPWT` | numeric | Final LLCP design weight (not used in primary analysis) |

---

## Outcome

| clean_name | raw_name   | type    | values / coding                                          | notes                              |
|------------|------------|---------|----------------------------------------------------------|------------------------------------|
| `diabetes` | `DIABETE4` | integer | `1` = diabetes, `0` = no/pre-diabetes, `NULL` = excluded | Gestational (2), DK (7), refused (9) excluded |

---

## Demographics

| clean_name      | raw_name   | type   | values / coding                                                                                      | ref level  |
|-----------------|------------|--------|------------------------------------------------------------------------------------------------------|------------|
| `age_group`     | `_AGEG5YR` | factor | `18-34` / `35-44` / `45-54` / `55-64` / `65-74` / `75+` (collapsed from 13 five-year groups)        | `18-34`    |
| `sex`           | `SEXVAR`   | factor | `Male` / `Female`                                                                                    | `Male`     |
| `race_ethnicity`| `_RACE`    | factor | `NH White` / `NH Black` / `NH AIAN` / `NH Asian` / `NH NHOPI` / `NH Other/Multiracial` / `Hispanic` / `NH Other` | `NH White` |

---

## Social Determinants of Health

| clean_name   | raw_name   | type    | values / coding                                                                           | ref level           |
|--------------|------------|---------|-------------------------------------------------------------------------------------------|---------------------|
| `education`  | `_EDUCAG`  | factor  | `Did not graduate HS` / `Graduated HS` / `Some college` / `Graduated college`            | `Graduated college` |
| `income_group` | `_INCOMG1` | factor | `<$15k` / `$15k-$25k` / `$25k-$35k` / `$35k-$50k` / `$50k-$100k` / `>$100k`           | `>$100k`            |
| `has_provider` | `PERSDOC3` | factor | `Has provider` (raw 1 or 2) / `No provider` (raw 3)                                     | `Has provider`      |

---

## Clinical / Behavioural

| clean_name           | raw_name    | type    | values / coding                                                              | ref level      |
|----------------------|-------------|---------|------------------------------------------------------------------------------|----------------|
| `bmi_category`       | `_BMI5CAT`  | factor  | `Underweight` / `Normal` / `Overweight` / `Obese`                            | `Normal`       |
| `physically_active`  | `_TOTINDA`  | factor  | `Active` (raw 1) / `Inactive` (raw 2)                                        | `Active`       |
| `smoking_status`     | `_SMOKER3`  | factor  | `Never` / `Former` / `Current (some days)` / `Current (daily)`               | `Never`        |
| ~~`sleep_hrs`~~      | `SLEPTIM1`  | —       | **Not present in 2024 dataset** — removed per executive orders; excluded from analysis | —   |
| `heavy_drinker`      | `_RFDRHV8`  | factor  | `No` (raw 1) / `Yes` (raw 2)                                                 | `No`           |
| `mental_health_status` | `_MENT14D` | factor | `0 days` / `1-13 days` / `14+ days` poor mental health in past 30 days      | `0 days`       |

---

## Excluded Variables

| raw_name    | reason excluded                                                                 |
|-------------|---------------------------------------------------------------------------------|
| `PRIMINS2`  | 12 categories, collinear with `PERSDOC3`, unwieldy to model                    |
| `FOODSTMP`  | Optional SDoH module — ~55% not asked; subsample restriction reduces power      |
