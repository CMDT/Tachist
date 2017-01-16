# Python script for creating text licence files as child windows for settings App. writes Acknowledgement.plist

# J A. Howell 27/11/15
#

# Reads .licence files in settings bundles and outputs one file
# called Acknowledgements.plist.  The file is formatted correctly for
# use as a child pane in the settings plist for the app.
#

import os
import sys
import plistlib
from copy import deepcopy

os.chdir(sys.path[0])

plist = {'PreferenceSpecifiers': [], 'StringsTable': 'Acknowledgements'}
base_group = {'Type': 'PSGroupSpecifier', 'FooterText': '', 'Title': ''}

for filename in os.listdir("."): # look for files
    if filename.endswith(".licence"): # input file name
        current_file = open(filename, 'r')
        group = deepcopy(base_group)
        title = filename.split(".licence")[0] # read the name for the Group Title
        group['Title'] = title # write the Group Title
        group['FooterText'] = current_file.read() # write the text body as a footnote
        plist['PreferenceSpecifiers'].append(group)
        
        plistlib.writePlist(
                            plist,"Acknowledgements.plist" #output file name
                            )
