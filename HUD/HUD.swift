//
//  HUD.swift
//  HUD
//
//  Created by Chakery on 16/4/6.
//  Copyright © 2016年 Chakery. All rights reserved.
//

import UIKit


public typealias HUDCompletedBlock = (Void) -> Void

public enum HUDType {
    case loading
    case success
    case error
    case info
    case none
}

public extension HUD {
    public class func show(_ type: HUDType, text: String, time: TimeInterval? = nil, completion: HUDCompletedBlock? = nil) {
        dismiss()
        instance.registerDeviceOrientationNotification()
        var isNone: Bool = false
        let window = UIWindow()
        window.backgroundColor = UIColor.clear
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
            headView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
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
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(label)
        
        var height: CGFloat = 0
        if isNone {
            height = label.frame.height + 30
        } else {
            height = label.frame.height + 70
        }
        let superFrame = CGRect(x: 0, y: 0, width: label.frame.width + 50, height: height)
        window.frame = superFrame
        mainView.frame = superFrame
        
        // image
        if !isNone {
            mainView.addConstraint( NSLayoutConstraint(item: headView, attribute: .centerY, relatedBy: .equal, toItem: mainView, attribute: .centerY, multiplier: 0.6, constant: 0) )
            mainView.addConstraint( NSLayoutConstraint(item: headView, attribute: .centerX, relatedBy: .equal, toItem: mainView, attribute: .centerX, multiplier: 1.0, constant: 0) )
            mainView.addConstraint( NSLayoutConstraint(item: headView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 36) )
            mainView.addConstraint( NSLayoutConstraint(item: headView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 36) )
        }
        // label
        var mainViewMultiplier: CGFloat = 0
        if isNone {
            mainViewMultiplier = 1.0
        } else {
            mainViewMultiplier = 1.5
        }
        mainView.addConstraint( NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: mainView, attribute: .centerY, multiplier: mainViewMultiplier, constant: 0) )
        mainView.addConstraint( NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: mainView, attribute: .centerX, multiplier: 1.0, constant: 0) )
        mainView.addConstraint( NSLayoutConstraint(item: label, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 90) )
        mainView.addConstraint( NSLayoutConstraint(item: label, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 0) )
        
        window.windowLevel = UIWindowLevelAlert
        window.center = getCenter()
        window.isHidden = false
        window.addSubview(mainView)
        windowsTemp.append(window)
        
        delayDismiss(time, completion: completion)
    }
    
    public class func dismiss() {
        if let _ = timer {
            timer!.cancel()
            timer = nil
        }
        instance.removeDeviceOrientationNotification()
        windowsTemp.removeAll(keepingCapacity: false)
    }
}

open class HUD: NSObject {
    fileprivate static var windowsTemp = [UIWindow]()
    fileprivate static var timer: DispatchSourceTimer?
    fileprivate static let instance = HUD()
    private struct Cache {
        static var imageOfCheckmark: UIImage?
        static var imageOfCross: UIImage?
        static var imageOfInfo: UIImage?
    }
    
    // center
    fileprivate class func getCenter() -> CGPoint {
        if let rv = UIApplication.shared.keyWindow?.subviews.first {
            if rv.bounds.width > rv.bounds.height {
                return CGPoint(x: rv.bounds.height * 0.5, y: rv.bounds.width * 0.5)
            }
            return rv.center
        }
        return .zero
    }

    // delay dismiss
    fileprivate class func delayDismiss(_ time: TimeInterval?, completion: HUDCompletedBlock?) {
        guard let time = time else { return }
        guard time > 0 else { return }
        var timeout = time
        timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: 0),
                                               queue: DispatchQueue.main)// as! DispatchSource
        timer!.scheduleRepeating(wallDeadline: .now(), interval: .seconds(1))

        timer!.setEventHandler { _ in
            if timeout <= 0 {
                DispatchQueue.main.async {
                    dismiss()
                    completion?()
                }
            } else {
                timeout -= 1
            }
        }
        timer!.resume()
    }
    
    // register notification
    fileprivate func registerDeviceOrientationNotification() {
        NotificationCenter.default.addObserver(HUD.instance, selector: #selector(HUD.transformWindow(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    // remove notification
    fileprivate func removeDeviceOrientationNotification() {
        NotificationCenter.default.removeObserver(HUD.instance)
    }
    
    // transform
    @objc fileprivate func transformWindow(_ notification: Notification) {
        var rotation: CGFloat = 0
        switch UIDevice.current.orientation {
        case .portrait:
            rotation = 0
        case .portraitUpsideDown:
            rotation = .pi
        case .landscapeLeft:
            rotation = .pi * 0.5
        case .landscapeRight:
            rotation = CGFloat(.pi + (.pi * 0.5))
        default:
            break
        }
        HUD.windowsTemp.forEach {
            $0.center = HUD.getCenter()
            $0.transform = CGAffineTransform(rotationAngle: rotation)
        }
    }
    
    // draw
    private class func draw(_ type: HUDType) {
        let checkmarkShapePath = UIBezierPath()
        
        // draw circle
        checkmarkShapePath.move(to: CGPoint(x: 36, y: 18))
        checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 18), radius: 17.5, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        checkmarkShapePath.close()
        
        switch type {
        case .success: // draw checkmark
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 18))
            checkmarkShapePath.addLine(to: CGPoint(x: 16, y: 24))
            checkmarkShapePath.addLine(to: CGPoint(x: 27, y: 13))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 18))
            checkmarkShapePath.close()
        case .error: // draw X
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 10))
            checkmarkShapePath.addLine(to: CGPoint(x: 26, y: 26))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 26))
            checkmarkShapePath.addLine(to: CGPoint(x: 26, y: 10))
            checkmarkShapePath.move(to: CGPoint(x: 10, y: 10))
            checkmarkShapePath.close()
        case .info:
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 6))
            checkmarkShapePath.addLine(to: CGPoint(x: 18, y: 22))
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 6))
            checkmarkShapePath.close()
            
            UIColor.white.setStroke()
            checkmarkShapePath.stroke()
            
            let checkmarkShapePath = UIBezierPath()
            checkmarkShapePath.move(to: CGPoint(x: 18, y: 27))
            checkmarkShapePath.addArc(withCenter: CGPoint(x: 18, y: 27), radius: 1, startAngle: 0, endAngle: .pi * 2, clockwise: true)
            checkmarkShapePath.close()
            
            UIColor.white.setFill()
            checkmarkShapePath.fill()
        default: break
        }
        
        UIColor.white.setStroke()
        checkmarkShapePath.stroke()
    }
    fileprivate class var imageOfCheckmark: UIImage {
        if (Cache.imageOfCheckmark != nil) {
            return Cache.imageOfCheckmark!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        HUD.draw(.success)
        
        Cache.imageOfCheckmark = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCheckmark!
    }
    fileprivate class var imageOfCross: UIImage {
        if (Cache.imageOfCross != nil) {
            return Cache.imageOfCross!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        HUD.draw(.error)
        
        Cache.imageOfCross = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfCross!
    }
    fileprivate class var imageOfInfo: UIImage {
        if (Cache.imageOfInfo != nil) {
            return Cache.imageOfInfo!
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 36, height: 36), false, 0)
        
        HUD.draw(.info)
        
        Cache.imageOfInfo = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Cache.imageOfInfo!
    }
}
