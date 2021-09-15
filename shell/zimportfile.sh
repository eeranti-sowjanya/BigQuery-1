echo "Using Project $1, Process Files in $2 and export to $3, adding the filename and the date as additional columns. Use $4 as the dataset."
echo "In addition, import the data into $5"
project=$1
gcsfile=$2
gcsdestination=$3
dataset=$4
finaltable=$5

schema="name:string,gender:string,counter:integer"
newschema="$schema,year,importpath,importdate"
filename=$(basename $gcsfile)
filenamenoext=${filename%%.*}
temptable=$dataset.$filenamenoext

gcloud config set project $project
bq load --project_id $project --source_format=CSV $temptable $gcsfile $schema

transformquery="CREATE OR REPLACE TABLE \`$temptable\` AS SELECT *,'$filenamenoext' as year,'$gcsfile' as importpath,CURRENT_DATE() as importdate FROM  \`$temptable\`"
echo $transformquery
bq query --project_id $project --use_legacy_sql=false $transformquery   # Use a query to add the new columns

filedestination=$gcsdestination$filename
bq extract --destination_format CSV --print_header=false $temptable $filedestination  # Export the Table

#bq rm $temptable   # Optionally - remove the temporary table
echo Load $filedestination into $finaltable
bq load --project_id $project --source_format=CSV $finaltable $filedestination $newschema