## Facet plot
# TODO: 
# - Get rid of the grey background.
# - Rotate x axis labels.
library(ggplot2)
facetPlotIndicator <- function(df = NULL, indicator = NULL) {
  # faceting
  data = df[df$indicatorTypeCode == indicator, ]
  data$time <- as.Date(data$time)
  data = data[data$time < as.Date("2015-06-01"),]
  # plotting
  plot = ggplot(data) + theme_bw() +
           geom_step(aes(time, value), size = 1, color = "#F2645A") +
           #geom_area(aes(time, value), alpha = .8, fill = "#F2645A") +
           facet_wrap(~ locationName) +
           labs(title = unique(data$indicatorTypeName)) +
           theme(
             panel.border = element_blank(),
             panel.grid.major = element_blank(), 
             panel.grid.minor = element_blank(), 
             panel.background = element_blank(), 
             axis.line = element_blank()
           )
  
  return(plot)
}