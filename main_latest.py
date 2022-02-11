# ------- done by zhi xuan -------
from numpy import int16
import pyttsx3                                                               # pip3 install pyttsx3
from googletrans import Translator, constants                                # pip3 install googletrans==3.1.0a0, pip3 uninstall googletrans

engine = pyttsx3.init()                                                      # initialise pyttsx3
translator = Translator()                                                    # initialise google translator

voices = engine.getProperty('voices')                                        # get all available system voices
google_translate_lang_dict = constants.LANGUAGES                             # get all available translation laguages

# --- declare all variables ---
pyttsx_original_code = []
translation_languages = []
available_lang_code = []
available_lang_name = []
translation_code = "en"
adjustProperty = ""
adjustValue = ""
language = ""
User_Input_Change_Voice_Properties = ""
User_Input_Continue_Customisation = ""
Selected_Lang = ""
available_name_code_dict = {}
translation_codes = []
translation_languages = []
supported_voice_language = []
voice_name_request = ""
not_first = False

# --- declare all user-defined functions ---
def speak(text): # Function to activate pyttsx3 module to output speech with provided text
    engine.say(text)
    engine.runAndWait()

def translate(text,language): # Function to translate given text using google translate library, with a google translate language code
    translation = translator.translate(text, dest=language)
    return(translation.text)

def pyttxs_get_voice_name(): # Function to obtain current pyttxs3 voice name
    Current_voice_ID = engine.getProperty("voice")
    for voice in voices:
        if Current_voice_ID == voice.id:
            return voice.name

def gather_obj_description(label): # Function to obtain description of object, with a string of the name of the object detected by the machine learning code
    attraction_labels_n_description = {"siloso": "What you're seeing is Fort Siloso. You'll be able to see many cannons and artilleries pointing towards the sea. They are relics from World War Two and were supposed to serve as armaments against the Japanese invasion of Singapore.", "GBTB": "What you are seeing is Gardens By The Bay. It is a modern garden that opened its doors in 2013. Its main attractions include the Flower Dome and Cloud Forest, where the former has different types of flora displayed based on current ongoing exhibition.", "Flyer": "What you're seeing is the Singapore Flyer It is a ferries wheel that stands at 165 metres tall, the tallest in the world when it opened in 2008. One revolution takes 30 minutes, and you'll have one of the greatest views of Singapore onboard."}
    return attraction_labels_n_description.get(label)

def convert_pyttsx3_code_to_google_trans_code(to_be_converted_code): # Function to convert a pyttxs3 code to a google translate code
    if to_be_converted_code[0:2] == "zh":
        return "zh" + "-" + to_be_converted_code[3:].lower()
    else:
        return to_be_converted_code[0:2]

def sublang(lang): # Function to return any available accents of the language when provided with the language name
    
    # -- Define variables used in function --
    sublang_code = ""
    accents_name = ""
    accents_code = []
    accents_names = []
    pyttsx_code__translation_code = []                                                                                                                  # An important variable that will contain the user-selected pyttsx3 language code and the user-selected google translate code
    User_Input_selected_accent = ""

    sublang_code = available_name_code_dict.get(lang)                                                                                                   # Obtain the segment of the code that is uniform for the particular language, referred to as uniform language code

    for x in pyttsx_original_code:                                                                                                                      # Extract all other available accents with the same language
        if sublang_code[0:2] != "zh" and sublang_code == x[0:2] and x not in accents_code:                                                              # Extraction for non-chinese language codes by matching the uniform language code, while making sure that there are no duplicates
            accents_code.append(x)
        elif x not in accents_code and sublang_code == x[0:2]+"-"+x[3:].lower():                                                                        # Extraction for chinese language codes by matching a special format code, unique only to chinese language (caused by simplified and traditional chinese)
            accents_code.append(x)

    for x in accents_code:                                                                                                                              # Obtaining the language name for each accent code, to be printed to the user in a neat format
        if x[0:2] != "zh":
            accents_name = translation_languages[translation_codes.index(x[0:2])].capitalize() + " ({})".format(x[3:].upper())
        else:
            accents_name = lang
        if accents_name not in accents_names:                                                                                                           # Prevent duplicates
            accents_names.append(accents_name)

    if len(accents_names) > 1:                                                                                                                          # To enable the user to choose between accents if multiple available accents are found, else to auto-select the only one accent available for that language 
        print("Supported Language Accents Found!")

        for x in accents_names:                                                                                                                         # Printing the name of available accents, separated by a comma
            if x == accents_names[-1]:
                print(x, end="\n")
            else:
                print(x, end=", ")
        
        while True:                                                                                                                                     # Input validation for user's selection of the name of the accent
            print("Please Select Your Language Accent. Selection is case sensitive. Please type in full or copy the name of the accent directly.")
            User_Input_selected_accent = str(input("Answer: "))
            if User_Input_selected_accent in accents_names:
                break
            else:
                print("Invalid Input Detected. Please Retry.")
                pass
        
        pyttsx_code__translation_code.append(accents_code[accents_names.index(User_Input_selected_accent)])                                             # Adding the user-selected pyttxs3 code into the variable that is to be returned   

        pyttsx_code__translation_code.append(convert_pyttsx3_code_to_google_trans_code(pyttsx_code__translation_code[0]))                               # Adding the derived google translate code into the variable that is to be returned

    else:
        print("Selected Language: {}".format(accents_names[0]))                                                                                         # Show user the auto-selected accent, as there is only one available
        
        pyttsx_code__translation_code.append(accents_code[0])                                                                                           # Adding the auto-selected pyttxs3 code into the variable that is to be returned
        
        pyttsx_code__translation_code.append(convert_pyttsx3_code_to_google_trans_code(pyttsx_code__translation_code[0]))                               # Adding the derived google translate code into the variable that is to be returned
    
    return pyttsx_code__translation_code                                                                                                                # Returns the codes that are to be used in other functions, such as translation and voice type when speaking

# --- print deafult settings to see if user wants to change them ---
print("Default Language Used: English (GB)")
print("Current Voice Properties:")
print("Volume: {}".format(engine.getProperty('volume')))
print("Rate (Word Per Minute): {}".format(engine.getProperty('rate')))
print("Voice Name: {}".format(pyttxs_get_voice_name()))
print("Initialised. Do you need to change voice properties?")

speak('Initialised. Do you need to change voice properties?')                              # play audio of the same question to let user decide if voice and language suited to their preferences



while True:                                                                                # Input validation for asking user whether to change voice properties
    if not_first == False:                                                                  # prevent repeat of second question
        User_Input_Change_Voice_Properties = input("Answer (y/n): ")                       # ask user if they want to change voice properties
    if User_Input_Change_Voice_Properties == "y":
        while True:                                                                        # Input validation for asking user what property to change 
            print("Change one of the following: (volume/rate/voice and language)")         # ask user what voice property to change
            adjustProperty = str(input("Answer: "))

            # ---asking the user to change the selected property to what value---
            if adjustProperty == "volume":
                while True:
                    print("Volume determines how long the voice is.")
                    print("Min Volume: 0.0")
                    print("Max Volume: 1.0")
                    print("Enter a number with one decimal place between 0.0 and 1.0. Change volume to?")
                    adjustValue = input("Answer: ")
                    try:
                        checkVal = float(adjustValue)
                        if float(checkVal) > 0 and float(checkVal) < 1:
                            break
                        else:
                            print("Input out of range. Please Renter")
                    except:
                        print("Invalid Input. Please Renter")
                break

            elif adjustProperty == "rate":
                while True:
                    print("Rate determines word per minute spoken by the voice.")
                    print("Min Rate: 50")
                    print("Max Rate: 300")
                    print("Enter an integer between 50 and 300. Change rate to?")
                    adjustValue = input("Answer: ")
                    try:
                        checkVal = int(adjustValue)
                        if checkVal == int(adjustValue) and checkVal > 50 and checkVal < 300:
                            break
                        else:
                            print("Invalid Input. Please Renter")
                    except:
                        print("Invalid Input. Please Reenter")
                        
                break

            elif adjustProperty == "voice and language":
                adjustProperty = "voice"

                # ---obtaining all the available language codes for both modules and turning them into lists---
                for voice in voices:
                    pyttsx_original_code.append(voice.languages[0])
                
                translation_codes = list(google_translate_lang_dict.keys())
                translation_languages = list(google_translate_lang_dict.values())

                for x in pyttsx_original_code:                                              # convert pyttsx language code to google translate language code
                    if x[0:2] != "zh":                                                      
                        x = x[0:2]
                    else:
                        x = x[0:2] + "-" + x[3:].lower()                                    # exception for chinese code, which has simplified and traditional under same language, different converting method

                    if x in translation_codes and x not in available_lang_code:             # prevent duplicates for languages with more than 1 accents
                        available_lang_code.append(x)

                for x in available_lang_code:                                                               # obtain list of languages with a full name, to display to user, for the sake of user friendliness.
                    if x in translation_codes:
                        language = translation_languages[translation_codes.index(x)].capitalize()           # extract full language name from key of available language code and capitalise it
                        if language not in available_lang_name:                                             # prevent duplicates for languages with more than 1 accents
                            available_lang_name.append(language)
                
                for x in available_lang_name:                                                               # Creating a dictionary to sort language names alphabetically with language codes as the same order, as the language name may not be the same as letters of language code
                    available_name_code_dict[x] = available_lang_code[available_lang_name.index(x)]
                
                available_lang_name = sorted(available_lang_name)                                           # Sorting the name
                available_lang_code = []                                                                    # Resetting the language code array to store the new order
                for x in available_lang_name:                                                               # Retrieve code from dictionary to maintain index of code and language name
                    available_lang_code.append(available_name_code_dict.get(x))
            

                print("Languages Supported: ", end = "")                                                    # set up printing of languages to display to user

                for x in available_lang_name:                                                               # printing full language names without new lines, separated by comma, except for the last language name
                    if x != available_lang_name[-1]:
                        print(x, end=", ")
                    else:
                        print(x)
                
                while True:                                                                                 # Input Validation for language selection
                    print("Please Select Your Language. Selection is case sensitive. Please type in full or copy the name of the accent directly.")
                    Selected_Lang = str(input("Answer: "))
                    if Selected_Lang not in available_lang_name:
                        print("Invalid Input Detected. Please Retry.")
                        pass
                    else:
                        break
                
                pyttsx_code__translation_code = sublang(Selected_Lang)                                      # Obtain the required codes for pyttsx3 and google trans code
                translation_code = pyttsx_code__translation_code[1]                                         # Extract the google translate code from the list
                
                for voice in voices:                                                                        # Print out all available pyttsx3 voices that supports a particular language, based on user's previous choice
                    if pyttsx_code__translation_code[0] in voice.languages:
                        supported_voice_language.append(voice.name)
                        print("\n")
                        print("Voice Name: %s" % voice.name)
                        print(" -  Gender: %s" % voice.gender)
                        print(" -     Age: %s" % voice.age)
                
                while True:                                                                                 # Input Validation for voice selection
                    print("Please Enter Name of Selected Voice. Selection is case sensitive. Please type in full or copy the name of the accent directly")
                    voice_name_request = input("Answer: ")
                    if voice_name_request not in supported_voice_language:
                        print("Invalid Input Detected. Please Retry.")
                        pass
                    else:
                        break

                for voice in voices:                                                                        # Extract relevant voice id using name of voice
                    if voice.name == voice_name_request:
                        adjustValue = voice.id
                        break
                break
            else:
                print("Invalid Input Detected. Please enter an input shown in brackets.")
                pass
        
        engine.setProperty(adjustProperty, adjustValue)                                                     # Tell engine to adjust the selected property with the selected value
        if adjustProperty == "voice":
            for voice in voices:
                if adjustValue == voice.id:
                    adjustValue = voice.name
        print("Changing {} to {}.".format(adjustProperty, adjustValue))                                     # Alert user what property has been changed to what value
        engine.runAndWait()                                                                                 # Let engine execute changing operation
        
        # --- Print new voice properties ---
        print("Current Voice Properties:")
        print("Volume: {}".format(engine.getProperty('volume')))
        print("Rate (Word Per Minute): {}".format(engine.getProperty('rate')))
        print("Voice Name: {}".format(pyttxs_get_voice_name()))
        speak(translate("This is a test",translation_code))                                                 # Let user hear the new voice after property is changed
        
        
        while True:                                                                                         # Input Validation for asking if user wants to continue with customisation
            print("Continue with customisation? (y/n)")
            User_Input_Continue_Customisation = input("Answer: ")
            if User_Input_Continue_Customisation == "y":   
                not_first = True                              
                break
            elif User_Input_Continue_Customisation == "n":
                break
            else:
                print("Invalid Input Detected. Please enter an input shown in brackets.")
                pass
        
        if User_Input_Continue_Customisation == "n":                                                        
            break

    elif User_Input_Change_Voice_Properties == "n":
        break

    else:
        print("Invalid Input Detected. Please enter an input shown in brackets.")
        pass


while True:                                                                                                 # Let the program speak about whatever label is detected by the machine learning
    speak(translate(gather_obj_description("!!!!!"),translation_code)) #replace "!!!!!" with variable that gives detected label name
    print("iteration done") #delete this later