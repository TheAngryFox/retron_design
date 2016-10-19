/*
///////////////////////////////////////////////////////////////////////////

Finds a complementary sequence of the given sequence.
Inputs: 
1) R or RNA for RNA; D or DNA for DAN sequence type
2) Sequence
Output: Complimentary DNA/RNA sequence

///////////////////////////////////////////////////////////////////////////
*/

#include <cstdlib>
#include <cstdio>
#include <string>

using namespace std;

int main (int argc, char **argv)
{
	if(argc==3)
	{
        string input = (string)argv[2];
        if((string)argv[1]=="R" || (string)argv[1]=="RNA") 
        {
            for(char &c:input)
            {
                if(c=='A') c='U';
                else if(c=='U') c='A';
                else if(c=='G') c='C';
                else if(c=='C') c='G';
                else if(c=='a') c='u';
                else if(c=='u') c='a';
                else if(c=='g') c='c';
                else if(c=='c') c='g';
            }
            printf("%s",input.c_str());
        }
        else if((string)argv[1]=="D" || (string)argv[1]=="DNA")
        {
            for(char &c:input)
            {
                if(c=='A') c='T';
                else if(c=='T') c='A';
                else if(c=='G') c='C';
                else if(c=='C') c='G';
                else if(c=='a') c='t';
                else if(c=='t') c='a';
                else if(c=='g') c='c';
                else if(c=='c') c='g';
            }
            printf("%s",input.c_str());
        }
        else printf("\n\nYour input sucks!\n\n");
	}
	else printf("\n\nYour input sucks!\n\n");
	return 0;
}
