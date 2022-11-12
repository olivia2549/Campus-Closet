//
//  NavExtension.swift
//  Campus-Closet
//
//  Created by Olivia Logan on 11/12/22.
//

import Foundation
import SwiftUI

// allow user to swipe back
extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
