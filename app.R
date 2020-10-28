library(shiny)
library(maps)
library(mapproj)
source("~/learning_R/helpers.R")

census <- readRDS("~/learning_R/data/counties.rds")

# Define UI ----
ui <- fluidPage(
  titlePanel("Census data visualization"),
  sidebarLayout(
    sidebarPanel(
      helpText("Visualizes census data"),
      selectInput("var",
                  label = "Please select",
                  choices = list("Percent White", 
                                 "Percent Black",
                                 "Percent Hispanic", 
                                 "Percent Asian"),
                  selected = "Percent White"),
      sliderInput("range",
                  label = "Range of interest",
                  min = 0,
                  max = 100,
                  value = c(0,100)),
      p("Shiny is available on CRAN under:"),
      code("install.packages(Shiny)"),
      actionButton("action", label = "Action")
      
    ),
  mainPanel(
    textOutput("Selected_var"),
    textOutput("Selected_range"),
    plotOutput("Map")
   )
    
    
    
  )  
  )
  

# Define server logic ----
server <- function(input, output) {
  output$Map <- renderPlot({
    data <- switch(input$var, 
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)
    
    color <- switch(input$var, 
                    "Percent White" = "darkgreen",
                    "Percent Black" = "black",
                    "Percent Hispanic" = "darkorange",
                    "Percent Asian" = "darkviolet")
    
    legend <- switch(input$var, 
                     "Percent White" = "% White",
                     "Percent Black" = "% Black",
                     "Percent Hispanic" = "% Hispanic",
                     "Percent Asian" = "% Asian")
    percent_map(data, color, legend, input$range[1], input$range[2])
    
  })
  
  output$Selected_var <- renderText({
    paste("You have selected", input$var)
  })
  output$Selected_range <- renderText({
    paste("You have selected a range of", input$range[1], "to", input$range[2])
  }
    
    
  )
}

# Run the app ----
shinyApp(ui = ui, server = server)
