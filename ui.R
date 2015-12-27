library(shiny)

# Define UI for application that draws the stock chart and add RSI and SMA indicators based on user input
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Stock Return Correlation with Relative Strength Index and Moving Average"),

    # Sidebar for input
    sidebarLayout(
        sidebarPanel(
            # selection box for stock code
            selectInput("stock", label = h3("Select Stock:"), 
                choices = list("IBM" = "IBM", "Apple" = "AAPL","Microsoft" = "MSFT"), selected = "IBM"),
            # slider input for period of Relative Strength Index                                       
            sliderInput("rsi_period", label=h4("Period for Relative Strength Index (RSI):"), min = 2, max = 20, value = 14),
            # slider input for period of simple moving average
            sliderInput("ma_period", label=h4("Period for Simple Moving Average (SMA):"), min = 10, max = 50, value = 25)
            
    ),

        # Show a plot of the stock chart with RSI and SMA
        mainPanel(
            h3("Documentation"),
            h5("This application lets user to experiment with different values of parameters for RSI and SMA and check the correlation of these indicators with the stock's next 3 day return during a period up to 8 years (depending on the availability of historical data from Yahoo Finance)."),
            h5("The historical stock data are collected from Yahoo Finance via the Quantmod package. The 3 days of return is calculated from the difference in closing price in 3 days."),            
            h5("For the correlation calculation, 3 day return, RSI and SMA data are normalized. The 3 day return is normalized by dividing the 3 day return by the closing price of the fist day."),
            h5("The RSI value is divided by 100 so that it falls between 0 and 1. The SMA value is normalized as a percentage deviation of the closing price from the SMA value."),            
            h5("The stock plot is using the Quantmod package while the correlation plot is using the corrplot package. The color and size of the circle shows the extent of correlation."),
            h5("For easy viewing the stock plot is using the last 12 months of data."),
            h3("Stock Plot with RSI and SMA"),
            plotOutput("stockplot"),
            h3("Calculation"),
            h5("Correlation between the stock return and technical analysis indicators are performed"),
            h3("Stock 3 day return correlation with RSI and SMA"),
            plotOutput("correlationplot")
        )
    )
))