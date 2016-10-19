#/bin/bash
### Mutagenizing program that tries to modify the binding constants of the nucleases to get them both equal to the GOAL input
m1=$(<mRNA1.in)
m2=$(<mRNA2.in)
start1=${m1%&*}
start2=${m2%&*}
m1=${m1#*&}
m2=${m2#*&}

RNAcofold --noconv --noPS -p -a -f concfile < mRNA1.in > test1 &
RNAcofold --noconv --noPS -p -a -f concfile < mRNA2.in > test2 &
wait

c1=$(sed '10q;d' test1 | cut -d$'\t' -f3)
c2=$(sed '10q;d' test1 | cut -d$'\t' -f6)
c3=$(sed '10q;d' test1 | cut -d$'\t' -f7)
K1=$(echo "$c1 / ($c2 * $c3)"|bc -l)
K1_new=$(echo "$K1 * 0.1" | bc -l)

c1=$(sed '10q;d' test2 | cut -d$'\t' -f3)
c2=$(sed '10q;d' test2 | cut -d$'\t' -f6)
c3=$(sed '10q;d' test2 | cut -d$'\t' -f7)
K2=$(echo "$c1 / ($c2 * $c3)"|bc -l)
K2_new=$(echo "$K2 * 0.1" | bc -l)
K1_new="2"
K2_new="1"

while (( $(bc -l <<< "($K1_new/$K2_new)<0.95") || $(bc -l <<< "($K1_new/$K2_new)>1.05") ))
do
	m_new=$(./mut DNA 6 $m1 $m2)
	m11=${m_new%&*}
	m21=${m_new#*&}re

	printf $start1 > mRNA11.in
	printf "&" >> mRNA11.in
	printf $m11 >> mRNA11.in
	printf $start2 > mRNA21.in
	printf "&" >> mRNA21.in
	printf $m21 >> mRNA21.in
	RNAcofold --noconv --noPS -p -a -f concfile < mRNA11.in > test1 &
	RNAcofold --noconv --noPS -p -a -f concfile < mRNA21.in > test2 &
	wait

	c1=$(sed '10q;d' test1 | cut -d$'\t' -f3)
	c2=$(sed '10q;d' test1 | cut -d$'\t' -f6)
	c3=$(sed '10q;d' test1 | cut -d$'\t' -f7)
	K1_new=$(echo "$c1 / ($c2 * $c3)"|bc -l)
	rat1="0"
	if(( $(echo "$c2 > $c3"|bc -l) )); then
		rat1=$(echo "$c2 / $c3"|bc -l)
	else
		rat1=$(echo "$c3 / $c2"|bc -l)
	fi

	c1=$(sed '10q;d' test2 | cut -d$'\t' -f3)
	c2=$(sed '10q;d' test2 | cut -d$'\t' -f6)
	c3=$(sed '10q;d' test2 | cut -d$'\t' -f7)
	K2_new=$(echo "$c1 / ($c2 * $c3)"|bc -l)
	rat2="0"
	if(( $(echo "$c2 > $c3"|bc -l) )); then
		rat2=$(echo "$c2 / $c3"|bc -l)
	else
		rat2=$(echo "$c3 / $c2"|bc -l)
	fi

	newdiff=$(echo "sqrt(($K1_new-$1)^2+($K2_new-$1)^2)"|bc -l)
	olddiff=$(echo "sqrt(($K1-$1)^2+($K2-$1)^2)"|bc -l)
	#echo $newdiff $olddiff $K1_new $K2_new $K1 $K2

	if (( $(bc -l <<< "(($K1_new-$K2_new)/($K1_new+$K2_new))^2<(($K1-$K2)/($K1+$K2))^2") && ( $(bc -l <<< "($K1_new+$K2_new)/2>1") || $(bc -l <<< "($K1_new+$K2_new)>($K1+$K2)") ) )); then
		m1=$m11
		m2=$m21
		K1=$K1_new
		K2=$K2_new
		printf $start1 > mRNA1.in
		printf "&" >> mRNA1.in
		printf $m1 >> mRNA1.in
		printf $start2 > mRNA2.in
		printf "&" >> mRNA2.in
		printf $m2 >> mRNA2.in
		echo "GOOD!"
	fi

	echo "K1_new: " $K1_new " K2_new: " $K2_new " Goal: " $1 " K1: " $K1 " K2: " $K2 
done

rm mRNA11.in
rm mRNA21.in
