# Load libraries and data -----------------------------------------------------
library(shiny)
library(plotly)

load("MEPS_data.Rdata")

# User Interface (HTML) -------------------------------------------------------

ui <- fluidPage(

  # Add title ('h2' tag in html)
  titlePanel("Mean expenditure per person,
             MEPS 2006-2016"),

  # Dropdown input to select grouping factor
  selectInput(
    inputId = "group",
    label   = "Group By:",
    choices =
      c("Age Group"          = "age",
        "Insurance Coverage" = "insurance",
        "Race/Ethnicity"     = "race")),

  # Plotly output
  plotlyOutput(outputId = "expPlot")
)


# Server function (JavaScript) ------------------------------------------------

server <- function(input, output) {

  # 'render' function signals reactivity
  output$expPlot <- renderPlotly({

    # Get selected group from input object with inputId = 'group'
    grp <- input$group

    # Select data
    data <- MEPS_data[[grp]]

    # Create plot and return as output
    data %>%
      group_by(group) %>%
      plot_ly(x = ~Year,
              y = ~Expenditure,
              type = "scatter",
              mode = "lines+markers",
              color = ~group)
  })
}

# Run app ---------------------------------------------------------------------
shinyApp(ui = ui, server = server)
