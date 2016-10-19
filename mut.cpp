/*
///////////////////////////////////////////////////////////////////////////

A (single) mutation program that receives 4 inputs:
1) "DNA" or "RNA" depending on the kind of sequence you want to mutate.
2) The number of mutations you want to make
3) The number of bases in front and behind of a sequence that can be mutated.
4) The sequences of sequence and its reverse complimentary that will both be mutated

Returngs the resulting sequences s1&s2

///////////////////////////////////////////////////////////////////////////
*/

#include <cstdlib>
#include <cstdio>
#include <algorithm>
#include <string>
#include <chrono>

using namespace std;

char complement(bool DNA_or_RNA,char c)
{
    if(DNA_or_RNA) 
    {
        if(c=='A') c='T';
        else if(c=='T') c='A';
        else if(c=='G') c='C';
        else if(c=='C') c='G';
        else if(c=='a') c='t';
        else if(c=='t') c='a';
        else if(c=='g') c='c';
        else if(c=='c') c='g';
        return c;
    }
    else
    {
        if(c=='A') c='U';
        else if(c=='U') c='A';
        else if(c=='G') c='C';
        else if(c=='C') c='G';
        else if(c=='a') c='u';
        else if(c=='u') c='a';
        else if(c=='g') c='c';
        else if(c=='c') c='g';
        return c;
    }
}

int main (int argc, char **argv)
{
	char DNA [] = {'g','c','a','t'};
	char RNA [] = {'g','c','a','u'};
	typedef std::chrono::high_resolution_clock myclock;
    myclock::time_point beginning = myclock::now();
	std::minstd_rand0 generator ((myclock::now() - beginning).count());
    std::uniform_int_distribution<int> distribution(0,3);
	distribution(generator);
	int DNA_or_RNA = -1;
	int num_bases = -1;
	string m1;
	string m2;
	if(argc>=4)
	{
		if((string)argv[1]=="RNA" || (string)argv[1]=="R") DNA_or_RNA = 0;
		else if ((string)argv[1]=="DNA" || (string)argv[1]=="D") DNA_or_RNA = 1; 
		if(DNA_or_RNA!=-1) num_bases = atoi(argv[2]);	
		m1 = (string)argv[3];
		m2 = (string)argv[4];

		std::uniform_int_distribution<int> distribution_coor(1,num_bases*2);
		distribution_coor(generator);

		if(DNA_or_RNA>=0)
		{
			int mut_coor = distribution_coor(generator);
			int comp_coor = -1;
			if(mut_coor<=num_bases) {comp_coor=m1.length()-mut_coor;  mut_coor--;}
			else {mut_coor = m1.length()-2*num_bases+mut_coor-1; comp_coor = m1.length()-mut_coor-1; }
			bool found = false;
			while(!found)
			{
				int mut_int = distribution(generator);
				char mut = (DNA_or_RNA) ? DNA[mut_int] : RNA[mut_int];
				if(m1[mut_coor]!=mut)
				{
					m1[mut_coor]=mut;
					m2[comp_coor]=complement(DNA_or_RNA,mut);
					printf("%s&%s",m1.c_str(),m2.c_str());
					found = true;
				}
			}
		}
		else printf("\n\nYour input sucks!\n\n");
	}
	else printf("\n\nYour input sucks!\n\n");
	return 0;
}
