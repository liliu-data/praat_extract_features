#######################################
#Modified by Liting Liu from Prf. Joey Stanley, December 21, 2017, 
...Stanley, J. (n.d.). A tutorial on extracting formants in Praat – Joey Stanley. 
...https://joeystanley.com/blog/a-tutorial-on-extracting-formants-in-praat/#conclusion

#This script extracts the second formant frequency of each phoneme from the selected Sound and TextGrid at three time points.
...They are the onset, the mid point and the time point 30ms before the end of the phoneme, which are labelled in the output .csv file.
#######################################

writeInfoLine: "Extracting formants..."


# Extract the names of the Praat objects
thisSound$ = selected$("Sound")
thisTextGrid$ = selected$("TextGrid")

# Extract the number of intervals in the phoneme tier
select TextGrid 'thisTextGrid$'
numberOfPhonemes = Get number of intervals: 1  
appendInfoLine: "There are ", numberOfPhonemes, " intervals."

# Create the Formant Object
select Sound 'thisSound$'
To Formant (burg)... 0 5 5000 0.025 50

# Create the output file and write the first line.
outputPath$ = "/Users/litingliu/Documents/assignment/uef/technology/formant/'thisSound$'.csv "
writeFileLine: "'outputPath$'", "file, phoneme, onset, midpoint, 30ms_before_end, F2onset, F2mid, F2bef"

# Loop through each interval on the phoneme tier.
for thisInterval from 1 to numberOfPhonemes
	appendInfoLine: thisInterval

    # Get the label of the interval
    select TextGrid 'thisTextGrid$'
    thisPhoneme$ = Get label of interval: 1, thisInterval
	appendInfoLine: thisPhoneme$
    
    # Find the onset time
    thisPhonemeStartTime = Get start point: 1, thisInterval

    # Find the time 30ms before next phoneme.
    thisPhonemeEndTime   = Get end point:   1, thisInterval
    beforeEndTime = thisPhonemeEndTime - 0.030

    # Find the midpoint time
    duration = thisPhonemeEndTime - thisPhonemeStartTime
    midpoint = thisPhonemeStartTime + duration/2
    
    # Extract formant 2 measurements
    select Formant 'thisSound$'
    f2onset = Get value at time... 2 thisPhonemeStartTime Hertz Linear
    f2mid = Get value at time... 2 midpoint Hertz Linear
    f2bef = Get value at time... 2 beforeEndTime Hertz Linear
  

    # Save to a spreadsheet
    appendFileLine: "'outputPath$'", 
            ...thisSound$, ",",
            ...thisPhoneme$, ",",
            ...thisPhonemeStartTime, ",",
            ...midpoint, ",",
            ...beforeEndTime, ",",
            ...f2onset, ",",
            ...f2mid, ",",
            ...f2bef

endfor

appendInfoLine: newline$, newline$, "Whoo-hoo! It didn't crash!"