#!/bin/bash
set -x -v -e



R --version
Rscript --version
Rscript --vanilla -e 'stopifnot(sum(c(2, 4, 6)) == 12); cat("R runtime works\n")'
Rscript --vanilla -e "writeLines(paste0('R svn rev: ', ' ', R.version\$`svn rev`))"
Rscript --vanilla -e "writeLines(paste0('R_HOME: ', R.home()))"
