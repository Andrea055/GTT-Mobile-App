# Orari Bus GTT

<center>
<img src="icon.png" />
<center>
<br/>

Un'applicazione scritta con Flutter per permettere la visione degli orari delle linee GTT


# Compilazione

Per compilare l'app dovete installare Flutter SDK, Android Studio o Xcode

```bash
flutter pub get
flutter build apk # oppure flutter build ios
```

# Pull request

Tutte le modifiche che volete fare all'app sono ben accette, aprite una pull request e la revisionerò.

# Sviluppo

Quest'app si basa sulla pagina di calcolo percorso del sito GTT dove facendo una query all'API, mettendo il numero della fermata come parametro, si otteranno tutti i passaggi alla fermata.
I nomi della fermata e la sua posizione sono ricavati da un file CSV(trasformato in JSON per essere più comprensibile ed evitare l'utilizzo di librerie esterne) messo a disposizione da GTT.
Tutti i vecchi endpoint del servizio 5T che avevano tutte le informazioni della fermata non sono più funzionanti e sono stati cambiati in mapi.5t.it ma, sinceramente, non so come eseguire le richieste, ho provato ad analizzare il traffico che il mio telefono fa quando, l'applicazione 5T cerca una fermata ma ovviamente è tutto criptato in SSL e la richiesta sembra una POST e non una GET con i parametri nell'URL.
Spero che un giorno 5T metta delle API pubbliche e non debba perdere 2 giorni per trovare l'endpoint giusto per i passaggi alla fermata.

