## Make assessments.
## TODO: 
# - reshape2

library(reshape2)

makeCountryAssessment <- function(df) {
  
  # Cleaning
  df$time = as.Date(df$time)
  df = df[df$time < as.Date("2015-06-01"),]
  df = df[!duplicated(df),]  # lots of duplicates?

  # Making unique lists.
  i_list = unique(df$indicatorTypeCode)
  c_list = unique(df$locationCode)
  
  for (i in 1:length(i_list)) {
    
    # Subset for indicator.
    s = df[df$indicatorTypeCode == i_list[i],]
    for (j in 1:length(c_list)) {
      
      # Subset for country.
      s_country = s[s$locationCode == c_list[j],]
      if (nrow(s_country) != 0) {
        it <- data.frame(
          iso = c_list[j],
          date = max(s_country$time),
          indid = i_list[i]
        )
        if (j == 1) c_out <- it
        else c_out <- rbind(c_out, it)
      }
      else next
      
      # Assembling all country date.
      if (i == 1) out <- c_out
      else out <- rbind(out, c_out)
    }
  }
  d = out[!duplicated(out),]
  d$date = format(d$date, "%Y")
  e = dcast(d, iso ~ indid, value.var = "date")
  return(e)
}