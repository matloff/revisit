x <- runif(10000) 
y <- runif(10000) + 0.02 
t.test.rv(x,y) 
for (i in 1:5) {
   print(i)
}
