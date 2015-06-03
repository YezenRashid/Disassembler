# Disassembler

This is code for a dissassemlber our group created. It is writting in 68k assemlby code.  

The program begins by asking the user to specify a memory location that will be used by the program to dissembler that memory location. 
After being supplied with a starting address and ending address the disassembler attempts to decode program in memory. If a given 
address is invalid the program prints an error message.If the address range given is valid, the I/O reads 1000 words starting from the starting address. 
If it reads a null value, or if it reaches the end of 1000 words. Each word is dissembled by analyzing bits to determine the Opcode and length of the command. 
The program reads bit masks of the word length being read to determine what Opcode the address is. The Opcode is then printed.
From there, EA, is decoded in the same manner as the Opcode. The program uses bit masks to check what EA is being used. 
The EA is then printed. If the program finishes reading 1000 words, the program waits for the user to press enter to continue reading.

Our design for the disassembler program uses an input/output management routine to control user interaction. 
The user I/O routines scans memory locations, based on user input and stores the address words as an ascii value. 
The ascii values are converted to decimal values and stored using our conversion algorithm.

The program checks if the ascii value is less than $40. If it is, the conversion algorithm subtracts 37 from the 
ascii value if it is found to be a letter to get the hex value. Otherwise, it is a numerical value, 30 is subtracted instead.

Once we have the converted memory values, we begin the process of decoding. The decoding process initially, compares 
the 12th, 13th, 14th, and 15th bits to all possible permutations of those bits to route to the subroutine related to 
that particular bit pattern. The four bit permutation determines what Opcode the input data is using.

For example, if we find that the 12-15 inclusive bits are 1001, we know that the Opcode is either SUB or SUBA.
From there we determine the length being used with 3rd, 4th, and 5th bits, (D2) and the EA Mode being used with the 6th, 
7th, and 8th bits (D3). The proper length and EAs are then printed. Figure 2 shows the flow of the program.

