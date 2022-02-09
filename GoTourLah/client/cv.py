import cv2
import numpy as np

cap = cv2.VideoCapture(0)
while True:
  success, frame = cap.read()
  cv2.imshow("video feed", frame)
  key = cv2.waitKey(1)
  if key == ord("q"):
    break

cap.release()
cv2.destroyAllWindows()