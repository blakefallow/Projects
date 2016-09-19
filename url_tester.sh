while read i
do
wget --spider $i > /dev/null 2>1
if [ $? == 0 ]
then
echo $i >> validlist.txt
fi
done
