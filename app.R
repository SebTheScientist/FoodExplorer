## app.R ##
library(shinydashboard)
library(DT)
require(googlesheets)
require(tidyverse)


# pre-load recipes
recipes1 <- gs_key("15HBB5cF983vW9hTPaR-eE46gfDv94Qax8gmQxCxmZp0")



ui <- dashboardPage(
  dashboardHeader(title = "Food Explorer"),
  dashboardSidebar(),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    fluidRow(
      h1("Spaghetti Carbonara"),
      box(width = 4,
          title = "Ingredients",
          tableOutput("ingredientTable")
          ),
      
      box(width = 8,
        title = "Preparation",
        uiOutput("steps")
      )
    )
  ),
  
  tags$head(tags$style("#steps{font-size: 20px;}"))
)

server <- function(input, output) {
  
  reactiveRecipe <- reactive({
    recipes1 %>%
      gs_read(ws = "Spaghetti Carbonara")
  })

  output$ingredientTable <- renderTable({
    currentRecipe <- reactiveRecipe()
    currentRecipe <- subset(currentRecipe, currentRecipe$type == "ingredient")
    currentRecipe[c("amount", "unit", "name")]
  }, colnames = F, align = "rll", rownames = F, na = "", width = "auto")
  
  reactiveSteps <- reactive({
    frontmatter <- '<ol type="1">'
    currentRecipe <- reactiveRecipe()
    currentRecipe <- subset(currentRecipe, currentRecipe$type == "step")
    for (i in 1:length(currentRecipe$type)) {
      snippet <- paste0("<li>", currentRecipe$name[i], "</li>")
      frontmatter <- paste0(frontmatter, snippet)
    }
    frontmatter
  })
  
  output$steps <- renderUI(
    HTML(reactiveSteps())
  )
  
}

shinyApp(ui, server)