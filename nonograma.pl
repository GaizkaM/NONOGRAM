% -----------------------------------------------------------------------------------------------
% Pràctica Final - Llenguatges de Programació (Prolog)
% Curs 2024-25
% Nom: Gaizka Medina Gordo
% Grup: PF3-26 (Grup 301)
% Professor: Antoni Oliver Tomàs
% Convocatòria: Extraordinària
% Data: 26/06/2025
% -----------------------------------------------------------------------------------------------
% Aquesta pràctica resol nonogrames mitjançant un predicat principal:
% Diferents exemples que verifiquen parts opcionals:
%
% ?- nonograma([[5], [], [2, 1], [1], [1, 2]],  
%              [[1, 1], [1, 1], [1, 1, 1], [1, 2], [1, 1]],
%              Caselles).
%
% Caselles = [[1, 1, 1, 1, 1],
%             [0, 0, 0, 0, 0],
%             [0, 1, 1, 0, 1],
%             [0, 0, 0, 1, 0],
%             [1, 0, 1, 1, 0]]
%
%
% ?- nonograma([[2], [1]], [[2], [1], []], Caselles).
% 
% Caselles = [[1, 1, 0], [1, 0, 0]]
% 
% 
% Mida 7x7
% C = [[2, 2], [2, 2], [1, 2], [3, 1, 1], [2, 3], [5], [1, 3]],
% F = [[1, 3], [2, 2, 1], [3, 1], [1, 2], [2, 4], [2, 3], [1, 2]],
% nonograma(C, F, Caselles).
% 
% Caselles = [[1, 1, 0, 0, 1, 1, 0], 
% 			 [0, 1, 1, 0, 1, 1, 0], 
% 			 [1, 0, 1, 1, 0, 0, 0], 
% 			 [1, 1, 1, 0, 1, 0, 1], 
% 			 [1, 1, 0, 1, 1, 1, 0], 
% 			 [0, 0, 1, 1, 1, 1, 1], 
% 			 [0, 1, 0, 0, 1, 1, 1]],
% 
% 
% % Mida 3x8
% C = [[1, 1, 1], [2], [3, 2]],
% F = [[1], [1, 1], [2], [2], [1], [1], [1], []],
% nonograma(C, F, Caselles).
% 
% Caselles = [[0, 1, 0, 1, 0, 0, 1, 0], 
% 			 [0, 0, 1, 1, 0, 0, 0, 0], 
% 			 [1, 1, 1, 0, 1, 1, 0, 0]]
% 
% 
% Una altre forma de verificar la correctesa és veure si un valor de 
% Caselles és correcte per a les pistes donades
% 
% ?- nonograma([[5], [], [2, 1], [1], [1, 2]],  
%              [[1, 1], [1, 1], [1, 1, 1], [1, 2], [1, 1]],
%              [[1, 1, 1, 1, 1],
%             [0, 0, 0, 0, 0],
%             [0, 1, 1, 0, 1],
%             [0, 0, 0, 1, 0],
%             [1, 0, 1, 1, 0]]).
% true
% -----------------------------------------------------------------------------------------------
% Aspectes opcionals afegits:
%
% Nonogrames rectangulars: de mida NxM
%
% Per a poder generar nonogrames rectangulars, el que he fet bàsicament ha estat tractar durant 
% tota l'implementació de la pràctica els nonogrames amb 2 paràmetres de longitud (N i M) enlloc
% de tractar només amb N. D'aquesta manera, quan feim el length de PistaColumnes, no hi ha cap 
% problema de que aquest sigui diferent de N.
% -----------------------------------------------------------------------------------------------
% Disseny declaratiu i implementació de la solució
%
% El disseny general del codi per aquesta pràctica es basa en descompondre el problema
% dels nonogrames en diverses etapes independents que s'unifiquen al predicat principal 
% emprant allò vist a classe (recursivitat, unificació i backtracking). 
%
% El que faré serà afegir explicacions a cada passa important del codi perque quedi
% més clar, però de manera molt general l'estructura segueix aquest fluxe:
%
% 1. Creació de la matriu Caselles buida
% 2. Aplicació de les restriccions de les files amb PistesFiles
% 3. Fer la transposada de les columnes per treballar amb elles com si fosin files
% 4. Tornar a aplicar les restriccions de les files (realment columnes) amb PistesColumnes 
%
% El programa no genera imperativament una solució, sinó que descriu les condicions que 
% una solució ha de complir, deixant que Prolog explori les possibles assignacions de valors, i
% finalment agafa la primera solució possible que troba i finalitza l'execució degut al cut verd
% final.
% 
% Per a cada funció recursiva amb diferents casos, explicaré a la mateixa funció quins són aquests
% i per a que els feim servir, de la mateixa manera explicaré el perquè dels cuts.
%
% **He intentat realitzar l'explicació de les restriccions recursives de la meva manera, potser
% no sigui del tot correcta, però la idea principal ha estat la que varem xerrar a classe.
% -----------------------------------------------------------------------------------------------


% Predicat principal: resol el nonograma
nonograma(PistesFiles, PistesColumnes, Caselles) :-
	% Generam el tauler amb les Caselles buides
    generar_Caselles(PistesFiles, PistesColumnes, Caselles),
	% Aplicam les restriccions de files en funció de pistes
    aplicar_restriccions(PistesFiles, Caselles),
    % Transposam les columnes per tractarles com files
    transposada(Caselles, Columnes),
	% Tornam a aplicar les restriccions per a les columnes
    aplicar_restriccions(PistesColumnes, Columnes),
    % Ús cut verd -> una vegada trobam una solució, ens quedam amb ella
    !.

% -----------------------------------------------------------------------------------------------
% FUNCIONS PRINCIPALS
% -----------------------------------------------------------------------------------------------

% Inicialitza el tauler buit amb variables lliures

% ?- generar_Caselles([[],[],[],[],[]],[[],[],[],[],[]],Caselles).
%
% Caselles = [[_, _, _, _, _], [_, _, _, _, _], [_, _, _, _, _], [_, _, _, _, _], [_, _, _, _, _]]
generar_Caselles(PistesFiles, PistesColumnes, Caselles) :-
    % Agafam les longituds de la matriu
    length(PistesFiles, NFiles),
    length(PistesColumnes, NColumnes),
    construir_tauler(NFiles, NColumnes, Caselles).

% Construeix una matriu de dimensions donades (N i M)
% Cas base -> N = 0, no hi ha més files per construir
% Ús cut verd -> evita cridar al cas general amb N = 0
construir_tauler(0, _, []) :- !.
% Cas genearl -> Per cada fila, cridam a construir_fila_buida i restam una fila del total
construir_tauler(N, M, [Fila|Resta]) :-
    construir_fila_buida(M, Fila),
    N1 is N - 1,
    construir_tauler(N1, M, Resta).

% Crea una fila de M caselles buides
% Cas base -> M = 0, no hi ha més caselles a la fila per construir
% Ús cut verd -> evita cridar al cas general amb M = 0
construir_fila_buida(0, []) :- !.
% Cas general -> Per cada casella, afegim un element buid i restam una casella del total de la fila
construir_fila_buida(M, [_|R]) :-
    M1 is M - 1,
    construir_fila_buida(M1, R).

% Aplica les restriccions (pistes) fila a fila de manera recursiva
% Cas base -> Pistes = [], no hi ha més pistes per emprar
aplicar_restriccions([], []).
% Cas general-> Per cada pista i fila, aplicam les restriccions i cridam a la següent pista i fila
aplicar_restriccions([Pista|RPistes], [Fila|RTauler]) :-
    construir_fila(Pista, Fila),
    aplicar_restriccions(RPistes, RTauler).

% Construeix una fila segons la pista donada

% Per aplicar restriccions, el que tindrem serà una fila del tipus:
% [BlocInici, BlocMig, ... BlocFi] 
% On la quantitat de blocs vindrà donada per la longitud de la pista,
% BlocInici és com BlocMig però sense necessàriament un 0 davant
% Cada BlocMig serà del tipus [0,Uns]
% Uns -> quantitat de uns en funció de la pista (Ex: 2 -> [1,1])
% El nombre de 0s que no s'hagin emprat passaràn a la següent cridada recursiva
% Al final trobaremm BlocFi = [Uns,Rest] on Rest representarà la quantitat
% de zeros que han quedat després d'aplicar el reste de restriccions.
% La funció append ens permet generar totes les possibles solucions,
% i com Fila ja està inicialitzada amb la longitud del tauler, obviam
% totes les solucions majors que aquesta longitud.

% Després de trasposar les columnes i aplicar les restriccions, les possibles
% solucions de cada fila/columna es veuràn molt reduïdes degut a que hem
% aplicat doble restricció (per files i per columnes).

% Cas base -> la pista es buida, la fila serà emplenada per zeros
construir_fila([], Fila) :-
    length(Fila, L),
    emplenar_zeros(L, Fila).

% Cas base -> darrera restricció de la pista, afegim BlocFi
construir_fila([Primer], Fila) :-
    bloc_fi(Primer, Fila).

% Cas general -> encara queden restriccions, generam un blocMig
construir_fila([Primer|Resta], Fila) :-
    bloc_mig(Primer, Fila, Restant),
    % Crida recursiva amb els zeros que falten
    construir_fila(Resta, Restant).

% Afegeix BlocFi dins la fila
bloc_fi(Longitud, Fila) :-
	% Dividim la fila en dues parts de totes les maneres possibles
    dividir(Fila, Prefix, Sufix),
	% Només continuaràn les files on el prefix tingui tot zeros (per no dividir la pista)
    tots_zeros(Prefix),
    % Genera els uns en funció de la longitud de la pista
    generar_uns(Longitud, Uns),
    % Uneix:
    % - Els uns de la pista actual
	% - El reste de zeros que queden
    append(Uns, Rest, Sufix),
    % Generam el reste de zeros que queden ja que ens trobam al darrer bloc
    tots_zeros(Rest).

% Afegeix un BlocMig dins la fila
bloc_mig(Longitud, Fila, Rest) :-
	% Dividim la fila en dues parts de totes les maneres possibles
    dividir(Fila, Prefix, Sufix),
    % Només continuaràn les files on el prefix tingui tot zeros (per no dividir la pista)
    tots_zeros(Prefix),
	% Genera els uns en funció de la longitud de la pista
    generar_uns(Longitud, Uns),
	% Uneix:
    % - Els uns de la pista actual
	% - Un zero fixe per separar blocs
	% - El reste de la fila per a següents blocs (crida recursiva)
    append(Uns, [0|Rest], Sufix).

% -----------------------------------------------------------------------------------------------
% FUNCIONS AUXILIARS
% -----------------------------------------------------------------------------------------------

% Omple una fila només amb zeros en funció de la seva longitud
% Cas base -> hem arribat al final de la fila
% Ús cut verd -> evita cridar al cas general amb N = 0
emplenar_zeros(0, []) :- !.
% Cas general -> per cada casella de la fila, afegim un zero i cridam a la següent
emplenar_zeros(N, [0|R]) :-
    N1 is N - 1,
    emplenar_zeros(N1, R).

% Comprova que una llista està formada només per zeros
% Cas base -> llista buida
tots_zeros([]).
% Cas general -> capçalera 0 i cridam per al reste
tots_zeros([0|R]) :-
    tots_zeros(R).

% Genera una llista de N uns consecutius
% Cas base -> hem acabat 
% Ús cut verd -> evita cridar al cas general amb N = 0
generar_uns(0, []) :- !.
generar_uns(N, [1|R]) :-
    N > 0,
    N1 is N - 1,
    generar_uns(N1, R).

% Divideix una llista en dues parts, tals que A ++ B = L
% S'utilitza per provar totes les divisions possibles en blocs
dividir(L, A, B) :-
    append(A, B, L).

% Funció auxiliar que transposa les files d'una matriu (vista i treballada a classe)
transposada(L,[]):- L=[Car|_], Car=[].
transposada(M, [PrimeraCol|TRC]):- 
	extreu1acol(M, PrimeraCol),
	extreuRestaCol(M, RestaCols),
	transposada(RestaCols, TRC).

% Funció auxiliar interna que extreu la primera columna (vista i treballada a classe)
extreu1acol([],[]).
extreu1acol([PrimeraFila|RestaFiles], [PC|RC]):-
	PrimeraFila=[PC|_],
	extreu1acol(RestaFiles,RC).

% Funció auxiliar interna que extreu el reste de columnes (vista i treballada a classe)
extreuRestaCol([],[]).
extreuRestaCol([PrimeraFila|RestaFiles],[PR|RR]):-
	PrimeraFila=[_|PR],
	extreuRestaCol(RestaFiles,RR).
