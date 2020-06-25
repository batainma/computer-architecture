#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>
#include <inttypes.h>


uint32_t getCode(char *file, int count);
bool testValidity(char *newfile, uint32_t codeA);
int readFile();

/**
 * Mohammed Bataineh
 * CS 352
 * This program accepts 2 text files and uses bit manipulation to create a check sum
 * 10/14/19
 * 
 * NOTE: Must be compiled with c99 or later
 * */
int main()
{
	/*Initialize all while loop variables beforehand*/
	int count;
	bool isEqual;
	bool validResponse;
	bool moreInput = true;
	char *response = (char*) malloc (sizeof(char));
	char *file_name = (char*) malloc(25*sizeof(char));;
	uint32_t checkSum;

	while(moreInput)
	{
		printf("Enter a file name: ");
		count = readFile(file_name);

		checkSum = getCode(file_name, count);
		printf("Calculated Code: ");
		printf("%08" PRIx32 "\n", checkSum);

		isEqual = testValidity(file_name, checkSum);	
		if(isEqual)
			printf("Success! They have the same contents\n");
		else
			printf("Fail -> files have different contents\n");
		
		validResponse = false;
		while(!validResponse)
		{
			printf("Again? (Y/N) ");
			scanf("%s", response);
			if(strcmp(response, "N") == 0)
			{
				moreInput = false;
				validResponse = true;
			}
			else if(strcmp(response, "Y") == 0)
			{
				validResponse = true;
			}
			else
			{
				printf("Not a valid response. Please try again\n");
			}
		}
		
	}
	
	free(file_name);
	free(response);
	return 0;


}

/*Reads in the file and returns the count of chars used to get chunk count*/
int readFile(char* file_name)
{
	
	FILE *fileA;
	
	/*Accept a file name and open it*/
	scanf("%s", file_name);
	fileA = fopen(file_name, "r");

	/*Allowing redos if name is wrong*/
	while(fileA == NULL)
	{
		printf("Cannot open this file. Please re-enter the file name.\n");
		printf("Enter a filename: ");
		scanf("%s", file_name);
		fileA = fopen(file_name, "r");
	}
	
	unsigned char fileChar = 0x0;
	int charCount = 0;
	while(fileChar != (unsigned char) EOF)
	{
		fileChar = getc(fileA);
		charCount++;	
	}

	return charCount;
}

/*getCode generates the checksum and returns it as 32 bits*/
uint32_t getCode(char *file, int count)
{
	/*Initialize codeA and codeB to hold bit chunks coming from fileChar*/
	unsigned char fileChar = 0x0;
	FILE *fileA = fopen(file, "r");
	uint64_t codeA = 0;
	uint64_t codeB = 0;

	int chunks = count / 4;
	int paddedBytes = 4 - (count % 4);

	/*Gets the first chunk of 32 bits*/
	for(int i = 3; i >= 0; i--)
	{
		fileChar = getc(fileA);
		codeA |= (uint64_t) fileChar << (8*i);
	}
	/*Overflow bit to use later for masking and checking*/
	uint64_t overflowBit = 0x100000000;
	uint64_t overflowCheck = 0x0;
	unsigned int overflow = 0;

	/*Loop to grab the other full chunks and add them / handle overflow*/
	for(int i = 0; i < chunks - 1; i++)
	{
		for(int j = 3; j >= 0; j--)
		{
			fileChar = getc(fileA);
			codeB |= (uint64_t) fileChar << (8*i);
		}
		codeB = codeB + overflow;
		codeA = codeA + codeB;
		
		/*Checks for overflow*/	
		if(((overflowBit&codeA) >> 32) != 0)
			overflow = 1;
		else
			overflow = 0;	

		codeA = codeA|overflowBit;	
	}

	for(int i = paddedBytes; i >= 0; i--)
	{
		fileChar = getc(fileA);
		codeB |= (uint64_t) fileChar << (8*i);	
	}
	codeB = codeB + overflow;
	codeA = codeA + codeB;

	/*Moves the bits into a 32 bit uint and toggles all bits)*/
	uint32_t checkSum = ~(codeA & 0xFFFFFFFF);
	return checkSum;
	

}

/*testValidity takes another file and finds if the checksums are equal*/
bool testValidity(char *newfile, uint32_t codeA)
{
	printf("Enter another filename for validation: ");
	int count = readFile(newfile);
	printf("Validation: ");	
	uint32_t codeB = getCode(newfile, count);
	return(codeA == codeB);

}



