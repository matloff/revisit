
# analysis of MovieLens data, 
# https://grouplens.org/datasets/movielens/100k/

# read ratings data
ud <- read.table('u.data',header=F,sep='\t')
# read user covariate data
uu <- read.table('u.user',header=F,sep='|')

ud <- ud[,-4]   # remove timestamp, leaving user, item, rating
uu <- uu[,1:3]  # user, age, gender
names(ud) <- c('user','item','rating')
names(uu) <- c('user','age','gender')
uu$gender <- as.integer(uu$gender == 'M')
uall <- merge(ud,uu)

# investigate effect of age, gender on user mean ratings
usermeans <- tapply(uall$rating,uall$user,mean)
lmout <- lm(usermeans ~ uu[,2] + uu[,3])
summary(lmout)  # get estimates, p-values etc.
coef.rv(lmout)  # get a more realistic look

