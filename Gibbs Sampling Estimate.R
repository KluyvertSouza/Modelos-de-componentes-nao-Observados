# Importação dos dados
library(readr)
USPCE_2015Q4 = read_csv("USPCE_2015Q4.csv")

# Os dados se referem a variação da inflação, por isso esse passo é importante:

linha = nrow(USPCE_2015Q4)-1
dados = data.frame(matrix(data=NA , nrow = linha , ncol = 1))

for (i in 1:linha) {
  
  dados[i,] = (USPCE_2015Q4$V1[i+1]/USPCE_2015Q4$V1[i])
}

#Renomeando

names(dados) = "USPCE_2015"

# Uma visualização rápida
y = ts((dados-1)*100 ,frequency = 4 , start = c(1959,1))
y = as.vector((dados$USPCE_2015-1)*100)

ts.plot(y)
n = length(y)

# Definir a distribuição a priori ----

# τ_0 ~ N( a0 , b0 )
a0 = 5
b0 = 100

# σ2 ~ IG(ν1 , S1) 
ν1 = 3
S1 = 1*(ν1-1)

# ω2 ~ IG(ν2 , S2)
ν2 = 3
S2 = 2*(0.25^2)

## Matrizes do tipo Banda ----
library(Matrix)

## Dimensão da Matriz ---- 

t = n

H = sparseMatrix(i = c(1:t  , 2:t ), j = c(1:t , 1:(t-1)), 
                 x = c(rep(1,t) , rep(-1,(t-1))) , dims = c(t, t))

## Produto H'*H ----
HH = t(H)%*%H 
It = diag(t)
HHIt = HH %*% matrix(data = rep(1,t), nrow = t , ncol = 1)

## Estimar Tau ----
# Número de iterações do Gibbs Sampling
N = 20000

# Burnin
burn = 1000
N = N + burn

# Matriz para armazenar as amostras
X = matrix(0, N, 3)
library(actuar)

# Valores iniciais
σ2 = 1
ω2 = 0.1
τ0 = 5
X[1,] = c(σ2 , ω2 ,τ0 )
tau_amostras =  data.frame(matrix(0, nrow = n, ncol = N))

# Amostrador de Gibbs
for (i in 2:N) {
  # Amostrar Tau
  Kt = (HH/X[i-1,2]) + (1/X[i-1,1])*It 
  C_τ = chol(Kt)
  τ_hat = solve(Kt)%*%((X[i-1,3]/X[i-1,2])*HHIt + y/X[i-1,1])
  tau = τ_hat + solve(t(C_τ))%*%rnorm(n , mean=0 , sd =1) 
  tau_amostras[,i-1] = as.numeric(tau)
  
  X[i,1] = rinvgamma(1 , shape = ν1 + n/2 , scale =  as.numeric(S1 + 0.5*(t(y-tau)%*%(y-tau))))  
  X[i,2] = rinvgamma(1 , shape = ν2 + n/2 , 
                     scale  = as.numeric(S2 + 0.5*( t(tau - X[i-1,3])%*%HH%*%(tau-X[i-1,3])) ))
  
  K0 = (1/b0)+(1/X[i-1,2])
  X[i,3] = rnorm(1 ,mean = (1/K0)*((a0/b0)+ rnorm(n = 1,mean = 0, sd = X[i-1,2])) ,sd = 1/K0  )
  
}

# Removendo os valroes discrepantes ----
b = burn+1
X2 = data.frame(tau_amostras[,b:N])

# Resolvendo o problema de autocorrelação ----

X2 = data.frame(tau_amostras[,-seq(2, ncol(tau_amostras), 21)])
dim(X2)
tauv = rowMeans(X2)


# Visualização
y = ts(y,frequency = 4 , start = c(1959,1))
plot(y, 
     xlab = "Ano", ylab = "PCE inflation", 
     xaxt = "n", yaxt = "n", 
     bty = "n"  , lwd = 1.9 )
lines(ts(tauv , start = c(1959,1) , frequency = 4),col='red' , lwd = 2 , lty = 2)
title(main="Estimação do Componente de Tendência", cex.lab=0.75)

box(bty = "l")
grid(nx = 10, ny = NULL, 
     lty = 3, 
     lwd = 1, 
     col = "gray")
axis(side = 1 ,lwd.ticks = 2)
axis(side = 2, las = 1 , lwd.ticks = 2)

legend(x = 1998, y = 5, 
       legend = "USPCE", 
       lty = 1,
       lwd = 2, 
       bty = "n")

legend(x = 1998, y = 4, 
       legend = "Trend", 
       lty = 1,
       lwd = 2, 
       bty = "n",
       col = 'red')

