# qPCR Statistical Shiny App

## About
Dashboard written in R / Shiny to analyze data with few features for data from qPCR reaction. After uploading data from a file, user can perform preeliminary analysis of the data distribution, and perform statistical tests.

## Technologies and libraries
- <b> R programming language </b>
- Shiny
- ggplot2 / plotly
- reshape2
- outliers
- splines
- rcompanion

## Description
This project aims mainly to a biologist to help them analyze their data from experiments, including qPCR reactions. It is an interactive dashboard written in R/Shiny, which allows to investigate data distribution via descriptive statistics, plots and statistical test e.g. Shapiro-Wilk test of normality. Another features are statistical test to compare means one or two means between samples or to compare means between groups (parametric and non-parametric tests are included.) 

There are also three additional features created especially for qPCR data 
- Limit of Detection (LOD) calculation for three dilution concentration points, where LOD is the smallest number of molecules that can be detected by a diagnostic kit
- Fluorescence Visualization - Interactive plot with amplification curves from every sample labeled and marked with a color
- HRM, where differences between amplification curves are calculated based on reference curve, which is provided by user

## Application structure overview
- Data uploading from file with descriptive statistics table
- Visualizing data:
    - Boxplots
    - Scatter plots
    - Histograms
- Testing assumptions:
    - Distribution normality with Shapiro-Wilk test
    - Variance Homogenity with Bartlett test
    - Outliers detection with Q-dixon test, when dataset has less than 30 observations
    - Outliers detection based on Z-score when dataset has more than 30 observations
- Means comparison
    - T-test
    - Wilcox test
- Analysis of variance
    - ANOVA
    - Kruskal-Wallis test
- Limit of Detection (LOD) calculation and visualization for three dilution contentration points (qPCR data)
- Fluorescence curves visualization (qPCR data)
- Calculating differences between fluorescence curves to differentiate genotypes from qPCR High Resolution Melt reaction

