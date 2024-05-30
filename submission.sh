#!/bin/bash

# to check if arguments is given or not
if [ $# -eq 0 ]; then
    echo "Usage: $0 <argument>"
    exit 1
fi

# export is not working because each case it is opening new shell but 
#exports works for child shells so i am storing git status info in an hidden
# file through wich i will get to know wether git is initialized or not


# File to store the state of git_init_executed
state_file=".git_state"

# Check if the state file exists, if not, initialize git_init_executed to false
if [ ! -f "$state_file" ]; then
    git_init_executed=false
else
    # Read the value of git_init_executed from the state file
    read -r git_init_executed < "$state_file"
fi

# same problem here (export not working) i am storing the directory name given as argument in git init 
# in a hidden file so that i can use it in other cases 

# File to store the directory name
dir=".dir"
if [ ! -f "$dir" ]; then
    touch .dir
else
    read -r name_dir < "$dir"
fi
# using case to check the command given as argument
case "$1" in
    combine)        
                #usage bash submission.sh combine

        #wrote three cases which are main.csv doesnt exists , main.csv exists 
        #and it contains Total and last case it doesnt contain total
        # because to handle Total its the only way i could think of
        
        
            # main.csv doesnt exists 
        if [ ! -f main.csv ];then
                                        ###### combine ######
                #here i am adding header in main.csv and then i am adding first two 
                #columns from all exam files to main.csv and removing duplicates which 
                #results names and roll numbers of all students in all exams in main.csv
                #then i will read each line from main.csv and then i will itereate over 
                #exams if roll number in main.csv is present in exam file i will append 
                #its 3 rd column to the line in main.csv else i will append 'a' to main.csv


            #all files except main.csv
            csv_files=($(ls *.csv | grep -v "main.csv"))

            # Initialize the header
            result="Roll_Number,Name"

            # Initialize an empty array for exam names
            exam=()    

            # Iterate over each file path in the list
            for file_path in "${csv_files[@]}"; do
                # Extract the file name from the file path
                file=$(basename "$file_path")
                        
                # Extract the name of the exam from the file name i.e without .csv at the end
                name="${file%.*}"
                        
                # Add the exam name to the 'exam' array
                exam+=("$name")
                        
                # Read each line of the CSV file, skipping the header (first line)
                tail -n +2 "$file_path" | while IFS=, read -r column1 column2 _; do
                    # Check if both columns have data
                    if [[ -n $column1 && -n $column2 ]]; then
                    
                        echo "$column1,$column2" >> output_file.txt
                    fi
                done
            done    
            # header in main.csv    
            # will results Roll number,name,exams in 1 st line of main.csv
            for i in ${exam[@]};do
                result+=",$i"
            done
            # adding student names and rollnumbers in main.csv and removing duplicates 

            # header adds in main.csv
            echo $result>main.csv 
            # appending output_file.txt to main.csv
            cat output_file.txt >> main.csv 
            rm output_file.txt # removing temporary file

            #removing duplicates
            head -1 main.csv > temp.csv
            tail -n +2 main.csv | sort -u >> temp.csv
            cat temp.csv > main.csv
            rm temp.csv        

            #modifying main.csv 
            # adding marks to main.csv
                        
            for file in "${csv_files[@]}"; do    # iterating over files        
                file_=$(tail -n +2 "$file") # removing header from file
                test=$(tail -n +2 main.csv) # removing header from main.csv

                #reading line from main.csv withouyt header
                while IFS=',' read -r line; do
                    #extracting roll number and name from main.csv
                    roll_number=$(echo "$line" | cut -d, -f1)
                    name=$(echo "$line" | cut -d, -f2)
                    
                    #checking for roll number in exam file
                    if grep -q "$roll_number" <<< "$file_"; then
                        # if roll number is present in exam file then i will extract marks
                        # and append it to main.csv
                        marks=$(grep "$roll_number" <<< "$file_" | cut -d, -f3)
                        echo "$line,$marks"
                    else
                        # if roll number is not present in exam file then i will append 'a' to main.csv
                        echo "$line,a"
                    fi

                done <<< "$test" >temp #writing to temp file

                # writing header in output_temp.csv
                head -1 main.csv > output_temp.csv
                cat temp >> output_temp.csv
                rm temp
                mv output_temp.csv main.csv # renaming temp file to main.csv
                # now finally we get all students marks in main.csv
            done
        else
            # if main.csv is not empty then i will check if it has Total in its header or not
            heading=$(head -1 main.csv)
            if ! grep -q "Total" <<< "$heading"; then
                    # Total is not present in header

                    #here i am adding header in main.csv and then i am adding first two 
                    #columns from all exam files to main.csv and removing duplicates which 
                    #results names and roll numbers of all students in all exams in main.csv
                    #then i will read each line from main.csv and then i will itereate over 
                    #exams if roll number in main.csv is present in exam file i will append 
                    #its 3 rd colum to the line in main.csv else i will append 'a' to main.csv


                #all files except main.csv
                csv_files=($(ls *.csv | grep -v "main.csv"))

                # Initialize the header
                result="Roll_Number,Name"

                # Initialize an empty array for exam names
                exam=()    

                # Iterate over each file path in the list
                for file_path in "${csv_files[@]}"; do
                    # Extract the file name from the file path
                    file=$(basename "$file_path")
                            
                    # Extract the name of the exam from the file name
                    name="${file%.*}"
                            
                    # Add the exam name to the 'exam' array
                    exam+=("$name")
                            
                    # Read each line of the CSV file, skipping the header (first line)
                    tail -n +2 "$file_path" | while IFS=, read -r column1 column2 _; do
                        # Check if both columns have data
                        if [[ -n $column1 && -n $column2 ]]; then
                            # Append the data to the output file

                            echo "$column1,$column2" >> output_file.txt
                        fi
                    done
                done    
                # header in main.csv  
                # will results Roll number,name,exams in 1 st line of main.csv  
                for i in ${exam[@]};do
                    result+=",$i"
                done
                # adding student names and rollnumbers in main.csv and removing duplicates 

                # header adds in main.csv
                echo $result>main.csv
                # appending output_file.txt to main.csv
                cat output_file.txt >> main.csv
                rm output_file.txt # removing temporary file

                #removing duplicates
                head -1 main.csv > temp.csv
                tail -n +2 main.csv | sort -u >> temp.csv
                cat temp.csv > main.csv
                rm temp.csv        

                #modifying main.csv
                # adding marks to main.csv

                for file in "${csv_files[@]}"; do     # iterating over files        
                    file_=$(tail -n +2 "$file")  # removing header from file
                    test=$(tail -n +2 main.csv) # removing header from main.csv
                    
                    #reading line from main.csv withouyt header
                    while IFS=',' read -r line; do
                        #extracting roll number and name from main.csv
                        roll_number=$(echo "$line" | cut -d, -f1)
                        name=$(echo "$line" | cut -d, -f2)

                        #checking for roll number in exam file
                        if grep -q "$roll_number" <<< "$file_"; then
                            #extracting marks from exam file# if roll number is present in exam file then i will extract marks
                            # and append it to main.csv
                            marks=$(grep "$roll_number" <<< "$file_" | cut -d, -f3)
                            echo "$line,$marks"
                        else
                            # if roll number is not present in exam file then i will append 'a' to main.csv
                            echo "$line,a"
                        fi

                    done <<< "$test" >temp #writing to temp file

                    # writing header in output_temp.csv
                    head -1 main.csv > output_temp.csv
                    cat temp >> output_temp.csv
                    rm temp
                    mv output_temp.csv main.csv   # renaming temp file to main.csv 
                    # now finally we get all students marks in main.csv
                done
            else
                # total is present in header

                    #here i am adding header in main.csv and then i am adding first two 
                    #columns from all exam files to main.csv and removing duplicates which 
                    #results names and roll numbers of all students in all exams in main.csv
                    #then i will read each line from main.csv and then i will itereate over 
                    #exams if roll number in main.csv is present in exam file i will append 
                    #its 3 rd colum to the line in main.csv else i will append 'a' to main.csv


                #all files except main.csv
                csv_files=($(ls *.csv | grep -v "main.csv"))

                # Initialize the header
                result="Roll_Number,Name"

                # Initialize an empty array for exam names
                exam=()    

                # Iterate over each file path in the list
                for file_path in "${csv_files[@]}"; do
                    # Extract the file name from the file path
                    file=$(basename "$file_path")
                            
                    # Extract the name of the exam from the file name
                    name="${file%.*}"
                            
                    # Add the exam name to the 'exam' array
                    exam+=("$name")
                            
                    # Read each line of the CSV file, skipping the header (first line)
                    tail -n +2 "$file_path" | while IFS=, read -r column1 column2 _; do
                        # Check if both columns have data
                        if [[ -n $column1 && -n $column2 ]]; then
                            # Append the data to the output file

                            echo "$column1,$column2" >> output_file.txt
                        fi
                    done
                done    
                # header in main.csv    
                # will results Roll number,name,exams in 1 st line of main.csv
                for i in ${exam[@]};do
                    result+=",$i"
                done
                # adding student names and rollnumbers in main.csv and removing duplicates 

                # header adds in main.csv
                echo $result>main.csv
                # appending output_file.txt to main.csv
                cat output_file.txt >> main.csv
                rm output_file.txt # removing temporary file

                #removing duplicates
                head -1 main.csv > temp.csv
                tail -n +2 main.csv | sort -u >> temp.csv
                cat temp.csv > main.csv
                rm temp.csv        

                #modifying main.csv
                # adding marks to main.csv
                            
                for file in "${csv_files[@]}"; do      # iterating over files       
                    file_=$(tail -n +2 "$file") # removing header from file
                    test=$(tail -n +2 main.csv)  # removing header from main.csv

                    #reading line from main.csv withouyt header
                    while IFS=',' read -r line; do
                        #extracting roll number and name from main.csv
                        roll_number=$(echo "$line" | cut -d, -f1)
                        name=$(echo "$line" | cut -d, -f2)

                        #checking for roll number in exam file
                        if grep -q "$roll_number" <<< "$file_"; then
                            #extracting marks from exam file# if roll number is present in exam file then i will extract marks
                            # and append it to main.csv
                            marks=$(grep "$roll_number" <<< "$file_" | cut -d, -f3)
                            echo "$line,$marks"
                        else
                            # if roll number is not present in exam file then i will append 'a' to main.csv
                            echo "$line,a"
                        fi

                    done <<< "$test" >temp #writing to temp file

                    # writing header in output_temp.csv
                    head -1 main.csv > output_temp.csv
                    cat temp >> output_temp.csv
                    rm temp
                    mv output_temp.csv main.csv    # renaming temp file to main.csv
                    # now finally we get all students marks in main.csv
                done
                #if total is already present in main.csv we need to add even 
                #that column in main.csv after combine so i am calculating 
                #total marks through awk see total.awk
                
                awk -f total.awk main.csv > temp
                mv temp main.csv
            fi
        fi   
            
        ;;
    upload)
        # usage    bash submission.sh upload <path>
        #uploads the file to the current directory
        cp "$2" .
        ;;
    total)
        # usage    bash submission.sh total
        #calculates the total marks of all students
        heading=$(head -1 main.csv) 
        #if loop to check if Total is already present 
        #if we combine some more files after total command and again if we do total , 
        #total column adds again so here if loop to check If total is already present
        if ! grep -q "Total" <<< "$heading"; then
            #calculating total marks through awk see total.awk
            awk -f total.awk main.csv > temp
            mv temp main.csv
        fi
        
        ;;
    git_init)
                ### initialising git ###
            # usage    bash submission.sh git_init <path>
        # if loop to check wether path is given or not 
        if [ $# -eq 2 ];then
            path=$2
            # as i am using case for each case it uses different shell so 
            #export doesnt work in order to store path given in git_init 
            #i am storing its value in .dir in pwd to refer in git checkout and commit
            echo "$path" > .dir

            mkdir -p "$path"
            #to modify git_init_status
            git_init_executed=true
        else
            echo "usage    bash submission.sh git_init <path>"
            exit 1
        fi
        
        ;;
    git_commit)
                                 ### git commit ###
            # usage bash submission.sh git_commit -m "message"
        # git_init_executed is read from .git_state file which tells wether 
        #git_init command is executed or not it works only if git_init is done

        #if loop to check for correct no of arguments
        if [ $# -eq 3 ];then
            if [ "$git_init_executed" = "true" ]; then
                message=$3
                # if there is no .git_user file in repositry it asks for user name and email
                # as only one time taking user details is sufficient right
                if [ ! -f $name_dir/.git_user ];then
                    # reads user name as commit_name
                    read -p "enter your name :" commit_name
                    # reads user email as commit_email
                    read -p "enter you email :" commit_email
                    # its stored in an hidden file in the repositry 
                    echo "$commit_name,$commit_email" > $name_dir/.git_user
                fi
                #below to generate random 16 character hash 
                hash=$(openssl rand -hex 8 | tr -dc '[:alnum:]' | head -c 16)
                # storing hash and commit message in remote repository in .git_log file 
                # for our reference
                echo ""$hash" "$3"" >> $name_dir/.git_log
                # i am checking for no of commits if its 1 no need to use patch we can directly copy right
                lines=$(wc -l < $name_dir/.git_log | awk '{print $1}')
                if [ $lines -eq 1 ];then
                    # only 1 commit so directly copying 
                    cp -R . $name_dir/$hash
                elif [ $lines -ge 2 ];then
                    # more  than 1 commit i am using patch to make next commits 
                    # so that it is better optimised

                    #x gives hash of previous commit
                    x=$(tail -2 "$name_dir/.git_log" | head -1 | awk '{print $1}')

                    #making $name_dir/$hash directory 
                    mkdir -p $name_dir/$hash

                    # copying $name_dir/$x and $name_dir/$hash so that i can perform 
                    #patch to $name_dir/$hash and make it like pwd i am doing this because if 
                    #you wish to add or delete files in pwd it will not be reflected in $name_dir/$hash

                    # -a because direct copying makes directory inside to avoid that chosing this option 
                    cp -a $name_dir/$x/. $name_dir/$hash

                    # storing diff blw pwd and previous commit in diff.patch in pwd
                    # -N if files not there in one version it treats as new in next version
                    # -u unified version makes human readable 
                    # -r recursively compare all files 

                    # Patch $name_dir/$hash with the diff.patch file
                    diff -Nur "$name_dir/$hash" . > diff.patch
                    patch -d "$name_dir/$hash" < diff.patch
                    rm diff.patch

                    #if new exams are added in pwd then patch doesnt automatically add 
                    #new file while modifying so i am wrting functions to do this operations
                    
                    # copying missing files those files which are newly added in pwd 
                    # those are new adding exams
                    copy_missing_files() {
                        for file in "$1"/*; do 
                        # Loop over each file in the $1
                            if [ -f "$file" ]; then # Check if the file exists
                                # Calculate the relative path of the file effectively removing the $1 prefix
                                relative_path="${file#$1}" 
                                # Calculate the target file path by appending the relative path to the $2 prefix
                                target_file="$2$relative_path" 
                                # Check if the target file exists if it exists modification is done by patch no need to worry
                                if [ ! -e "$target_file" ]; then
                                # If the target file does not exist, copy the file to the target path
                                    mkdir -p "$(dirname "$target_file")"
                                    # Copy the file to the target path
                                    cp "$file" "$target_file"
                                    # echo "Copied $file to $target_file"
                                fi
                            # Check if the file is a directory
                            elif [ -d "$file" ]; then
                                # Recursively call the copy_missing_files function for the directory
                                copy_missing_files "$file" "$2"
                            fi
                        done
                    }

                    # removing extra files those files which are deleted in pwd  those are
                    # deleted exams(if they wish to remove some exam for some reasons...)
                    remove_extra_files() {
                        # Loop over each file in the $1
                        for file in "$1"/*; do
                            if [ -f "$file" ]; then # Check if the file exists
                            # Calculate the relative path of the file by removing the $1 prefix
                                relative_path="${file#$1}"
                                # Check if the file exists in the $2 directory
                                source_file="$2$relative_path"
                                # If the file does not exist in the $2 directory, remove it
                                if [ ! -e "$source_file" ]; then
                                    rm "$file"
                                    # echo "Removed $file"
                                fi
                            # Check if the file is a directory
                            elif [ -d "$file" ]; then
                                # Recursively call the remove_extra_files function for the directory
                                relative_path="${file#$1}"
                                source_dir="$2$relative_path"
                                remove_extra_files "$file" "$source_dir"
                            fi
                        done
                    }
                    # calling the function copy_missing_files
                    copy_missing_files . $name_dir/$hash
                    # calling the function remove_extra_files
                    remove_extra_files $name_dir/$hash .
                fi
                # if the commit is not the first commit then it will show the files that are added or deleted
                if [ $lines -ge 2 ];then
                    # storing present commit hash in second_commit
                    second_commit=$(tail -1 $name_dir/.git_log|awk '{print $1}')
                    # storing previous commit hash in first_commit
                    first_commit=$(tail -2 $name_dir/.git_log|head -1|awk '{print $1}')
                    # diff -qr $name_dir/$first_commit $name_dir/$second_commit
                    echo "------------------------------------------------------"
                    # i am using diff -rq and then i will extract the files that are added or 
                    # deleted using greo -E "^(Only in).*" i will print just name using awk $NF which is last field
                    echo "Files added or deleted :"
                    diff -rq $name_dir/$first_commit $name_dir/$second_commit | grep -E "^(Only in).*" | awk '{print $NF}'
                    echo ""
                    # i am using diff -rq and then i will extract the files that are modified using greo -E "^(Files ).*"
                    # i will print just name using awk $NF which is last field
                    echo "Files that are modified :"
                    diff -rq $name_dir/$first_commit $name_dir/$second_commit | grep -E "^(Files ).*" | awk -F/ '{split($NF, a, " "); print a[1]}'

                    echo "------------------------------------------------------"
                fi
                # i am storing the time of commit and store it in .git_time 
                echo $(date) >> $name_dir/.git_time
                echo "commited"
            else
                # if git is not initialised it exits 
                echo "git_init has not been executed yet"
                exit 1
            fi
        else
            echo "usage bash submission.sh git_commit -m 'message'"
            exit 1
        fi        
        ;;
    git_checkout)
                        ### git checkout ###
        # we can checkout in 2 ways
        # bash submission.sh hash     starting phrase of hash is enough
        # bash submission.sh -m <message>
        if [ "$git_init_executed" = "true" ]; then
                # for first usage
            if [ $# -eq 2 ];then 
                #stores hash 
                check_hash=$2
                if [ $check_hash = "master" ];then
                    #getting the last hash from .git_log
                    master_hash=$(tail -1 $name_dir/.git_log | awk '{print $1}')
                    # Replace the contents of pwd with the contents of master
                    rsync -av --delete "$name_dir/$master_hash/" .
                else
                    #checking if there are more than 1 hash having starting 
                    #phrase or no hash at all in any case it throws an error
                    count=$(grep -c "^$check_hash" $name_dir/.git_log)
                    if [ "$count" -eq 1 ];then
                        #from phrase finding full hash
                        change_dir=$(grep "^$check_hash" $name_dir/.git_log|awk '{print $1}')
                        # Replace the contents of dir1 with the contents of dir2
                        rsync -av --delete "$name_dir/$change_dir/" .
                    else
                        echo "Error: More than one hash starts with '$phrase' or no hash"
                        exit 1
                    fi
                fi


            # for second usage
            elif [ $# -eq 3 ];then
                check_message=$3                
                #checking if there are more than 1 commit with given message
                # or no message at all in any case it throws an error
                count=$(grep -c "$check_message" $name_dir/.git_log)
                if [ $count -eq 1 ];then
                    #finding hash from given message
                    change_dir=$(grep  "$check_message" $name_dir/.git_log|awk '{print $1}')
                    # Replace the contents of dir1 with the contents of dir2
                    rsync -av --delete "$name_dir/$change_dir/" .
                else
                    echo "Error: More than one message or no message"
                    exit 1
                fi
            else
                echo "Error: usage 'bash submission.sh hash ' or 'bash submission.sh -m <message>' "
                exit 1
            fi
        else
            echo "git_init has not been executed yet"
            exit 1
        fi
        ;;
    git_log)
        # usage bash submission.sh git_log
        # echo "commit,"
        #initialising name
        name=
        #initialising mail
        mail=
        #reading name and mail from .git_user
        while IFS=',' read -r n m ; do
            export name="$n"
            export mail="$m"
        done < "$name_dir/.git_user"
        
        #pasting the log and time files so that we know at what time commit is made
        # simply reading 1 st line from .git_log and .git_tme simultaniously and so on....
        
        paste -d ',' $name_dir/.git_log $name_dir/.git_time | while IFS=',' read -r line1 line2; do
            #from line1 reading hash and message
            while IFS=' ' read -r hash message ; do
            #prints log
                echo "     $hash"
                echo "commited by  $name <$mail>"
                echo "Date: $line2"
                echo "     $message"
            done <<< $line1
        echo ""
        echo ""
        done
        ;;
    git_show)
        # bash submission.sh git_show commit:<file_name>

        input=$2
        #seperating the commit hash and file name
        show_dir=$(echo $input | awk -F : '{print $1 }')
        show_file=$(echo $input | awk -F : '{print $2 }')
        # if HEAD is given it prints files in master
        if [ $show_dir = "HEAD" ];then
            # echo "yes master"
            # finding master hash
            master_hash=$(tail -1 $name_dir/.git_log | awk '{print $1}')
            # searching for file in master
            search_file=$name_dir/$master_hash/$show_file
            # if file exists in master
            if [ -f $search_file ];then
                cat $search_file
            else 
                # if file doesnt exist in master
                echo "fatal: path '<$show_file>' does not exist in '<HEAD>'"
                # echo "doesnt exists"
            fi
        else
            # show_hash=$show_dir
            show_hash=$(grep "^$show_dir" $name_dir/.git_log|awk '{print $1}')
            # echo "$show_hash"
            # searching for file in commit hash
            search_file=$name_dir/$show_hash/$show_file
            # if file exists in commit hash
            if [ -f $search_file ];then
                cat $search_file
                # echo "file exists"
            else
            # if file doesnt exist in commit hash
                echo "fatal: path '<$show_file>' does not exist in '<$show_hash>'"
            fi
            # search_file=
            # echo "no master"
        fi
        ;;
    update)

        #### this update function first updates marks in the exam file and ###
        ####later it combines again to reflect in main.csv####


        # usage bash submission.sh update
        #function to search roll_number in csv file
        search_rollno() {
            local csv_file="$1" # local variable for file
            local roll_nu="$2" # local variable for roll_no
            #making roll_no to uppercase to make case insensitive search possible
            roll_nu=$(echo "$roll_nu" | tr '[:lower:]' '[:upper:]')
            #awk command to search roll_no in csv file
            awk -F',' -v roll="$roll_nu" '
                #if roll_no is found in csv file it prints the line i.e line is stored in search_rollno
                
                NR>1 {
                    #making roll_no to uppercase to make case insensitive search possible
                    if(toupper($1)==roll){print}
                }
            ' "$csv_file"
        }

        #to which student you like to update marks 
        # reads roll no from terminal and stores it in roll_no
        read -p "Enter roll_no: " roll_no
        #making roll_no to uppercase to make case insensitive search possible
        roll_no=$(echo "$roll_no" | tr '[:lower:]' '[:upper:]')
        #it displays all exams in terminal so that T.A may not be confused with names of exam
        # it just prints all the exams available in terminal
        echo -n "Exams available: "
        for file in *.csv; do
            if [ "$file" != "main.csv" ]; then
                name="${file%.*}"
                printf "%s, " "$name"
            fi
        done
        echo ""
        #type in which exams you want to change marks
        read -p "Exam name to update: " exam
        #checking for exam csv file 
        exam_file=$(find . -iname ""$exam".csv")
        #if entered exam is a valid exam it continues execution else exits 
        if [ -n "$exam_file" ];then 
            #searches for roll no in exam csv file
            search_result=$(search_rollno "$exam_file" "$roll_no")
            #if roll no is found in exam csv file it continues execution else it asks to add new student
            if [ -n "$search_result" ]; then
                #read updated marks from terminal as final marks
                read -p "enter updated marks: " final_marks
                #below two to seperate first 2 columns
                final_roll_no=$(echo "$search_result" | cut -d ',' -f1)
                final_name=$(echo "$search_result" | cut -d ',' -f2)
                #modifying marks in main.csv file through sed command then redirecting it to temp file and renaming it as main.csv
                sed -E "s/^$final_roll_no,[^,]+,[^,]+/$final_roll_no,$final_name,$final_marks/" "$exam_file" > temp
                mv temp "$exam_file"
            else
                # if T.A wants to add new student in exam he choses y anything else exits i.e 
                #he doesnt like to add new student he entered wrong roll number

                #reads choice from terminal as choice
                read -p "would you like to add new student in "$exam" (y/n) :" choice
                if [ $choice == y ];then
                    # it searches for roll no in main.csv file if it exists no need to take entry 
                    #from terminal right if we take again there might be spelling mistakes 
                    #to avoid this i will take name directly from main.csv

                    #returns line which contain roll number in main.csv
                    search_result=$(search_rollno main.csv "$roll_no")
                    if [ -n "$search_result" ]; then
                        # there exists roll number in main.csv
                        #reading name form search reasult and storing it in new_entry_name
                        new_entry_name=$(echo "$search_result" | cut -d ',' -f2)
                        #read marks of new student from terminal as new_entry_marks
                        read -p "enter marks obtained  :" new_entry_marks
                        #append this new data in corresponding exam file
                        echo ""$roll_no",$new_entry_name,"$new_entry_marks"" >> $exam_file
                    else
                        #reads name of new student from terminal as new_entry_name
                        echo "Enter name of the student :"
                        read -a new_entry_name
                        #reads marks of new student from terminal as new_entry_marks
                        read -p "enter marks obtained  :" new_entry_marks
                        #adding new student to exam file
                        echo ""$roll_no","${new_entry_name[*]}","$new_entry_marks"" >> $exam_file
                    fi
                else
                    echo "exiting..."
                    exit 1
                fi
            fi
        else
        #if exam entered is not present in exam list
            echo "There is no exam such as $exam." 
            exit 1
        fi
        #finally combine to show effect in main.csv

        bash submission.sh combine
        ;;
    search)
                ### displays marks of a particular student ### 
            
        # usage bash submission.sh search
        #read roll no to search from terminal as roll_no
        read -p "Enter roll_no to search marks: " roll_no
        #converting roll number to upper case so case insensitive search can be done
        roll_no=$(echo "$roll_no" | tr '[:lower:]' '[:upper:]')
        #function to search roll_number
        search_rollno() {
            local csv_file="$1" # local variable for file
            local roll_nu="$2" # local variable for roll_no
            #making roll_no to uppercase to make case insensitive search possible
            roll_nu=$(echo "$roll_no" | tr '[:lower:]' '[:upper:]')
            #awk command to search roll_no in csv file
            awk -F',' -v roll="$roll_nu" '
            #if roll_no is found in csv file it prints the line i.e line is stored in search_rollno

                NR>1 {
                    #making roll_no to uppercase to make case insensitive search possible
                    if(toupper($1)==roll){print}
                }
            ' "$csv_file"
        }
        #returns line which has same roll number
        search_result=$(search_rollno main.csv "$roll_no")
        if [ -n "$search_result" ];then
            # if roll no is valid then print header and search result
            echo $(head -1 main.csv)
            echo $search_result
        else
            #if roll no is invalid then print error message
            echo ""$roll_no" is invalid roll number"
        fi
        ;;
    analyse)
                #### to analyse marks ####
            #usage bash submission.sh analyse 
        #dont know why declare is not working so doing differently


        #storing all marks and exam name in a big string all_marks with ; which seperates each exam
        csv_files=(*.csv) #all csv files
        all_marks="" #array
        for file_path in "${csv_files[@]}"; do
            if [[ "$file_path" != "main.csv" ]]; then #all csv except main.csv
                name="${file_path%.*}"
                marks="" #to stores marks of current file
                # Read marks from current file then  append it to marks variable
                while IFS=, read -r _ _ mark; do
                    marks+=" $mark"
                done < <(tail -n +2 "$file_path")
                # Append filename and marks to all_marks variable
                all_marks+="$name:$marks;"
            fi
        done

        #form above we get all marks as big string with each exam seperated by ;
        #below we read each exam details in an array file_marks 

        
        # first i am removing file marks_to_analyse if it exists
        # as i am appending marks if it already present data might mess up 
        #so i am removing it
        if [ -f marks_to_analyse ];then
        rm  marks_to_analyse
        fi
        # creating file marks_to_analyse to store all marks
        touch marks_to_analyse
        #below is to seperate marks of each exam from string all_marks and store it in array file_marks
        IFS=';' read -ra file_marks <<< "$all_marks"
        #iterating through each exam and storing it in marks_to_analyse
        for entry in "${file_marks[@]}"; do
            #below is to seperate name of exam and marks
            #seperates exam name and marks from entry
            IFS=':' read -r name marks <<< "$entry"
            echo "$name$marks" >>marks_to_analyse
            # finally all marks are stored in marks_to_analyse
        done

        # here i tried to remove duplicates because if by mistake if we run 
        # two times in marks_to_analyse file each will be printed twise
        sort -u marks_to_analyse > temp
        mv temp marks_to_analyse

        #creating tsv for analysis because csv files may mess up above code
        #to know  total analysis refer analyse.py
        touch analyse.tsv
        echo -e "Exam\tMean\tMedian\tStandard_deviation\tMax\tMin" > analyse.tsv


        #see analyse.py to understand how analysis is done
        python3.11 analyse.py
        #creating grades.tsv for analysis because csv files may mess up above code
        #see grades.py to understand how grades are calculated
        python3.11 grades.py
        #sorting grades.tsv based on total marks because many people might 
        #have same marks so we need to sort them based on total marks
        head -1 grades.tsv > temp
        tail -n +2 grades.tsv|sort -k6 -rn -t'	' >>temp
        mv temp grades.tsv

        #making images directory 
        mkdir -p images/
        # 2>/dev/null because if file is unchanged it gives something 
        #in terminal which doesnt effect anything but looks bad in 
        #terminal so redirecting it to /dev/null/
        mv -f $(find . -name "*.png") images 2>/dev/null
        mv -f $(find . -name "*.png") images 2>/dev/null

        # for analysis it gives options to choose based on what 
        #criteria you would like to analyse marks

        ##options to choose based on which you like to analyse
        echo "1) exam name"
        echo "2) student roll number"
        echo "3) anything else to quit"
        # reads choice as choice
        read -p "Analyse based on :" choice
        if [ "$choice" == 1 ];then
            #displays all exam names so that we avoid spelling mistakes ..etc
            
            #just to display all exam names in terminal
            echo -n "Exams available: "
            for file in *.csv; do
                if [ "$file" != "main.csv" ]; then
                    name="${file%.*}"
                    printf "%s, " "$name"
                fi
            done
            echo ""
            
            #reads exam name from user from terminal as exam 
            read -p "enter name of the exam :" exam
            #finds the file with the name of exam entered by user
            exam_file=$(find . -iname ""$exam".csv")
            #if entered exam name is valid then it proceeds else exits
            if [ -n "$exam_file" ];then
            ## to open files in different operating systems there are 
            #different commands so i wrote an if loop to find ostype and 
            #run accordingly if it doesnt work kindly check this customisation in mac
                if [[ "$OSTYPE" == "darwin"* ]]; then 
                            #### works for mac #### 
                    #finds analysis image which is based on your selection 
                    open "$(find . -iname ""$exam".png")"
                elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
                            #### might work for ubuntu ####
                    #finds analysis image which is based on your selection
                    xdg-open "$(find . -iname ""$exam".png")"
                elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
                            ### might work for windows ###
                    #finds analysis image which is based on your selection
                    start "$(find . -iname ""$exam".png")"
                else
                    #if it doesnt work kindly check this customisation in mac
                    echo "this customisation doesnt work on your system ; you can see all graphs in images/ ;if possible check this customisation in mac , it works there"
                fi
            else
                #if exam is invalid it exits with message
                echo "exam "$exam" is invalid"
                exit 1 
            fi
            
        elif [ "$choice" == 2 ];then
            #if user selects 2 it asks for roll number and opens file
            read -p "enter roll number of a student :" roll_no
            #converting roll number to upper case so case insensitive search can be done
            roll_no=$(echo "$roll_no" | tr '[:lower:]' '[:upper:]')
            search_rollno() {
                local csv_file="$1"
                local roll_nu="$2"
                #converting roll number to upper case so case insensitive search can be done
                roll_nu=$(echo "$roll_nu" | tr '[:lower:]' '[:upper:]')
                #even while searching in csv file i am converting 1 st field to upper case so case insensitive search can be done
                awk -F',' -v roll="$roll_nu" '
                    NR>1 {
                        if(toupper($1)==roll){print}
                    }
                ' "$csv_file"
            }
            #searches for roll number in csv file
            #returns line which has same roll number
            search_result=$(search_rollno main.csv "$roll_no")
            #if line exists i.e valid roll number opens file else throws error
            if [ -n "$search_result" ];then
                ## to open files in different operating systems there are 
                #different commands so i wrote an if loop to find ostype and 
                #run accordingly 
                if [[ "$OSTYPE" == "darwin"* ]]; then
                             #### works for mac #### 
                    #finds analysis image which is based on your selection
                    open "$(find . -iname ""$roll_no".png")"
                elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
                            #### might work for ubuntu ####
                    #finds analysis image which is based on your selection
                    xdg-open "$(find . -iname ""$roll_no".png")"
                elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
                            ### might work for windows ###
                    #finds analysis image which is based on your selection
                    start "$(find . -iname ""$roll_no".png")"
                else
                    #if it doesnt work kindly check this customisation in mac
                    echo "this customisation doesnt work on your system ; you can see all graphs in images/ ;if possible check this customisation in mac , it works there"
                fi
            else
                #roll number entered is invalid 
                echo ""$roll_no" is invalid roll number"
            fi
        else
            exit 1
        fi
        ;;
esac

# Write the value of git_init_executed back to the state file so 
#that the script knows that it has been executed
echo "$git_init_executed" > "$state_file"













 





