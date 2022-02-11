# GoTourLah

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

## Installation & Setup

1. Clone the repository from GitHub.
2. Install Python 3.9.6 (other versions may fail to function).
3. Run `python ./start.py` from the project root directory to install packages and run the program.
4. Open 2 instances of Terminal.app (or Visual Studio Code Terminals).
5. On one Terminal, enter `cd server; python main.py`. On the other Terminal, enter `cd client; sudo python main.py`. (Important that server starts first because it has to be ready to receive the images from client)

## Usage

1. The device's camera should start. Hold up the image of Gardens By The Bay to the camera, to simulate the client looking at a landmark.
2. The server should receive and process the image, and send relevant information to be read out to the user to the client. You would hear an audio describing the landmark you are looking at.
3. You may then test this with the other trained landmark—Singapore Flyer
4. You may terminate the client program with the 'H' key, and the server program is not meant to terminated by the user (can be terminated with ^C)

## Why we run both client and server locally

The `server/main.py` Python script is to be run in the Cloud. The server receives images and determines the significant location shown in the image if present, and retrives relevant infomation about the landmark. The `client/main.py` Python script is to be run on the Raspberry Pi attached on the physical clip-on wearable. The client streams images to the server and plays audio using Text To Speech received from the server.

However, as a proof of concept, to ensure that errors are not caused by the electronic components of the wearable or other factors, the client and server will be tested to run locally. The server and client code have been tested to work on Intel Macs (does not work on M1 Macs at the time of writing)