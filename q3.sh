#!/bin/bash


echo -e "Lets play WORDLE! \nplease enter a 5 letter word"

#getting letters input
read -r letters

# Checking the length of the word
if [ "${#letters}" -ne 5 ]; then
        echo "Error: not a 5 letter word"
        exit 1
fi

echo "Fantastic! now what are the colors of the letters?"
echo -e "Remember, \n's' is for silver (not in the word), \n'y' is for yellow (in the word, wrong place) and \n'g' for green (in the word and in the right place)"

#getting colors input
read -r colors

# making sure its all lower case letters
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
filtered_words=$(<sgb-words.txt)

# main filtering of the words bank by the critiria given
for ((i = 0; i < 5; i++)); do
        #takes the letter and the color
        letter=${letters:$i:1}
        color=${colors:$i:1}

	#works on filtered_words and not the main bank of words
	#filter by color
        if [ "$color" = 'g' ]; then
                # green- in the right place
                #take all words that contain the letter in the i posotion
                filtered_words=$(awk -v letter="$letter" -v pos="$((i + 1))" 'length($0)==5 && substr($0, pos, 1)==letter' <<<"$filtered_words")
        elif [ "$color" = 's' ];then
                # silver not in the word at all
                #take all words that doesnt contain the letter
                filtered_words=$(awk -v letter="$letter" 'index($0, letter) == 0' <<<"$filtered_words")
        elif [ "$color" = 'y' ]; then
                # yellow- not right place
                # taking all words that doesnt have the letter in position i
                temp_words=$(awk -v letter="$letter" -v pos="$((i + 1))" 'length($0)==5 && substr($0, pos, 1) != letter' <<<"$filtered_words")
                # taking all the words that contain same letter in other places
                filtered_words=$(awk -v letter="$letter" 'index($0, letter) > 0' <<<"$temp_words")
        fi
done
echo "The words that match the description:"
echo "$filtered_words"

