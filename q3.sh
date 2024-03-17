#!/bin/bash


echo -e "Lets play WORDLE! \nplease enter a 5 letter word"

read letters

# Checking the length of the word
if [ ${#letters} -ne 5 ]; then
        echo "Error: not a 5 letter word"
        exit 1
fi

echo "Fantastic! now what are the colors of the letters?"
echo -e "Remember, \n's' is for silver (not in the word), \n'y' is for yellow (in the word, wrong place) and \n'g' for green (in the word and in the right place)"

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

# Bsnk of 5 letter Words
words_dict=$(<"sgb-words.txt")

# Main filtering of the words bank by the critiria given
for i in {0..4}; do
        #takes the letter and the color
        letter=${letters:$i:1}
        color=${colors:$i:1}

        #filter by color
        if [ $color = 'g' ]; then
                # green- in the right place
                filtered_words=grep "^.\{$i\}$letter.\{4-$i\}$" "$words_dict"
        elif [ $color = 's' ];then
                # silver not in the word at all
		filtered_words=grep -v '^[^$letter]*$' "$words_dict.txt"
        else
                # yellow- not right place
	        filtered_words=grep -v "^.\{$i\}$letter.\{4-$i\}$" "$words_dict"
        fi

done

echo "The words that match the description:"
echo $filtered_words

