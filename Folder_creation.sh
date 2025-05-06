#!/bin/bash

#This script is used to create multiple folders at the same time
#In this we have to give path where we need to create folders and then we need to mention the names for the folders
#After that it will check if the given path is present in system or not if not it will throw an error

create_folder() {
        local path=$1
        

# Now to check if given path is present or not

if [ ! -d "$path" ]; then
        echo "Error while finding the path, please enter correct path"
        return
fi

local folder_name=("${@:2}")

#Now we need to create folders in mentioned path

for Folder_Name in "${folder_name[@]}"; do
        Folder_Path="$path/$Folder_Name"
        mkdir -p "$Folder_Path"  # -p is used to create parent directory if it is not there
        echo "Folder has been created: $Folder_path"
done

}

echo "Enter foldder path where you need to create folder"
read path
echo "Enter  the folder name you need to create"
read -a folder_name

create_folder "$path" "${folder_name[@]}"
