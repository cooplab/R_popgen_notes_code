## update.R -- check for updates

OWNER_REPO <- 'cooplab/eve102'

#' Check GitHub to see if the eve102 package is out of date.
#'
#' This function checks whether the eve102 package is out of date. You should
#' run this periodically throughout the quarter. We will tell you via email
#' when to update the package; this is just a way to ensure you're using the
#' most recent version.
#'
#' DO NOT PUT THIS FUNCTION IN YOUR RMARKDOWN FILES.  Calling this function
#' each time you knit your RMarkdown files will make many unnecessary requests
#' to GitHub. Check by entering \code{eve102_status()} directly in your terminal
#' only.
#'
#' @export
eve102_status <- function() {
  url <- sprintf('https://api.github.com/repos/%s/contents/DESCRIPTION',
                 OWNER_REPO)
  request <- httr::GET(url)
  if (httr::status_code(request) >= 400) {
     stop(github_error(request))
  }
  desc <- rawToChar(openssl::base64_decode(httr::content(request)$content))
  txt <- readLines(textConnection(desc))
  ver <- txt[grep("Version", txt)]
  gh_ver <- gsub("^Version: (.*)$", "\\1", ver, perl=TRUE)
  if (gh_ver != packageVersion('eve102')) {
    warning("Your eve102 package is out of date!", call.=FALSE, immediate.=TRUE)
    message("Update it by running:\n  eve102_update()")
    invisible(FALSE)
  } else { 
    message("Your eve102 package is the same version as on GitHub.")
    invisible(TRUE)
  }
}

#' Update the eve102 package
#'
#' Calling this function updates the eve102 package to the latest version on
#' GitHub.
#' 
#' @export
eve102_update <- function() {
  devtools::install_github(OWNER_REPO, build_vignettes=TRUE)
}
