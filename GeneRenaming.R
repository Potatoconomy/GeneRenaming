# Patrick Campbell
# Gene Renaming from ENSEMBL to HGNC (Default)
# März 2021

rm(list=ls())
library("biomaRt")
library("dplyr")

dir <- "/path/to/counts/"
save_dir <- "/save/path/"
save_name <- 'counts'
cols <- c(...)  # Future column names (in order of txt files in directory)


make_df <- function(dir) {
  files <- list.files(path=dir, pattern="*.txt", full.names=TRUE, recursive=FALSE)
  print(files)
  read_in <- function(f) {
    df <- read.table(file=f, sep='\t', header=TRUE, stringsAsFactors = FALSE, colClasses = c(NA,"NULL","NULL","NULL","NULL","NULL",NA))
    colnames(df) <- c('gene_id', paste('count', f, sep=''))
    return(df)
  }
  x <- lapply(files, read_in)
  x1 <- x[1]
  
  
  for (i in 2:length(x)) {
    x1 <- merge(x1, x[i], by=c('gene_id'))
  }
  
  colnames(x1) <- c('gene_id', files)
  return(x1)
}

query_ensembl <- function(df, cols, dir, save_dir, save_name) {
  files <- list.files(path=dir, pattern="*.txt", full.names=TRUE, recursive=FALSE)
  ensembl <- useMart("ensembl")
  ensembl = useDataset("hsapiens_gene_ensembl",mart=ensembl)
  
  query <- getBM(attributes=c('ensembl_gene_id_version', 'hgnc_symbol'),
                 mart=ensembl,useCache = FALSE)
  
  idx <- match(df$gene_id, query$ensembl_gene_id_version)
  df$gene_name <- query$hgnc_symbol[idx]
  
  for (i in 1:nrow(df)) {
    if (df$gene_name[i] == "" || is.na(df$gene_name[i]) ) {
      df$gene_name[i] <- df$gene_id[i]
    }
  }
  df <- select(df, 'gene_name', files)
  df <- df[!duplicated(df$gene_name) ,]
  cols <- c('gene_name', cols)
  colnames(df) <- cols
  dir.create(file.path(save_dir), showWarnings = FALSE)
  f_save <- paste(save_dir, save_name, '.csv', sep='')
  write.csv(df, f_save)
  
  return(df)
}

x <- make_df(dir)
x <- query_ensembl(x, cols, dir, save_dir, save_name)





