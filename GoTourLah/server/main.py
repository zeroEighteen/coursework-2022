from pyexpat import model
import sys
sys.path.append("..")

import os
import cv2
import socket
import time
import shared.k as k
from rtp import RTP
import numpy as np
import matplotlib.pyplot as plt
import tensorflow as tf
from object_detection.utils import label_map_util
from object_detection.utils import config_util
from object_detection.utils import visualization_utils as viz_utils
from object_detection.builders import model_builder
from statistics import mode
import random

# import tensorboard as tb # Workaround from https://github.com/pytorch/pytorch/issues/47139
# tf.io.gfile = tb.compat.tensorflow_stub.io.gfile # Workaround from https://github.com/pytorch/pytorch/issues/47139
 

# https://medium.com/analytics-vidhya/creating-a-powerful-and-quick-object-detection-system-using-frozen-tensorflow-models-bacfff3e2114
# Load the Model
model_dir = "/Users/ElliotKoh/Documents/Programming/School/coursework-final/Tensorflow/workspace/models/my_ssd_mobnet/export/"
# savedmodel_path = model_dir + "saved_model/"
labels_path = model_dir + "label_map.pbtxt"
pipeline_config_path = model_dir + "pipeline.config"
checkpoint_dir = model_dir + "checkpoint/"

gpus = tf.config.experimental.list_physical_devices('GPU')
for gpu in gpus:
    tf.config.experimental.set_memory_growth(gpu, True)

# Load pipeline config and build a detection model
configs = config_util.get_configs_from_pipeline_file(pipeline_config_path)
model_config = configs['model']
detection_model = model_builder.build(model_config=model_config, is_training=False)

# Restore checkpoint
ckpt = tf.compat.v2.train.Checkpoint(model=detection_model)
print(checkpoint_dir)
ckpt.restore(os.path.join(checkpoint_dir, 'ckpt-0')).expect_partial()

@tf.function
def detect_fn(image):
    """Detect objects in image."""

    image, shapes = detection_model.preprocess(image)
    prediction_dict = detection_model.predict(image, shapes)
    detections = detection_model.postprocess(prediction_dict, shapes)

    return detections, prediction_dict, tf.reshape(shapes, [-1])
category_index = label_map_util.create_category_index_from_labelmap(labels_path, use_display_name=True) # Load labels
print(category_index)
print(type(category_index))

# if __name__ == "__main__":
#   s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) # RTP over UDP over IPv4
#   s.bind((socket.gethostname(), 1447))
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) # RTP over UDP over IPv4
s.bind((socket.gethostname(), k.SERVER_ADDR))
stc_packet_seq = random.randint(1, 9999) # https://en.wikipedia.org/wiki/Real-time_Transport_Protocol

while True:
    # Receive image
    cts_data, cts_address = s.recvfrom(k.BUFFER_SIZE)
    cts_payload = RTP().fromBytes(cts_data).payload
    print("Received.")

    npdata = np.frombuffer(bytes(cts_payload), dtype=np.uint8)
    image = cv2.imdecode(npdata, cv2.IMWRITE_JPEG_QUALITY)

    image_np_expanded = np.expand_dims(image, axis=0)

    input_tensor = tf.convert_to_tensor(np.expand_dims(image, 0), dtype=tf.float32)
    detections, predictions_dict, shapes = detect_fn(input_tensor)

    label_id_offset = 1
    image_np_with_detections = image.copy()

    viz_utils.visualize_boxes_and_labels_on_image_array(
            image_np_with_detections,
            detections['detection_boxes'][0].numpy(),
            (detections['detection_classes'][0].numpy() + label_id_offset).astype(int),
            detections['detection_scores'][0].numpy(),
            category_index,
            use_normalized_coordinates=True,
            max_boxes_to_draw=200,
            min_score_thresh=.70,
            agnostic_mode=False)

    temp  = (detections['detection_classes'][0].numpy())
    # print(type(temp))
    temp = temp.astype(int)
    # print(type(temp))
    # print(temp)
    temp2  = (detections['detection_classes'][0].numpy()+1)
    # print(temp2)
    # print(type(temp2))

    final = category_index[mode(temp) + 1]['name']
    print(category_index[mode(temp) + 1]['name'])

    s.sendto(bytes(final.encode()), (socket.gethostname(), k.CLIENT_ADDR))
    stc_packet_seq += 1

    # Display output
    cv2.imshow('object detection', cv2.resize(image_np_with_detections, (800, 600)))

    if cv2.waitKey(25) & 0xFF == ord('q'):
        break


cv2.destroyAllWindows()