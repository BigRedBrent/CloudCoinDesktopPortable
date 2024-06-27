# CloudCoin Desktop Portable

Download the latest version here:
https://github.com/BigRedBrent/CloudCoinDesktopPortable/raw/main/CloudCoinDesktopPortable.zip
___

CloudCoin Desktop Portable uses a command line argument that is built into CloudCoin Desktop, to store the settings and coin files in the same folder as this script, instead of in your computer's local user settings folder.

This allows you to store your coins and run the manager from a single location, such as a USB flash drive.  
You can then copy the "CloudCoin Desktop Portable" folder to multiple safe locations or flash drives to make backup copies of all of your coins.

Do not run this from more than one copy, or you will make changes to one copy that are not made in the original copy.  
You can make backup copies of the portable folder, but don't use a backup copy to run the manager unless you lose the original portable folder.
___

This script only works with the windows version of CloudCoin Desktop.

Download and install the latest version of the CloudCoin Desktop from here:  
https://cloudcoinconsortium.com/use.html

This script will attempt to find existing CloudCoin Desktop files, and copy them into this portable folder.  
If copied, the original files will not be altered in any way.

You may find the settings and coin files in the "Settings" folder.  
To start with a new blank copy of settings, select no when prompted to copy existing settings.  
To remove any existing settings files that have been copied, you will have to find and delete them yourself.  
Existing settings files are located in a directory that looks like this: "C:\Users\USER\cloudcoin_desktop"

To use the locally installed CloudCoin Desktop, select no when prompted to copy CloudCoin Desktop.  
To copy CloudCoin Desktop to the portable folder after originally selecting not to,  
simply delete the "CloudCoin Desktop" folder and run this script again.

After CloudCoin Desktop is installed, run: "Start CloudCoin Desktop Portable.cmd"
