# Estimação Bayesiana de Modelos de componentes não Observados

  Essa publicação se refere ao trabalho de J.C.C. Chan que pode ser encontrado em https://joshuachan.org/papers/BayesMacro. Minha tarefa foi transcrever a rotina de códigos presente no capítulo 6 (que estava em MatLab) para a linguagem R. Essa modelos se enquadram em uma classe mais ampla de modelos chamada modelo de espaço de estado, modelos de espaço de estado lineares, alvo da minha pesquisa de mestrado.
## Modelos de Nível Local
O modelo de componentes não observados mais simples é o modelo de nível local:

$y_t=\tau_t+\varepsilon_t$ (1), 

em que  $\varepsilon_t$ $\sim\mathcal{N}(0,\sigma^2)$ , $t=1,2,...,T$. A equação (1) é chamada de equação de observações. O nível local $\tau_t$ é modelado como um passeio aleatório: 

$\tau_t =\tau_{t-1}+\eta_t$ (2),   

em que $\varepsilon_t$ $\sim \mathcal{N}(0,\omega^2)$,  $t=1,2,...,T$, e $\tau_0$ é considerado parâmetro desconhecido. A equação (2) é chamada de equação de estados.

# Estimação
O processo de estimação e toda derivação das posterioris estão no livro com muitos detalhes. Nessa abordagem, como $\omega^2$ é inferido apenas a partir dos estados $\boldsymbol{\tau}$, que não são diretamente observados, por esse motivo a distribuição a priori do parâmetro de suavidade $\omega^2$ tem um grande impacto nos resultados a posteriori. Podemos usar o amostrador de Gibbs em 4 blocos para simular uma amostra da distribuição a posteriori:

1. simular $\tau^{(r)} \sim p(\tau \mid y, \sigma^{2(r-1)}, \omega^{2(r-1)}, \tau_0^{(r-1)})$ (normal multivariada).
2. simular $\sigma^{2(r)} \sim p(\sigma^2 \mid y, \tau^{(r)}, \omega^{2(r-1)}, \tau_0^{(r-1)})$  (gamma-inversa).
3. simular $\omega^{2(r)} \sim p(\omega^2 \mid y, \tau^{(r)}, \sigma^{2(r)}, \tau_0^{(r-1)})$ (gamma-inversa).
4. simular $\tau_0^{(r)} \sim p(\tau_0 \mid y, \tau^{(r)}, \sigma^{2(r)}, \omega^{2(r)})$ (normal).

## Toy example
### Dados Simulados

```
## Tamanho da amostra
n = 300

## Variância
sig = 0.1

## Média 
mi = sin(2*pi * seq(0,1,length = n))

## Observações
y = mi + rnorm(n = n, mean = 0 , sd = sig)
```
![Rplot02](https://github.com/user-attachments/assets/b6770f37-4d27-4d1d-bb38-157e60fa0526)

Em que a variável `Trend` é o componente de tendência estimado ($\tau$). O desenvolvimento está no código.


## Exemplo empírico

  Na seção 6.1.2, o autor apresenta uma aplicação: estimação da tendência da inflação. Especificamente, foi ajustado aos dados do PCE de 1959Q1 a 2015Q4 usando o modelo de componentes não observados em (6.1)–(6.2).

Conforme mencionado no livro, $ω^2$ controla a suavidade do componente de tendência. Foi definido $ν_{ω2} = 3$ e $S_{ω^2} = 2 \times 0,25^2$, de modo que a média a priori de $ω^2$ seja $0,25^2$. 


