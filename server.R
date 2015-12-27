library(shiny)
require(quantmod)
require(xts)
require(caret)
library(corrplot)

# plotting the stock and correlation table
shinyServer(function(input, output) {
    # stock plot with RSI and SMA indicators

    output$stockplot <- renderPlot({
        # get stock historical data from Yahoo Finance
        getSymbols(input$stock)
        # create the technical analysis string with user input parameters
        ta_string <- paste("addVo();addRSI(n=", input$rsi_period, ");addSMA(n=", input$ma_period, ")")
        # plot the chart
        chartSeries(last(get(input$stock), '12 months'), theme="white", TA=ta_string) 
        # add the stock name to chart
        title(main=input$stock)
    })
    # correlation table plot
    output$correlationplot <- renderPlot({
        # get stock history
        getSymbols(input$stock)
        y <- get(input$stock)
        # get RSI according to user input parameter
        rsi <- RSI(Cl(y),input$rsi_period)/100
        # get SMA according to user input parameter
        sma <- (Cl(y) - SMA(Cl(y),input$ma_period))/SMA(Cl(y),input$ma_period)
        # calculate 3 day return in the future 
        three_day_return <- (Next(Cl(y), k=3) - Cl(y))/Cl(y)
        # merge data to a data frame
        data.raw <- data.frame(three_day_return, rsi, sma)
        # assign meaningful names to data frame columns
        names(data.raw) <- c("3 Day Return", "RSI", "SMA")
        data.step1 <- data.raw[(100:nrow(data.raw)-3),]
        # calculate the correlations
        M <- cor(data.step1)
        # draw the coorelations
        corrplot(M, method = "circle")

    })
})