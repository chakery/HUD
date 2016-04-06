# HUD
A Simple HUD for iOS 8 and up

<img src="https://raw.githubusercontent.com/Chakery/HUD/master/images/loading.png" width="150px" />
<img src="https://raw.githubusercontent.com/Chakery/HUD/master/images/success.png" width="150px" />
<img src="https://raw.githubusercontent.com/Chakery/HUD/master/images/error.png" width="150px" />
<img src="https://raw.githubusercontent.com/Chakery/HUD/master/images/info.png" width="150px" />
<img src="https://raw.githubusercontent.com/Chakery/HUD/master/images/text.png" width="150px" />

# Installation

```
pod 'HUD'
```

# Using

```
// show
HUD.show(.loading, text: "Loading...")
HUD.show(.success, text: "Success")
HUD.show(.none, text: "Text...")

// timed dismiss
HUD.show(.loading, text: "Loading...", time: 3) { _ in
            print("Loading completed")
        }


// dismiss
HUD.dismiss()
```

# License
Source code is distributed under MIT license.