//
//  GTNotificationView.swift
//  An in app notification banner for Swift.
//
//  Version 0.1
//
//  Created by Mathieu White on 2015-06-20.
//  Copyright (c) 2015 Mathieu White. All rights reserved.
//

import UIKit

/// Identifies the position of the GTNotificationView when presented on the window
enum GTNotificationPosition: UInt
{
    case Top
    case Bottom
}

/// Identifies the animation of the GTNotificationView when presenting
enum GTNotificationAnimation: UInt
{
    case Fade
    case Slide
}

/**
A GTNotification object specifies the properties of the 
notification to display on the GTNotificationView.
*/
class GTNotification: NSObject
{
    /// The title of the notification
    var title: String = "Sample Notification"
    
    /// The message of the notification
    var message: String = "This is a sample notification."
    
    /// The color of the GTNotificationView. If blurEnabled is true, the color will be ignored. The default color is white
    var color: UIColor = UIColor.whiteColor()
    
    /// True if the GTNotificationView should blur the content it convers, false otherwise. The default value is false
    var blurEnabled: Bool = false {
        didSet {
            if (self.blurEnabled == true)
            {
                self.blurEffectStyle = UIBlurEffectStyle.Light
            }
        }
    }
    
    /// The blur effect style of the GTNotificationView when blurEnabled is true. The default value is Light.
    var blurEffectStyle: UIBlurEffectStyle?
    
    /// The duration the GTNotificationView should be displayed for. The default duration is 3 seconds
    var duration: NSTimeInterval = 3.0
    
    /// The position of the GTNotificationView when presented on the window. The default position is Top
    var position: GTNotificationPosition = GTNotificationPosition.Top
    
    /// The animation of the GTNotificationView when presented. The default animation is Fade
    var animation: GTNotificationAnimation = GTNotificationAnimation.Fade
    
    /// The action to be performed when the GTNotificationView is dismissed
    var action: Selector?
    
    /// The target object to which the action message is sent
    var target: AnyObject?
    
    /**
    Adds a target and action for a particular event to an interal dispatch table.
    
    :param: target the target object to which the action message is sent
    :param: action a selector identifying an action message
    */
    func addTarget(target: AnyObject, action: Selector)
    {
        self.target = target
        self.action = action
    }
}

/**
A GTNotificationView object specifies a GTNotification that can be
displayed in the app on the key window.
*/
class GTNotificationView: UIView
{
    // MARK: - Variables
    
    /// The singleton instance of the GTNotificationView
    static var sharedInstance: GTNotificationView = GTNotificationView()
    
    /// Identifies if the GTNotificationView is visible or not
    var isVisible: Bool = false
    
    /// The title label of the GTNotificationView
    weak var titleLabel: UILabel?
    
    /// The message label of the GTNotificationView
    weak var messageLabel: UILabel?
    
    /// The height of the GTNotificationView
    private var notificationViewHeight: CGFloat?
    
    /// The private array of notifications queued for display
    private var mutableNotifications: [GTNotification] = []
    
    /// The current notification being displayed
    private var currentNotification: GTNotification?
    
    /// The visual blur effect for the notification view
    private var blurView: UIVisualEffectView?
    
    /// The top layout constraint of the GTNotificationView
    private var topConstraint: NSLayoutConstraint?
    
    /// The bottom layout constraint of the GTNotificationView
    private var bottomConstraint: NSLayoutConstraint?
    
    /// The tap gesture that fires the action of the notification
    private var tapGesture: UITapGestureRecognizer?
    
    /// The timer that fires the scheduled dismissal of the notification
    private var dismissalTimer: NSTimer?
    
    // MARK: - Read Only
    
    /// The array of notifications queued for display
    internal var notifications: [GTNotification] {
        get {
            let immutableNotifications = self.mutableNotifications
            return immutableNotifications
        }
    }
    
    /// The vertical padding of the GTNotificationView
    internal var verticalPadding: CGFloat {
        get {
            return 20.0
        }
    }
    
    /// The horizontal padding of the GTNotificationView
    internal var horizontalPadding: CGFloat {
        get {
            return 20.0
        }
    }
    
    // MARK: - Initialization
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        self.initNotificationView()
    }
    
    convenience init()
    {
        self.init(frame: CGRectZero)
    }
    
    private func initNotificationView()
    {
        // Set the default properties of the GTNotificationView
        self.backgroundColor = UIColor.clearColor()
        self.alpha = 1.0
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // Initialize the title label for the notification view
        let titleLabel: UILabel = UILabel()
        titleLabel.font = UIFont.systemFontOfSize(18.0)
        titleLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // Initialize the message label for the notification view
        let messageLabel: UILabel = UILabel()
        messageLabel.font = UIFont.systemFontOfSize(14.0)
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        messageLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        // Initialize the tap gesture
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("notificationTapped"))
        self.addGestureRecognizer(tapGesture)
        
        // Add the labels to the notification view
        self.addSubview(titleLabel)
        self.addSubview(messageLabel)
        
        // Set each label to their variable
        self.titleLabel = titleLabel
        self.messageLabel = messageLabel
        self.tapGesture = tapGesture
    }
    
    // MARK: - Auto Layout
    
    /**
    This method will setup the constraints for the notification view.
    */
    private func setupConstraints()
    {
        if (self.blurView != nil)
        {
            // Layout the blur view vertically
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[_blur]|",
                options: NSLayoutFormatOptions(0),
                metrics: nil,
                views: ["_blur" : self.blurView!]))
            
            // Layout the blur view horizontally
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[_blur]|",
                options: NSLayoutFormatOptions(0),
                metrics: nil,
                views: ["_blur" : self.blurView!]))
        }
        
        // Title Label Top
        self.addConstraint(NSLayoutConstraint(item: self.titleLabel!,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Top,
            multiplier: 1.0,
            constant: self.verticalPadding))
        
        // Title Label Left
        self.addConstraint(NSLayoutConstraint(item: self.titleLabel!,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1.0,
            constant: self.horizontalPadding))
        
        // Title Label Right
        self.addConstraint(NSLayoutConstraint(item: self.titleLabel!,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: -self.horizontalPadding))
        
        // Message Label Top
        self.addConstraint(NSLayoutConstraint(item: self.messageLabel!,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.titleLabel!,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1.0,
            constant: 0.0))
        
        // Message Label Left
        self.addConstraint(NSLayoutConstraint(item: self.messageLabel!,
            attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.titleLabel!,
            attribute: NSLayoutAttribute.Left,
            multiplier: 1.0,
            constant: 0.0))
        
        // Message Label Right
        self.addConstraint(NSLayoutConstraint(item: self.messageLabel!,
            attribute: NSLayoutAttribute.Right,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.titleLabel!,
            attribute: NSLayoutAttribute.Right,
            multiplier: 1.0,
            constant: 0.0))
        
        // Message Label Bottom
        self.addConstraint(NSLayoutConstraint(item: self.messageLabel!,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1.0,
            constant: -self.verticalPadding))
    }
    
    /**
    This method will layout the notification view and add it to the key window of the application.
    */
    private func layoutNotificationViewInWindow()
    {
        // Get a reference of the application window
        var window: UIWindow? = UIApplication.sharedApplication().keyWindow
        
        // The application has a key window
        if let window = window
        {
            // Add the notification view to the window
            window.addSubview(self)
            
            // Calculate the height of the notification view
            self.notificationViewHeight = self.heightForNoticationView()
            
            // Views Dictionary
            var viewsDict: [NSObject : AnyObject] = [NSObject : AnyObject]()
            viewsDict["_view"] = self

            // Metrics Dictionary
            var metricsDict: [NSObject : AnyObject] = [NSObject : AnyObject]()
            metricsDict["_h"] = self.notificationViewHeight
            
            // Notification View Width
            let notificationHorizontalConstraints: [AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("H:|[_view]|",
                options: NSLayoutFormatOptions(0),
                metrics: metricsDict,
                views: viewsDict)
            
            // Notification View Height
            let notificationVerticalConstraints: [AnyObject] = NSLayoutConstraint.constraintsWithVisualFormat("V:[_view(_h)]",
                options: NSLayoutFormatOptions(0),
                metrics: metricsDict,
                views: viewsDict)
            
            // Notification View Top
            if (self.currentNotification?.position == GTNotificationPosition.Top)
            {
                var topConstant: CGFloat = 0.0

                if (self.currentNotification!.animation == GTNotificationAnimation.Slide)
                {
                    topConstant = -self.notificationViewHeight!
                }
                
                let topConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self,
                    attribute: NSLayoutAttribute.Top,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: window,
                    attribute: NSLayoutAttribute.Top,
                    multiplier: 1.0,
                    constant: topConstant)
                
                window.addConstraint(topConstraint)
                self.topConstraint = topConstraint
            }
            
            // Notification View Bottom
            if (self.currentNotification?.position == GTNotificationPosition.Bottom)
            {
                var bottomConstant: CGFloat = 0.0
                
                if (self.currentNotification!.animation == GTNotificationAnimation.Slide)
                {
                    bottomConstant = self.notificationViewHeight!
                }
                
                let bottomConstraint: NSLayoutConstraint = NSLayoutConstraint(item: self,
                    attribute: NSLayoutAttribute.Bottom,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: window,
                    attribute: NSLayoutAttribute.Bottom,
                    multiplier: 1.0,
                    constant: bottomConstant)
                
                window.addConstraint(bottomConstraint)
                self.bottomConstraint = bottomConstraint
            }
            
            // Add the constraints to the window
            window.addConstraints(notificationVerticalConstraints)
            window.addConstraints(notificationHorizontalConstraints)
            
            // Layout the notification view
            self.layoutIfNeeded()
            self.titleLabel?.layoutIfNeeded()
            self.messageLabel?.layoutIfNeeded()
        }
        else
        {
            // No key window found
            assertionFailure("Warning: make sure to call makeKeyAndVisible on the application's window.")
        }
    }
    
    // MARK: - Instance Methods
    
    /**
    This method shows the notification on the application's window.
    
    :param: notification the notification to display
    */
    func showNotification(notification: GTNotification)
    {
        // Only show one notification at a time
        if (self.currentNotification == nil)
        {
            // Set the current notification
            self.currentNotification = notification
            
            // Prepare the view for the notification to display
            self.prepareViewForNotification(notification)
            
            // Animate the notification
            self.animateNotification(notification, willShow: true, completion: {(finished: Bool) -> Void in
                
                self.isVisible = true
                
                // Schedule the notification view's dismissal
                self.dismissalTimer = NSTimer.scheduledTimerWithTimeInterval(notification.duration,
                    target: self,
                    selector: Selector("dismissCurrentNotification"),
                    userInfo: nil,
                    repeats: false)
                
            })
        }
    }
    
    /**
    This method dismissed the current notification on the application's window.
    */
    func dismissCurrentNotification()
    {
        self.dismissalTimer?.invalidate()
        self.dismissalTimer = nil
        
        if let notification = self.currentNotification
        {
            self.animateNotification(notification, willShow: false, completion: {(finished: Bool) -> Void in
                
                self.removeFromSuperview()
                self.blurView?.removeFromSuperview()
                self.blurView = nil
                self.currentNotification = nil
                self.topConstraint = nil
                self.bottomConstraint = nil
                self.isVisible = false
                
            })
        }
    }
    
    /**
    This method calculates and returns the height for the notification view.
    
    :returns: the height of the notification view
    */
    func heightForNoticationView() -> CGFloat
    {
        // Determine the maximum with of our labels
        let maximumLabelWidth: CGFloat = CGRectGetWidth(UIScreen.mainScreen().bounds) - (self.horizontalPadding * 2.0)
        
        // Initialize our maximum label size
        let maximumLabelSize: CGSize = CGSizeMake(maximumLabelWidth, CGFloat.max)
        
        // Get the height of the title label
        let titleLabelHeight: CGFloat = (self.titleLabel!.text! as NSString).boundingRectWithSize(maximumLabelSize,
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName : self.titleLabel!.font],
            context: nil).height
        
        // Get the height of the message label
        let messageLabelHeight: CGFloat = (self.messageLabel!.text! as NSString).boundingRectWithSize(maximumLabelSize,
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName : self.messageLabel!.font],
            context: nil).height
        
        // Return the total height
        return self.verticalPadding * 3.0 + titleLabelHeight + messageLabelHeight
    }
    
    /**
    This method applies the notification view's visual attributes.
    
    :param: notification the notification that will be displayed
    */
    private func prepareViewForNotification(notification: GTNotification)
    {
        self.titleLabel?.text = notification.title
        self.messageLabel?.text = notification.message
        
        if (notification.blurEnabled == true)
        {
            self.backgroundColor = UIColor.clearColor()
            
            // Add the blur effect to the notification view
            let blurEffect: UIBlurEffect = UIBlurEffect(style: notification.blurEffectStyle!)
            let blurView: UIVisualEffectView = UIVisualEffectView(effect: blurEffect)
            blurView.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.insertSubview(blurView, atIndex: 0)
            self.blurView = blurView
        }
        else
        {
            self.backgroundColor = notification.color
        }
        
        // Set the initial alpha to 0.0 for the fade animation
        if (notification.animation == GTNotificationAnimation.Fade)
        {
            self.alpha = 0.0
        }
        else
        {
            self.alpha = 1.0
        }
        
        // Layout the view's subviews
        self.setupConstraints()
        
        // Layout the view in the window
        self.layoutNotificationViewInWindow()
    }
    
    /**
    This method animates the notification view on the application's window
    
    :param: notification the notification object that will be displayed
    :param: dismiss      true if the notification view will dismiss, false otherwise
    :param: completion   the completion closure to execute after the animation
    */
    private func animateNotification(notification: GTNotification, willShow show: Bool, completion: (finished: Bool) -> Void)
    {
        // The notification view should animate with a fade
        if (notification.animation == GTNotificationAnimation.Fade)
        {
            UIView.animateWithDuration(0.4,
                animations: {
                    self.alpha = (show == true) ? 1.0 : 0.0
                },
                completion: { (finished) -> Void in
                    completion(finished: finished)
            })
        }
        
        // The notification view should animate with a slide
        if (notification.animation == GTNotificationAnimation.Slide)
        {
            if (notification.position == GTNotificationPosition.Top)
            {
                self.topConstraint?.constant = (show == true) ? 0.0 : -self.notificationViewHeight!
            }
            else
            {
                self.bottomConstraint?.constant = (show == true) ? 0.0 : self.notificationViewHeight!
            }
            
            UIView.animateWithDuration(0.4,
                animations: {
                    self.layoutIfNeeded()
                },
                completion: {(finished) -> Void in
                    completion(finished: finished)
            })
        }
    }
    
    // MARK: - Gesture Recognizer Methods
    
    /**
    This method fires when the notification view is tapped. 
    
    NOTE: Tapping the notification view will dismiss it immediately.
    */
    @objc private func notificationTapped()
    {
        if let notifcation = self.currentNotification
        {
            self.dismissCurrentNotification()
            
            if
                let target: AnyObject = notifcation.target,
                let action = notifcation.action
            {
                if (target.respondsToSelector(action) == true)
                {
                    dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), {
                        NSThread.detachNewThreadSelector(action, toTarget: target, withObject: nil)
                    })
                }
            }
        }
    }
}
