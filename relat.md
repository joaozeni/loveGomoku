## Função utilidade
Para a função utilidade de cada espaço vazio verifico cada um dos caminhos para a sequencia do espaço vazio
pontuado tanto os espaços vazios quanto as peças já postas. A função é apresentada abaixo:  
$V = (P * 3 * 10^5) + (O * 10^5)$ onde  
P são as peças do jogador já postas num caminho, este caminho deve ser possível de ser completado.  
O são espaços vazios em um caminho, este caminho deve ser possível de ser completado.

## Fim de jogo
Para a função de fim de jogo é utilizada o número de peças em jogo. A função é apresentada abaixo.  
$V = P * 10^7$  
Onde P são as peças em jogo.  
Ela é utilizada quando existe uma sequencia de 5 peças.  

## Sequencia de 4 peças
Esta lógica esta inclusa na função utilidade, uma vez que esta verifica a quantidade peças já colocadas
no caminho.

## Otimização
Para aumentar a velocidade do programa verifico apenas os espaços próximos aos quais já estão postas peças.  
