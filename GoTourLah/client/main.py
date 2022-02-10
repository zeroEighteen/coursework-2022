import sys
sys.path.append("..")
import cv2, imutils
import random
import time
import timeit
import socket
from copy import deepcopy
from shared.rtp import rtp
import shared.k as k
# Replacing shared.k with plain old variable declarations
import numpy as np
import keyboard as kb

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) # UDP over IPv4
s.bind((socket.gethostname(), 1234))

#time_int = random.randint(1,9999)
cts_packetSeq = random.randint(1, 9999) # https://en.wikipedia.org/wiki/Real-time_Transport_Protocol

cap = cv2.VideoCapture(1)
# cap = cv2.VideoCapture('../data/merlion4.mp4')

cap.set(cv2.CAP_PROP_FRAME_WIDTH, k.CAMERA_WIDTH)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, k.CAMERA_HEIGHT)
cap.set(cv2.CAP_PROP_FPS, 15)

final = "GBTB"
prev = ""
consec_count = 0
currentObj = ""
prevTime = timeit.default_timer()

while True:
  currentTime = timeit.default_timer()
  if currentTime - prevTime >= 0.5:
    print("sent")
    prevTime = currentTime

    image: np.ndarray
    isSuccess, image = cap.read()
    if not isSuccess:
      print("Camera Error")
      break
    
    image = cv2.resize(image, (k.CAMERA_WIDTH, k.CAMERA_HEIGHT))
    # image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

    isEncoded, buffer = cv2.imencode('.jpg',image,[cv2.IMWRITE_JPEG_QUALITY,80])
    if not isEncoded:
      print("JPG Encoding Error")
      break
    
    cts_payload = bytearray(buffer)
    rtpData = rtp(cts_payload, cts_packetSeq)
    cts_data = rtpData.toBytearray()
    s.sendto(cts_data, (socket.gethostname(), k.SERVER_ADDR))
    cts_packetSeq += 1

    stc_data, stc_addr = s.recvfrom(k.BUFFER_SIZE)
    print(stc_data.decode("utf-8"))

    if final == prev:
      consec_count += 1
    elif final != prev:
      consec_count = 0

    if consec_count == 2:                    
      currentObj = final
      consec_count = 0
    prev = final

  if kb.is_pressed("space") == True:
    print('space was pressed')  


s.close()
cap.release()
