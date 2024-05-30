 # input file is comma separated and output is also comma separated
BEGIN {FS=",";OFS=","}
# for 1 st record  of input file i.e main.csv
NR==1 {
    #using printf so that it can print in the same line
    for(i=1;i<=NF;i++){
        #prints all fields of 1st line with comma seperated
        printf "%s,",$i
    }
    #prints total in 1st line at the end of all fields
    printf "%s","Total"
    printf "\n" # break line
}
# for records greater than 1
NR>1{
    #prints all fields of 1st line with comma seperated
    for(i=1;i<=NF;i++){
        printf "%s,",$i
    }
    #sum of all fields from 3rd field excluding 1st and 2nd field as they are names and roll numbers
    # in sum a is by default taken as 0 as its string
    sum=0;
    for(i=3;i<=NF;i++){
        sum=sum+$i;
    }
    # appends sum of all fields to the end of all fields
    printf "%d" ,sum
    printf "\n" # break line
}