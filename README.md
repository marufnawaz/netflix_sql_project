# Netflix Movies and TV Shows Data Analysis using SQL
![Netflix Logo](https://github.com/marufnawaz/netflix_sql_project/blob/main/logo.png)

## Overview

This project entails a thorough analysis of Netflix's movies and TV shows data utilizing SQL. The primary objective is to derive valuable insights and address several business questions using the dataset. The following README offers a comprehensive overview of the project’s goals, the business challenges encountered, the solutions implemented, key findings, and final conclusions.

## Objectives

- Examine the distribution of content categories (movies vs. TV shows).
- Determine the most prevalent ratings for both movies and TV shows.
- Compile and analyze content according to release years, countries, and durations.
- Investigate and classify content based on specific criteria and keywords.

## Dataset

The data for this particular project is downloaded from kaggle

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
CREATE TABLE netflix (
show_id	VARCHAR(6),
type VARCHAR(10),
title VARCHAR(160),
director VARCHAR(210),
cast VARCHAR(1000),	
country	VARCHAR(150),
date_added	VARCHAR(50),
release_year INT,
rating VARCHAR(10),	
duration VARCHAR(15),
listed_in	VARCHAR(250),
description VARCHAR(250)
);
```
## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows

```sql
SELECT 
	type,
	COUNT(*)
FROM netflix
GROUP BY type
```
**Objecctive:** Determine the distribution of content types on Netflix
