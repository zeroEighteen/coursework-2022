from copy import deepcopy
import time
from rtp import RTP, Extension, PayloadType

baseRTP = RTP(
    marker=True,
    payloadType=PayloadType.L16_2chan,
    # extension=Extension(
    #     startBits=0,
    #     headerExtension=0
    # ),
    # ssrc=185755418
)

def rtp(payload, seq):
  rtpData = deepcopy(baseRTP)
  rtpData.sequenceNumber = seq
  rtpData.timestamp = int(time.time())
  rtpData.payload = payload
  return rtpData