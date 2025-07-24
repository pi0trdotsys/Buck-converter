# Buck-converter 🚧⚡

Projekt przetwornicy typu **Buck** (obniżającej napięcie) oparty na sterowniku IR2104 i tranzystorach mocy IGP20N65F5. Całość przygotowana w symulatorze **LTspice**, z możliwością implementacji w rzeczywistym układzie z mikrokontrolerem (np. ESP8266 do sterowania PWM).

## ⚙️ Cechy projektu

- Napięcie wejściowe: 24–100 V DC
- Napięcie wyjściowe: regulowane (zależnie od PWM)
- Topologia: półmostek H z przetwornicą typu Buck
- Sterowanie: sygnał PWM (np. z ESP8266)