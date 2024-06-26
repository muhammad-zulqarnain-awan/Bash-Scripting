#!/bin/bash

# Check whether the user has root access or not
if [[ ${UID} -ne 0 ]]
then
    echo "Only root/sudo user can run this script"
    exit 1
fi

# Create a new file which will create username and password
UDTFILE=$(pwd)/user-accounts-detail.txt
touch $UDTFILE

# Number of user
echo "Enter the number of user you want to create:"
read NUSER

for i in $(seq 1 $NUSER)
do

    # Ask for username
    echo "$i USERNAME:"
    read USERNAME

    # Generate a password
    PASSWORD=$(date +%s%n)

    # Create new user
    useradd -m $USERNAME

    if [[ $? -ne 0 ]]
    then
        echo "User could not be created"
        exit 1
    fi

    echo "$USERNAME:$PASSWORD" | chpasswd
    if [[ $? -ne 0 ]]
    then
        echo "Password could not be created"
        exit 1
    fi

    passwd -e $USERNAME

    echo "USERNAME: $USERNAME" >> $UDTFILE
    echo "PASSWORD: $PASSWORD" >> $UDTFILE
    echo "#########################################" >> $UDTFILE
    echo "" >> $UDTFILE
    
done;
