wget http://xinzhouneuroscience.org/wp-content/uploads/2017/08/example.tar.gz
wget http://xinzhouneuroscience.org/wp-content/uploads/2017/08/lib.tar.gz
tar -zxvf lib.tar.gz
tar -zxvf example.tar.gz
chmod +x src/*.sh
chmod +x lib/GenomeAnalysisTK/GenomeAnalysisTK.jar
rm lib.tar.gz
rm example.tar.gz
echo 'You have installed HAPDeNovo successfully!'
