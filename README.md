# ObjectRecognizer

Sends images using the Microsoft Vision API and parses the returned JSON and displays the top ranked suggestion.


## How to use
1) If you want to try out this app, you first have to register and subscribe to the Microsoft Computer vision api at https://rapidapi.com/microsoft-azure/api/microsoft-computer-vision (it is free). You then will have to clone/download the repo and create a swift file called Key.swift and put this into it:

class Key {
    let configKey = ["X-RapidAPI-Key":"API_KEY"]
}

2) Replace API_KEY with the api key from rapidapi.com
3) You can now compile and run the application.
