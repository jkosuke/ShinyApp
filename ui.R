# Load app
library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Correlation on Life Expectancy at Birth around the world (2015)"),
  
  # Sidebar 
  sidebarLayout(
    sidebarPanel(
      radioButtons("radio", label = h3("Economic Indicator"),
                   choices = list("Domestic general government health expenditure [% of GDP]" = 5, 
                                  "Production age (15-64) population [% of total]" = 6, 
                                  "GDP per capita [current US$]" = 7),
                   selected = 5), 
      
      checkboxGroupInput("checkGroup", label = h3("Regions"), 
                         choices = list("East Asia & Pacific" = "East Asia & Pacific", 
                                        "Europe & Central Asia" = "Europe & Central Asia", 
                                        "Latin America & Caribbean " = "Latin America & Caribbean ",
                                        "Middle East & North Africa" = "Middle East & North Africa",
                                        "North America" = "North America",
                                        "South Asia" = "South Asia",
                                        "Sub-Saharan Africa " = "Sub-Saharan Africa "),
                         selected = c("East Asia & Pacific",
                                      "Europe & Central Asia",
                                      "Latin America & Caribbean ",
                                      "Middle East & North Africa",
                                      "North America",
                                      "South Asia",
                                      "Sub-Saharan Africa ")),
      
      radioButtons("method", label = h3("Line Fit Method"),
                   choices = list("lm" = "lm", 
                                  "loess" = "loess"),
                   selected = "loess")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot"),
      h3(textOutput("Cor"), style="color:blue"),
      h4("Data Summary : "),
      tableOutput("Table")
    )
  )
))


