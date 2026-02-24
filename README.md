# Star Battle - Logica para Programacao (LP)

Este repositório contém a implementação em Prolog de um motor de resolução para o puzzle Star Battle, desenvolvido para a unidade curricular de Lógica para Programação (2024/25).

**O que é o Star Battle?**

O Star Battle é um puzzle de lógica jogado numa grelha N x N dividida em várias regiões. O objetivo é colocar duas estrelas em cada linha, cada coluna e cada região, respeitando as seguintes restrições:
- Distribuição: Exatamente duas estrelas por linha, coluna e região.
- Proximidade: Nenhuma estrela pode estar na vizinhança (horizontal, vertical ou diagonal) de outra estrela.
- Preenchimento: Espaços onde não podem existir estrelas devem ser marcados com um ponto (p).

**Implementação em Prolog**

O projeto utiliza Programação em Lógica e restrições sobre domínios finitos para encontrar soluções sem recorrer apenas à tentativa e erro do motor do Prolog. 

Principais Componentes:
- Visualização: Predicados para renderizar o tabuleiro no terminal de forma legível (visualiza/1, visualizaLinha/1).
- Manipulação de Dados: Predicados de inserção de objetos e pontos que respeitam a imutabilidade das variáveis até à unificação.
- Consultas e Inspeção: Extração de coordenadas e contagem de objetos ou variáveis livres no tabuleiro.
- Estratégias de Resolução:
    - Fecho de Estruturas: Completa automaticamente linhas ou regiões quando estas atingem o limite de estrelas ou espaços livres.
    - Deteção de Padrões: Aplicação de padrões lógicos (Padrão I e Padrão T) em sequências de variáveis.

Para obter uma explicação mais detalhada do projeto, consultar o documento pdf com o enunciado.

Este projeto foi classificado com nota máxima.
