# <------------------------------------Import relevant libraries------------------------------------>
import sys
sys.path.append("..")

import cv2 # OpenCV library: for webcam usage and detection usage
import random # random library: for wireless transfer
import timeit # timeit library: for timing the sending of data
import socket # socket library: for wireless trasnfer
from shared.rtp import rtp # shared module: self-written for sharing variables between client and server
import shared.k as k # shared module: self-written for sharing variables between client and server
import numpy as np # numpy library: for detection and much data manipulation
import keyboard as kb # keyboard library: for simulating keyboard keys as physical on-device buttons

# <------------------------------------Setting up wireless data transfer------------------------------------>
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) # UDP over IPv4
s.bind((socket.gethostname(), 1234))
cts_packetSeq = random.randint(1, 9999) # https://en.wikipedia.org/wiki/Real-time_Transport_Protocol

# <------------------------------------Setting up camera------------------------------------>
# Start camera
camera_id = 1
cap = cv2.VideoCapture(camera_id)
print("Your webcam should ahve been turned on at this stage. \nIf your camera has not turned on, please manually change camera_id to be greater than the current camera_id value by 1.")
# for x in range(5):
#   cap = cv2.VideoCapture(x)
#   isSuccess, image = cap.read()
#   print("Attempting to connect to camera id: " + str(x))
#   if isSuccess == True:
#     print("Successfully connected camera id: " + str(x)) 
#     break
#   else:
#     print("Unable to connect to camera ids 0 to 4. It is likely an error on your device. Terminating program.")
#     raise "A problem occured with starting the camera: " + str(BaseException)
    
# except:
#   try:
#     cap = cv2.VideoCapture(1)
#   except BaseException as error:
#     print("A problem occured with starting the camera: " + str(BaseException))

# Configuring camera properties: includes height, width and max framerate
cap.set(cv2.CAP_PROP_FRAME_WIDTH, k.CAMERA_WIDTH)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, k.CAMERA_HEIGHT)
cap.set(cv2.CAP_PROP_FPS, 15)

# <------------------------------------Miscellaneous configuration------------------------------------>
# Declaring variables for use in main loop
current = "GBTB"
prev = ""
consec_count = 0
currentObj = ""
prevTime = timeit.default_timer()

print("Setup complete. Entering main loop.")
# <------------------------------------Main program loop------------------------------------>
while True:
  # Timer to run image sending and receiving code every 0.5 seconds
  currentTime = timeit.default_timer()
  if currentTime - prevTime >= 0.5:
    prevTime = currentTime
    
    # Setup and read camera within loop
    image: np.ndarray
    isSuccess, image = cap.read()
    if not isSuccess:
      print("Camera Error")
      break
    
    # Configure camera input
    image = cv2.resize(image, (k.CAMERA_WIDTH, k.CAMERA_HEIGHT))
    isEncoded, buffer = cv2.imencode('.jpg',image,[cv2.IMWRITE_JPEG_QUALITY,80])
    if not isEncoded:
      print("JPG Encoding Error")
      break
    
    # Preparing camera input for wireless transfer 
    cts_payload = bytearray(buffer)
    rtpData = rtp(cts_payload, cts_packetSeq)
    cts_data = rtpData.toBytearray()

    # Sending camera input to server
    s.sendto(cts_data, (socket.gethostname(), k.SERVER_ADDR))
    cts_packetSeq += 1

    # Receiving class name from server
    stc_data, stc_addr = s.recvfrom(k.BUFFER_SIZE)
    # print(stc_data.decode("utf-8"))

    current = str(stc_data.decode("utf-8"))
    print(current)

    if current == prev:
      consec_count += 1
    elif current != prev:
      consec_count = 0

    if consec_count == 4:                    
      currentObj = current
      print("current object detected: " + currentObj)
      consec_count = 0
    prev = current
    print("consec_count: " + str(consec_count))

  if kb.is_pressed("space") == True:
    print('space was pressed')  


s.close()
cap.release()
