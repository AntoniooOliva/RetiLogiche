### Oliva Antonio
# PROVA FINALE RETI LOGICHE A.A. 2023/2024

## Descrizione generale
La specifica della "Prova Finale (Progetto di Reti Logiche)" per l'Anno Accademico 2023/2024 chiede di implementare un modulo HW (descritto in VHDL) che si interfacci con una memoria e che rispetti le indicazioni riportate nella seguente specifica.<br>
A livello generale, il sistema legge un messaggio costituito da una sequenza di K parole W il cui valore è compreso tra 0 e 255. Il valore 0 all'interno della sequenza deve essere considerato non come valore ma come informazione "il valore non è specificato". La sequenza di K parole W da elaborare è memorizzata a partire da un indirizzo specificato (ADD), ogni 2 byte (e.g. ADD, ADD+2, ADD+4, ..., ADD+2*(K-1)). II byte mancante dovrà essere completato come descritto in seguito. Il modulo da progettare ha il compito di completare la sequenza, sostituendo gli zero laddove presenti con l'ultimo valore letto diverso da zero, ed inserendo un valore di "credibilità” C, nel byte mancante, per ogni valore della sequenza. La sostituzione degli zero avviene copiando l'ultimo valore valido (non zero) letto precedente e appartenente alla sequenza. Il valore di credibilità C è pari a 31 ogni volta che il valore W della sequenza è non zero, mentre viene decrementato rispetto al valore precedente ogni volta che si incontra uno zero in W. Il valore C associato ad ogni parola W viene memorizzato in memoria nel byte subito successivo (i.e. ADD+1 per W in ADD, ADD+3 per W in ADD+2,...). Il valore C è sempre maggiore o uguale a 0 ed è reinizializzato a 31 ogni volta che si incontra un valore W diverso da zero. Quando C raggiunge il valore 0 non viene ulteriormente decrementato.

__ESEMPIO (valori in decimale)__:<br>
Sequenza di partenza (in grassetto i valori W):<br>
&emsp; &emsp; 128 0 64 0 0 0 0 0 0 0 0 0 0 0 1000 1000 5 0 23 0 200 0 0 0<br>
Sequenza finale:<br>
&emsp; &emsp; 128 31 64 31 64 30 64 29 64 28 64 27 64 26 100 31 1 31 1 30 5 31 23 31 200 31 200 30

## Funzionamento
Il modulo da implementare ha 3 ingressi primari, uno ad 1 bit (START), uno a 16 bit (ADD) e uno da 10 bit (K), e una uscita primaria da 1 bit (DONE). Inoltre, il modulo ha un segnale di clock CLK, unico per tutto il sistema, e un segnale di reset RESET anch'esso unico per tutto il sistema. Tutti i segnali sono sincroni e devono essere interpretati sul fronte di salita del clock. L'unica eccezione è RESET che, invece, è asincrono.<br>
All'istante iniziale, quello relativo al reset del sistema, l'uscita DONE deve essere 0. Quando RESET torna a zero, il modulo partirà nella elaborazione quando un segnale START in ingresso verrà portato a 1. Il segnale di START rimarrà alto fino a che il segnale di DONE non verrà portato alto; al termine della computazione (e una volta scritto il risultato in memoria), il modulo da progettare deve alzare (portare a 1) il segnale DONE che notifica la fine dell'elaborazione. Il segnale DONE deve rimanere alto fino a che il segnale di START non è riportato a 0. Un nuovo segnale START non può essere dato fin tanto che DONE non è stato riportato a zero.<br>
Il modulo deve essere progettato considerando che prima del primo START=1 (e prima di richiedere il corretto funzionamento del modulo) verrà sempre dato il RESET (RESET=1). Prima del primo reset del sistema, il funzionamento del modulo da implementare è non specificato. Una seconda (o successiva) elaborazione con START=1 non dovrà invece attendere il reset del modulo. Ogni qual volta viene dato il segnale di RESET (RESET=1), il modulo viene re-inizializzato.<br>
Quando il segnale di START viene posto ad 1 (e per tutto il periodo in cui esso rimane alto) sugli ingressi ADD e K vengono posti il primo indirizzo e la dimensione della sequenza da elaborare. Il modulo prima di alzare il segnale di DONE deve aggiornare la sequenza ed i relativi valori di credibilità al valore opportuno seguendo la descrizione generale del modulo.

__Nota__: Se il primo dato della sequenza è pari a zero, il suo valore rimane tale e il valore di credibilità deve essere posto a 0 (zero). Lo stesso succede fino al raggiungimento del primo dato della sequenza con valore diverso da zero.

#### Voto finale: 28
