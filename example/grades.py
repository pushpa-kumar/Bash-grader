import csv
#defining function to read csv files
def read_csv_file(file_name):

    #Reads student data from a CSV file and returns a list of rows.
    # Open the CSV file in read mode
    with open(file_name, 'r') as csvfile:
        # Create a CSV reader object to read the file
        reader = csv.reader(csvfile, delimiter=',')
        # Read and store the header row
        header = next(reader)
        # Read and store the data rows
        data = [row for row in reader]
    # Return the data rows
    return data
# Function to calculate the total marks of a student by summing the integers in the 3rd to 5th columns
# and ignoring any string values
def calculate_total(row):
    # Initialize the total to 0
    total = 0
    # Iterate over the values in the 3rd to 5th columns
    for value in row[2:5]:
        # Check if the value is an integer
        if value!= 'a':
            # Convert the value to an integer and add it to the total
            total += int(value)
    # Return the total
    return total
# Function to assign a grade to a student based on their total marks
def assign_grade(total,max_total):
    # Check if the total is greater than or equal to 80
    if total >= 0.8*max_total:
        # Return an 'AA' grade
        return 'AA'
    # Check if the total is greater than or equal to 70
    elif total >= 0.7*max_total:
        # Return a 'BA' grade
        return 'BA'
    # Check if the total is greater than or equal to 60
    elif total >= 0.6*max_total:
        # Return a 'BB' grade
        return 'BB'
    # Check if the total is greater than or equal to 50
    elif total >= 0.5*max_total:
        # Return a 'CB' grade
        return 'CB'
    # If none of the above conditions are met, return a 'CC' grade
    else:
        return 'CC'

def rank_students(data):
    """
    Calculates the total marks of each student, sorts the list in decreasing order of total marks
    and grade, assigns a rank to each student based on their position in the sorted list,
    and calculates the maximum total score.
    """
    total_data = sorted(data, key=lambda x: (-calculate_total(x), x[0]), reverse=True)
    ranks = {}
    rank = 1
    max_total = 0
    # Calculate the maximum total score
    for row in total_data:
        # Calculate the total score
        total = calculate_total(row)
        
        if total > max_total:
            max_total = total
        # Assign a rank to the student based on their position in the sorted list
        if total not in ranks:
            ranks[total] = rank
            rank += 1
        else:
            while total in ranks:
                total += 0.001
            ranks[total] = rank

    for row in total_data:
        #appending grade and rank to the list
        row.append(assign_grade(calculate_total(row),max_total))
        row.append(ranks[calculate_total(row)])

    return total_data, max_total

def add_comments(data):
    """
    Adds a comment to each student's data based on their grade.
    """
    for i, row in enumerate(data):
        # Check if the row is a list and has at least two elements
        if isinstance(row, list) and len(row) >= 2: 
            # knowing grade
            grade = row[-2]
        else:
            # comments based on grades
            print(f"Warning: Unexpected row format at index {i}: {row}")
        if grade == 'AA':
            row.append('Excellent performance! Keep up the good work.')
        elif grade == 'BA':
            row.append('Good job! You can improve your score by focusing on your weak areas.')
        elif grade == 'BB':
            row.append('You can do better. Try to improve your performance in all subjects.')
        elif grade == 'CB':
            row.append('You need to work harder. Focus on your studies and seek help if needed.')
        elif grade == 'CC':
            row.append('Your performance is not satisfactory. You need to put in more effort and attend all classes.')
        else:
            row.append('')
#writing output to tsv files
def write_to_tsv(data, file_name):
    """
    Writes the student data to a TSV file with the appropriate headers.
    """
    with open(file_name, 'w') as tsvfile:
        #assigning delimiter
        writer = csv.writer(tsvfile, delimiter='\t')
        #header
        header = ['Roll_Number', 'Name', 'midsem', 'quiz1', 'test', 'Total', 'Grade','Rank', 'Comment']
        #writing header
        writer.writerow(header)
        for row in data:
            writer.writerow(row)

    
if __name__ == '__main__':
    file_name = 'main.csv'
    data = read_csv_file(file_name)
    total_data, max_total = rank_students(data)

    add_comments(total_data)
    output_file_name = 'grades.tsv'
    #finally writing to grades.tsv
    write_to_tsv(total_data, output_file_name)
