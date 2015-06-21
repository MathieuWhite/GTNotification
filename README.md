# GTNotificationView
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

// Get the notification view and set its view properties
let view: GTNotificationView = GTNotificationView.sharedInstance
view.titleLabel?.textColor = UIColor.whiteColor()
view.messageLabel?.textColor = UIColor.whiteColor()
view.titleLabel?.font = UIFont(name: "AvenirNext-Medium", size: 18.0)
view.messageLabel?.font = UIFont(name: "AvenirNext-Regular", size: 14.0)
        
// Show the notification
view.showNotification(notification)
```

**Screenshots**

*Top Notification*

![Top Notification](https://raw.githubusercontent.com/MathieuWhite/GTNotificationView/master/Screenshots/Top%20Notification.png)

*Bottom Notification*

![Bottom Notification](https://raw.githubusercontent.com/MathieuWhite/GTNotificationView/master/Screenshots/Bottom%20Notification.png)

*Blurred Notification*

![Blurred Notification](https://raw.githubusercontent.com/MathieuWhite/GTNotificationView/master/Screenshots/Blurred%20Notification.png)
