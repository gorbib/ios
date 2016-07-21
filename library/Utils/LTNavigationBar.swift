//
//  LTNavigationBar.swift
//  Library
//
//  Created by Andrey Polyskalov on 09.02.16.
//  Copyright © 2016 Kachkanar library. All rights reserved.
//

import Foundation
import UIKit
/*
extension UINavigationBar {
    private struct AssociatedKeys {
        static var overlayKey = "overlayKey"
        static var emptyImageKey = "emptyImageKey"
    }

    var overlay: UIView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.overlayKey) as? UIView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.overlayKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var emptyImage: UIImage? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.emptyImageKey) as? UIImage
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.emptyImageKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /**
     Set navigationBar background color

     - parameter color: Color for navgationBar
     */
    func lt_setBackgroundColor(color: UIColor?) {
        if var view = self.overlay {
            self.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            view = UIView(frame: CGRect(x: 0, y: -20, width: UIScreen.mainScreen().bounds.width, height: CGRectGetHeight(self.bounds) + 20))
            view.userInteractionEnabled = false
            view.autoresizingMask = .FlexibleHeight // TODO:
            self.insertSubview(view, atIndex: 0)
        }

        self.overlay?.backgroundColor = color
    }

    func lt_setTranslationY(translationY: CGFloat) {
        self.transform = CGAffineTransformMakeTranslation(0, translationY)
    }


    func lt_setContentAlpha(alpha: CGFloat) {
        if self.overlay == nil {
            self.lt_setBackgroundColor(self.barTintColor)
        }

        self.setAlpha(alpha, forSubviewsOfView: self)

        if alpha == 1 {
            if self.emptyImage == nil {
                self.emptyImage = UIImage()
            }
            self.backIndicatorImage = self.emptyImage
        }
    }

    func setAlpha(aplha: CGFloat, forSubviewsOfView view: UIView) {
        for view in view.subviews {
            if view == self.overlay {
                continue
            }

            view.alpha = alpha
            self.setAlpha(alpha, forSubviewsOfView: view)
        }
    }

    /**
     Reset navigationBar to defaults
     */
    func lt_reset() {
        self.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        self.shadowImage = nil
        self.overlay?.removeFromSuperview()
        self.overlay = nil
    }
}
 */