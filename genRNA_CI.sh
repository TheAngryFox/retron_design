#/bin/bash
# this program has 2 inputs (see below)
# Create reverse complements of a locus on the CI mRNA
pre="aggacgca"
post="cgccttaa"
pre=$(rev<<<$pre)
pre=$(./complement DNA $pre)
post=$(rev<<<$post)
post=$(./complement DNA $post)

# Generate mRNA from CI DNA sequence
tr -d "\n " < RBS_11.in > mRNA.in
full=$(tr 't' 'u' < mRNA.in)
full=$(tr 'T' 'U' <<< $full)
printf $full > mRNA.in

# Copy the CI mRNA into two instances
printf "&" >> mRNA.in
cp mRNA.in mRNA1.in
cp mRNA.in mRNA2.in

# Generate random sticky tails for the nucleases (in our case first argument = 6, second - 1.0
tail1=$(./randseq DNA $1 $2 | tr -d "\n ")
tail2=$(./randseq DNA $1 $2 | tr -d "\n ")

####### CREATE THE mRNA ############

# Create nuclease number 1
printf $tail1 >> mRNA1.in
printf $post >> mRNA1.in
tr -d "\n " < msDNA.in >> mRNA1.in
printf $pre >> mRNA1.in
printf $tail2 >> mRNA1.in

# Reverse complement tails for nuclease 2
tail1=$(rev<<<$tail1)
tail1=$(./complement DNA $tail1)
tail2=$(rev<<<$tail2)
tail2=$(./complement DNA $tail2)

# Create nuclease number 2
printf $tail2 >> mRNA2.in
printf $post >> mRNA2.in
tr -d "\n " < msDNA.in >> mRNA2.in
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
