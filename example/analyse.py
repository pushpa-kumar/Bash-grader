import numpy as np
import matplotlib.pyplot as plt
# Open the file 'marks_to_analyse' in read mode
with open('marks_to_analyse', 'r') as mf:
    # Iterate over each line in the file
    for line in mf:
        # Remove any leading/trailing whitespaces and split the line into words
        words=line.strip().split( )
        # Get the list of marks from the words
        m=words[1:]
        # Get the name of the exam from the words
        name=words[0]
        # Convert the list of marks to a numpy array
        marks = [int(mark) for mark in m]

        marks=np.array(marks)
        # Calculate the average of the marks
        
        average=np.mean(marks)
        # Round the average to 2 decimal places
        average=np.round(average,decimals=2) 
        # Calculate the median of the marks
        median=np.median(marks)
        # Round the median to 2 decimal places
        median=np.round(median,decimals=2)
        # Calculate the standard deviation of the marks
        standard_deviation=np.std(marks)
        # Round the standard deviation to 2 decimal places
        standard_deviation=np.round(standard_deviation,decimals=2)#standard deviation for each exam
        max=np.max(marks)#max marks for each exam
        min=np.min(marks)#min marks for each exam
        # Write the data to the file 'analyse.tsv'
        with open('analyse.tsv','a') as file:
            file.write(f"{name}\t{average}\t{median}\t{standard_deviation}\t{max}\t{min}\n")
                          
                          
                          ### graphs ####


        # Create a new figure
        fig, ax = plt.subplots()
         # Find the unique marks and their counts
        unique_marks, mark_counts = np.unique(marks, return_counts=True)
        # Plot the bar graph
        bars = ax.bar(unique_marks, mark_counts, color=plt.cm.viridis(np.linspace(0, 1, len(unique_marks))))
        # Set the y-axis ticks
        ax.yaxis.set_ticks(np.arange(int(np.min(mark_counts)), int(np.max(mark_counts)) + 1, 1))
        # ax.grid(axis='y', linestyle='--')
        # Set the title of the plot
        ax.set_title('Marks in ' + name + ' vs Number of Students', color='red')
        # Set the label for the x-axis
        ax.set_xlabel('Marks in ' + name, color='green')
        # Set the label for the y-axis
        ax.set_ylabel('Number of Students', color='green')

        # Save the figure
        fig.savefig(name + '.png')

        # Close the figure
        plt.close(fig)
 #Open the file 'main.csv' in read mode
with open('main.csv','r') as file:
    # Read all the lines in the file
    lines = file.readlines()
    # Get the heading from the first line
    heading=lines[0].strip().split(',')
    # Get the names of the exams from the heading
    exam_names=heading[2:]
    # Iterate over each line in the file starting from the second line
    for line in lines[1:]:
        # Remove any leading/trailing whitespaces and split the line into words
        words=line.strip().split(',')
        # Convert the list of marks to a numpy array
        data=[0 if entry == 'a' else int(entry) for entry in words[2:]]
        # Check if the data is empty
        if not data:
            continue  
        # Create a new figure
        data=np.array(data)
        fig, dt = plt.subplots()
        # Plot the bar graph
        bars = dt.bar(exam_names, data, color=plt.cm.viridis(np.linspace(0, 1, len(exam_names))))
        dt.yaxis.set_ticks(data)
        # dt.grid(axis='y', linestyle='--')
        dt.set_title('Marks of ' + words[0] + ' in all exams', color='red')
        dt.set_ylabel('Marks ', color='green')
        dt.set_xlabel('Number of exam', color='green')
        # Save the figure
        fig.savefig(words[0] + '.png')
        # Close the figure
        plt.close(fig)
           
        
        
