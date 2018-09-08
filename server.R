# Load app
library(shiny)
library(WDI)
library(ggplot2)
library(dplyr)

# Data Download
indicators <- c("SP.DYN.LE00.IN", "SH.XPD.GHED.GD.ZS",  
                "SP.POP.1564.TO.ZS", "NY.GDP.PCAP.CD")
df <- WDI(country = "all", indicator = indicators,
          start = 2015, end = 2015, extra = TRUE)
# Exclude aggregated rows of region
df <- df[df$region != "Aggregates", ] 
# Exclude rows where all indicators are NA
df <- df[which(rowSums(!is.na(df[, indicators])) > 0), ]
# Exclude rows with no iso2c
df <- df[!is.na(df$iso2c), ]
dfInput <- data.frame()

# shiny
shinyServer(function(input, output) {
  # Plot
  output$distPlot <- renderPlot({
    variableInput <- as.numeric(input$radio)
    
    dfInput <- filter(df, region %in% input$checkGroup)
    dfInput <- dfInput[, c(4, variableInput, 9)]
    colnames(dfInput) <- c("Age", "X", "region")
    dfInput <- na.omit(dfInput)
    
    variable <- c("Domestic general government health expenditure [% of GDP]", 
                  "Production age (15-64) population [% of total]", 
                  "GDP per capita [current US$]")
    
    ggplot(dfInput, aes(x = dfInput$X, y = dfInput$Age,
                        color = region)) + 
      geom_point() +
      labs(title = "Life expectancy at birth, total") +
      theme(title=
              element_text(colour="darkred", size=17)) +
      xlab(variable[variableInput-4]) +
      theme(axis.title.x=
              element_text(face="italic",
                           colour="darkred", size=17)) +
      ylab("Age") +
      theme(axis.title.y=
              element_text(colour="darkred", size=17)) +
      stat_smooth(method=input$method, se=FALSE, 
                  colour = "salmon", size = 1)
  })
  
  # Correlation
  output$Cor <- renderText({
    variableInput <- as.numeric(input$radio)
    
    dfInput <- filter(df, region %in% input$checkGroup)
    dfInput <- dfInput[, c(4, variableInput, 9)]
    colnames(dfInput) <- c("Age", "X", "region")
    
    dfInput2 <- na.omit(dfInput)
    corInput <- cor(dfInput2$Age, dfInput2$X)
    Cor <- paste("Correlation between Life Expectancy at Birth and Selected Economic Indicator : ", 
                 round(corInput, 5))
  })
  
  # Summary
  output$Table <- renderTable({
    variableInput <- as.numeric(input$radio)
    
    dfInput <- filter(df, region %in% input$checkGroup)
    dfInput <- dfInput[, c(4, variableInput)]
    colnames(dfInput) <- c("Age", "X")
    
    variable <- c("Domestic general government health expenditure [% of GDP]", 
                  "Production age (15-64) population [% of total]", 
                  "GDP per capita [current US$]")
    
    dfInput3 <- na.omit(dfInput)
    a <- as.data.frame(summary(dfInput3))
    b <- as.data.frame(a[1:6, 3])
    c <- as.data.frame(a[7:12, 3])
    e <- cbind(b, c)
    colnames(e) <- c("Life expectancy at birth",
                     variable[variableInput-4])
    Table <- e
  })
  
})


