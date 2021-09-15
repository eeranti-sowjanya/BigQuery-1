project="grant-moyle"
gcssource="gs://www.grantmoyle.com/names/byyear/yob*.txt"
gcsdestination="gs://www.grantmoyle.com/names/withyear/"
bqdataset="namesimport"
allnamestable="$bqdataset.allnames"
echo "$gcssource -> $bqdataset -> $gcsdestination"
for filename in $(gsutil ls $gcssource)
do
    echo $filenamebq
    gsutil ls $gcssource
    ./zimportfile.sh $project $filename $gcsdestination $bqdataset $allnamestable &    # add the & to run in parallel, but add a sleep of 1 on the next line so you don't overwhelm the cloud shell
    sleep 1
done
