# 🍎 Fruit Ninja Clone 🍊

Un clone del famoso gioco Fruit Ninja sviluppato in Flutter per Android con supporto per risoluzione 4K (3840x2160).

## 🎮 Caratteristiche

- **Modalità di Gioco Multiple**:
  - **Classico**: 3 vite, frutti e bombe
  - **Arcade**: 1 vita, difficoltà crescente
  - **Zen**: Modalità rilassante senza bombe

- **Supporto 4K**: Ottimizzato per schermi ad alta risoluzione (3840x2160)
- **Fisica Realistica**: Gravitazione e movimento fluido dei frutti
- **Effetti Visivi**: Particelle, trail del taglio, animazioni
- **Sistema di Punteggio**: Combo e punti per tipo di frutto
- **UI Responsiva**: Interfaccia adattiva per diverse risoluzioni

## 🛠️ Tecnologie Utilizzate

- **Flutter**: Framework UI cross-platform
- **Dart**: Linguaggio di programmazione
- **Vector Math**: Calcoli matematici per la fisica
- **Custom Paint**: Rendering personalizzato per effetti grafici

## 📱 Requisiti di Sistema

- Android 5.0 (API level 21) o superiore
- Flutter SDK 3.0.0 o superiore
- Schermo con supporto touch
- Consigliato: dispositivo con risoluzione 4K per la migliore esperienza

## 🚀 Installazione

### Prerequisiti

1. Installa [Flutter SDK](https://flutter.dev/docs/get-started/install)
2. Installa [Android Studio](https://developer.android.com/studio)
3. Configura un emulatore Android o collega un dispositivo fisico

### Setup del Progetto

1. Clona il repository:
```bash
git clone <repository-url>
cd flutter-fruit-ninja-clone
```

2. Installa le dipendenze:
```bash
flutter pub get
```

3. Esegui l'applicazione:
```bash
flutter run
```

## 🎯 Come Giocare

1. **Avvia il gioco** dal menu principale
2. **Seleziona una modalità** (Classico, Arcade, Zen)
3. **Taglia i frutti** trascinando il dito sullo schermo
4. **Evita le bombe** (tranne in modalità Zen)
5. **Mantieni le combo** per ottenere più punti
6. **Gestisci le vite** per continuare a giocare

### Controlli

- **Touch & Drag**: Taglia frutti e bombe
- **Pausa**: Tocca l'icona pausa per mettere in pausa
- **Menu**: Torna al menu principale dalla pausa

## 🏆 Sistema di Punteggio

- **Mela**: 10 punti
- **Arancia**: 15 punti
- **Anguria**: 25 punti
- **Fragola**: 20 punti
- **Banana**: 12 punti
- **Ananas**: 30 punti
- **Bomba**: -50 punti (e perdi una vita)

### Combo

- Ogni frutto tagliato aumenta il combo
- I punti vengono moltiplicati per il livello del combo
- Tagliare una bomba o mancare un frutto resetta il combo

## 🎨 Personalizzazione

### Modificare i Frutti

I frutti sono definiti nel file `lib/models/fruit.dart`. Puoi:
- Aggiungere nuovi tipi di frutto
- Modificare i colori e le emoji
- Cambiare i valori dei punti
- Regolare la fisica

### Modificare gli Effetti

Gli effetti visivi sono in:
- `lib/widgets/slice_trail.dart`: Trail del taglio
- `lib/widgets/particle_widget.dart`: Particelle
- `lib/models/game_state.dart`: Logica degli effetti

## 📁 Struttura del Progetto

```
lib/
├── main.dart                 # Entry point dell'app
├── models/
│   ├── fruit.dart           # Modello frutto
│   └── game_state.dart      # Stato del gioco
├── screens/
│   ├── menu_screen.dart     # Schermata menu
│   └── game_screen.dart     # Schermata di gioco
└── widgets/
    ├── fruit_widget.dart    # Widget frutto
    ├── slice_trail.dart     # Trail del taglio
    └── particle_widget.dart # Particelle
```

## 🔧 Configurazione 4K

Il gioco è ottimizzato per schermi 4K con:

- **Hardware Acceleration**: Abilitata per performance ottimali
- **Vector Graphics**: Scalabili senza perdita di qualità
- **Responsive Design**: Adattivo a diverse risoluzioni
- **High DPI Support**: Supporto per schermi ad alta densità

## 🐛 Risoluzione Problemi

### Problemi Comuni

1. **App non si avvia**:
   - Verifica che Flutter sia installato correttamente
   - Esegui `flutter doctor` per diagnosticare problemi

2. **Performance lente**:
   - Assicurati che l'hardware acceleration sia abilitata
   - Riduci la frequenza di spawn dei frutti

3. **Problemi di risoluzione**:
   - Verifica che il dispositivo supporti la risoluzione
   - Controlla le impostazioni di densità dello schermo

## 📄 Licenza

Questo progetto è rilasciato sotto licenza MIT. Vedi il file `LICENSE` per i dettagli.

## 🤝 Contributi

I contributi sono benvenuti! Per contribuire:

1. Fai un fork del progetto
2. Crea un branch per la tua feature
3. Committa le modifiche
4. Fai un pull request

## 📞 Supporto

Per supporto o domande:
- Apri una issue su GitHub
- Contatta gli sviluppatori

---

**Divertiti a tagliare frutti! 🍎⚔️** 