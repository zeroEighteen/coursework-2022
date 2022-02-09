import sys
# sys.path.append("..")
import cv2, imutils
import random
import time
import socket
from copy import deepcopy
from rtp import RTP, Extension, PayloadType
# import shared.k as k
# Replacing shared.k with plain old variable declarations
CAMERA_WIDTH = 320
CAMERA_HEIGHT = 320
BUFFER_SIZE = 65536
import numpy as np

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) # UDP over IPv4
s.bind((socket.gethostname(), 1234))

#time_int = random.randint(1,9999)
packet_seq = random.randint(1, 9999) # https://en.wikipedia.org/wiki/Real-time_Transport_Protocol

cap = cv2.VideoCapture(1)
# cap = cv2.VideoCapture('../data/merlion4.mp4')

cap.set(cv2.CAP_PROP_FRAME_WIDTH, CAMERA_WIDTH)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, CAMERA_HEIGHT)
cap.set(cv2.CAP_PROP_FPS, 15)

baseRTP = RTP(
    marker=True,
    payloadType=PayloadType.L16_2chan,
    # extension=Extension(
    #     startBits=0,
    #     headerExtension=0
    # ),
    # ssrc=185755418
)

while True:
  image: np.ndarray
  isSuccess, image = cap.read()
  if not isSuccess:
    print("Camera Error")
    break
  
  image = cv2.resize(image, (CAMERA_WIDTH, CAMERA_HEIGHT))
  # image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

  isEncoded, buffer = cv2.imencode('.jpg',image,[cv2.IMWRITE_JPEG_QUALITY,80])
  if not isEncoded:
    print("JPG Encoding Error")
    break
  
  payload = bytearray(buffer)

  nextRTP = deepcopy(baseRTP)
  nextRTP.sequenceNumber += 1
  nextRTP.timestamp = int(time.time())
  nextRTP.payload = payload

  data = nextRTP.toBytearray()
  print(sys.getsizeof(data))
  s.sendto(data, (socket.gethostname(), 1447))

  packet_seq += 1

  time.sleep(0.5)

s.close()
cap.release()
