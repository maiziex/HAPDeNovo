#set -x
child_vcfgz=$2
parent1_vcfgz=$4
parent2_vcfgz=$6
chr_start=$8
chr_end=${10}
out_dir=${12}

##### Step 2: longranger variant call for single vcf to phase vcf, then merge them to one vcf
if [ ! -d $out_dir ]
then
    mkdir $out_dir
else
    echo "using existing "$out_dir""
fi

echo "running Step 2..."
echo "chr_start="$chr_start" , chr_end="$chr_end
./cut_chr_from_phased_vcf.sh $child_vcfgz $parent1_vcfgz $parent2_vcfgz $chr_start $chr_end "$out_dir"trio_mergecall_10x_phased

