// 8085 microprocessor assembly code for a special interrupt service routine

// we are given a task to write the code for the ISR (Interrupt Service Routine) for the interrupt obtained from a peripherical device via data bus:(11101111)2 = EFh

// we first determine which interrupt this is: 5th, 4th and 3rd digits of EFh = D5D4D3 = (101)2 = 5 => so this is RST5 interrupt and its a non-vectored interrupt. Its ISR is located at (5*8)10 = 28h address (actually 0028h)

// !! TASK !!: Write an interrupt service routine that, when an interrupt occurs, will turn on and off the LED connected to the FFH port 5 times at 0.5-second intervals (assume the system clock frequency is 2 MHz).

// assembly code for 8085 microprocessor

# ORG 0028H         // this is where the ISR for RST5 is found
	   JMP 3000     // the routine takes more than 1 line, so we reference to it
# ORG 3000H

RST5:	   PUSH PSW // we have to use stack to keep track of every register
	   PUSH B
	   MVI C,05
BLINK:
	   MVI A,01
	   OUT FF
	   CALL DELAY
	   MVI A,00
	   OUT FF
       CALL DELAY
	   DCR C
	   JNZ BLINK
	   POP B
	   POP PSW
	   EI           // this is a discussion topic
	   RET

DELAY:	   MVI B,FF // a delay subroutine for approximetly 0.5 seconds for 2MHZ processor

LOOP1:	   MVI C,FF

LOOP2:	   DCR C
	   JNZ LOOP2
	   DCR B
	   JNZ LOOP1
	   RET