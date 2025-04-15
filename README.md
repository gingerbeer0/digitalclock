# Digital Stopwatch on Altera DE2 Board

This project is a digital stopwatch implemented using Verilog HDL on the Altera DE2 development board. The stopwatch counts from 00.00 to 99.99 and displays the result on 7-segment displays.

✅ Basic Features
Clock Display (7-Segment)
Displays date, hour, minute, and second in 00:00:00:00 format using SW0.

X100 Debugging Mode
Enables a high-speed simulation mode using SW3.

Time Setting Mode

Activated by SW1

Use KEY3 to enter setting mode

KEY2 to increase time (Count Up)

KEY1 to decrease time (Count Down)

Stopwatch Functionality

Activated by SW2

Use KEY3 to start and stop the stopwatch

🆕 Additional Features
Timer Function
Functions as a countdown timer.

Cuckoo Clock Feature
Plays sound or indicates each hour like a cuckoo clock.

Extended Display Options

World time mode

12-hour / 24-hour display toggle

## 🧰 Development Environment

- **FPGA Board**: Altera DE2
- **Language**: Verilog HDL
- **Software**: Quartus II

## ▶️ How to Run

1. Open the project in Quartus II.
2. Compile all design files.
3. Upload the bitstream to the Altera DE2 board.
4. Use the buttons to start, stop, and reset the stopwatch.

## 📁 Block diagram

![image](https://github.com/user-attachments/assets/e49d0abe-03c7-4104-b959-f30dfc60cf28)
![image](https://github.com/user-attachments/assets/e38d47ac-1b03-4abc-9179-3d3d3cfcebf5)

## Testbench
![image](https://github.com/user-attachments/assets/c7f84756-ebcb-4941-85ac-05ea14e5ea2c)
![image](https://github.com/user-attachments/assets/af5c3e30-ac9d-42ec-8749-de84858fb7a9)



