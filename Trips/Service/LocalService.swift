//
//  LocalSave.swift
//  Trips
//
//  Created by Egor Syrtcov on 8.12.22.
//

import Foundation

fileprivate enum SessionUserDefaultKey: String {
    case notification = "notification"
    var key: String { return rawValue }
}

final class LocalService {
 
    private let userDefaults = UserDefaults.standard
    
    var tripModels: [TripModel] {
        get {
            guard let data = userDefaults.value(forKey: SessionUserDefaultKey.notification.key) as? Data,
                  let items = try? PropertyListDecoder().decode([TripModel].self, from: data) else { return [] }
            return items
        }
        
        set {
            guard let data = try? PropertyListEncoder().encode(newValue) else { return }
            userDefaults.set(data, forKey: SessionUserDefaultKey.notification.key)
        }
    }
    
    func removeItem(index: Int) {
        var newTripModels = tripModels
        newTripModels.remove(at: index)
        self.tripModels = newTripModels
    }
}

