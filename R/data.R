## data.R -- functions for interacting with data in this package

#' Retrieve a list of all datasets, or the path of a specific dataset
#'
#' When run without arguments, this function returns a list of all datasets in
#' the `eve102` package, with the description, filename, and filepath of each
#' dataset. To retrieve the filepath of a specific dataset (e.g. to use this path
#' to load it), call `eve102_data()` with the `id` of the dataset you wish to 
#' have the path to.
#'
#' @param id the `id` to specify which dataset to return the filepath to.
eve102_data <- function(id=NULL) {
  # Note: these are the raw files, will likely hide these from users later on
  files <- c(
             "CEU_10000.hw.gz", "CEU_YRI_10000.hw.gz", "YRI_10000.hw.gz")
  desc <- c(
            "10,000 HapMap SNPs, from CEU (Northern Europeans living in Utah)",
            "10,000 HapMap SNPs, combined from CEU and YRI samples",
            "10,000 HapMap SNPs, from YRI (Yoruban individuals in Ibadan, Nigeria")
  ids = seq_along(files)
  data <- data.frame(id=ids, files, desc, stringsAsFactors=FALSE)
  data$path  <- sapply(data$files, function(x) 
                       system.file("extdata", x, package='eve102'))
  if (!is.null(id)) {
    if (!is.numeric(id) || id > length(files) || id < 0)
      stop(sprintf("'id' must be a number between 1 and %d.", length(files)))
    return(data$path[id])
  }
  data
}
