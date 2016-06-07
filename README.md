# HUD
A Simple HUD for iOS 8 and up, Support screen rotation.
![image](https://raw.githubusercontent.com/Chakery/HUD/master/HUDExample/gif.gif)

# Installation

```
platform :ios, '8.0'
use_frameworks!

pod 'HUD', '~>1.2.1'
```

# Using

```
// show
HUD.show(.Loading, text: "Loading")
HUD.show(.Success, text: "Success")
HUD.show(.Error, text: "Error")
HUD.show(.Info, text: "Warning")
HUD.show(.None, text: "Text")


// timed dismiss
HUD.show(.Loading, text: "Loading", time: 3) { _ in
    print("Loading completed")
}
HUD.show(.Success, text: "success", time: 3) { _ in
    print("Success completed")
}
HUD.show(.Error, text: "error", time: 3) { _ in
    print("Error completed")
}
HUD.show(.Info, text: "Warning", time: 3) { _ in
    print("Warning completed")
}
HUD.show(.None, text: "Text", time: 3) { _ in
    print("Text completed")
}


// dismiss
HUD.dismiss()
```

# License
Source code is distributed under MIT license.
