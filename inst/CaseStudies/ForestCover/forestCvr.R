
# analysis of forest cover type  data, 
# https://archive.ics.uci.edu/ml/datasets/covertype

library(R.utils)
datapath <- system.file("data", package="revisit")
filepath <- paste0(datapath, "/cover.data")
if (!file.exists(filepath)){
   print('downloading data')
   download.file("https://archive.ics.uci.edu/ml/machine-learning-databases/covtype/covtype.data.gz",'cover.data.gz')
   gunzip('cover.data.gz')
   file.copy('cover.data',filepath)
   file.remove('cover.data')
}

datapath <- system.file("data", package="revisit")
cvr <- read.csv(paste0(datapath, "/cover.data"), header = FALSE)             
library(randomForest)
cvr <- cvr[,c(1:10,55)]
cvr$V55 <- as.factor(as.character(cvr$V55))
testidxs <- sample(1:nrow(cvr),10000)
cvrtest <- as.matrix(cvr[testidxs,1:10])
cvrtesttrue <- cvr[testidxs,11]
cvrtrain <- cvr[-testidxs,]
print('computing, may take a few minutes')
rfout <- randomForest(V55 ~ .,data=cvrtrain)
ypred <- predict(rfout,cvrtest,type='response')
cat('correct class. rate: ',mean(ypred == cvrtesttrue),'\n')

