# original code
pima <- read.csv('http://archive.ics.uci.edu/ml/machine-learning-databases/pima-indians-diabetes/pima-indians-diabetes.data',header=FALSE)
colnames(pima) <- c('NPreg','Gluc','BP','Thick','Insul','BMI','Genet','Age','Diab')
print(summary(glm(Diab ~ .,data=pima)))
