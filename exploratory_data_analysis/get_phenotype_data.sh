file='selected_phenotypes.txt'
columns='cut -f2,6,7,8,9,10,22,27,28,31'

head -n1 full | $columns
IFS=$'\n'
for line in $(cat $file)
do
    awk -v dis=$line -F $'\t' '$8 == dis' full | eval "$columns"
done
