## Função utilidade
A função utilidade é composta de uma soma de avaliações, sendo avaliados todos os espaços disponiveis para 
realizar uma jogada, sendo que em cada um destes espaços é avaliado o valor desta jogada para o jogador e 
para o seu oponente.  
Para cada espaço disponivel para jogar a avaliação é feita levando em consideração quantos vizinhos da cor 
do jogador a posição posui, sendo o valor exponencial do número de vizinhor, o valor é dobrado caso a outra 
extremidade esteja aberta.  
As funções matematicas são apresentadas abaixo:  
$V = \sum_{listaDePocisoes}^{x,y} f(x,y,corJogador) - f(x,y,corAdversario)$  

$f(x,y,cor) = 2^{numeroDeVizinhos(x,y,cor)}$  
A logica para isto é que um tabuleiro bom para o jogador é um tabuleiro que contém boas jogadas para o jogador 
e não contém jogadas boas para o adversário.

## Fim de jogo
Para a função de fim de jogo é utilizada o número de peças em jogo. A função é apresentada abaixo.  
$V = 10^{Pecas}$  
Ela é utilizada quando existe uma sequencia de 5 peças.  

## Sequencia de 4 peças
Esta lógica esta inclusa na função utilidade, uma vez que esta verifica a quantidade peças já colocadas
no caminho.

## Otimização
Para aumentar a velocidade do programa verifico apenas os espaços próximos aos quais já estão postas peças.  

## Implementação do tabuleiro
O tabuleiro é implementado usando uma tabela de tabelas(sendo o modo de implementar uma matriz), visto que 
esta é a estrutura fundamental da linguagem lua. A implementação do também pertime fazer as verificações 
necessárias para a mecânica de jogo e para a IA, sendo que estas duas verificações foram feitas em duas 
funções diferentes para facilidade de modificação e avaliação. Fora isto a classe é apenas utilizada como um 
acessor para a matriz.

## Implementação da IA
A implementação da função de minimax é feita de forma recursiva sendo quando é encontrada uma folha, por 
limite de profundidade ou vitória de um jogador, é feita uma avaliação do tabuleiro. Sendo que a cada chamada 
recursiva da função é testada uma nova jogada inserida no tabuleiro, que é posteriormente retirada, sendo 
assim a arvore de busca é gerada dinamicamente e é feita uma busca em profundidade. A avaliação da folha é 
apenas um implementação em código da função mátematica apresentada anteriormente, que pode ser vista no 
arquivo ia.lua
