# <------------------------------------Import relevant libraries------------------------------------>
print("Loading...")
import sys
sys.path.append("..")

import os # OS library: for path manipulation
import cv2 # OpenCV library: for webcam usage and detection usage
import socket # socket library: for wireless trasnfer
import shared.k as k # shared module: self-written for sharing variables between client and server
from rtp import RTP # RTP library: for wireless transfer
import random # random library: for wireless transfer
import numpy as np # numpy library: for detection and much data manipulation
import tensorflow as tf # tensorflow library: for detection and much data manipulation
from object_detection.utils import label_map_util # object decttion library: Add-on for Tensorflow
from object_detection.utils import config_util  # object decttion library: Add-on for Tensorflow
from object_detection.utils import visualization_utils as viz_utils  # object decttion library: Add-on for Tensorflow
from object_detection.builders import model_builder  # object decttion library: Add-on for Tensorflow

# <------------------------------------Setting up the model------------------------------------>
# Creating variables for manipulating path to load/use the model
model_dir = "/Users/ElliotKoh/Documents/Programming/School/coursework-final/Tensorflow/workspace/models/my_ssd_mobnet/export/"
labels_path = model_dir + "official/label_map.pbtxt"
pipeline_config_path = model_dir + "pipeline.config"
checkpoint_dir = model_dir + "checkpoint/"

# Use GPU
gpus = tf.config.experimental.list_physical_devices('GPU')
for gpu in gpus:
    tf.config.experimental.set_memory_growth(gpu, True)

# Load pipeline config and build a detection model
configurations = config_util.get_configs_from_pipeline_file(pipeline_config_path)
model_config = configurations['model']
detect_model = model_builder.build(model_config=model_config, is_training=False)

# Load/Restore checkpoint
checkpt = tf.compat.v2.train.Checkpoint(model=detect_model)
checkpt.restore(os.path.join(checkpoint_dir, 'ckpt-0')).expect_partial()

# Define main detection function
@tf.function
def detection_func(image):
    """Detect objects in image."""

    image, shapes = detect_model.preprocess(image)
    prediction_dict = detect_model.predict(image, shapes)
    detections = detect_model.postprocess(prediction_dict, shapes)

    return detections, prediction_dict, tf.reshape(shapes, [-1])

# Load labels from label map
category_index = label_map_util.create_category_index_from_labelmap(labels_path, use_display_name=True) 
print("-" * 50)
print("Server setup is completed. \nHit the \"Q\" key to quit the server program anytime.")
print("-" * 50)
# <------------------------------------Setting up wireless data transfer------------------------------------>
s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) # RTP over UDP over IPv4
s.bind((socket.gethostname(), k.SERVER_ADDR))
stc_packet_seq = random.randint(1, 9999) # https://en.wikipedia.org/wiki/Real-time_Transport_Protocol

# <------------------------------------Main program loop------------------------------------>
print("Entering main program loop.\nPlease start the client-side program. (run \"sudo python main.py\" in the correct directory.)")
print("-" * 50)
while True:
    # Receive image from client
    cts_data, cts_address = s.recvfrom(k.BUFFER_SIZE)
    cts_payload = RTP().fromBytes(cts_data).payload
    print("Received data from client.")

    # Process sent image for detection
    npdata = np.frombuffer(bytes(cts_payload), dtype=np.uint8)
    image = cv2.imdecode(npdata, cv2.IMWRITE_JPEG_QUALITY)
    
    # Input image for detection and detect
    input_tensor = tf.convert_to_tensor(np.expand_dims(image, 0), dtype=tf.float32)
    detections, predictions_dict, shapes = detection_func(input_tensor)

    # Draw output box for detected image - for testing/demonstration purposes
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

    # Format detected array(Tensor) and extract and output class name of detected object
    classes  = (detections['detection_classes'][0].numpy())
    scores = detections['detection_scores'][0].numpy()
    class_name = ""
    if scores[0] > 0.7:
        try:
            class_name = category_index[classes[0] + 1]['name']
        except:
            continue
    print(class_name)
    #  temp = temp.astype(int)
    # count0 = len(temp[temp==0])
    # count1 = len(temp[temp==1])
    # print(count0)
    # print(count1)
    # detected = category_index[mode(temp) + 1]['name']
    # print("Detected: " + str(category_index[mode(temp) + 1]['name']))

    # Send detected class name to client
    s.sendto(bytes(class_name.encode()), (socket.gethostname(), k.CLIENT_ADDR))
    stc_packet_seq += 1

    # Display output
    cv2.imshow('Server Demonstration', cv2.resize(image_np_with_detections, (1280, 720)))

    # Hit Q as an escape key
    if cv2.waitKey(25) & 0xFF == ord('q'):
        break

cv2.destroyAllWindows()