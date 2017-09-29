# HUD
A Simple HUD for iOS 8 and up, Support screen rotation.
![image](https://raw.githubusercontent.com/Chakery/HUD/master/HUDExample/gif.gif)

# Installation

### Swift3.0+

```
platform :ios, '8.0'
use_frameworks!

pod 'HUD', '~>2.0.1'

# if use Xcode9(Swift4.0)
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.2'
    end
  end
end
```

### Swift2.0
```
pod 'HUD', '1.2.1'
```


# Using

```
import HUD
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
