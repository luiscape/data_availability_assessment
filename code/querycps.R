
# Function o query the CPS API.
queryCPS <- function(indicator = "RW001", location = "AFG") {
  
  # Base url for CPS API.
  b = "https://manage.hdx.rwlabs.org/public/api2/values?"
  
  # Iterate over indicators.
  for (i in 1:length(indicator)) {
    q = paste0(b, "it=", indicator[i])
    cat("Collecting data for:", indicator[i], "\n")
    
    # Iterate over locations.
    pb = txtProgressBar(min = 0, max = length(location), char = "=", style = 3)
    for (j in 1:length(location)) {
      setTxtProgressBar(pb, j)
      q = paste0(q, "&l=", location[j])
      doc = fromJSON(getURL(q))
      
      if (doc$totalCount == 0) {
        cat("No data for", location[j],". Skipping...")
        if (j == 1) trigger = j + 1
        next
      }
      else trigger = 1
      
      # Iterate over resulting records.
      for (k in 1:length(doc$results)) {
        it = data.frame(doc$results[[k]])
        if (k == 1) country = it
        else country = rbind(country, it)
      }
      
      # Merge resulting list of countries.
      if (j == trigger) country_data <- country
      else country_data <- rbind(country_data, country)
      cat("\n")
    }
    
    # Merge resulting list of indicators.
    if (i == 1) indicator_data <- country_data
    else indicator_data <- rbind(indicator_data, country_data)
    
  }
  
  # Return, baby.
  return(indicator_data)
}

