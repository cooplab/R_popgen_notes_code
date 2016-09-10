## update.R -- check for updates

eve102_status <- function() {
  url <- 'https://api.github.com/repos/vsbuffalo/eve102/contents/DESCRIPTION'
  request <- httr::GET(url)
  if (httr::status_code(request) >= 400) {
     stop(github_error(request))
  }
  desc <- rawToChar(openssl::base64_decode(httr::content(request)$content))
  txt <- readLines(textConnection(desc))
  ver <- txt[grep("Version", txt)]
  gh_ver <- gsub("^Version: (.*)$", "\\1", ver, perl=TRUE)
  if (gh_ver != packageVersion('eve102')) {
    warning("Your eve102 package is out of date!")
    message("Update it by running:\n\tlibary(devtools)\ninstall_github('vsbuffalo/eve102')")
    invisible(FALSE)
  } 
  message("Your eve102 package is the same version as on GitHub.")
  invisible(TRUE)
}
