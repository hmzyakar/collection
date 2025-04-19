// 8085 microprocessor assembly code for checking whether an 8-bit data in a given address is palindrome or not

// copy and paste directly to the 8085 simulator to see functioning

# BEGIN 0000h       // start Program Counter from 0000h
# ORG 0000h         // start this code fragment from 0000h address in memory
MAIN:               // main func
    LXI H, 1000h    // address to be given as parameter to IS_PALINDROME
    LXI SP, FFFFh   // start stack from the end of memory
    PUSH PSW        // Push flags and Accumulator to stack
    PUSH B          // Push B and C registers to stack
    PUSH D          // Push D and E registers to stack
    // uses A, B, C, D, E registers and CY flag, reads the data shown by HL and checks if the data is palindrome using an algorithm with RAL instruction and a mask, puts to Accumulator 1 if the data is palindrome, 0 else
    CALL IS_PALINDROME
    POP D           // Pop D and E registers back
    POP B           // Pop B and C registers back
    OUT 00h         // put value of Accumulator to 00 port (0 or 1)
    POP PSW         // Pop flags and Accumulator back
    HLT             // end the program

IS_PALINDROME:
    MOV A, M        // load the data in the address shown by HL to A
    MOV B, A        // store the original data at B
    MVI C, 08h      // counter for the loop
    MVI D, 00h      // result of inversing will be stored in D
    MVI E, 01h      // mask to choose each bit 1 by 1
LOOP:               // loop for inversing the original data
    MOV A, B        // rotate the data left throuh CY
    RAL
    MOV B, A        // restore the data back at B
    JC MAKE_BIT_ONE // mask the corresponding bit with 1
CONT:
    PUSH PSW        // RLC changes CY, we need to protect it
    MOV A, E        // rotate the mask by 1 bit (multiply by 2)
    RLC
    MOV E, A        // restore mask back at E
    POP PSW
    DCR C           // decrease loop counter
    JNZ LOOP        // loop condition
    
    MOV A, B        
    RAL             // to get original data back to start (reg + CY = 9 bits)
    CMP D           // compare original and inversed data
    MVI A, 00h      // default value of A to return
    JZ RETURN_1     // return 1 if data is palindrome
RETURN:    
    RET

MAKE_BIT_ONE:
    PUSH PSW        // CY gets set to 0 after ORA, we need to protect it 
    MOV A, D
    ORA E
    MOV D, A
    POP PSW
    JMP CONT

RETURN_1:
    MVI A, 01h
    JMP RETURN

# ORG 1000h         // put example data to the address to check
# DB 11h            // 99h = 1001 1001, so palindrome
