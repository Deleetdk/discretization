
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(MASS)
library(ggplot2)
library(stringr)

shinyServer(function(input, output) {
  
  reac_data = reactive({
    #generate data
    set.seed(1)
    d = as.data.frame(mvrnorm(2e4, c(0, 0), matrix(c(1, input$pop_cor, input$pop_cor, 1), ncol = 2), empirical = T))
    colnames(d) = c("A", "B")
    
    #cut A
    if ("A" %in% input$cut) { #to cut or not
      if ("A" %in% input$method) { #how to cut
        d$A = cut(d$A, quantile(d$A, seq(0, 1, length.out = input$A_bins + 1)), labels = F, include.lowest = T)
      } else {d$A = cut(d$A, input$A_bins, labels = F)}
    }
    
    #cut B
    if ("B" %in% input$cut) {
      if ("B" %in% input$method) {
        d$B = cut(d$B, quantile(d$B, seq(0, 1, length.out = input$B_bins + 1)), labels = F, include.lowest = T)
      } else {d$B = cut(d$B, input$B_bins, labels = F)}
    }
    
    return(d)
  })

  output$distPlot <- renderPlot({
    #jittering
    if (input$jitter) {position = position_jitter(w = 0.1, h = 0.1)} else {position = "identity"}
    
    #data
    d = reac_data()
    
    #plot
    ggplot(d, aes(A, B)) +
      geom_point(position = position, alpha = .3) +
      geom_smooth(method = "lm", se = F) +
      annotate("text",
               x = -Inf,
               y = Inf,
               hjust = 0,
               vjust = 1,
               label = sprintf("Correlation in sample: %.2f", round(cor(d$A, d$B), 3)),
               color = "darkorange",
               size = 10) +
      theme_bw()
  })

})
