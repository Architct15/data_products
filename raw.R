require(quantmod)
require(TTR)
require(xts)
require(caret)
library(corrplot)
x <- "SPY"
getSymbols(x)
y <- get(x)
rsi2 <- RSI(Cl(y),2)/100
rsi4 <- RSI(Cl(y), 4)/100
atr3 <- ATR(y, 3)$tr/Cl(y)
return3 <- (Next(Cl(y), k=5) - Cl(y))/Cl(y)
mom10 <- (Cl(y) - lag(Cl(y), 10))/lag(Cl(y), 10)
mom5 <- (Cl(y) - lag(Cl(y), 5))/lag(Cl(y), 5)
mom2 <- (Cl(y) - lag(Cl(y), 2))/lag(Cl(y), 2)
mom1 <- (Cl(y) - lag(Cl(y), 1))/lag(Cl(y), 1)
ma20 <- (Cl(y) - SMA(Cl(y),20))/SMA(Cl(y),20)
ma10 <- (Cl(y) - SMA(Cl(y),10))/SMA(Cl(y),10)
ma5 <- (Cl(y) - SMA(Cl(y),5))/SMA(Cl(y),5)
#data.raw <- data.frame(return3,rsi2, rsi4, atr3, mom10, mom5, mom2, mom1, ma20, ma10, ma5)
data.raw <- data.frame(return3,rsi2, mom5, ma20)

#names(data.raw) <- c("return3", "rsi2", "rsi4", "atr3", "mom10", "mom5", "mom2", "mom1", "ma20", "ma10", "ma5")

names(data.raw) <- c("return3", "rsi2", "mom5", "ma20")

data.step1 <- data.raw[(25:nrow(data.raw)-5),]

data.step2 <- data.step1 #[(data.step1$return3 > 0.03),]

M <- cor(data.step1)

corrplot(M, method = "number")

data.step2.sample = createDataPartition(data.step2$return3, p=0.75, list=FALSE)

data.step2.training <- data.step2[data.step2.sample,]; dim(data.step2.training)

data.step2.testing <- data.step2[-data.step2.sample,]; dim(data.step2.testing)

fit.lm <- train(return3 ~ ., data = data.step2.training, method = "lm")

summary(fit.lm)

data.step2.lm.prediction <- predict(fit.lm, newdata = data.step2.testing[,-1])

compare1 <- data.frame(data.step2.lm.prediction,data.step2.testing$return3)
names(compare1) <- c("prediction", "actual")

ggplot(compare1, aes(x=prediction, y=actual)) + geom_point(shape=1) + geom_smooth(method=lm)
