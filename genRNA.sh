#/bin/bash
# This program has one input. See below.
####### CREATE THE mRNA ############
pre="a"
post="b"
rm mRNA.in
# Add the RBS compliment
tr -d "\n " < RBS_0.in >> mRNA.in

# Add a random tract of defined length with high AT content (3 in our case)
./randseq DNA $1 0.1 > RNA.txt
tr -d "\n " < RNA.txt >> mRNA.in
# Add a random 8 nucleotide nuclease recognition tract
./randseq DNA 8 > RNA.txt
pre=$(tr -d "\n " < RNA.txt)
printf $pre >> mRNA.in
# Invert and compliment the 8 nucleotide recognition tract
pre=$(rev<<<$pre)
pre=$(./complement DNA $pre)

# Add the nuclease cutting sequence
printf "CGU" >> mRNA.in

# Add a second random 8 nucleotide nuclease recognition tract
./randseq DNA 8 > RNA.txt
post=$(tr -d "\n " < RNA.txt)
printf $post >> mRNA.in
# Invert and compliment the 8 nucleotide recognition tract
post=$(rev<<<$post)
post=$(./complement DNA $post)
# Add a second random tract of defined length with high AT content (3 in our case)
./randseq DNA $1 0.1 > RNA.txt
tr -d "\n " < RNA.txt >> mRNA.in

# Add the actual RBS
tr -d "\n " < RBS_1.in >> mRNA.in
# Convert everything into RNA
full=$(tr 't' 'u' < mRNA.in)
full=$(tr 'T' 'U' <<< $full)
printf $full > mRNA.in

# Add separator
printf "&" >> mRNA.in
# Copy everything into two separate instances
cp mRNA.in mRNA1.in
cp mRNA.in mRNA2.in

####### CREATE THE NUCLEASES ############

# Make end tails with hight GC content that the nucleases quench each other with
tail1=$(./randseq DNA 6 40.0 | tr -d "\n ")
tail2=$(./randseq DNA 6 40.0 | tr -d "\n ")

### Nuclease 1 ###
# Add tail and complementary region to one of the 8 nucleotide tracks above
printf $tail1 >> mRNA1.in
printf $post >> mRNA1.in
# Add the nuclease sequence
tr -d "\n " < msDNA.in >> mRNA1.in
# Add tail and complementary region to one of the 8 nucleotide tracks above
printf $pre >> mRNA1.in
printf $tail2 >> mRNA1.in

# Reverse the tails for the second nuclease
tail1=$(rev<<<$tail1)
tail1=$(./complement DNA $tail1)
tail2=$(rev<<<$tail2)
tail2=$(./complement DNA $tail2)

### Nuclease 2 ###
# Add tail and complementary region to one of the 8 nucleotide tracks above
printf $tail2 >> mRNA2.in
printf $post >> mRNA2.in
# Add the nuclease sequence
tr -d "\n " < msDNA.in >> mRNA2.in
# Add tail and complementary region to one of the 8 nucleotide tracks above
printf $pre >> mRNA2.in
printf $tail1 >> mRNA2.in

### Create a file that contains both nucleases for the mutual affinity check (Done with a different version of the RNA cofold)
end1=$(<mRNA1.in)
end1=${end1#*&}
end2=$(<mRNA2.in)
end2=${end2#*&}
printf $end1 > mRNA.in
printf "&" >> mRNA.in
printf $end2 >> mRNA.in

# Run the folding on the mRNA-nuclease pairs sequentially
RNAcofold --noconv -p < mRNA1.in > test1
cp rna.ps rna1.ps
RNAcofold --noconv -p < mRNA2.in > test2
