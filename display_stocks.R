# BDA400 Assignment 2 — Data display and visualization
# In RStudio: Session > Set Working Directory > Choose Directory > Assignment2
source("stock_functions.R")
stocks <- load_stock_data("portfolio.txt")
statistics <- summarize_portfolio(stocks)
cat("\nPORTFOLIO SUMMARY\n")
print(statistics, row.names = FALSE, digits = 4)

for (symbol in names(stocks)) {
  df <- stocks[[symbol]]
  cat("\n", symbol, "— FIRST SIX ROWS\n", sep = "")
  print(head(df))
  cat("\n", symbol, "— LAST SIX ROWS\n", sep = "")
  print(tail(df))
  cat("\n", symbol, "— COLUMN SUMMARY\n", sep = "")
  print(summary(df))
  if (interactive()) {
    # Opens a tabular viewer in RStudio
    utils::View(df, title = paste(symbol, "historical prices"))
  }
  sma20 <- TTR::SMA(df$Close, n = 20)
  plot(df$Date, df$Close, type = "l", col = "steelblue", lwd = 2,
       xlab = "Date", ylab = "Closing price (USD)",
       main = paste(symbol, "closing price and 20-day SMA"))
  lines(df$Date, sma20, col = "firebrick", lwd = 2)
  legend("topleft", legend = c("Close", "20-day SMA"),
         col = c("steelblue", "firebrick"), lty = 1, bty = "n")
}
# Optional: export summary after independently checking the values:
# write.csv(statistics, "portfolio_statistics.csv", row.names = FALSE)
