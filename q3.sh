#!/bin/bash


echo -e "Lets play WORDLE! \nplease enter a 5 letter word"

#getting letters input
read letters

# Checking the length of the word
if [ ${#letters} -ne 5 ]; then
        echo "Error: not a 5 letter word"
        exit 1
fi

echo "Fantastic! now what are the colors of the letters?"
echo -e "Remember, \n's' is for silver (not in the word), \n'y' is for yellow (in the word, wrong place) and \n'g' for green (in the word and in the right place)"

#getting colors input
read colors

colors=$(echo "$colors" | tr '[:upper:]' '[:lower:]')

# Sort the characters of the string colors
sorted_string=$(echo "$colors" | grep -o . | sort | tr -d '\n')

# Define the regular expression pattern
pattern="^[sgy]+$"

# Check if the sorted string matches the pattern
if ! [[ $sorted_string =~ $pattern ]]; then
        echo "Error: string '$colors' contain other characters than 's', 'g' and 'y'"
        exit 1
fi

# Bank of 5 letter Words
words_dict=$(<"test")
echo "$words_dict"

# Main filtering of the words bank by the critiria given
for i in {0..4}; do
        #takes the letter and the color
        letter=${letters:$i:1}
        color=${colors:$i:1}
	echo "$letter" "$color"
	#checks for first run or not
	if [ $i -eq 0 ]; then
		#filter by color
	        if [ $color = 'g' ]; then
	                # green- in the right place
	                #take all words that contain the letter in the i posotion
	                filtered_words=$(awk -v letter="$letter" pos="$((i+1))" 'length($0)==5 && substr($0, pos, 1)==letter' <<< "$words_dict")
	        elif [ $color = 's' ];then
	                # silver not in the word at all
	                #take all words that doesnt contain the letter
	                filtered_words=$(awk -v letter="$letter" 'index($0,letter) == 0' <<< "$words_dict")
	        elif [ $color = 'y' ]; then
	                # yellow- not right place
	                # taking all words that doesnt have the letter in position i
	                filtered_words=$(awk -v letter="$letter" -v pos="$((i+1))" 'length($0)==5 && substr($0, pos, 1) != letter' <<<"$words_dict")
	                # taking all the words that contain same letter in other places
	                filtered_words=$(awk -v letter="$letter" 'index($0,letter) > 0' <<< "$words_dict")
	        fi
	else
		#works on filtered_words and not the main bank of words
		#filter by color
                if [ $color = 'g' ]; then
                        # green- in the right place
                        #take all words that contain the letter in the i posotion
                        filtered_words=$(awk 'length($0)==5 && substr($0, '"$((i+1))"', 1)=="'"$letter"'"' <<< "$filtered_words")
                elif [ $color = 's' ];then
                        # silver not in the word at all
                        #take all words that doesnt contain the letter
                        filtered_words=$(awk -v letter="$letter" 'index($0,letter) == 0' <<< "$filtered_words")
                elif [ $color = 'y' ]; then
                        # yellow- not right place
                        # taking all words that doesnt have the letter in position i
                        filtered_words=$(awk -v letter="$letter" -v pos="$i" 'length($0)==5 && substr($0, pos, 1) != letter' <<< "$filtered_words")
                        # taking all the words that contain same letter in other places
                        filtered_words=$(awk -v letter="$letter" 'index($0,letter) > 0' <<< "$filtered_words")
                fi

	fi
done
echo "The words that match the description:"
echo "$words_dict"

