# GoTourLah

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

## Installation

1. Clone the repository from GitHub.
2. Install Python 3.9.6 (other versions may fail to function).
3. Run `python ./start.py` from the project root directory to install packages and run the program.

## Usage

The `server/main.py` Python script is to be run in the Cloud. The server receives images and determines the significant location shown in the image if present. The `client/main.py` Python script is to be run on the Raspberry Pi attached on the physical clip-on wearable. The client streams images to the server and plays audio using Text To Speech received from the server.

However, as a proof of concept, to ensure that errors are not caused by the electronic components of the wearable or other factors, the client and server will be tested to run locally. The server and client code have been tested to work on Intel Macs (does not work on M1 Macs at the time of writing)