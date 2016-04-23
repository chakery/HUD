//
//  HUD.swift
//  HUD
//
//  Created by Chakery on 16/4/6.
//  Copyright © 2016年 Chakery. All rights reserved.
//

import UIKit

public enum HUDType {
    case Loading
    case Success
    case Error
    case Info
    case None
}

public extension HUD {
    public class func show(type: HUDType, text: String, time: NSTimeInterval? = nil, completion: (Void -> Void)? = nil) {
        instance.removeDeviceOrientationNotification()
        instance.registerDeviceOrientationNotification()
        var isNone: Bool = false
        let window = UIWindow()
        window.backgroundColor = UIColor.clearColor()
        let mainView = UIView()
        mainView.layer.cornerRadius = 10
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.7)
        
        var image = UIImage()
        var headView = UIView()
        
        switch type {
        case .Success:
            image = imageOfCheckmark
        case .Error:
            image = imageOfCross
        case .Info:
            image = imageOfInfo
        default:
            break
        }
        
        switch type {
        case .Loading:
            headView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
            (headView as! UIActivityIndicatorView).startAnimating()
            headView.translatesAutoresizingMaskIntoConstraints = false
            mainView.addSubview(headView)
        case .Success:
            fallthrough
        case .Error:
            fallthrough
        case .Info:
            headView = UIImageView(image: image)
            headView.translatesAutoresizingMaskIntoConstraints = false
            mainView.addSubview(headView)
        case .None:
            isNone = true
        }
        
        // label
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.font = UIFont.systemFontOfSize(13)
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(label)
        
        var height: CGFloat = 0
        if isNone {
            height = label.frame.height + 30
        } else {
            height = label.frame.height + 70
        }
        let superFrame = CGRectMake(0, 0, label.frame.width + 50, height)
        window.frame = superFrame
        mainView.frame = superFrame
        
        // image
        if !isNone {
            mainView.addConstraint( NSLayoutConstraint(item: headView, attribute: .CenterY, relatedBy: .Equal, toItem: mainView, attribute: .CenterY, multiplier: 0.6, constant: 0) )
            mainView.addConstraint( NSLayoutConstraint(item: headView, attribute: .CenterX, relatedBy: .Equal, toItem: mainView, attribute: .CenterX, multiplier: 1.0, constant: 0) )
            mainView.addConstraint( NSLayoutConstraint(item: headView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 36) )
            mainView.addConstraint( NSLayoutConstraint(item: headView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 36) )
        }
        // label
        var mainViewMultiplier: CGFloat = 0
        if isNone {
            mainViewMultiplier = 1.0
        } else {
            mainViewMultiplier = 1.5
        }
        mainView.addConstraint( NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: mainView, attribute: .CenterY, multiplier: mainViewMultiplier, constant: 0) )
        mainView.addConstraint( NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: mainView, attribute: .CenterX, multiplier: 1.0, constant: 0) )
        mainView.addConstraint( NSLayoutConstraint(item: label, attribute: .Width, relatedBy: .GreaterThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 90) )
        mainView.addConstraint( NSLayoutConstraint(item: label, attribute: .Height, relatedBy: .GreaterThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0) )
        
        window.windowLevel = UIWindowLevelAlert
        window.center = getCenter()
        window.hidden = false
        window.addSubview(mainView)
        windowTemp = window
        
        delayDismiss(time, completion: completion)
    }
    
    public class func dismiss() {
        instance.removeDeviceOrientationNotification()
        let _ = windowTemp?.subviews.map {
            $0.removeFromSuperview()
        }
        windowTemp?.removeFromSuperview()
        windowTemp = nil
    }
}

public class HUD: NSObject {
    private static var windowTemp: UIWindow?
    private static let instance: HUD = HUD()
    private struct Cache {
        static var imageOfCheckmark: UIImage?
        static var imageOfCross: UIImage?
        static var imageOfInfo: UIImage?
    }
    
    // center
    private class func getCenter() -> CGPoint {
        let rv = UIApplication.sharedApplication().keyWindow?.subviews.first as UIView!
        if rv.bounds.width > rv.bounds.height {
            return CGPoint(x: rv.bounds.height/2, y: rv.bounds.width/2)
        }
        return rv.center
    }
    
    // delay dismiss
    private class func delayDismiss(time: NSTimeInterval?, completion: (Void->Void)?) {
        guard let time = time else { return }
        guard time > 0 else { return }
        let time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)))
        dispatch_after(time_t, dispatch_get_main_queue()) {
            dismiss()
            completion?()
        }
    }
    
    // register notification
    private func registerDeviceOrientationNotification() {
        NSNotificationCenter.defaultCenter().addObserver(HUD.instance, selector: #selector(HUD.transformWindow(_:)), name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    // remove notification
    private func removeDeviceOrientationNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(HUD.instance)
    }
    
    // transform
    @objc private func transformWindow(notification: NSNotification) {
        var rotation: CGFloat = 0
        switch UIDevice.currentDevice().orientation {
        case .Portrait:
            rotation = 0
        case .PortraitUpsideDown:
            rotation = CGFloat(M_PI)
        case .LandscapeLeft:
            rotation = CGFloat(M_PI/2)
        case .LandscapeRight:
            rotation = CGFloat(M_PI + (M_PI/2))
        default:
            break
        }
        HUD.windowTemp?.center = HUD.getCenter()
        HUD.windowTemp?.transform = CGAffineTransformMakeRotation(rotation)
    }
    
    // draw
    private class func draw(type: HUDType) {
        let checkmarkShapePath = UIBezierPath()
        
        // draw circle
        checkmarkShapePath.moveToPoint(CGPointMake(36, 18))
        checkmarkShapePath.addArcWithCenter(CGPointMake(18, 18), radius: 17.5, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: true)
        checkmarkShapePath.closePath()
        
        switch type {
        case .Success: // draw checkmark
            checkmarkShapePath.moveToPoint(CGPointMake(10, 18))
            checkmarkShapePath.addLineToPoint(CGPointMake(16, 24))
            checkmarkShapePath.addLineToPoint(CGPointMake(27, 13))
            checkmarkShapePath.moveToPoint(CGPointMake(10, 18))
            checkmarkShapePath.closePath()
        case .Error: // draw X
            checkmarkShapePath.moveToPoint(CGPointMake(10, 10))
            checkmarkShapePath.addLineToPoint(CGPointMake(26, 26))
            checkmarkShapePath.moveToPoint(CGPointMake(10, 26))
            checkmarkShapePath.addLineToPoint(CGPointMake(26, 10))
            checkmarkShapePath.moveToPoint(CGPointMake(10, 10))
            checkmarkShapePath.closePath()
        case .Info:
            checkmarkShapePath.moveToPoint(CGPointMake(18, 6))
            checkmarkShapePath.addLineToPoint(CGPointMake(18, 22))
            checkmarkShapePath.moveToPoint(CGPointMake(18, 6))
            checkmarkShapePath.closePath()
            
            UIColor.whiteColor().setStroke()
            checkmarkShapePath.stroke()
            
            let checkmarkShapePath = UIBezierPath()
            checkmarkShapePath.moveToPoint(CGPointMake(18, 27))
            checkmarkShapePath.addArcWithCenter(CGPointMake(18, 27), radius: 1, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: true)
            checkmarkShapePath.closePath()
            
            UIColor.whiteColor().setFill()
            checkmarkShapePath.fill()
        default: break
        }
        
        UIColor.whiteColor().setStroke()
        checkmarkShapePath.stroke()
    }
    private class var imageOfCheckmark: UIImage {
        if (Cache.imageOfCheckmark != nil) {
            return Cache.imageOfCheckmark!
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), false, 0)
        
        HUD.draw(.Success)
        
        Cache.imageOfCheckmark = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCheckmark!
    }
    private class var imageOfCross: UIImage {
        if (Cache.imageOfCross != nil) {
            return Cache.imageOfCross!
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), false, 0)
        
        HUD.draw(.Error)
        
        Cache.imageOfCross = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCross!
    }
    private class var imageOfInfo: UIImage {
        if (Cache.imageOfInfo != nil) {
            return Cache.imageOfInfo!
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), false, 0)
        
        HUD.draw(.Info)
        
        Cache.imageOfInfo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfInfo!
    }
}
