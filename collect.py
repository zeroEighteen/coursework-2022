import cv2
import time

camera = cv2.VideoCapture(1)

seconds = int(input("Enter number of images: "))
dataset = input("Enter the dataset to collect: ")
time.sleep(5)
for i in range(seconds):
    time.sleep(0.5)
    return_value, image = camera.read()
    cv2.imwrite('./collected_data/v1/img_'+dataset+str(i)+'.png', image)
    cv2.imshow("Capture data", image)
    print("Image " + str(i) + "captured")
del(camera)