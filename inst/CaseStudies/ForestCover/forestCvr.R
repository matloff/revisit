
# analysis of forest cover type  data, 
# https://archive.ics.uci.edu/ml/datasets/covertype

library(R.utils)
datapath <- system.file("data", package="revisit")
filepath <- paste0(datapath, "/cover.data")
if (!file.exists(filepath)){
   download.file("https://archive.ics.uci.edu/ml/machine-learning-databases/covtype/covtype.data.gz",'cover.data.gz')
   gunzip('cover.data.gz')
   file.copy('cover.data',filepath)
   file.remove('cover.data')
}

