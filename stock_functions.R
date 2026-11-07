# BDA400 Assignment 2 — Stock data loading and descriptive statistics
# Run from the Assignment2 directory. Internet access is needed for Yahoo data.
# Install once: install.packages(c("quantmod", "TTR"))

read_portfolio <- function(path = "portfolio.txt") {
  if (!file.exists(path)) stop("Portfolio file not found: ", path)
  symbols <- trimws(readLines(path, warn = FALSE))
  symbols <- unique(symbols[nzchar(symbols) & !grepl("^#", symbols)])
  if (!length(symbols)) stop("Portfolio is empty")
  symbols
}

load_stock_data <- function(path = "portfolio.txt", from = Sys.Date() - 365,
                            to = Sys.Date()) {
  if (!requireNamespace("quantmod", quietly = TRUE)) stop("Install quantmod")
  result <- list()
  for (symbol in read_portfolio(path)) {
    tryCatch({
      prices <- quantmod::getSymbols(symbol, src = "yahoo", from = from,
                                      to = to, auto.assign = FALSE,
                                      warnings = FALSE)
      df <- data.frame(Date = as.Date(zoo::index(prices)),
                       Open = as.numeric(quantmod::Op(prices)),
                       High = as.numeric(quantmod::Hi(prices)),
                       Low = as.numeric(quantmod::Lo(prices)),
                       Close = as.numeric(quantmod::Cl(prices)),
                       Volume = as.numeric(quantmod::Vo(prices)))
      if (!nrow(df)) stop("No observations returned")
      result[[symbol]] <- df
      message("Loaded ", symbol, ": ", nrow(df), " rows")
    }, error = function(e) warning("Unable to load ", symbol, ": ", conditionMessage(e)))
  }
  if (!length(result)) stop("No stock datasets loaded. Check internet, symbols and dates.")
  result
}

observed_mode <- function(x) {
  x <- x[is.finite(x)]
  if (!length(x)) return(NA_real_)
  frequencies <- table(x)
  if (max(frequencies) == 1L) return(NA_real_) # No repeated price
  as.numeric(names(frequencies)[which.max(frequencies)])
}

calculate_statistics <- function(stock_df, symbol = "Stock", n = 20L) {
  if (!requireNamespace("TTR", quietly = TRUE)) stop("Install TTR")
  if (!"Close" %in% names(stock_df)) stop("Data requires a Close column")
  close <- as.numeric(stock_df$Close)
  valid <- close[is.finite(close)]
  if (!length(valid)) stop("No valid closing prices")
  sma <- TTR::SMA(close, n = n)
  data.frame(Symbol = symbol, Observations = length(valid),
             Mean = mean(valid), Median = median(valid),
             Mode = observed_mode(valid), SD = if (length(valid) > 1) sd(valid) else NA_real_,
             Latest_Close = tail(valid, 1),
             Latest_SMA20 = if (all(is.na(sma))) NA_real_ else tail(sma, 1),
             stringsAsFactors = FALSE)
}

summarize_portfolio <- function(stock_list) {
  do.call(rbind, lapply(names(stock_list), function(symbol)
    calculate_statistics(stock_list[[symbol]], symbol)))
}
