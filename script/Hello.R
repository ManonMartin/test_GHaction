
library(emayili)
library(statquotes)
library(magrittr)
library(hpar)

email <- envelope(
  to = "manon.martin@uclouvain.be",
  from = "manon.martin@uclouvain.be",
  subject = "HPA version update"
)

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

hpaRelease <- getHpaRelease()

mat <- rbind(hpaRelease, inst_package = c(getHpaVersion(), getHpaDate(),
                    getHpaEnsembl()))

### is hpar up to date?

test <- apply(mat,2, duplicated)[2,]

if (sum(test)==3){
  txt_hpar <- "<p> Everything is up-to-date for <code> hpar </code> </p>"
} else{
  ix <- !test
  txt_hpar <-  paste0("<p> A new version of HPA is available: <br> " , paste0(names(mat["hpaRelease",ix]),": ",
                      mat["hpaRelease",ix], collapse = " <br>"), "</p>")
}

stquot <- statquote()

# adding text
email <- email %>% html(paste(txt_hpar, "<b>And the statistical quote a the day: </b> ", stquot$text))


smtp <- server(host = "outlook.office365.com",
               port = 587,
               username = "manon.martin@uclouvain.be",
               password = "MoabArches2016")
smtp(email, verbose = TRUE)
