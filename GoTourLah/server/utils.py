"""
Run object detection on images, Press ESC to exit the program
For Raspberry PI, please use `import tflite_runtime.interpreter as tflite` instead
"""
import re
import numpy as np
import sys
sys.path.append("..")
import cv2
import shared.k as k
import tensorflow.lite as tflite
import timeit
# import tflite_runtime.interpreter as tflite

def load_labels(label_path):
  r"""Returns a list of labels"""
  with open(label_path) as f:
    labels = {}
    for line in f.readlines():
      m = re.match(r"(\d+)\s+(\w+)", line.strip())
      labels[int(m.group(1))] = m.group(2)
    return labels


def load_model(model_path):
  r"""Load TFLite model, returns a Interpreter instance."""
  interpreter = tflite.Interpreter(model_path=model_path)
  interpreter.allocate_tensors()
  return interpreter


def process_image(interpreter, image, input_index):
  r"""Process an image, Return a list of detected class ids and positions"""

  input_data = np.expand_dims(image, axis=0)  # expand to 4-dim

# gay
  # Process
  interpreter.set_tensor(input_index, input_data)

  interpreter.invoke() # bottleneck

  # Get outputs
  output_details = interpreter.get_output_details()
  # print(output_details)
  # output_details[0] - position
  # output_details[1] - class id
  # output_details[2] - score
  # output_details[3] - count

  positions = np.squeeze(interpreter.get_tensor(output_details[0]['index']))
  classes = np.squeeze(interpreter.get_tensor(output_details[1]['index']))
  scores = np.squeeze(interpreter.get_tensor(output_details[2]['index']))

  # print(positions, classes, scores)
  result = []

  for idx, score in enumerate(scores):
    if score > 0.7:
      result.append({'pos': positions[idx], '_id': classes[idx]})

  # if scores > 0.1:
  #   result.append({'pos': positions[0], '_id': classes})

  return result

def display_result(result, frame, labels):
  r"""Display Detected Objects"""
  font = cv2.FONT_HERSHEY_SIMPLEX
  size = 0.6
  color = (255, 0, 0)  # Blue color
  thickness = 1

  # position = [ymin, xmin, ymax, xmax]
  # x * CAMERA_WIDTH
  # y * CAMERA_HEIGHT
  for obj in result:
    pos = obj['pos']
    _id = obj['_id']

    x1 = int(pos[1] * k.CAMERA_WIDTH)
    x2 = int(pos[3] * k.CAMERA_WIDTH)
    y1 = int(pos[0] * k.CAMERA_HEIGHT)
    y2 = int(pos[2] * k.CAMERA_HEIGHT)

    cv2.putText(frame, labels[_id], (x1, y1), font, size, color, thickness)
    cv2.rectangle(frame, (x1, y1), (x2, y2), color, thickness)

  cv2.imshow('Object Detection', frame)