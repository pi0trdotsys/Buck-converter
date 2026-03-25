# Buck-converter 🚧⚡

Projekt przetwornicy typu **Buck** (obniżającej napięcie) oparty na sterowniku IR2104 i tranzystorach mocy IGP20N65F5. Całość przygotowana w symulatorze **LTspice**, z możliwością implementacji w rzeczywistym układzie z mikrokontrolerem (np. ESP8266 do sterowania PWM).

## ⚙️ Cechy projektu

- Napięcie wejściowe: 24–100 V DC
- Napięcie wyjściowe: regulowane (zależnie od PWM)
- Topologia: półmostek H z przetwornicą typu Buck
- Sterowanie: sygnał PWM (np. z ESP8266)

## 🔌 Zastosowanie

Ten projekt może być użyty jako:

- regulator napięcia do zasilania urządzeń elektronicznych,
- baza do nauki projektowania przetwornic impulsowych,
- część większego systemu zasilania (np. z mikrokontrolerem IoT),
- zakres napięcia, w którym przetwornica działa stabilnie

## ⚡ Co zostanie zmierzone i przeanalizowane?

Jak zachowują się bramki tranzystorów?
Które elementy się nagrzewają?
Gdzie pojawiają się dudnienia?

## 📏 Pomiary

Pomiary wykonywane są oscyloskopem. Przy częstotliwościach **200 kHz i 300 kHz** pojawiają się
interesujące zjawiska przełączeniowe, które zostaną szczegółowo przeanalizowane.

## Dead time ⏱️

W mostku z dwoma tranzystorami (high-side + low-side) nigdy nie mogą być włączone jednocześnie — spowodowałoby to zwarcie zasilania (shoot-through).

Dead time to krótka przerwa między wyłączeniem jednego a włączeniem drugiego tranzystora, gdy oba są wyłączone jednocześnie. W IR2104 wynosi ~520 ns i jest generowany sprzętowo.

## Przebiegi do zbadania 📊

1. **HO** 🔵 — bramka Q1 (high-side). Przechodzi między 0 V a ~15 V (bootstrap). Pozwala sprawdzić czy IR2104 poprawnie steruje tranzystorem.

2. **LO** 🟢 — bramka Q2 (low-side), komplementarny do HO z widocznym dead time. Jeśli amplituda jest mniejsza niż HO, problem z zasilaniem części low-side drivera.

3. **V_SW** 🟠 — węzeł między drenem Q1 a źródłem Q2, czyli wyjście mocy przed cewką. Najważniejszy przebieg — prostokąt 0 V / V_in z ringiem na zboczach. Ujawnia pasożyty PCB, decyduje o EMI, pokazuje stan obu tranzystorów jednocześnie.

4. **I_L** 🟣 — prąd przez cewkę, mierzony przez rezystor bocznikowy (shunt) szeregowo z L1. Kształt trójkątny: rośnie gdy Q1 ON, opada gdy Q2 ON. Wartość średnia odpowiada V_out = V_in × D.

## EMI (Electromagnetic Interference) 📡

EMI to zakłócenia elektromagnetyczne — niecelowo emitowana energia, która interferuje z innymi urządzeniami lub samym układem. W przetwornicy głównym źródłem są strome zbocza V_SW, które powodują emisję w paśmie 20–100 MHz. Przy wyższych częstotliwościach przełączania (200–300 kHz) zakłócenia obejmują szersze widmo.
## 📋 Ocena z projektu

Projekt składa się z dwóch części, do których przygotowujemy osobne raporty:
- **a)** Symulacja w LTspice
- **b)** Płytka PCB i jej pomiary

## 📝 Kolokwium

- Odbywa się na **drugich zajęciach od końca**
- Dwie części (odpowiadające częściom projektu)
- Ocena na podstawie **sumy punktów** z obu kolokwiów — każde z osobna nie musi być zaliczone
