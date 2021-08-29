%% INTRO-------------------------------------------------------
/*
Es un software de síntesis de voz en el que se animan a personajes, 
llamados vocaloids. Muy pronto habrán varios conciertos de esta 
temática a lo largo de varias ciudades del mundo, y para determinar 
información crítica de los cantantes nos pidieron una solución en Prolog 
para ayudar a los organizadores a elegir los vocaloids que participarán
en cada concierto.

De cada vocaloid (o cantante) se conoce el nombre y además la canción
que sabe cantar. De cada canción se conoce el nombre y la cantidad 
de minutos de duración.

Queremos reflejar entonces que:
- megurineLuka sabe cantar la canción nightFever cuya duración es de 4 
min y también canta la canción foreverYoung que dura 5 minutos.	
- hatsuneMiku sabe cantar la canción tellYourWorld que dura 4 minutos.
- gumi sabe cantar foreverYoung que dura 4 min y tellYourWorld que dura
5 min
- seeU sabe cantar novemberRain con una duración de 6 min 
y nightFever con una duración de 5 min.
- kaito no sabe cantar ninguna canción.

Tener en cuenta que puede haber canciones con el mismo nombre
pero con diferentes duraciones.
a) Generar la base de conocimientos inicial
*/
canta(megurineLuka,[(nightFever,4),(foreverYoung,5)]).
canta(hatsuneMiku,[(tellYourWorld,4)]).
canta(gumi,[(foreverYoung,4),(tellYourWorld,5)]).
canta(seeU,[(novemberRain,6),(nightFever,5)]).
canta(kaito,[]).


/*
Definir los siguientes predicados que sean totalmente inversibles, 
a menos que se indique lo contrario.

Para comenzar el concierto, es preferible introducir primero a los 
cantantes más novedosos, por lo que necesitamos un predicado para 
saber si un vocaloid es novedoso cuando saben al menos 2 canciones y 
el tiempo total que duran todas las canciones debería ser menor a 15.
	
Hay algunos vocaloids que simplemente no quieren cantar canciones largas
porque no les gusta, es por eso que se pide saber si un cantante es 
acelerado, condición que se da cuando todas sus canciones duran 4 minutos 
o menos. Resolver sin usar forall/2.
*/

esNovedoso(Vocaloid):-
 cuantasCancionesSabe(Vocaloid,CancionesQueSabe),
 duracionTotal(Vocaloid,DuracionTotalCanciones),
 CancionesQueSabe>=2,
 DuracionTotalCanciones<15.

esAcelerado(Vocaloid):-
    canta(Vocaloid,ListaCanciones),
    not(algunaCancionDuraMas(ListaCanciones,4)).

algunaCancionDuraMas(ListaCanciones,DuracionMaxima):-
    member((_,Duracion),ListaCanciones),
    Duracion>DuracionMaxima.

cuantasCancionesSabe(Participante,CancionesQueSabe):-
    canta(Participante,ListaCanciones),
    length(ListaCanciones,CancionesQueSabe).

duracionTotal(Participante,DuracionTotalCanciones):-
    canta(Participante,ListaCanciones),
    findall(Duracion,member((_,Duracion),ListaCanciones),ListaDuraciones),
    sumlist(ListaDuraciones, DuracionTotalCanciones).
    
/*
Además de los vocaloids, conocemos información acerca de varios
conciertos que se darán en un futuro no muy lejano. De cada concierto 
se sabe su nombre, el país donde se realizará, una cantidad de fama y 
el tipo de concierto.

Hay tres tipos de conciertos:
- gigante del cual se sabe la cantidad mínima de canciones que 
el cantante tiene que saber y además la duración total de todas las
canciones tiene que ser mayor a una cantidad dada.
- mediano sólo pide que la duración total de las canciones del cantante
sea menor a una cantidad determinada.
- pequeño el único requisito es que alguna de las canciones dure
más de una cantidad dada.
*/

gigante(Participante,CantMinimaCanciones,DuracionTotalMinima):-
    cuantasCancionesSabe(Participante,CancionesQueSabe),
    duracionTotal(Participante,DuracionTotalCanciones),
    CancionesQueSabe>CantMinimaCanciones,
    DuracionTotalCanciones>DuracionTotalMinima.

mediano(Participante,DuracionTotalMaxima):-
    duracionTotal(Participante,DuracionTotalCanciones),
    DuracionTotalCanciones<DuracionTotalMaxima.    


pequenio(Participante,DuracionMinimaCancion):-
    canta(Participante,ListaCanciones),
    member(Cancion, ListaCanciones),
    cumpleDuracionMinima(Cancion,DuracionMinimaCancion).

cumpleDuracionMinima((_,Duracion),DuracionMinimaCancion):-
    Duracion>DuracionMinimaCancion.
    



/*
Queremos reflejar los siguientes conciertos:

- Miku Expo, es un concierto gigante que se va a realizar en 
Estados Unidos, le brinda 2000 de fama al vocaloid que pueda participar
en él y pide que el vocaloid sepa más de 2 canciones y el tiempo mínimo 
de 6 minutos.	
- Magical Mirai, se realizará en Japón y también es gigante, pero da
una fama de 3000 y pide saber más de 3 canciones por cantante con un
tiempo total mínimo de 10 minutos. 
- Vocalekt Visions, se realizará en Estados Unidos y es mediano
brinda 1000 de fama y exige un tiempo máximo total de 9 minutos.	
- Miku Fest, se hará en Argentina y es un concierto pequeño que solo
da 100 de fama al vocaloid que participe en él, con la condición de que
sepa una o más canciones de más de 4 minutos.


1) Modelar los conciertos y agregar en la base de conocimiento todo 
lo necesario.
*/




concierto(mikuExpo,estadosUnidos,2000,Participante):-
    gigante(Participante,2,6).
concierto(magicalMirai,japon,3000,Participante):-
    gigante(Participante,3,10).
concierto(vocalektVisions,estadosUnidos,1000,Participante):-
    mediano(Participante,9).
concierto(mikuFest,argentina,100,Participante):-
    pequenio(Participante,4).


/*
2) Se requiere saber si un vocaloid puede participar en un concierto, 
esto se da cuando cumple los requisitos del tipo de concierto. 

También sabemos que Hatsune Miku puede participar en cualquier concierto.

*/



listaConciertos(Conciertos):-
    findall(Concierto,concierto(Concierto,_,_,_),ConciertosConRepeticion),
    list_to_set(ConciertosConRepeticion, Conciertos).
    
puedeParticipar(Vocaloid,Concierto):-
    concierto(Concierto,_,_,Vocaloid),
    listaConciertos(Conciertos),
    member(Concierto,Conciertos),
    Vocaloid\=hatsuneMiku.

puedeParticipar(hatsuneMiku,Concierto):-
    listaConciertos(Conciertos),
    member(Concierto,Conciertos).

/*
3) Conocer el vocaloid más famoso, es decir con mayor nivel de fama. 
El nivel de fama de un vocaloid se calcula como la fama total que
le dan los conciertos en los cuales puede participar multiplicado
por la cantidad de canciones que sabe cantar.
*/

esElMasFamoso(Vocaloid):-
    canta(Vocaloid,_),
    nivelDeFama(Vocaloid,Fama1),
    canta(OtroVocaloid,_),
    Vocaloid\=OtroVocaloid,
    forall(nivelDeFama(OtroVocaloid,Fama2),Fama2<Fama1).

nivelDeFama(Vocaloid,Fama):-
    calculoFama(Vocaloid,FamaTotal),
    cuantasCancionesSabe(Vocaloid,CancionesQueSabe),
    Fama is CancionesQueSabe * FamaTotal.

calculoFama(Vocaloid,FamaTotal):-
    canta(Vocaloid,_),
    findall(FamaConcierto,puedeParticiparYConsigueFama(Vocaloid,_,FamaConcierto), ListaFamas),
    sumlist(ListaFamas, FamaTotal).
    
puedeParticiparYConsigueFama(Vocaloid,Concierto,FamaConcierto):-
    puedeParticipar(Vocaloid,Concierto),
    concierto(Concierto,_,FamaConcierto,_).

/*
4)
Sabemos que:
megurineLuka conoce a hatsuneMiku  y a gumi 
gumi conoce a seeU
seeU conoce a kaito

Queremos verificar si un vocaloid es el único que participa de un 
concierto, esto se cumple si ninguno de sus conocidos ya sea directo 
o indirectos (en cualquiera de los niveles) participa en el mismo 
concierto.


*/
conoceA(magurineLuka,hatsuneMiku).
conoceA(magurineLuka,gumi).
conoceA(gumi,seeU).
conoceA(seeU,kaito).

conocidos(Vocaloid1,Vocaloid2):-
    conoceA(Vocaloid1,Vocaloid2).

conocidos(Vocaloid1,Vocaloid3):-
    conoceA(Vocaloid1,Vocaloid2),
    conocidos(Vocaloid2,Vocaloid3).

esElUnicoParticipanteDelConcierto(Vocaloid,Concierto):-
    puedeParticipar(Vocaloid,Concierto),
    findall(Conocido,conocidos(Vocaloid,Conocido),ListaConocidos),
    not(algunConocidoParticipa(ListaConocidos,Concierto)).

algunConocidoParticipa(ListaConocidos,Concierto):-
    member(Conocido,ListaConocidos),
    puedeParticipar(Conocido,Concierto).


/*
5) Supongamos que aparece un nuevo tipo de concierto y necesitamos 
tenerlo en cuenta en nuestra solución, explique los cambios que habría 
que realizar para que siga todo funcionando. 
¿Qué conceptos facilitaron dicha implementación?

Serían necesarios cambios en la base de conocimiento. Suponiendo que 
el concierto sea de uno de los tipos predefinidos, hay que determinar de
cual. Si no pertenece a ninguno hay que agregar el tipo nuevo acompañado
de las condiciones genericas para los vocaloids que participan. En la base
de conocimiento también hay que agregar el lugar donde se lleva a cabo el 
concierto, nivel de fama que les brinda a sus vocaloids y su nombre. 

La delegacion a otros predicados genericos como gigante/3 , mediano/2 y 
pequenio/2 facilitan esta implementacion
*/