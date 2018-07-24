## app.R ##
library(shinydashboard)
library(DT)

# pre-load recipes
recipes1 <- gs_key("15HBB5cF983vW9hTPaR-eE46gfDv94Qax8gmQxCxmZp0")

currentRecipe <- recipes1 %>%
  gs_read(ws = "Spaghetti Carbonara")

ui <- dashboardPage(
  dashboardHeader(title = "Food Explorer"),
  dashboardSidebar(),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    fluidRow(
      h1("Spaghetti Carbonara"),
      box(width = 4,
          #DT::dataTableOutput("ingredientTable")
          tableOutput("ingredientTable")
          ),
      
      box(
        title = "Controls",
        sliderInput("slider", "Number of observations:", 1, 100, 50),
        verbatimTextOutput("ingredientList")
      )
    )
  )
)

server <- function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
  
  output$ingredientList  <- renderText({
    paste(currentRecipe)
  })
  
  # output$ingredientTable = DT::renderDataTable({
  #   currentRecipe
  # })
  
  output$ingredientTable = renderTable({
    currentRecipe
  })
  
}

shinyApp(ui, server)