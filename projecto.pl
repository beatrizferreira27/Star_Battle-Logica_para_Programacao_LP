% lp24 - ist1114838 - projecto
:- use_module(library(clpfd)). % para poder usar transpose/2
:- set_prolog_flag(answer_write_options,[max_depth(0)]). % ver listas completas
:- [puzzles]. % Ficheiro dado. A avaliação terá mais puzzles.
:- [codigoAuxiliar]. % Ficheiro dado. Não alterar.
% Atenção: nao deves copiar nunca os puzzles para o teu ficheiro de código
% Nao remover nem modificar as linhas anteriores. Obrigado.
% Segue-se o código
%%%%%%%%%%%%

% 5.1- Visualização

/*
    Predicado: visualiza/1
    Descrição: Permite obter, em linhas diferentes, os elementos de Lista.
    Argumento:
        Lista: Lista de elementos.
*/

visualiza([]).

visualiza([H | T]) :- 
    writeln(H), 
    visualiza(T).


/*
    Predicado: visualizaLinha/1
    Descrição: Permite obter, em linhas diferentes, os elementos de Lista 
               antecedidos pelo seu índice, ":" e espaço. 
    Argumento:
        Lista: Lista de elementos.
*/

visualizaLinha(Lista) :- 
    visualizaLinha(Lista, 0).

visualizaLinha([], _).

visualizaLinha([H | T], Ac) :- 
    N is Ac + 1, 
    write(N), 
    write(': '), 
    writeln(H), 
    visualizaLinha(T, N).

% 5.2- Inserção de estrelas e pontos

/*
    Predicado: insereObjecto/3
    Descrição: Devolve o tabuleiro alterado através da inserção de um objeto na 
               coordenada indicada, caso esta anteriormente possuí-se uma 
               variável. O predicado não falha caso a coordenada fornecida não 
               pertença ao tabuleiro ou caso ela possua uma estrela ou ponto.
               Este predicado funciona chamando sucessivas funções auxiliares 
               que analizam o tabuleiro linha a linha e coluna a coluna.
    Argumentos:
        (L, C): Coordenada onde será colocado o objeto.
        Tab: Tabuleiro que será alterado.
        Obj: Objeto a ser inserido no tabuleiro.
*/

insereObjecto((L, C), Tab, Obj) :- 
    insereObjecto_linhas((L, C), Tab, 1, Obj),
    !.

% se L > N_linha, ocorre recursão até L = N_linha
insereObjecto_linhas((L, C), [_ | T1], N_linha, Obj) :-
    L > N_linha,
    Mais_linha is N_linha + 1,
    insereObjecto_linhas((L, C), T1, Mais_linha, Obj).

% quando L = N_linha, podemos começar a analizar as colunas, utilizando apenas a cabeça da lista
insereObjecto_linhas((L, C), [H1 | _], N_linha, Obj) :-
    L = N_linha,
    insereObjecto_colunas(C, H1, 1, Obj).

% quando L ultrapassa o número de linhas do tabuleiro
insereObjecto_linhas((L, _), _, N_linha, _) :-
    L > N_linha;
    true.

% se C > N_coluna, ocorre recursão até L = N_coluna
insereObjecto_colunas(C, [_ | T2], N_coluna, Obj) :-
    C > N_coluna,
    Mais_coluna is N_coluna + 1,
    insereObjecto_colunas(C, T2, Mais_coluna, Obj).

% quando C = N_coluna, determina-se se é possível ocorrer a inserção de objetos
insereObjecto_colunas(C, [H2 | _], N_coluna, Obj) :-
    C = N_coluna,
    (var(H2) -> Obj = H2; true). % se H2 for uma variável, não ocorre mudança

insereObjecto_colunas(C, _, N_coluna, _) :-
    C > N_coluna;
    true.


/*
    Predicado: insereVariosObjectos/3
    Descrição: Funciona de forma semelhante a insereObjecto/3 mas permite inserir
               vários objetos de cada vez, através de recursão, no tabuleiro. 
               L_Coord e L_Obj têm que ter o mesmo tamanho para o predicado não 
               falhar.
    Argumentos:
        L_Coord: Lista de coordenadas onde serão colocados os novos objetos.
        Tab: Tabuleiro que será alterado.
        L_Obj: Lista de objetos que serão colocados no tabuleiro.
*/

insereVariosObjectos(L_Coord, Tab, L_Obj) :-
    same_length(L_Coord, L_Obj), % falha se não tiverem o mesmo tamanho
    insereVariosObjectos_aux(L_Coord, Tab, L_Obj).

insereVariosObjectos_aux([], _, []).

insereVariosObjectos_aux([H1|T1], Tab, [H2|T2]) :-
    insereObjecto(H1, Tab, H2),
    insereVariosObjectos_aux(T1, Tab, T2).          


/*
    Predicado: inserePontosVolta/2
    Descrição: Devolve o tabuleiro inicial inserindo pontos à volta de todas as 
               coordenadas adjacentes (esquerda, direita, diagonais, cima e 
               baixo) da coordenada fornecida no objetivo. Utiliza nextTo/3 para
               determinar quais coordenadas adjacentes existem.
    Argumentos:
        Tab: Tabuleiro que será alterado.
        (L, C): Coordenada do tabuleiro.
*/

inserePontosVolta(Tab, (L, C)) :-
    findall((L_Adj, C_Adj), nextTo((L, C), (L_Adj, C_Adj), Tab), Lista_adj), % determina todas as posições adjacentes
    insereObjecto_aux(Tab, Lista_adj),
    !.

nextTo((L, C), (L_Adj, C_Adj), Tab) :- 
    length(Tab, N_Linhas),
    nth1(1, Tab, Linha),
    length(Linha, N_Colunas),
    ((L_Adj is L - 1, C_Adj is C - 1, L_Adj > 0, C_Adj > 0); % diagonal superior esquerda
     (L_Adj is L - 1, C_Adj is C, L_Adj > 0); % linha anterior, mesma coluna
     (L_Adj is L - 1, C_Adj is C + 1, L_Adj > 0, C_Adj =< N_Colunas); % diagonal superior direita
     (L_Adj is L, C_Adj is C + 1, C_Adj =< N_Colunas); % mesma linha, próxima coluna
     (L_Adj is L + 1, C_Adj is C + 1, L_Adj =< N_Linhas, C_Adj =< N_Colunas); % diagonal inferior direita
     (L_Adj is L + 1, C_Adj is C, L_Adj =< N_Linhas); % próxima linha, mesma coluna
     (L_Adj is L + 1, C_Adj is C - 1, L_Adj =< N_Linhas, C_Adj > 0); % diagonal inferior esquerda
     (L_Adj is L, C_Adj is C - 1, C_Adj > 0)). % mesma linha, coluna anterior

insereObjecto_aux(_, []).

insereObjecto_aux(Tab, [(L_Adj, C_Adj) | T]) :-
    insereObjecto((L_Adj, C_Adj), Tab, p),
    insereObjecto_aux(Tab, T).


/*
    Predicado: inserePontos/2
    Descrição: Devolve o tabuleiro alterando os elementos das coordenadas dadas, 
               caso elas sejam variáveis, para pontos. Se alguma das coordenadas 
               não estiver livre, o predicado não falha.
    Argumentos:
        Tab: Tabuleiro que será alterado.
        L_Coord: Lista de coordenadas do tabuleiro para inserção de pontos.
*/

inserePontos(Tab, L_Coord) :- 
    inserePontos(Tab, L_Coord, Tab).

inserePontos(_, [], _).

inserePontos(Tab, [H | T], Novo_Tab) :-
    insereObjecto(H, Tab, p),
    inserePontos(Novo_Tab, T, Novo_Tab),
    !.


% 5.3 Consultas

/*
    Predicado: objectosEmCoordenadas/3
    Descrição: Devolve a lista dos objetos que existem no tabuleiro nas 
               coordenadas fornecidas no objetivo. Caso sejam fornecidas 
               coordenadas fora do tabuleiro, o predicado deve falhar.
    Argumentos:
        ListaCoord: Lista de coordenadas.
        Tab: Tabuleiro (lista de listas de objetos).
        ListaObj: Lista com os objetos das posições indicadas.
*/

objectosEmCoordenadas([], _, []).

objectosEmCoordenadas([(L, C) | T1], Tab, [Pos | L_Obj]) :-
    nth1(L, Tab, Linha),
    nth1(C, Linha, Pos),
    objectosEmCoordenadas(T1, Tab, L_Obj).


/*
    Predicado: coordObjectos/5
    Descrição: Dada L_Coord, determina em quais e em quantas dessas coordenadas
               se encontra o objeto indicado no objetivo.
    Argumentos:
        Obj: Pode ser uma variável (_), uma estrela (e) ou um ponto (p).
        Tab: Tabuleiro (lista de listas com objetos).
        L_Coord: Lista de coordenadas do tabuleiro.
        L_Coord_Obj: Lista das coordenadas de L_Cood que possuem o mesmo objeto
                     que o pedido no objetivo.
        N: Número de objetos encontrados correspondentes a Obj em L_Coord.
*/

coordObjectos(_, _, [], [], 0) :- !.

% caso em que o objeto na posição pedida é igual ao objeto dado no argumento
coordObjectos(Obj, Tab, [(L, C) | T1], [(L, C) | L_Coord_Obj], N) :-
    nth1(L, Tab, Linha),
    nth1(C, Linha, Obj_Pos),
    (Obj == Obj_Pos; var(Obj), var(Obj_Pos)),
    !,
    coordObjectos(Obj, Tab, T1, L_Coord_Obj, N1),
    N is N1 + 1.

% quando não é igual avança para a seguinte
coordObjectos(Obj, Tab, [(L, C) | T1], L_Coord_Obj, N) :-
    nth1(L, Tab, Linha),
    nth1(C, Linha, Obj_Pos),
    Obj \== Obj_Pos,
    !,
    coordObjectos(Obj, Tab, T1, L_Coord_Obj, N).

% ordenação
coordObjectos(Obj, Tab, ListaCoords, ListaCoordObjs, N) :-
    coordObjectos(Obj, Tab, ListaCoords, L_Coord_Obj, N),
    sort(L_Coord_Obj, ListaCoordObjs).


/*
    Predicado: coordenadasVars/2
    Descrição: Determina se as coordenadas fornecidas correspondem às posições
               das variáveis. Falha caso não sejam e devolve tab caso sejam.
    Argumentos:
        Tab: Tabuleiro.
        ListaVars: Lista de coordenadas do tabuleiro.
*/

coordenadasVars(Tab, ListaVars) :-
    findall((L, C), (nth1(L, Tab, Linha), nth1(C, Linha, Elem), var(Elem)), L_Sem_Ordem),
    sort(L_Sem_Ordem, ListaVars).


% 5.4.1 Fechar linhas, colunas ou estruturas

/*
    Predicado: fechaListaCoordenadas/2
    Descrição: Analisa as coordenadas de L_Coord e altera o tabuleiro consoante
               3 condições: quando existem duas estrelas na mesma coluna, linha 
               ou região, preencher as restantes coordenadas com pontos; quando
               na mesma linha, coluna ou região existe uma estrela e uma posição 
               livre, colocar uma estrela na posição livre e pontos à sua volta;
               quando existem duas posições livres e nenhuma estrela, colocar
               uma estrela em cada uma dessas posições e também adicionar pontos 
               à volta de cada uma.
    Argumentos:
        Tab: Tabuleiro que irá ser alterado.
        L_Coord: Lista de coordenadas.
*/

fechaListaCoordenadas(Tab, L_Coord) :- 
    coordObjectos(e, Tab, L_Coord, L_Coord_Obj_Estrela, _),
    coordObjectos(_, Tab, L_Coord, L_Coord_Obj_Variavel, _),
    length(L_Coord_Obj_Estrela, N_estrelas),
    length(L_Coord_Obj_Variavel, N_variaveis),
    ((condicoes(Tab, L_Coord_Obj_Estrela, N_estrelas, L_Coord_Obj_Variavel, N_variaveis), !);
     true). % devolve o tabuleiro sem alterações caso ele falhe para os predicados anteriores

% h1- quando existem duas estrelas na mesma linha, coluna ou região
condicoes(Tab, _, 2, L_Coord_Obj_Variavel, _) :-
    inserePontos(Tab, L_Coord_Obj_Variavel).

% h2- quando na mesma linha, coluna ou região existe apenas uma estrela e uma posição livre
condicoes(Tab, _, 1, [(L, C)], 1) :-
    insereObjecto((L, C), Tab, e),
    inserePontosVolta(Tab, (L, C)).

% h3- quando a linha, coluna ou região não tiver nenhuma estrela e exatamente duas posições livres
condicoes(Tab, _, 0, [(L1, C1), (L2, C2)], 2) :-
    insereObjecto((L1, C1), Tab, e),
    inserePontosVolta(Tab, (L1, C1)),
    insereObjecto((L2, C2), Tab, e),
    inserePontosVolta(Tab, (L2, C2)).


/*
    Predicado: fecha/2
    Descrição: Devolve o tabuleiro depois da aplicação de fechaListaCoordenadas/2
               para cada elemento de ListaListasCoord.
    Argumentos:
        Tab: Tabuleiro que irá ser alterado.
        ListaListasCoord: Lista de listas de coordenadas.
*/

fecha(_, []) :- !.

fecha(Tab, [H | T]) :-
    fechaListaCoordenadas(Tab, H),
    fecha(Tab, T).


% 5.4.2 Encontrar padrões

/*
    Predicado: encontraSequencia/4
    Descrição: Este predicado permite determinar se uma determinada lista de 
               coordenadas é uma sequência. Para ser uma sequência, as suas 
               coordenadas têm que representar posições com variáveis, ser 
               seguidas (linha, coluna ou região) e poder ser concatenada com
               duas listas, uma à frente e outra atrás, de forma a obter L_Coord.
               se existirem mais variáveis que N, o predicado deve falhar.
    Argumentos:
        Tab: Tabuleiro.
        N: Tamanho de Seq.
        L_Coord: Lista de coordenadas do tabuleiro.
        Seq: Sequência de coordenadas; Sublista de L_Coord.
*/

encontraSequencia(Tab, N, L_Coord, Seq) :-
    length(Seq, N), % o tamanho da sequência deve ser igual a N
    saoVariaveis(Tab, Seq),
    contaVariaveis(Tab, L_Coord, N_Vars),
    N_Vars =:= N, % determina se o número de variáveis na sequência é maior que N
    sort(Seq, SeqOrdenado), % para garantir que não falhe mesmo que as coordenadas não estejam por ordem
    seguidas(Tab, SeqOrdenado),
    concatenacao(Seq, L_Coord),
    !.

% determina se as coordenadas fornecidas representam variáveis
saoVariaveis(_, []).

saoVariaveis(Tab, [(L, C) | T]) :-
    nth1(L, Tab, Linha),
    nth1(C, Linha, Elem),
    var(Elem),
    saoVariaveis(Tab, T).

% conta o total de variáveis em L_Coord
contaVariaveis(_, [], 0).

% utilizamos -> para melhorar a eficiência
contaVariaveis(Tab, [(L, C) | T], N_Vars) :-
    nth1(L, Tab, Linha),
    nth1(C, Linha, Elem),
    (var(Elem) -> 
        contaVariaveis(Tab, T, N_VarsParcial),
        N_Vars is N_VarsParcial + 1; 
    contaVariaveis(Tab, T, N_Vars)).

% determina se as coordenadas aparecem seguidas (se são adjacentes)
seguidas(_, [_]).

seguidas(Tab, [(L, C), (L_Adj, C_Adj) | T]) :-
    nextTo((L, C), (L_Adj, C_Adj), Tab), % verifica se as coordenadas são adjacentes
    seguidas(Tab, [(L_Adj, C_Adj) | T]).

% verifica se Seq pode ser concatenada de forma a obter L_Coord
concatenacao(Seq, L_Coord) :-
    append(L1, S, L_Coord), % divide L_Coord em duas partes, sendo uma delas S
    append(Seq, L2, S), % verifica se Seq pode ser concatenada com alguma lista de forma a dar S
    verificaElem(L1),
    verificaElem(L2).

% determina se as listas para a concatenação não têm estrelas
verificaElem([]).

verificaElem([(L, C) | T]) :-
    nth1(L, _, Linha),
    nth1(C, Linha, Elem),
    (Elem == p; var(Elem)),
    verificaElem(T).


/*
    Predicado: aplicaPadraoI/2
    Descrição: Dada uma lista de 3 coordenadas, este predicado coloca uma 
               estrela na primeira e terceira coordenadas, através do uso de 
               insereObjecto/3, e aplica pontos à volta dessas mesmas coordenadas 
               utilizando o predicado inserePontosVolta/2.
    Argumentos:
        Tab: Tabuleiro que irá ser alterado.
        [(L1, C1), (L2, L3), (L3, C3)]: Lista com 3 coordenadas.
*/

aplicaPadraoI(Tab, [(L1, C1), (_, _), (L3, C3)]) :-
    insereObjecto((L1, C1), Tab, e),
    insereObjecto((L3, C3), Tab, e),
    inserePontosVolta(Tab, (L1, C1)),
    inserePontosVolta(Tab, (L3, C3)).


/*
    Predicado: aplicaPadroes/2
    Descrição: Utiliza coordTodas/2 para organizar as coordenadas por linha, 
               coluna e região para posteriormente percorrer cada uma das listas 
               formadas e procurar por sequências de 3 ou 4 coordenadas para 
               aplicar aplicaPadraoI/2 ou aplicaPadraoT/2, respetivamente.
    Argumentos:
        Tab: Tabuleiro que é alterado por aplicaPadraoT/2 e aplicaPadraoI/2.
        ListaListasCoord: Lista de listas formadas por coordenadas.
*/

aplicaPadroes(Tab, _) :-
    coordTodas(_, TodasCoords), % obtem coordenadas de cada linha, coluna e região
    listaPorLista(Tab, TodasCoords).

listaPorLista(_, []).

listaPorLista(Tab, [H | T]) :-
    length(H, Tam),
    ((Tam =:= 3, encontraSequencia(Tab, 3, H, Seq)) -> aplicaPadraoI(Tab, Seq); 
     (Tam =:= 4, encontraSequencia(Tab, 4, H, Seq)) -> aplicaPadraoT(Tab, Seq)),
    listaPorLista(Tab, T).


% 5.5 Apoteose final

/* 
    Predicado: resolve/2
    Descrição: Este predicado tenta resolver o desafio através de um processo 
               recursivo utilizando os predicados aplicaPadroes/2 e fecha/2. Nem
               sempre é possível concluir o desafio até ao fim, podendo o 
               tabuleiro ficar com variáveis livres. Como tal, o predicado para 
               e devolve o tabuleiro quando já não existirem mais alterações a 
               ser feitas.
    Argumentos:
        Estrutura: Lista de listas em que cada lista é uma região do puzzle.
        Tab: Tabuleiro que sofrerá alterações devido à aplicação de fecha/2 e 
             aplicaPadroes/2.
*/

resolve(Estrutura, Tab) :- 
    coordTodas(Estrutura, TodasCoord),
    resolve_aux(TodasCoord, Tab).

resolve_aux(TodasCoord, Tab) :-
    coordenadasVars(Tab, VarsInicio),
    aplicaPadroes(Tab, TodasCoord),
    fecha(Tab, TodasCoord),
    coordenadasVars(Tab, VarsFim),
    (VarsInicio == VarsFim -> true; % se o número de variáveis não mudaram, devolve o tabuleiro
     resolve_aux(TodasCoord, Tab)). % se existirem alterações, volta a aplicar as estratégias