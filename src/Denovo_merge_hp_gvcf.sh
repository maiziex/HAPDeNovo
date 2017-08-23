sample1_name=$2
sample2_name=$4
sample3_name=$6
reference=${8}
chr_start=${10}
chr_end=${12}
out_dir=${14}
out_file_prefix=${16}


for i in `eval echo {$chr_start..$chr_end}`
do
    echo $i
    if [ ! -f run_denovo_step3_merge_"$i".sh ]
    then
        touch run_denovo_step3_merge_"$i".sh
    else
        rm run_denovo_step3_merge_"$i".sh
        touch run_denovo_step3_merge_"$i".sh
    fi

    echo ./run_denovo_step3_merge3hp.sh --child $sample1_name --parent1 $sample2_name --parent2 $sample3_name --reference $reference --chr_num $i  --output_dir $out_dir --output_prefix $out_file_prefix>>run_denovo_step3_merge_"$i".sh
    chmod +x run_denovo_step3_merge_"$i".sh
done

for i in `eval echo {$chr_start..$chr_end}`
do
    if [ "$i" == "$chr_end" ]
    then
        ./run_denovo_step3_merge_"$i".sh & wait 
    else
        ./run_denovo_step3_merge_"$i".sh & 
    fi
done
