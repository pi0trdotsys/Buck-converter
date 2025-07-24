#define PWM_PIN1 5 // (D1)
#define PWM_PIN2 4 // (D2)
#define ENABLE 0 

void setup() {
  pinMode(PWM_PIN1, OUTPUT);
  pinMode(PWM_PIN2, OUTPUT);
  pinMode(ENABLE, OUTPUT);
}

void loop() {
  
  const int period_us = 20;     // 50 kHz = 20 µs
  const int high_us = 3;        // 15% wypelnienia ≈ 3 µs
  const int deadtime_us = 1;


  GPOC = (1 << PWM_PIN2);
  GPOS = (1 << PWM_PIN1);
  delayMicroseconds(high_us);

  GPOC = (1 << PWM_PIN1);
  delayMicroseconds(deadtime_us);

  GPOS = (1 << PWM_PIN2);
  delayMicroseconds(period_us - high_us - deadtime_us);
}