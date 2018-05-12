sample_name=$2
sample_num=$4
sample_num_hp1=$6
sample_num_hp2=$8
sample_num_nohp=${10}
input_bam=${12}
reference=${14}
chr_start=${16}
chr_end=${18}
out_dir=${20}
child_sex=${22}

for i in `eval echo {$chr_start..$chr_end}`
do
    echo $i
    if [ ! -f denovo_step3_"$sample_name"_"$i".sh ]
    then
        touch denovo_step3_"$sample_name"_"$i".sh
    else
        rm denovo_step3_"$sample_name"_"$i".sh
        touch denovo_step3_"$sample_name"_"$i".sh
    fi

    echo ./cut_chr_from_bam_3hp.sh --sample $sample_name --sample_id $sample_num --sample_hp1_id $sample_num_hp1 --sample_hp2_id $sample_num_hp2 --sample_nohp_id $sample_num_nohp --sample_bam $input_bam --reference $reference --chr_num $i --output_dir $out_dir --child_sex $child_sex>>denovo_step3_"$sample_name"_"$i".sh
    chmod +x denovo_step3_"$sample_name"_"$i".sh
done


for i in `eval echo {$chr_start..$chr_end}`
do
    if [ "$i" == "$chr_end" ]
    then
        ./denovo_step3_"$sample_name"_"$i".sh & wait 
    else
        ./denovo_step3_"$sample_name"_"$i".sh & 
    fi
done




