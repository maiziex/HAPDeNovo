wget http://xinzhouneuroscience.org/wp-content/uploads/2017/08/example.tar.gz
wget http://xinzhouneuroscience.org/wp-content/uploads/2018/05/lib.tar.gz
tar -zxvf lib.tar.gz
tar -zxvf example.tar.gz
cd lib
tar -xzvf longranger-2.1.5.tar.gz
mv longranger-2.1.5 longranger
cd ..
chmod +x src/*.sh
chmod +x lib/GenomeAnalysisTK/GenomeAnalysisTK.jar
rm lib.tar.gz
rm example.tar.gz
echo 'You have installed HAPDeNovo successfully!'
