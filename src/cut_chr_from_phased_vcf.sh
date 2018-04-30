set -x
input1=$1
input2=$2 
input3=$3
input_chr_start=$4
input_chr_end=$5
output_start=$6
if [ ! -f $input1".tbi" ]
then
    tabix -p vcf $input1
else
    echo "using existing "$input1".tbi"
fi
if [ ! -f $input2".tbi" ]
then
    tabix -p vcf $input2
else
    echo "using existing "$input2".tbi"
fi
if [ ! -f $input3".tbi" ]
then
    tabix -p vcf $input3
else
    echo "using existing "$input3".tbi"
fi

for i in `eval echo {$input_chr_start..$input_chr_end}`
do
    chr="chr"
    chr_num=$chr$i
    chromosomeX=23
    if [ $i -eq $chromosomeX ]
    then
        chr_num="chrX"
        echo $chr_num
    fi

    output_prefix="_"
    output_suffix=".vcf.gz"
    output1=$input1$output_prefix$chr$i$output_suffix
    output2=$input2$output_prefix$chr$i$output_suffix
    output3=$input3$output_prefix$chr$i$output_suffix

    output4=$output_start"_"$chr$i".vcf"
    echo $chr_num
    echo "processing "$output1
    tabix -h $input1 $chr_num | bgzip -c > $output1
    tabix -p vcf $output1

    echo "processing "$output2
    tabix -h $input2 $chr_num | bgzip -c > $output2
    tabix -p vcf $output2

    echo "processing "$output3
    tabix -h $input3 $chr_num | bgzip -c > $output3
    tabix -p vcf $output3

    vcf-merge $output1 $output2 $output3  > $output4

    rm $output1
    rm $output1".tbi"
    rm $output2 
    rm $output2".tbi"
    rm $output3
    rm $output3".tbi"
done
