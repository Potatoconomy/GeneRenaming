# Patrick Campbell
# Gene Renaming from ENSEMBL to HGNC (Default)
# März 2021

library("biomaRt")
library("dplyr")

dir <- "/path/to/counts/"
save_dir <- "/save/path/"
save_name <- 'counts'

make_df <- function(dir) {
  files <- list.files(path=dir, pattern="*.txt", full.names=TRUE, recursive=FALSE)
  
  read_in <- function(f) {
    df <- read.table(file=f, sep='\t', header=TRUE, stringsAsFactors = FALSE, colClasses = c(NA,"NULL","NULL","NULL","NULL","NULL",NA))
    colnames(df) <- c('gene_id', 'count')
    return(df)
  }
  
  x <- lapply(files, read_in)
  x1 <- x[1]
  
  for (i in 2:length(x)) {
    x1 <- merge(x1, x[i], by=c('gene_id'))
  }
  
  colnames(x1) <- c('gene_id', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12')
  return(x1)
}

query_ensembl <- function(df, dir) {
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
  
  df <- select(df, 'gene_name', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12')
  
  
  #f_save <- paste(gsub('.{4}$', '', f),'.csv',sep='')
  f_save <- paste(dir, 'counts.csv')
  write.csv(df, f_save)
  
  return(df)
}

x <- make_df(dir)
x <- query_ensembl(x, dir)
x <- x[!duplicated(x$gene_name) ,]

f_save <- paste(dir_2, save_name, '.csv', sep='')
write.csv(x, f_save)

# Optional if you would like to change column names
#colnames(x) <- c(...)






