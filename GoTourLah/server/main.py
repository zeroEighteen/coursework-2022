from pyexpat import model
import sys
# sys.path.append("..")

import os
import cv2
import socket
import time
# import shared.k as k
# Replacing shared.k with plain old variable declarations
CAMERA_WIDTH = 320
CAMERA_HEIGHT = 320
BUFFER_SIZE = 65536
from rtp import RTP
import numpy as np
import matplotlib.pyplot as plt
import tensorflow as tf
from object_detection.utils import label_map_util
from object_detection.utils import config_util
from object_detection.utils import visualization_utils as viz_utils
from object_detection.builders import model_builder
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


# Load model and save
# print('Loading model...', end='')
# start = time.time() # Start time count
# # Load saved model and build the detection function
# detect_fn = tf.saved_model.load(savedmodel_path)

# end = time.time() # End time count
# duration = end - start
# print('Done! Took {} seconds'.format(duration))
# #@elliot
# pb_file = os.path.join(model_path, 'saved_model.pb')


# Read the graph.
# with tf.io.gfile.GFile(pb_file, 'rb') as f:
#     graph_def = tf.compat.v1.GraphDef()
#     graph_def.ParseFromString(f.read())
# gpu_options = tf.GPUOptions(per_process_gpu_memory_fraction=1)
# with tf.Session(config=tf.ConfigProto(gpu_options=gpu_options)) as sess:
#     sess.graph.as_default()
#     tf.import_graph_def(graph_def, name='')

if __name__ == "__main__":
  s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) # RTP over UDP over IPv4
  s.bind((socket.gethostname(), 1447))

  while True:
    # Receive image
    data, address = s.recvfrom(BUFFER_SIZE)
    print("Received.")
    s.sendto(data, address)

    payload = RTP().fromBytes(data).payload

    npdata = np.frombuffer(bytes(payload), dtype=np.uint8)
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
          min_score_thresh=.30,
          agnostic_mode=False)

    # Display output
    cv2.imshow('object detection', cv2.resize(image_np_with_detections, (800, 600)))

    if cv2.waitKey(25) & 0xFF == ord('q'):
        break
    # Provide path to an image for testing
    # image_height, image_width, _ = image.shape
    # image = cv2.resize(image, (224, 224))
    # image = image[:, :, [2, 1, 0]] # BGR2RGB
    
    # outputs = sess.run([sess.graph.get_tensor_by_name('num_detections:0'),
    #             sess.graph.get_tensor_by_name('detection_scores:0'),
    #             sess.graph.get_tensor_by_name('detection_boxes:0'),
    #             sess.graph.get_tensor_by_name('detection_classes:0')],  
    #             feed_dict={
    #                       'image_tensor:0': image.reshape(1,
    #                         image.shape[0],
    #                         image.shape[1],3)})

    # Visualize the results
    # font = cv2.FONT_HERSHEY_SIMPLEX
    
    # for i in range(num_detections):
    #     classId = int(outputs[3][0][i])
    #     print(classId)
    #     score = float(outputs[1][0][i])
    #     bbox = [float(v) for v in outputs[2][0][i]]
    #     if True:
    #         x = bbox[1] * image_width
    #         y = bbox[0] * image_height
    #         right = bbox[3] * image_width
    #         bottom = bbox[2] * image_height
    #         cv2.rectangle(image,
    #                       (int(x), int(y)),
    #                       (int(right), int(bottom)),
    #                       (225, 255, 0),
    #                       thickness=2)
    #         cv2.putText(image,str(class_list[classId-1]),(int(x),int(y)), font, 1, (200,0,0), 3, cv2.LINE_AA)
    #         print('SCORE:',score, ', Class:',class_list[classId-1], ', BBox:',int(x),int(y),int(right),int(bottom))
    # cv2.imshow("Image", image)
    # if cv2.waitKey(25) & 0xFF == ord('q'):
    #   break

cv2.destroyAllWindows()