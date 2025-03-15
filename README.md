# Modelos de componentes não Observados

  Essa publicação se refere ao trabalho de J.C.C. Chan que pode ser encontrado em https://joshuachan.org/papers/BayesMacro. Minha tarefa foi transcrever a rotina de códigos presente no capítulo 6 (que estava em MatLab) para a linguagem R. Essa modelos se enquadram em uma classe mais ampla de modelos chamada modelo de espaço de estado, modelos de espaço de estado lineares, alvo da minha pesquisa de mestrado.

  Os métodos bayesianos são baseados em regras elementares da teoria das probabilidades. Apresenta como principal característica a capacidade de poder combinar novas evidências com conhecimentos anteriores através do uso do teorema de Bayes.
Suponha que tenhamos um modelo caracterizado pela função de verossimilhança $p(\textbf{y}|\boldsymbol{\theta})$, em que $\boldsymbol{\theta}$ é o vetor de parâmetros desconhecidos (geralmente não observáveis). Obtida uma amostra $\textbf{y}=\{y_1 , ..., y_T\}'$, o objetivo do método bayesiano é obter a distribuição a posteriori $p(\boldsymbol{\theta}|\textbf{y})$, que resume toda a informação sobre o vetor de parâmetros \boldsymbol{$\theta$} condicionada aos dados observados. Dessa forma, aplicando o Teorema de Bayes, a distribuição a posteriori pode ser calculada como: 
\
$$p(\boldsymbol{\theta}|\textbf{y}) =\frac{p(\boldsymbol{\theta})p(\textbf{y}|\boldsymbol{\theta})}{p(\textbf{y})}$$\
  A informação de que dispomos sobre $\boldsymbol{\theta}$ pode é resumida probabilisticamente através de $p(\boldsymbol{\theta})$ e é chamada de distribuição a priori de $\boldsymbol{\theta}$ e $$p(\textbf{y})=\int p(\boldsymbol{\theta}) p(\textbf{y}|\boldsymbol{\theta})d\boldsymbol{\theta} $$ é a verossimilhança marginal.

