
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Discretization"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("pop_cor",
                  "Underlying population correlation.",
                  min = 0,
                  max = 1,
                  value = .5),
      sliderInput("A_bins",
                  "Number of bins for variable A.",
                  min = 2,
                  max = 15,
                  value = 5),
      sliderInput("B_bins",
                  "Number of bins for variable B.",
                  min = 2,
                  max = 15,
                  value = 10),
      checkboxGroupInput("method", "Use equal sized bins instead of equal ranged bins:",
                         c("Variable A" = "A",
                           "Variable B" = "B")),
      checkboxGroupInput("cut", "Discretize:",
                         c("Variable A" = "A",
                           "Variable B" = "B"), selected = "A"),
      checkboxInput("jitter", "Jitter points to avoid overplotting?", T)
    ),

    # Show a plot of the generated distribution
    mainPanel(
      HTML("Sometimes we measure something but only have a few possible values. This could be social classes or mental traits where we use a very short meaurement. For instance, if we have 5 items scored as either 0 or 1, the possible range of scores is [0-5]. In practice this means that (Pearson) correlations based on such data will be biased towards zero to some degree due to the reduced variation.<br><br>
           The plot below shows the correlation between two variables, which may or may not be discretized. Try playing around with the options to the left and see the effects. The bias is stronger when both variables are discretized and when they use a small number of possible values. The effect also depends on how the variables are discretized (equal ranges or equal numbers).<br><br>
           The simuatlion is based on 20,000 cases, so there may be minor sampling errors."),
      plotOutput("distPlot", width = "600px"),
      hr(),
      HTML("Made by <a href='http://emilkirkegaard.dk'>Emil O. W. Kirkegaard</a> using <a href='http://shiny.rstudio.com/'/>Shiny</a> for <a href='http://en.wikipedia.org/wiki/R_%28programming_language%29'>R</a>. Source code available on <a href='https://github.com/Deleetdk/discretization'>Github</a>.")
    )
  )
))
