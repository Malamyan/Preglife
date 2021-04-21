# PreglifeTask

To run the project please follow these instructions:

``` console
cd PreglifeTask
pod install
```
Open the `PreglifeTask.xcworkspace` file to run.

For image caching [SDWebImage](https://github.com/SDWebImage/SDWebImage) is used. It's really a fast and reliable library. The work is done by extending UIImageView class.

The main architecture of the app is **MVVM**.
Also used **dependency injection**, **delegation** and **singleton patterns**.
Data caching is done by using **CoreData**.
JSON decoding is done by using **Decodable** protocol.
