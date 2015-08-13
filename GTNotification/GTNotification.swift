//
//  GTNotification.swift
//  An in app notification banner for Swift.
//
//  Version 0.1
//
//  Created by Mathieu White on 2015-06-20.
//  Copyright (c) 2015 Mathieu White. All rights reserved.
//

import UIKit

@objc public protocol GTNotificationDelegate: NSObjectProtocol
{
    /**
    Tells the delegate that the notification has been dismissed
    and is no longer visible on the application's window.
    
    :param: notification the notification object that was dismissed
    */
    optional func notificationDidDismiss(notification: GTNotification)
    
    /**
    Asks the delegate for the font that should be used to display
    the title on the notification.
    
    :param: notification the object requesting a font for its title
    
    :returns: the font for the notitifcation's title
    */
    optional func notificationFontForTitleLabel(notification: GTNotification) -> UIFont
    
    /**
    Asks the delegate for the font that should be used to display
    the message on the notification.
    
    :param: notification the object requesting a font for its message
    
    :returns: the font for the notitifcation's message
    */
    optional func notificationFontForMessageLabel(notification: GTNotification) -> UIFont
}

/**
A GTNotification object specifies the properties of the
notification to display on the application's window.
*/
public class GTNotification: NSObject
{
    /// The title of the notification
    public var title: String = "Sample Notification"
    
    /// The message of the notification
    public var message: String = "This is a sample notification."
    
    /// The color of the notifiation background. If blurEnabled is true, the color will be ignored. The default color is white
    public var backgroundColor: UIColor = UIColor.whiteColor()
    
    /// The color of the text and image of the notification. The default value is black
    public var tintColor: UIColor = UIColor.blackColor()
    
    /// The image icon for the notification
    public weak var image: UIImage?
    
    /// True if the notification should blur the content it convers, false otherwise. The default value is false
    var blurEnabled: Bool = false {
        didSet {
            if (self.blurEnabled == true)
            {
                self.blurEffectStyle = UIBlurEffectStyle.Light
            }
        }
    }
    
    /// The blur effect style of the notification when blurEnabled is true. The default value is Light.
    var blurEffectStyle: UIBlurEffectStyle?
    
    /// The duration the notification should be displayed for. The default duration is 3 seconds
    var duration: NSTimeInterval = 3.0
    
    /// The position of the notification when presented on the window. The default position is Top
    var position: GTNotificationPosition = GTNotificationPosition.Top
    
    /// The animation of the notification when presented. The default animation is Fade
    public var animation: GTNotificationAnimation = GTNotificationAnimation.Fade
    
    /// The action to be performed when the notification is dismissed manually
    var action: Selector?
    
    /// The target object to which the action message is sent
    public var target: AnyObject?
    
    /// The delegate of the GTNotification
    public weak var delegate: GTNotificationDelegate?
    
    /**
    Adds a target and action for a particular event to an interal dispatch table.
    
    :param: target the target object to which the action message is sent
    :param: action a selector identifying an action message
    */
    public func addTarget(target: AnyObject, action: Selector)
    {
        self.target = target
        self.action = action
    }
}
