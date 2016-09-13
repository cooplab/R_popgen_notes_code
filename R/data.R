## data.R -- functions for interacting with data in this package

#' Retrieve a list of all datasets, or the path of a specific dataset
#'
#' When run without arguments, this function returns a list of all datasets in
#' the \code{eve102} package, with the description, filename, and filepath of
#' each dataset. To retrieve the filepath of a specific dataset (e.g. to use
#' this path to load it), call \code{eve102_data()} with the \code{id} of the
#' dataset you wish to have the path to.
#'
#' @param id the \code{id} to specify which dataset to return the filepath to.
#' With no argument supplied, this returns a dataframe of all datasets.
#' @param include_raw whether to include the raw files.
#'
#' @examples
#' eve102_data()  # retrieve all datasets
#' eve102_data(2)  # retrieve the path to the second dataset
#' @export
eve102_data <- function(id=NULL, include_raw=FALSE) {
  # Note: these are the raw files, will likely hide these from users later on
  owidth = options()$width
  on.exit({options(width=owidth)})
  options(width=120)

  # Registry of files with descriptions (TODO: can go to TSV file in
  # inst/extdata later)
  data <- read.table(system.file('extdata', 'index.txt', package='eve102'),
                     header=TRUE, sep='\t')
  if (!include_raw) {
    data <- data[!data$raw, ]
  }
  data <- data[, -3]
  data$ids <- seq_along(data$file)
  data <- data[, c(3, 1, 2)]
  data$path  <- sapply(data$file, function(x) 
                       system.file("extdata", x, package='eve102'))
  files <- data$file
  if (!is.null(id)) {
    if (is.numeric(id)) {
      if (id > length(files) || id < 0)
        stop(sprintf("'id' must be a number between 1 and %d.", length(files)))
      return(data$path[id])
    } else if (is.character(id)) {
      i <- id == files
      if (!any(i)) stop("no file matching this 'id' found.")
      return(data$path[i])
    }
  }
  data[, -4]
}
