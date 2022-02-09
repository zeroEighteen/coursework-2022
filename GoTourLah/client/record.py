import sys
sys.path.append("..")

import datetime, time
import shared.k as k
import numpy as np
import os
import cv2

duration = 60
frames_per_second = 24.0
res = '1080p'

t = datetime.datetime.now()

cap = cv2.VideoCapture(0)

width  = int(cap.get(3))
height = int(cap.get(4))

print(width, height)

out1 = cv2.VideoWriter('video1_{}.mp4'.format(str(t)).replace(" ", "_"), cv2.VideoWriter_fourcc(*'XVID'), 60, (width, height))
out2 = cv2.VideoWriter('video2_{}.mp4'.format(str(t)).replace(" ", "_"), cv2.VideoWriter_fourcc(*'XVID'), 60, (width, height))

while True:
    ret, frame = cap.read()
    out1.write(frame)
    out2.write(frame)
    cv2.imshow('frame',frame)
    if cv2.waitKey(30) == 27 or datetime.datetime.now().timestamp() - t.timestamp() >= duration:
        break

cap.release()
out1.release()
out2.release()
cv2.destroyAllWindows()