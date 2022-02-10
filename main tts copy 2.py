import pyttsx3 #pip3 install pyttsx3
from googletrans import Translator, constants #pip3 install googletrans==3.1.0a0, pip3 uninstall googletrans
engine = pyttsx3.init() #initialise pyttsx3
translator = Translator() #initialise google translator

voices = engine.getProperty("voices")
lang = []
for voice in voices:
    lang.append(voice.languages)
print(lang)

print(len(lang))
# totallist = []
# user_lvl_list = []
# langlist = []
# lang_user_list = []
# translation_code = "en"

# def speak(text):
#     engine.say(text)
#     engine.runAndWait()

# def translate(text,language):
#     translation = translator.translate(text, dest=language)
#     return(translation.text)

# if input("Answer(y/n): ") == "y":
#     while True:
#         voices = engine.getProperty('voices')
#         for voice in voices:
#             Current_voice_ID = voice.id
#             if Current_voice_ID == engine.getProperty('voice'):
#                 selected_voice_name = voice.name
#         print("Current Property Stats:")
#         print("Volume: {}".format(engine.getProperty('volume')))
#         print("Rate (WPM): {}".format(engine.getProperty('rate')))
#         print("Voice Name: {}".format(selected_voice_name))
        
        
        
#         adjustProperty = str(input("Change volume/rate/voice(language): "))

#         if adjustProperty == "volume":
#             adjustValue = float(input("Change volume to: "))
#             engine.setProperty(adjustProperty, adjustValue)
#         elif adjustProperty == "rate":
#             adjustValue = int(input("Change rate to: "))
#             engine.setProperty(adjustProperty, adjustValue)
#         elif adjustProperty == "voice(language)":
#             adjustProperty = "voice"
#             import translation
#             # from pprint import pprint
#             voices = engine.getProperty('voices')
#             pyttsx_original_code = []
#             for voice in voices:
#                 pyttsx_original_code.append(voice.languages[0])

            

#             google_translate_lang_dict = constants.LANGUAGES
#             translation_codes = list(sorted(google_translate_lang_dict.keys()))
#             translation_languages = []
#             for x in translation_codes:
#                 translation_languages.append(google_translate_lang_dict.get(x))
#             available_lang_code = []
#             available_lang_name = []
#             for x in pyttsx_original_code:
#                 if x[0:2] != "zh":
#                     x = x[0:2]
#                 else:
#                     x = x[0:2] + "-" + x[3:].lower() 
#                 if x in translation_codes and x not in available_lang_code:
#                     available_lang_code.append(x)
#             available_lang_code = sorted(available_lang_code)
#             for x in available_lang_code:
#                 if x in translation_codes:
#                     language = translation_languages[translation_codes.index(x)].capitalize()
#                     if language not in available_lang_name:
#                         available_lang_name.append(language)

#             # print(available_lang_name)
#             print("\n", available_lang_code)
#             print("Languages Supported: ", end = "")
#             for x in available_lang_name:
#                 if available_lang_name.index(x) != len(available_lang_name)-1:
#                     print(x, end=", ")
#                 else:
#                     print(x)

#             def sublang(lang):
#                 print(available_lang_name)
#                 sublang_code = available_lang_code[available_lang_name.index(lang)]
#                 print(sublang_code)
#                 accents_code = []
#                 accents_names = []
#                 accents_name = ""
#                 pyttsx_code__translation_code = []
#                 print(pyttsx_original_code)
#                 for x in pyttsx_original_code:
#                     if sublang_code[0:2] != "zh" and sublang_code == x[0:2] and x not in accents_code:
#                         accents_code.append(x)
#                     elif x not in accents_code and sublang_code == x[0:2]+"-"+x[3:].lower():
#                         accents_code.append(x)
#                 print(accents_code)
#                 for x in accents_code:
#                     if x[0:2] != "zh":
#                         accents_name = translation_languages[translation_codes.index(x[0:2])].capitalize() + "({})".format(x[3:].upper())
#                     else:
#                         accents_name = lang
#                     if accents_name not in accents_names: 
#                         accents_names.append(accents_name)
#                 print(accents_code, accents_names,accents_name)
#                 if len(accents_names) > 1:
#                     print("Supported Language Accents Found!")
#                     for x in accents_names:
#                         if accents_names.index(x) == len(accents_names)-1:
#                             print(x, end="\n")
#                         else:
#                             print(x, end=", ")
#                     pyttsx_code__translation_code.append(accents_code[accents_names.index(input("Please Select Your Language Accent: "))])
#                     if pyttsx_code__translation_code[0][0:2] != "zh":
#                         pyttsx_code__translation_code.append(pyttsx_code__translation_code[0][0:2])
#                     else:
#                         pyttsx_code__translation_code.append(pyttsx_code__translation_code[0][0:2] + "-" + pyttsx_code__translation_code[3:].lower())
#                 else:
#                     print("Selected Language: {}".format(accents_names[0]))
#                     pyttsx_code__translation_code.append(accents_code[0])
#                     if pyttsx_code__translation_code[0][0:2] != "zh":
#                         pyttsx_code__translation_code.append(pyttsx_code__translation_code[0][0:2])
#                     else:
#                         pyttsx_code__translation_code.append(pyttsx_code__translation_code[0][0:2] + "-" + pyttsx_code__translation_code[0][3:].lower())
#                 return pyttsx_code__translation_code
#             Selected_Lang = str(input("Please Select Your Language: "))
#             pyttsx_code__translation_code = sublang(Selected_Lang)
#             translation_code = pyttsx_code__translation_code[1]
#             for voice in voices:
#                 if pyttsx_code__translation_code[0] in voice.languages:
#                     print("\n")
#                     print("Voice: %s" % voice.name)
#                     print(" - Gender: %s" % voice.gender)
#                     print(" - Age: %s" % voice.age)
#             voice_name_request = input("Enter Name of Selected Voice: ")
#             adjustValue = ""
#             for voice in voices:
#                 if voice.name == voice_name_request:
#                     adjustValue = voice.id
#                     break
#             engine.setProperty(adjustProperty, adjustValue)
#         print("Changing {} to {}.".format(adjustProperty, voice_name_request))
#         engine.runAndWait()
#         speak(translate("This is a test",translation_code)) 
#         if str(input("Continue with customisation? Answer(y/n): ")) == "n":
#             break

# def gather_obj_description(label):
#     attraction_labels_n_description = {"siloso": "Description", "GBTB": "Description", "Flyer": "Description"}
#     return attraction_labels_n_description.get(label)

# while True:
#     speak(translate(gather_obj_description("!!!!!"),translation_code)) #replace "!!!!!" with variable that gives detected label name
#     print("iteration done") #delete this later