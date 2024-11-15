# Œcie¿ka do pliku
path <- "C:/Users/jmich/Documents/zaliczenie ekonometria/daneostateczne.csv"

# Wczytanie danych
dane <- read.csv(path, header = FALSE, sep = ",")
print(dane) # Opcjonalne, wyœwietlenie danych (plik mo¿e byæ du¿y)

# Podstawowe statystyki
summary(dane)

# Model liniowy i estymacja parametrów
model <- lm(V1 ~ V2, data = dane)
X <- model.matrix(model)
y <- dane$V1

# Obliczenie estymatora beta
beta_hat <- solve(t(X) %*% X) %*% t(X) %*% y
print(beta_hat)

# Prognozy i statystyki
y_hat <- X %*% beta_hat
R2 <- 1 - sum((y - y_hat)^2) / sum((y - mean(y))^2)
print(R2)

# Residua i ich wykres
residuals <- y - y_hat
plot(residuals, xlab = "Numer obserwacji", ylab = "Residua", main = "Wykres residuów")

# Alternatywne metryki
Rsq <- summary(model)$r.squared
RSS <- sum(model$residuals^2)

# Predykcja z przedzia³ami ufnoœci
df <- data.frame(V1 = 0, V2 = 0.09)
predict(model, df, interval = "confidence", level = 0.95)

# Wczytanie drugiego zbioru danych
path2 <- "C:/Users/jmich/Documents/zaliczenie ekonometria/zaliczenie/Michalska1.csv"
dane2 <- read.csv(path2, header = FALSE, sep = ",", col.names = c("temperatura", "deltaO18"))
print(dane2)

# Podstawowe statystyki dla drugiego zbioru danych
summary(dane2)

# Model liniowy dla drugiego zbioru danych
model2 <- lm(temperatura ~ deltaO18, data = dane2)

# Wykres rozrzutu i prosta regresji
plot(temperatura ~ deltaO18, data = dane2)
abline(model2)

# Przedzia³y ufnoœci i predykcja
pred <- predict(model2, interval = "confidence")
ddp <- data.frame(deltaO18 = c(1, 2, 3, 4, 5))
predict(model2, newdata = ddp, interval = "prediction")

# Diagnostyka modelu
summary(model2)
confint(model2)

# Wykresy diagnostyczne
par(mfrow = c(2, 2))
plot(model2)

# Obliczenie estymatora beta dla drugiego modelu
X2 <- model.matrix(model2)
y2 <- dane2$temperatura
beta_d <- solve(t(X2) %*% X2) %*% t(X2) %*% y2
print(beta_d)

# Residua i ich wykresy
residua <- y2 - X2 %*% beta_d
rss <- residua^2
plot(rss, xlab = "Numer obserwacji", ylab = "RSS")
plot(residua, xlab = "Numer obserwacji", ylab = "Residua")

# Test Breuscha-Pagana
if (!require(lmtest)) install.packages("lmtest")
library(lmtest)
bptest(model2)

# Dalsza analiza - dane wielowymiarowe
path3 <- "C:/Users/jmich/Documents/zaliczenie ekonometria/daneostateczne.csv"
dane3 <- read.csv(path3, header = FALSE, col.names = c("Long", "Temp", "saniti", "oxygen", "month"), dec = ".", sep = ",")
print(head(dane3))

# Podstawowe statystyki dla wielowymiarowych danych
summary(dane3)

# Histogram i wykres pude³kowy dla temperatury
hist(dane3$Temp, xlab = "Temperatura", main = "Histogram temperatury", breaks = sqrt(nrow(dane3)))
boxplot(dane3$Temp, ylab = "Temperatura")

# Przekszta³cenia zmiennych
dane3$month <- as.factor(dane3$month)
dane3$saniti <- as.numeric(dane3$saniti)

# Model liniowy wielowymiarowy
model3 <- lm(Temp ~ oxygen + saniti + Long, data = dane3)
summary(model3)

# Diagnostyka i regresja uproszczona
model4 <- lm(Temp ~ saniti + Long, data = dane3)
summary(model4)

# Test RESET
resettest(model3, power = 2, type = "regressor", data = dane3)
resettest(model3, power = 3, type = "regressor", data = dane3)
resettest(model3, power = 4, type = "regressor", data = dane3)
