/*
///////////////////////////////////////////////////////////////////////////

Generate a random RNA/DNA sequence:
Inputs:
1) RNA (R) or DNA (D)
2) Length of generated sequence
3) GC to AT ratio (1.0 if equally prevalent).
Output:
Generated DNA/RNA sequence. 

///////////////////////////////////////////////////////////////////////////
*/

#include <cstdlib>
#include <cstdio>
#include <algorithm>
#include <string>
#include <chrono>

using namespace std;

int main (int argc, char **argv)
{
    double gc_to_at_ratio = 1.0;
	char DNA [] = {'g','c','a','t'};
	char RNA [] = {'g','c','a','u'};
	typedef std::chrono::high_resolution_clock myclock;
    myclock::time_point beginning = myclock::now();
	std::minstd_rand0 generator ((myclock::now() - beginning).count());
    std::uniform_real_distribution<double> distribution(0.0,1.0);
	distribution(generator);
	int DNA_or_RNA = -1;
	int num_bases = -1;
	if(argc>=3)
	{
		if((string)argv[1]=="RNA" || (string)argv[1]=="R") DNA_or_RNA = 0;
		else if ((string)argv[1]=="DNA" || (string)argv[1]=="D") DNA_or_RNA = 1; 
		if(DNA_or_RNA!=-1) num_bases = atoi(argv[2]);	
	}
    if(argc==4)
    {
        gc_to_at_ratio = atof(argv[3]);
    }
	if(DNA_or_RNA>=0)
	{
        double div = gc_to_at_ratio/(1+gc_to_at_ratio);
        double div1 = div/2;
        double div2 = (1+div)/2;
		printf("\n\n");
		for(int i=0;i<num_bases;i++) 
        {
            double temp = distribution(generator);
			char c = ' ';
            if(temp<div)
            {
                if(temp<div1) c = (DNA_or_RNA) ? DNA[0] : RNA[0];
                else c = (DNA_or_RNA) ? DNA[1] : RNA[1];
            }
            else
            {
				if(temp<div2) c = (DNA_or_RNA) ? DNA[2] : RNA[2];
				else c = (DNA_or_RNA) ? DNA[3] : RNA[3];
            }
            printf("%c",c);
        }
		printf("\n\n");
	}
	else printf("\n\nYour input sucks!\n\n");
	return 0;
}
