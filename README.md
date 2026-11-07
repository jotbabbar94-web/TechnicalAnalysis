# BDA400 — Assignment 2: Technical Analysis (Preliminary Stage)

This folder contains an introductory stock-data analysis workflow using R, `quantmod`, and `TTR`.

## Files
- `portfolio.txt`: one ticker symbol per line (AAPL, MSFT, GOOGL).
- `stock_functions.R`: reads tickers, retrieves Yahoo Finance daily historical data, and calculates descriptive statistics.
- `display_stocks.R`: prints data and statistics and plots closing prices with a 20-observation simple moving average.
- `Assignment2_Report.docx`: report template requiring your own screenshots and observations.

## Setup and execution
1. Install R and RStudio.
2. In the RStudio Console, run `install.packages(c("quantmod", "TTR"))` once.
3. Set the working directory to this `Assignment2` folder (Session > Set Working Directory > Choose Directory).
4. Run `source("display_stocks.R")`.
5. Inspect Console, Data Viewer, and Plots. Capture your own screenshots for the report.

## Method notes
- Data source: Yahoo Finance through `quantmod::getSymbols`; internet access and source availability are required.
- The default retrieval window is approximately the preceding 365 calendar days. Output varies by run date.
- Mean, median, standard deviation and observed mode use the **Close** column; mode is `NA` if no price repeats.
- The 20-day simple moving average uses 20 trading observations; the first 19 entries are missing.
- These are historical descriptive indicators, not investment advice.
- No market data is fabricated or bundled. Check the retrieved dates and values before reporting results.
