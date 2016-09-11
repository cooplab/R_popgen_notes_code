## doc.R -- helpers to find vignettes

#' Browse EVE102 R tutorials, or open specific tutorial
#'
#' Running \code{tutorials()} without arguments opens a list of all 
#' available EVE102 tutorials. Entering a specific \code{num} opens that
#' tutorial.
#' 
#' @param num tutorial number (numbers 1-3).
#' @export
tutorials <- function(num=NULL) {
  if (is.null(num)) {
    browseVignettes('eve102')
  } else {
    vignette(sprintf("tutorial-%s", as.character(num)), package='eve102')
  }
}
