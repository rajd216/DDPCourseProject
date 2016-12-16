
library(shiny)
library(datasets)

# Define UI for application

ui <- fluidPage(
    titlePanel(h2("MTCARS DATA, BOX PLOTS, SUMMARY & STRUCTURE")),
   
   mainPanel(
        tabsetPanel(
          tabPanel("Box Plot",
                   h4("Exploring relation between mpg & cyl / am / hp / gear / wt variables"),
                   selectInput("var", "variable:",
                    list("Cylinders" = "cyl", 
                          "Transmission" = "am", 
                          "Horse Power" = "hp",
                          "Gears" = "gear",
                          "Weight" = "wt")), 
                   checkboxInput("outliers", "Show outliers", FALSE), plotOutput("mpgPlot")),
          tabPanel("Summary", verbatimTextOutput("summary")),
          tabPanel("mtcars.Data", dataTableOutput("carstable")),
          tabPanel("Structure", selectInput("Columns","Columns", names(mtcars), multiple = TRUE),
                   verbatimTextOutput("structure"))
        # h3(textOutput("caption"))
        )
      )
   )

# Defining server source code

carsData <- mtcars
carsData$am <- factor(carsData$am, labels = c("Automatic", "Manual"))

server <- function(input, output) {
  
  output$carstable = renderDataTable(options = list(orderClasses = TRUE), {mtcars})
  output$summary = renderPrint(summary(mtcars))
  
  df <- reactive({mtcars[,input$Columns]})
  output$structure <- renderPrint({str(df())})
  
  captionText <- reactive({paste("mpg ~", input$var)})
  output$caption <- renderText({captionText()})
  
  output$mpgPlot <- renderPlot({
    boxplot(as.formula(captionText()), 
            data = carsData, col = c("red", "green", "blue", "yellow"), xlab = input$var, ylab = "MPG",
            outline = input$outliers)
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)

