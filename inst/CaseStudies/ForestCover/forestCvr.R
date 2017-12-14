
# analysis of forest cover type  data, 
# https://archive.ics.uci.edu/ml/datasets/covertype

if (!file.exists("./data/cover.data")){
   download.file("https://archive.ics.uci.edu/ml/machine-learning-databases/covtype/covtype.data.gz",'frst.data')
   con <- gzfile('frst.data')
   frst <- readLines(con)
}

