set -x
sample1_name=$2
sample2_name=$4
sample3_name=$6
sample1_num=$8
sample2_num=${10}
sample3_num=${12}
sample1_bam=${14}
sample2_bam=${16}
sample3_bam=${18}
reference=${20}
chr_start=${22}
chr_end=${24}
out_dir=${26}
child_sex=${28}

if [ ! -d $out_dir ]
then
    mkdir $out_dir
else
    echo "using existing "$out_dir""
fi

./Denovo_step3_split_3hps.sh --sample $sample1_name --sample_id $sample1_num --sample_hp1_id 20000 --sample_hp2_id 20001 --sample_nohp_id 20002  --sample_bam $sample1_bam --reference $reference --chr_start $chr_start --chr_end $chr_end  --output_dir $out_dir --child_sex $child_sex &
./Denovo_step3_split_3hps.sh --sample $sample2_name --sample_id $sample2_num --sample_hp1_id 20003 --sample_hp2_id 20004 --sample_nohp_id 20005 --sample_bam $sample2_bam --reference $reference --chr_start $chr_start --chr_end $chr_end  --output_dir $out_dir --child_sex $child_sex & 
./Denovo_step3_split_3hps.sh --sample $sample3_name --sample_id $sample3_num --sample_hp1_id 20006 --sample_hp2_id 20007 --sample_nohp_id 20008 --sample_bam $sample3_bam --reference $reference --chr_start $chr_start --chr_end $chr_end  --output_dir $out_dir --child_sex $child_sex & wait


for i in `eval echo {$chr_start..$chr_end}`
do
    rm denovo_step3_"$sample1_name"_"$i".sh
    rm denovo_step3_"$sample2_name"_"$i".sh
    rm denovo_step3_"$sample3_name"_"$i".sh
done


./Denovo_merge_hp_gvcf.sh --child $sample1_name --parent1 $sample2_name --parent2 $sample3_name --reference $reference --chr_start $chr_start --chr_end $chr_end --output_dir $out_dir --output_prefix hp


for i in `eval echo {$chr_start..$chr_end}`
do
    rm run_denovo_step3_merge_"$i".sh 
done


