# setwd("/Users/manon/Documents/CBIO/Packages/documentation/hpar/gh_actions/test_GHaction")

load(file.path("data","hpaRelease.rda"))
  
### testing hpar version
  
getHpaRelease <- function() {
    rel <- readLines("http://www.proteinatlas.org/about/releases", warn = FALSE)
    suppressWarnings(reldate <- grep("Release date:", rel, value = TRUE)[1])
    suppressWarnings(relver <- grep("Protein Atlas version", rel, value = TRUE)[1])
    reldate <- sub("</b.+$", "", sub("^.+<b>", "", reldate))
    relver <- sub("<.+$", "", sub("^.+version ", "", relver))
    hpa <- c("version" = relver, "date" = reldate)
    ens <- grep("Ensembl version", rel, value = TRUE, useBytes=TRUE)[1]
    ens <- sub("</b>", "", sub("^.+<b>", "", ens))
    ens <- sub("\t", "", ens)
    ans <- c(hpa, ensembl = ens)
    return(ans)
  }
  
HPARel <- getHpaRelease()
  
mat <- rbind(HPARel, inst_package = c(hpaRelease["version"], 
                                        hpaRelease["date"],
                                        hpaRelease["ensembl"]))
  
### is hpar up to date?
  
test <- apply(mat,2, duplicated)[2,]
  
if (sum(test)==3){
  "Everything is up-to-date for hpar"
  stop("A new version of HPA is available:")
  }else{
    ix <- !test
    txt_hpar <-  paste0("A new version of HPA is available: " , paste0(names(mat["hpaRelease",ix]),": ",
                        mat["hpaRelease",ix], collapse = " "), "")
    warning(txt_hpar)
  }
  
