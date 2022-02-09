'''
Module detailing errors thrown during runtime
'''

class Error(Exception):
  '''
  Abstract class for errors
  '''

class CameraError(Error):
  '''
  Error thrown when camera fails such as connection failure
  '''

raise CameraError('A very specific bad thing happened.')