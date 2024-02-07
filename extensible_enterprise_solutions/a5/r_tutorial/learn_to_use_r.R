#Clears console, environment, plot planes and frees memory
rm(list =ls(envir = globalenv()), envir = globalenv()); if(!is.null(dev.list())) dev.off(); gc(); cat("\014")

setwd('C:/Users/Jemoo/repos/lis4369/a5/r_tutorial')


#install.packages("", dependencies = TRUE)<-- install dependencies too
#update.packages(ask = FALSE, checkBuilt = TRUE)
#installed.packages() -- details of all packages installed in specified libraries

#quantmod, dplyr, ggplot2
# %>%

#stores entire workspace to file 'R.Data'(default) so won't lose work
#save.image()
# load("filename.rda")

installed.packages()
update.packages(ask = FALSE, checkBuilt = TRUE)

#help(data)
# example(library)

data()

mtcars
#mydata <- read.table("filename.txt", sep= "|", header= TRUE, stringsAsFactor = FALSE)
#x <- read.table(file= 'clipboard')-- for Windows
#pew_data <- read.csv("http://bit.ly/11I3iuU")
mydata <- mtcars

install.packages('quantmod')
library('quantmod')
getSymbols('AAPL')
barChart(AAPL)
barChart(AAPL, subset='last 14 days')
chartSeries(AAPL, subset='last 14 days')
help(chartSeries)
help(barChart)

chartSeries(AAPL['2022-11-21::2023-11-15'])

# rm(x)

save.image()

head(mydata)

head(mydata, n=10)

tail(mydata)

str(mydata)

colnames(mydata)
rownames(mydata)

summary(mydata)

install.packages("psych")
library(psych)

describe(mydata)

cor(mydata)


choose(15, 4)

mypeople <- c("Bob", "Joanne", "Sally", "Tim", "Neal")

combn(mypeople, 2)

names(mydata)

mydata$mpg

mydata[,2:4]
mtcars[,c(2,4)]


mtcars$mpg >20
mtcars[mtcars$mpg >20,]

mpg20 <- mtcars$mpg > 20
cols <- c("mpg", "hp")

mtcars[mpg20, cols]

attach(mtcars)
mpg20 <- mpg > 20
detach(mtcars)

subset(mtcars, mpg > 20, c("mpg", "hp"))

subset(mtcars, mpg==max(mpg))

# subset(mtcars, ,c("mpg", "hp"))
# subset(mtcars, select=c("mpg", "hp"))

install.packages('dplyr')
library(dplyr)

filter(mtcars, mpg > 20)

select(mtcars, mpg, hp)

mtcars %>% filter(mpg > 20) %>% select(mpg,hp) %>% arrange(desc(mpg))

table(mtcars$mpg > 20)

plot(mtcars$disp, mtcars$mpg, 
     xlab="Engine Displacement",
     ylab="MPG",
     main="MPG Compared with Engine Displacement",
     las=1)


install.packages("ggplot2")
library(ggplot2)

qplot(disp, mpg, ylim=c(0,35), data=mtcars)

ggplot(mtcars, aes(x=disp, y=mpg)) + geom_point()
ggplot(pressure, aes(x=temperature, y=pressure)) + geom_line() + geom_point()

barplot(BOD$demand, main="Graph of Demand", names.arg = BOD$Time)

cylcount <- table(mtcars$cyl)

barplot(cylcount)

qplot(mtcars$cyl)
qplot(factor(mtcars$cyl))

ggplot(mtcars, aes(factor(cyl))) + geom_bar()

hist(mtcars$hp, breaks= 3)

qplot(hp, data=mtcars, binwidth= 50)
ggplot(mtcars, aes(x=hp)) + geom_histogram(binwidth=50)

boxplot(mtcars$mpg)

boxplot(diamonds$x, diamonds$y, diamonds$z)

mycolor = rainbow(3)
ggplot(mtcars, aes(x=factor(cyl))) + geom_bar(fill=mycolor)
ggplot(mtcars, aes(x=factor(cyl))) + geom_bar(fill=heat.colors(3))

barplot(BOD$demand, col=rainbow(6))
barplot(BOD$demand, col="royalblue3")

testscores <- c(96, 71, 85, 92, 82, 78, 72, 81, 68, 61, 78, 86, 90)
testcolors<- ifelse(testscores >= 80, "blue", "red")
# barplot(testscores, col=testcolors)
barplot(testscores, 
        col=testcolors,
        main="Test scores", 
        ylim=c(0,100),
        las=1)

testscores <- sort(c(96, 71, 85, 92, 82, 78, 72, 81, 68, 61, 78, 86, 90), decreasing = TRUE)

pdf("R_studio_output.pdf")
barplot(BOD$demand, col=rainbow(6))
dev.off()

my_vector <- c(1,1,2,3,5,8)#same type
my_list <- list(1,4,"hello", TRUE) #multiple types

my_vector <- c(7,8,23,5)
my_pct_vector <- my_vector * 0.01
print(my_pct_vector)

# apply(my_matrix, 1, median)

print(class(3))
print(class(3.0))
print(class(3L))
print(class(as.integer(3)))

edit(mtcars)

save.image()
