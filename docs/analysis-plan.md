# Analysis Plan

**Study:** Logistic Regression: Social Determinants of Diabetes Diagnosis in U.S. Adults
**Data source:** CDC BRFSS 2024
**Analyst:** Julian Chung
**Created:** 2026-04-05

---

## Study Overview

Cross-sectional analysis of the 2024 BRFSS, modelling the odds of a diabetes
diagnosis as a function of demographic, behavioural, and social determinant
predictors in a nationally representative US adult sample.

- **Design:** Cross-sectional
- **Population:** US adults who completed the 2024 BRFSS telephone survey
- **Setting:** 49 states, DC, and US territories (Tennessee excluded from 2024 dataset)
- **N raw:** 457,670 respondents, 345 variables

---

## Research Questions

1. Which demographic, behavioural, and social determinant factors are
   independently associated with a diabetes diagnosis in US adults?
2. Does adding SDoH predictors (education, income, healthcare access) to a
   base demographic model meaningfully improve discrimination (AUC)?

---

## Objectives

### Primary objective

Estimate adjusted odds ratios for demographic, behavioural, and social
determinant predictors of ever having been told you have diabetes (DIABETE4 = 1).

### Secondary objectives

1. Compare model discrimination (AUC) between a base demographic model
   (age + sex + race) and the full SDoH model.
2. Describe the crude prevalence of diabetes across key subgroups (Table 1,
   EDA notebook).

---

## Outcome

| | Variable | Definition | Coding |
|---|---|---|---|
| **Primary** | `diabetes` (from `DIABETE4`) | Ever told you have diabetes | `1` = Yes, `0` = No/pre-diabetes |

Exclusions from outcome: gestational diabetes only (DIABETE4 = 2), don't know
(7), refused (9), and complete case exclusion on all predictors.

---

## Predictors

| Variable | SAS Name | Type | Reference level |
|---|---|---|---|
| Age group | `_AGEG5YR` | Categorical (6 bands) | `18-34` |
| Sex | `SEXVAR` | Binary | `Male` |
| Race/ethnicity | `_RACE` | Categorical (8 groups) | `NH White` |
| Education | `_EDUCAG` | Categorical (4 levels) | `Graduated college` |
| Income | `_INCOMG1` | Categorical (6 levels) | `>$100k` |
| BMI category | `_BMI5CAT` | Categorical (4 levels) | `Normal` |
| Physical activity | `_TOTINDA` | Binary | `Active` |
| Smoking status | `_SMOKER3` | Categorical (4 levels) | `Never` |
| Heavy alcohol use | `_RFDRHV8` | Binary | `No` |
| Healthcare provider | `PERSDOC3` | Binary | `Has provider` |
| Mental health status | `_MENT14D` | Ordinal (3 levels) | `0 days` |

---

## Planned Analyses

### Primary analysis

- **Method:** Multiple logistic regression
- **Notebook:** `analysis/logistic-regression.qmd`
- **Model:** `diabetes ~ age_group + sex + race_ethnicity + education + income_group + has_provider + bmi_category + physically_active + smoking_status + heavy_drinker + mental_health_days`
- **Estimand:** Adjusted odds ratios with 95% CIs

### Secondary analysis

| # | Description | Notebook | Notes |
|---|---|---|---|
| 1 | Base demographic model AUC vs full model AUC | `logistic-regression.qmd` | Δ AUC as measure of SDoH contribution |

---

## Missing Data

- **Handling:** Complete case analysis
- **Approach:** Rows with any missing predictor post-recode are dropped
- **Note:** With 400k+ respondents, even substantial missingness leaves an
  adequate analytical sample; potential selection bias noted in limitations

---

## Diagnostics

- VIF for multicollinearity (`car::vif`)
- `performance::check_model()` for visual diagnostics
- Hosmer-Lemeshow goodness of fit (`ResourceSelection::hoslem.test`)
- Check for separation in small race/ethnicity subgroups (NH NHOPI, NH AIAN)

---

## Limitations (pre-specified)

- Cross-sectional design — temporal ordering of predictors and outcome unknown
- Self-reported diabetes diagnosis — no clinical validation
- Unweighted analysis — estimates not nationally representative
- Complete case analysis — potential selection bias if missingness not random
- Tennessee excluded from 2024 dataset
- `SLEPTIM1` (sleep hours) absent from 2024 dataset — removed per executive orders; dropped from analysis
- Some other 2024 variables removed per executive orders — structural missingness noted
- Telephone survey excludes adults without phone access

---

## Software

- R + Quarto
- Key packages: arrow, gtsummary, broom, pROC, car, performance, ResourceSelection
- Data pipeline: DuckDB (SQL stage) → R (analysis stage)

---

## Devlog

| Date | Note |
|---|---|
| 2026-04-05 | Project initialised; scaffold applied from `quarto-epi-scaffold`; SQL stage scripts written per plan |
