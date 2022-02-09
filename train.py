# Import libraries
import os # To run terminal commands
import tensorflow as tf # Google's Machine Learning frameowrk. using for Transfer training.
from object_detection.utils import config_util # Add-on for Tensorflow
from object_detection.protos import pipeline_pb2 # Add-on for Tensorflow
from google.protobuf import text_format # Add-on for Tensorflow

# Ensure user navigates and runs the program from the correct directory path
print("All terminal related actions should be executed from the Tensorflow directory. If not, please navigate to the directory.")
while True:
  confirmation = input("Enter \"ready\" when training is to commence")
  if confirmation == "ready":
    break
  else:
    continue

# <------------------------------------Generate label map------------------------------------>
num = int(("Enter the number of types of items/objects to be detected: ")) # Get user input on the number of labels
label_map = []
for x in num:
  label = input("Enter label name for item " + str(x) + ": ") # Get user input on label names
  label_map.append({"name": label, "num": x})

with open("Tensorflow/workspace/annotations" + '/label_map.pbtxt', 'w') as f: # Write label map file
    for x in label_map:
        f.write('item { \n')
        f.write('\tname:\'{}\'\n'.format(x['name']))
        f.write('\tid:{}\n'.format(x['id']))
        f.write('}\n')

# <------------------------------------Create model directory------------------------------------>
model_name = input("Enter name for the model") # Get use input for custom model name
os.system("mkdir Tensorflow/workspace/models/" + model_name) # Creates directory to store all model-related files
os.system("cp Tensorflow/workspace/pre-trained-models/ssd_mobilenet_v2_fpnlite_320x320_coco17_tpu-8/pipeline.config Tensorflow/workspace/models/" + model_name) # Copy template model config file into custom model

# <------------------------------------Configure config file------------------------------------>
config_file_path = "Tensorflow/workspace/models/" + model_name + "/pipeline.config"
config = config_util.get_configs_from_pipeline_file(config_file_path)

pipeline_config = pipeline_pb2.TrainEvalPipelineConfig()
with tf.io.gfile.GFile(config_file_path, "r") as f:                                                      
    proto_str = f.read()                                                                                                  
    text_format.Merge(proto_str, pipeline_config)

# <------------------------------------Settings for config file------------------------------------>

batch_size = int(input("Default batch size is 4. Enter custom batch size:")) # User input for batch size for training 
if str(batch_size) == "":
  batch_size = 4

pipeline_config.model.ssd.num_classes = num
pipeline_config.train_config.batch_size = batch_size
pipeline_config.train_config.fine_tune_checkpoint = "Tensorflow/workspace/pre-trained-models/ssd_mobilenet_v2_fpnlite_320x320_coco17_tpu-8/checkpoint/ckpt-0"
pipeline_config.train_config.fine_tune_checkpoint_type = "detection"
pipeline_config.train_input_reader.label_map_path= "Tensorflow/Workspace/annotations/label_map.pbtxt"
pipeline_config.train_input_reader.tf_record_input_reader.input_path[:] = ["Tensorflow/Workspace/annotations/train.record"]
pipeline_config.eval_input_reader[0].label_map_path = "Tensorflow/Workspace/annotations/label_map.pbtxt"
pipeline_config.eval_input_reader[0].tf_record_input_reader.input_path[:] = ["Tensorflow/Workspace/annotations/test.record"]

# Write to the config file
config_text = text_format.MessageToString(pipeline_config)                                                                       
with tf.io.gfile.GFile(config_file_path, "wb") as f:
    f.write(config_text)

# Final interaction with user. 
print("Preparation for training complete. Training shall now commence")
print("Please copy and paste the following program into your Terminal within this directory.")
print("""python Tensorflow/workspace/model_main_tf2.py --model_dir=Tensorflow/workspace/models/{} --pipeline_config_path=Tensorflow/workspace/models/{}/pipeline.config --num_train_steps=10000""".format(model_name,model_name)) # Generate Terminal command for user to run
print("This program will now terminate. All the best with the training!")
exit()







# WORKSPACE_PATH = 'Tensorflow/workspace'
# SCRIPTS_PATH = 'Tensorflow/scripts'
# APIMODEL_PATH = 'Tensorflow/models'
# ANNOTATION_PATH = WORKSPACE_PATH+'/annotations'
# IMAGE_PATH = WORKSPACE_PATH+'/images'
# MODEL_PATH = WORKSPACE_PATH+'/models'
# PRETRAINED_MODEL_PATH = WORKSPACE_PATH+'/pre-trained-models'
# CONFIG_PATH = MODEL_PATH+'/my_ssd_mobnet/pipeline.config'
# CHECKPOINT_PATH = MODEL_PATH+'/my_ssd_mobnet/'

##import tensorflow as tf
##from object_detection.utils import config_util
##from object_detection.protos import pipeline_pb2
##from google.protobuf import text_format

##labels = [{'name':'GBTB', 'id':1}, {'name':'Flyer', 'id':2}, {'name':'siloso', 'id':3}]
##
##with open(ANNOTATION_PATH + '\label_map.pbtxt', 'w') as f:
##    for label in labels:
##        f.write('item { \n')
##        f.write('\tname:\'{}\'\n'.format(label['name']))
##        f.write('\tid:{}\n'.format(label['id']))
##        f.write('}\n')

# set config path
CONFIG_PATH = "Tensorflow/workspace/models/my_ssd_mobnet/pipeline.config"
# set config
config = config_util.get_configs_from_pipeline_file(CONFIG_PATH)
