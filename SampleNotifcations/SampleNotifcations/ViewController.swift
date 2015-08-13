//
//  ViewController.swift
//  SampleNotifcations
//
//  Created by Mathieu White on 2015-06-21.
//  Copyright (c) 2015 Mathieu White. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GTNotificationDelegate
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        // Notification Button
        let button: UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        button.setTitle("Show Notification", forState: UIControlState.Normal)
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        button.addTarget(self, action: Selector("notificationButtonPressed"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(button)
        
        // Center the button vertically
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[_super]-(<=1)-[_btn]",
            options: NSLayoutFormatOptions.AlignAllCenterY,
            metrics: nil,
            views: ["_super" : self.view, "_btn" : button]))
        
        // Center the button horizontally
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[_super]-(<=1)-[_btn]",
            options: NSLayoutFormatOptions.AlignAllCenterX,
            metrics: nil,
            views: ["_super" : self.view, "_btn" : button]))
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func notificationButtonPressed()
    {
        // Initialize a notification
        let notification: GTNotification = GTNotification()
        notification.image = UIImage(named: "notification")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        notification.blurEnabled = true
        notification.blurEffectStyle = UIBlurEffectStyle.Dark
        notification.tintColor = UIColor.whiteColor()
        notification.animation = GTNotificationAnimation.Slide
        notification.delegate = self
        
        // Add a selector to perform on tap
        notification.addTarget(self, action: Selector("dismissNotification"))
        
        // Show the notification
        GTNotificationManager.sharedInstance.showNotification(notification)
    }
    
    func dismissNotification()
    {
        NSLog("The notification was dismissed manually")
        
        let alertController: UIAlertController = UIAlertController(title: "",
            message: "Thank you for checking out GTNotification.",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        let dismissAction: UIAlertAction = UIAlertAction(title: "Dismiss",
            style: UIAlertActionStyle.Default) { (alert) -> Void in
                alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(dismissAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
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
    
}
