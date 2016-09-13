## hw.R -- functions for HW plots


RAW_DATA_COLS <- c(chr='factor', snp='character',
                   which_inds='NULL', allele_A='character',
                   allele_a='character', genotype='character',
                   obs_het='numeric', exp_het='numeric', HWE_pval='numeric')
RAWFILES <- c(CEU_10000="CEU_10000.hw.gz", 
	      CEU_YRI_10000="CEU_YRI_10000.hw.gz",
	      YRI_10000="YRI_10000.hw.gz")


#' Tidy up raw genptype data from PLINK (internal function)
#'
#' For extracting the genotype counts from the original raw data from PLINK.
#'
#' @examples 
#' \dontrun{
#'  # this is how tidy versions were created (run in package dir)
#'  files <- sapply(RAWFILES, eve102_data, include_raw=TRUE)
#'  for (i in seq_along(files)) {
#'    outfile <- file.path("inst", "extdata", paste0(names(files)[i], ".txt.gz"))
#'    outcon <- gzfile(outfile, "w")
#'    write.table(tidy_hwdata(file.path("inst", "extdata", basename(files[i]))), 
#'                file=outcon, sep="\t", quote=FALSE, row.names=FALSE)
#'    close(outcon)
#'  }
#' }
tidy_hwdata <- function(file, flip=TRUE) {
  # note: drops which_inds, since colClass is NULL
  d_raw <- read.table(file, stringsAsFactors=FALSE,
                      col.names=names(RAW_DATA_COLS),
                      colClasses=RAW_DATA_COLS)
  d <- tidyr::separate(d_raw, genotype, c("AA", "Aa", "aa"), sep='/', convert=TRUE)

  # flip half the allele labels for prettier plot (currently allele_A is always
  # minor)
  if (flip) {
    d$flip <- 1:2
    parts <- split(d, d$flip)
    # flip alleles & genotypes columns, restore original column names
    parts[[1]] <- setNames(parts[[1]][, c(1, 2, 4, 3, 7, 6, 5, 8:11)],
                           colnames(parts[[1]]))
    d <- unsplit(parts, d$flip)[, -11]  # drop flip col
  }
  d$total <- d$AA + d$Aa + d$aa
  d$freq <- (d$AA + d$Aa/2)/d$total
  return(d[, c(1:7, 12, 11)])
}

## Run to regenerate files:
# files <- sapply(RAWFILES, eve102_data, include_raw=TRUE)
# for (i in seq_along(files)) {
#   outfile <- file.path("inst", "extdata", paste0(names(files)[i], ".txt.gz"))
#   outcon <- gzfile(outfile, "w")
#   write.table(tidy_hwdata(file.path("inst", "extdata", basename(files[i]))), 
#               file=outcon, sep="\t", quote=FALSE, row.names=FALSE)
#   close(outcon)
# }

#' Combine data
#'
#' Combine all counts into one dataframe.
#' @examples 
#' \dontrun{
#'  write.table(combine_hwdata(),
#'    file=file.path("inst", "extdata", "combined_YRICEU.txt"),
#'    quote=FALSE, row.names=FALSE, sep="\t")
#' }
combine_hwdata <- function(flip=TRUE) {
  keep_cols <- c("snp", "allele_a", "allele_A", "AA", "Aa", "aa", "total")
  df_ceu <- tidy_hwdata(eve102_data('CEU_10000.hw.gz', include_raw=TRUE), 
                        flip=FALSE)[, keep_cols]
  df_yri <- tidy_hwdata(eve102_data('YRI_10000.hw.gz', include_raw=TRUE),
                        flip=FALSE)[, keep_cols]
  common_snps <- unique(c(df_ceu$snp, df_yri$snp))
  jj = merge(df_ceu, df_yri, by='snp', suffixes=c("_CEU", "_YRI"))[, -c(8,9)]
  colnames(jj)[2:3] <- c('allele_a', 'allele_A')
  if (flip) {
    jj$flip <- rep_len(1:2, nrow(jj))  # recycling not working for myserious reason
    parts <- split(jj, jj$flip)
    # flip alleles & genotypes columns, restore original column names
    parts[[1]] <- setNames(parts[[1]][, c(1, 3, 2, 6, 5, 4, 7, 10, 9, 8, 11, 12)],
                           colnames(parts[[1]]))
    jj <- unsplit(parts, jj$flip)[, -12]  # drop flip col
  }
  return(jj)
}

