//
//  UIApplication.swift
//  Trips
//
//  Created by Egor Syrtcov on 6.12.22.
//

import UIKit

extension UIApplication {
    
 static let notificationSettingsURLString: String? = {
    if #available(iOS 16, *) {
      return UIApplication.openNotificationSettingsURLString
    }

    if #available(iOS 15.4, *) {
      return UIApplicationOpenNotificationSettingsURLString
    }

    if #available(iOS 8.0, *) {
      // just opens settings
      return UIApplication.openSettingsURLString
    }

    return nil
  }()
}
