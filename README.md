# GTNotification
An in-app notification banner for Swift.

**Setup with Cocoapods (recommended setup)**

- Add the instructions below to your Podfile:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

pod 'GTNotification', '0.1'
```

- Then add ```import GTNotification``` at the top of your Swift class.

- Finally compile and run and you will be good to go.

**Otherwise you can also manually import the framework**

Just drag and drop ```'GTNotification/*.swift``` file(s) into your Xcode project and do not forget to check the checkbox entitled "Copy items if needed" and the appropriate checkboxe(s) in "Add to targets" section.

**Example**

``` swift
// Initialize a notification
let notification: GTNotification = GTNotification()
notification.title = "Welcome Notification"
notification.message = "Thank you for checking out GTNotificationView."
notification.position = GTNotificationPosition.Top
notification.animation = GTNotificationAnimation.Slide
notification.blurEnabled = true

// Perform a custom selector on tap
notification.addTarget(self, action: Selector("dismissNotification"))

// Set the notification's delegate
notification.delegate = self

// Show the notification
GTNotificationManager.sharedInstance.showNotification(notification)
```

**GTNotificationDelegate Methods**
```swift
// MARK: GTNotificationDelegate Methods
    
func notificationDidDismiss(notification: GTNotification)
{
    // The notification was dismissed automatically
    NSLog("The notification was dismissed automatically")
}
    
func notificationFontForTitleLabel(notification: GTNotification) -> UIFont
{
    return UIFont(name: "AvenirNext-Medium", size: 16.0)!
}
    
func notificationFontForMessageLabel(notification: GTNotification) -> UIFont
{
    return UIFont(name: "AvenirNext-Regular", size: 13.0)!
}
```

**Screenshots**

*Dark Blur*

![Dark Blur Notification](https://raw.githubusercontent.com/MathieuWhite/GTNotification/screenshots/Screenshots/Dark%20Blur.png)

*Light Blur*

![Light Blur Notification](https://raw.githubusercontent.com/MathieuWhite/GTNotification/screenshots/Screenshots/Light%20Blur.png)

*Extra Light Blur*

![Extra Light Blur Notification](https://raw.githubusercontent.com/MathieuWhite/GTNotification/screenshots/Screenshots/Extra%20Light%20Blur.png)

*Solid Color*

![Solid Color Notification](https://raw.githubusercontent.com/MathieuWhite/GTNotification/screenshots/Screenshots/Solid%20Color.png)
