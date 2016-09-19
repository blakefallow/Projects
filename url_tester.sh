while read i
do
wget --spider $i > /dev/null 2>1
if [ $? == 0 ]
then
echo $i >> {enter file here}
fi
done
