import os
import subprocess

# packages to install
packages = ['numpy', 'opencv-python', 'imutils', 'rtp']#, 'tensorflow']

# runs 
process = subprocess.run(['pip', 'install', *packages],
                         stdout=subprocess.PIPE, universal_newlines=True)

