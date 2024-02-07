#Clears console, environment, plot planes and frees memory
rm(list =ls(envir = globalenv()), envir = globalenv()); if(!is.null(dev.list())) dev.off(); gc(); cat("\014")

setwd('C:/Users/Jemoo/repos/lis4369/a5')

#Scalars: most basic way to store a number is through assignment
#use <-
a <- 9
a #print a

a+5

b <- sqrt(a)
b

# Nonscalar data types:
# Easiest way to sore list of numbers, through assignment, using c command
# c = combine
# Vectors(1-D arrays), by default, specified with c command
c <- c(1,2,5.3,6,-2,4)
# or c <- vector(1,2,5.3,6,-2,4)
print(c)

typeof(c)

is.list(c)
is.vector(c)

d <- c('one', 'two', 'three') #character vector
d

typeof(d)

e <- c(TRUE, TRUE, TRUE, FALSE, TRUE, FALSE)
typeof(e)

#OBJECTNAME[i,j] for object in i row, j column
# refer to columnname by OBJECTNAME$columnname
# index starts from 0
d[1]

my_str <- "Hello World!"
my_str

typeof(my_str)

sqrt(a)
sqrt(c)

a^2
c^2

min(c)
max(c)
mean(c)
sum(c)

#read.csv(NameofFile, IfFirstRowAreHeaders,Separator)
url = 'https://raw.github.com/vincentarelbundock/Rdatasets/master/csv/Stat2Data/Titanic.csv'
titanic <- read.csv(file= url, head=TRUE, sep=",")
titanic

summary(titanic)

dir() #list files in cwd
getwd()

names(titanic)

titanic$Name #prints names

titanic$Age #prints ages

attributes(titanic)

ls()

mean(titanic$Age) #NA due to missing values

mean(titanic$Age, na.rm=TRUE)
median(titanic$Age, na.rm=TRUE)
quantile(titanic$Age, na.rm=TRUE)
min(titanic$Age, na.rm=TRUE)
max(titanic$Age, na.rm=TRUE)
var(titanic$Age, na.rm=TRUE)
sd(titanic$Age, na.rm=TRUE)

summary(titanic$Age, na.rm=TRUE)

# complete.cases() return logical vector indicating which cases are complete
titanic[!complete.cases(titanic),]

#na.omit() returns object with listwise deletion of missing values

# create new dataset w/o missing data
titanic_no_missing_data <- na.omit(titanic)
titanic_no_missing_data

help(stripchart)

pdf(file="C:/Users/Jemoo/repos/lis4369/a5/myplotfile.pdf")
stripchart(titanic_no_missing_data$Age)

# histogram
# hist(titanic_no_missing_data$Age, main="Distribution of Titanic Passengers Ages", xlab="ages")

boxplot(titanic_no_missing_data$Age)
# dev.off()

# png(filename="boxplot.png", width=800, height=600, units="px", pointsize = 12, bg = "chartreuse")
boxplot(titanic_no_missing_data$Age, 
        main= "Distribution of Titanic Passengers Ages",
        xlab="Ages",
        horizontal = TRUE)

dev.off()

#Scatterplot shows graphical view of relationship between 2 sets of numbers:
# png(filename = "scatter_plot.png",
#     width=800, height=600, units="px", 
#     pointsize = 12, bg="#ccffff")
plot(titanic_no_missing_data$Age, titanic_no_missing_data$Survived,
     main= "Realtionship Between Ages and Survival",
     xlab="Age",
     ylab="Survived")

# dev.off()

save.image()