//
//  HUD.swift
//  HUD
//
//  Created by Chakery on 16/4/6.
//  Copyright © 2016年 Chakery. All rights reserved.
//

import UIKit

public enum HUDType {
    case loading
    case success
    case error
    case info
    case none
}

public extension HUD {
    public class func show(type: HUDType, text: String, time: NSTimeInterval? = nil, completion: (Void -> Void)? = nil) {
        dismiss()
        var isNone: Bool = false
        let window = UIWindow()
        window.backgroundColor = UIColor.clearColor()
        let mainView = UIView()
        mainView.layer.cornerRadius = 10
        mainView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha: 0.7)
        
        var image = UIImage()
        var headView = UIView()
        
        switch type {
        case .success:
            image = imageOfCheckmark
        case .error:
            image = imageOfCross
        case .info:
            image = imageOfInfo
        default:
            break
        }
        
        switch type {
        case .loading:
            headView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
            (headView as! UIActivityIndicatorView).startAnimating()
            headView.translatesAutoresizingMaskIntoConstraints = false
            mainView.addSubview(headView)
        case .success:
            fallthrough
        case .error:
            fallthrough
        case .info:
            headView = UIImageView(image: image)
            headView.translatesAutoresizingMaskIntoConstraints = false
            mainView.addSubview(headView)
        case .none:
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
        let _ = windowTemp?.subviews.map {
            $0.removeFromSuperview()
        }
        windowTemp?.removeFromSuperview()
        windowTemp = nil
    }
}

public class HUD: NSObject {
    private static var windowTemp: UIWindow?
    private static let rv = UIApplication.sharedApplication().keyWindow?.subviews.first as UIView!
    private struct Cache {
        static var imageOfCheckmark: UIImage?
        static var imageOfCross: UIImage?
        static var imageOfInfo: UIImage?
    }
    
    // center
    private class func getCenter() -> CGPoint {
        if rv.bounds.width > rv.bounds.height {
            return CGPoint(x: rv.bounds.width/2, y: rv.bounds.height/2)
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
    
    // draw
    private class func draw(type: HUDType) {
        let checkmarkShapePath = UIBezierPath()
        
        // draw circle
        checkmarkShapePath.moveToPoint(CGPointMake(36, 18))
        checkmarkShapePath.addArcWithCenter(CGPointMake(18, 18), radius: 17.5, startAngle: 0, endAngle: CGFloat(M_PI*2), clockwise: true)
        checkmarkShapePath.closePath()
        
        switch type {
        case .success: // draw checkmark
            checkmarkShapePath.moveToPoint(CGPointMake(10, 18))
            checkmarkShapePath.addLineToPoint(CGPointMake(16, 24))
            checkmarkShapePath.addLineToPoint(CGPointMake(27, 13))
            checkmarkShapePath.moveToPoint(CGPointMake(10, 18))
            checkmarkShapePath.closePath()
        case .error: // draw X
            checkmarkShapePath.moveToPoint(CGPointMake(10, 10))
            checkmarkShapePath.addLineToPoint(CGPointMake(26, 26))
            checkmarkShapePath.moveToPoint(CGPointMake(10, 26))
            checkmarkShapePath.addLineToPoint(CGPointMake(26, 10))
            checkmarkShapePath.moveToPoint(CGPointMake(10, 10))
            checkmarkShapePath.closePath()
        case .info:
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
        
        HUD.draw(.success)
        
        Cache.imageOfCheckmark = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCheckmark!
    }
    private class var imageOfCross: UIImage {
        if (Cache.imageOfCross != nil) {
            return Cache.imageOfCross!
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), false, 0)
        
        HUD.draw(.error)
        
        Cache.imageOfCross = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCross!
    }
    private class var imageOfInfo: UIImage {
        if (Cache.imageOfInfo != nil) {
            return Cache.imageOfInfo!
        }
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), false, 0)
        
        HUD.draw(.info)
        
        Cache.imageOfInfo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfInfo!
    }
}
