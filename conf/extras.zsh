#!/usr/bin/env zsh
function watch_mpv() {
    local watched_file="watched.txt"
    local directory="${1:-$PWD}"  # Use argument or $PWD if argument is empty
    directory="${directory//\'/\'}"  # Remove single quotes from the directory path

    # Check if watched.txt exists
    if [ ! -f "$directory/$watched_file" ]; then
        # If watched.txt doesn't exist, find the first .mkv file in the directory
        local first_file=$(ls -1 "$directory"/*.mkv | head -n 1)
        if [ -n "$first_file" ]; then
            echo "$first_file" > "$directory/$watched_file"
            mpv "$first_file"
        else
            echo "No .mkv files found in directory"
        fi
    else
        # If watched.txt exists, read the last watched file
        local last_watched=$(cat "$directory/$watched_file")

        # Get a list of all .mkv files in the directory
        local -a mkv_files
        mkv_files=("$directory"/*.mkv(N))  # Use globbing to handle special characters

        # Find the index of the last watched file in the array
        local index
        for (( i = 1; i <= ${#mkv_files[@]}; i++ )); do
            if [ "${mkv_files[$i]}" = "$last_watched" ]; then
                index=$i
                break
            fi
        done

        # If the last watched file was found, play the next one in the list
        if [ -n "$index" ] && [ $index -lt ${#mkv_files[@]} ]; then
            local next_file="${mkv_files[$((index + 1))]}"
            if [ -n "$next_file" ]; then
                echo "$next_file" > "$directory/$watched_file"
                mpv "$next_file"
            else
                echo "No more .mkv files to watch"
            fi
        else
            echo "No .mkv files to watch"
        fi
    fi
}
