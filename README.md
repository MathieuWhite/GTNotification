# GTNotification
An in-app notification banner for Swift.

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
