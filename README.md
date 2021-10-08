# BlobStar ✨

iOS application to automagically control the device torch/flash and capture photos.

The software was quickly drafted to monitor some [Physarum Polycephalum](https://en.wikipedia.org/wiki/Physarum_polycephalum) evolution during the [Mission Alpha](https://missionalpha.cnes.fr/) assignment [#EleveTonBlob](https://disciplines.ac-toulouse.fr/daac/elevetonblob-lexperience-educative-du-cnes-pour-la-mission-alpha).
This custom project was developed by a volunteer parent to help a primary school in French Jura, not so far away from where the first [Comté](https://france3-regions.francetvinfo.fr/bourgogne-franche-comte/jura/espace-thomas-pesquet-savoure-du-comte-1207393.html) 🧀 to the ISS was produced.

Photos are stored in the device Photo Library and are meant to be aggregated in a single movie file later, using [FFmpeg](https://www.ffmpeg.org/) for example.

The name is a word play on "blob", the other name The French 🇫🇷 give to the Physarum Polycephalum, and The B-52's track [Rock Lobster](https://www.youtube.com/watch?v=n4QSYx4wVQg) 🦞

## Features

* Take photo every 1 to 60 minutes
* Turn on then off device torch to take a photo
* Control device flash mode
* Store device location to photo EXIF data
* Store photos to Photo Library
* Persistent user settings
* Prevent device from sleeping when app is active

## Privacy settings 🔒

The app needs to access some Privacy sensitive features, such as:

| Privacy | Permission | Required | Usage |
|-|-|:-:|-|
| Camera        | Access the Camera          | ✅ | Preview and capture photos
| Location      | Allow While Using App      | ❌ | Store device location in photo EXIF data
| Photo Library | Allow Access to All Photos | ✅ | Store photo in the device library

Location and Camera permissions are requested at the app first launch.

Photo Library permission is requested during the first photo capture.
You can press the Camera 📷 button to trigger the authorization first.

The app raises a `fatalError()` when it can't access the camera 🐞 and no photo is saved when it can't access the Photo Library.
This is by ~~poor~~ design because of rushed deadlines, and Privacy controls can later be fixed in the BlobStar section of the Settings app.

Once Privacy settings are in order, it might be a good idea to [quit and reopen](https://support.apple.com/guide/iphone/quit-and-reopen-an-app-iph83bfec492/ios) the app...

## Build

The app was developed with [Xcode](https://developer.apple.com/xcode/) version 13 and tested on recent devices running iOS version 15.

It is trivial to build and run the app on any device, as long as you deal with the [Signing](https://developer.apple.com/support/code-signing/) requirements.
Anyone with a Mac and registered as a free [Developer](https://developer.apple.com/) can install Xcode to build and install apps, with just a few limitations such as the provisioning profile expiration period.

The project source code is provided as is and it's not ok to contact me for support (this file covers pretty much everything you need) or feature requests beyond the scope of the mission.
Responsible pull requests and forks are welcome.

## Preview

A picture is worth a thousand words, so here you have a Simulator screen shot:

![BlobStar Simulator Preview](./Resources/Simulator.jpg)

## Acknowledgments

Many thanks to the wonderful pilots, doctors, engineers, _etc._ who turn the Space discovery dream into a reality.
I am so glad you are sharing your research with all the kids down here 🌍

Also, I am using the mission logo for the app icon without permission, sorry 😅
