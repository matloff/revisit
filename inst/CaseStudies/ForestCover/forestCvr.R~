
# analysis of MovieLens data, 
# https://grouplens.org/datasets/movielens/100k/

if (!file.exists("./data/u.data")){
   download.file("http://files.grouplens.org/datasets/movielens/ml-100k/u.data", "u.data")
   file.rename("u.data", "./data/u.data")
}
if (!file.exists("./data/u.user")){
   download.file("http://files.grouplens.org/datasets/movielens/ml-100k/u.user", "u.user")
   file.rename("u.user", "./data/u.user")
}
# read ratings data (userID, movieID, rating, timestamp)
ud <- read.table('./data/u.data',header=F,sep='\t')
# read user covariate data (user, age, gender, ...(
uu <- read.table('./data/u.user',header=F,sep='|')

ud <- ud[,-4]   # remove timestamp, leaving user, item, rating
uu <- uu[,1:3]  
names(ud) <- c('user','item','rating')
names(uu) <- c('user','age','gender')
uu$gender <- as.integer(uu$gender == 'M')
uall <- merge(ud,uu)

# investigate effect of age, gender on user mean ratings
usermeans <- tapply(uall$rating,uall$user,mean)
lmout <- lm(usermeans ~ uu[,2] + uu[,3])
print(summary(lmout))  # get estimates, p-values etc.

