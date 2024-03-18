get_files_names <- function(path){
  f <- list.files(path, full.names = T)
  return(f)
}

create_output_container <- function(groups_of_interest){
  out_con <- as.data.frame(
    matrix(
      NA, ncol=length(groups_of_interest)+2, nrow=length(files)
    )
  )
  colnames(ou_con) <- c(groups_of_interest, "total", "individual")
  out_con$individual <- extract_substring(files)
  return(out_con)
}

extract_substring <- function(input_string) {
  # Use str_extract to find the substring between the last "/" and the last "."
  # The pattern "[^/]+$" matches any characters after the last "/" until the end of the string.
  # To stop at the last ".", use a positive lookahead assertion.
  result <- str_extract(input_string, "(?<=/)[^/]+(?=\\.)")
  return(result)
}

scrap_files <- function(files){
  for(k in ( 1:n_files ) ){
    # Import of the k-th file:
    d <- read.delim(files[k], header = F)
    d <- d[,1:6]
    # We find where is the first character in the scientific name column:
    d$first_char_pos <- sapply(d[,6], function(x) unlist(gregexpr("\\S", x))[1])
    output_data$total[k] <- sum(d[d$first_char_pos==1,2])
    # we get rid of indentations of the groups column:
    d[,6] <- trimws(d[,6]) # note : we loose some information here
    # We filter the dataset:
    df <- d %>% 
      filter(word(tolower(d[,6]),1) %in% groups_of_interest | tolower(d[,6]) %in% c("homo sapiens") )
    df2 <- df %>%
      filter(df[,4] %in% c("U","R","D","K","G") | tolower(df[,6]) %in% c("homo sapiens") )
    df3 <- df2[,c(2,4,6)]
    colnames(df3) <- c("reads","rank_code","name")
    df3$name <- tolower(df3$name)
    rownames(df3) <- df3$name
    df3 <- df3[match(groups_of_interest,df3$name),]
    #
    output_data[k,1:length(groups_of_interest)] <- df3$reads
  }
}
