StockHist <- read.csv("Stock.csv", header=TRUE, sep=",")
library(dplyr)
library(forecast)
library(lubridate)
library(fUnitRoots)

print(StockHist$Date)


StockHist$Date <- as.Date(StockHist$Date)
str(StockHist)

Stock_byDayTS <- msts(StockHist$Close, seasonal.periods=c(5,253))
StockPrice.fit <- tbats(Stock_byDayTS)

Stock_byDayTS <- ts(StockHist$Close, start = c(2015, 8,25), frequency = 253)

StockPrice_fitHW1 <- HoltWinters(Stock_byDayTS, beta=FALSE, gamma=FALSE)
StockPrice_fitHW2 <- HoltWinters(Stock_byDayTS, beta=FALSE)
StockPrice_fitHW3 <- HoltWinters(Stock_byDayTS)

eeadj <- seasadj(stl(Stock_byDayTS, s.window="periodic"))
plot(eeadj)
tsdisplay(diff(eeadj),main="")

StockPrice_fitLM <- tslm(Stock_byDayTS ~ trend + season)
StockPrice_fitARIMA <- arima(Stock_byDayTS, order=c(3, 1, 1))

StockPrice_fit_Auto_ARIMA <- auto.arima(Stock_byDayTS)

forecast <- predict(StockPrice_fit_Auto_ARIMA, n.ahead = 24, prediction.interval = T, level = 0.95)
plot(StockPrice_fit_Auto_ARIMA, forecast)


#Fct = forecast(StockPrice.fit)
PlotOb = Stock_byDayTS
Plotfortbat <-forecast(StockPrice.fit,48)
PlotforHW <-forecast(StockPrice_fitHW1,48)
PlotforLM <-forecast(StockPrice_fitLM,48)
PlotforARIMA <- forecast(StockPrice_fitARIMA,48)
PlotforAutoARIMA <- forecast(StockPrice_fit_Auto_ARIMA,48)

plot(Plotfortbat,main ="Observed Vs Modelled WPM tbats Share price", ylab = "Price($)", xlab = "Date")
lines(PlotOb,col="black")
lines(Plotfortbat$fitted,col="red")
legend('topright', c("Observed","Fitted","Forecasted"),lty=1, col=c('black', 'red','blue'), bty='n', cex=.7)

plot(PlotforHW,main ="Observed Vs Modelled WPM HoltWinter Share price", ylab = "Price($)", xlab = "Date")
lines(PlotOb,col="black")
lines(PlotforHW$fitted,col="red")
legend('topright', c("Observed","Fitted","Forecasted"),lty=1, col=c('black', 'red','blue'), bty='n', cex=.7)

plot(PlotforLM,main ="Observed Vs Modelled WPM LM Share price", ylab = "Price($)", xlab = "Date")
lines(PlotOb,col="black")
lines(PlotforLM$fitted,col="red")
legend('topright', c("Observed","Fitted","Forecasted"),lty=1, col=c('black', 'red','blue'), bty='n', cex=.7)

plot(PlotforAutoARIMA,main ="Observed Vs Modelled WPM ARIMA Share price", ylab = "Price($)", xlab = "Date")
lines(PlotOb,col="black")
lines(PlotforAutoARIMA$fitted,col="red")
legend('topright', c("Observed","Fitted","Forecasted"),lty=1, col=c('black', 'red','blue'), bty='n', cex=.7)