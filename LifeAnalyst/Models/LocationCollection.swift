//
//  locationCollection.swift
//  LifeAnalyst
//
//  Created by 山本竜也 on 2019/2/3.
//  Copyright © 2019 山本竜也. All rights reserved.
//

import Foundation

protocol locationCollectionDelegate:class {
    func saved()
}

class LocationCollection {
    static var shared = LocationCollection()
    
    var selectTitle:[String] = ["No Title","work","programing","study","lanch","dinner","move","reading","rest","youtube"]
    
    let userDefaults = UserDefaults.standard
    
    private var locations: [Location] = []
    
    weak var delegate: locationCollectionDelegate?
    
    private init() {
        self.load()
    }
    
    func getLocation (at: Int) -> Location{
        return locations[at]
    }
    
    func locationCount () -> Int{
        return locations.count
    }
    
    // タスクの追加
    func addLocation (_ location: Location) {
        locations.append(location)
        self.save()
    }
    
    // タスクの削除
    func removeLocation (at: Int) {
        locations.remove(at: at)
        self.save()
    }
    
    func editLocation () {
        self.save()
    }
    
    func save () {
        // シリアル化
        let data = try! PropertyListEncoder().encode(locations)
        // UserDefaultsにlocationsという名前で保存
        userDefaults.set(data, forKey: "locations")
        // デリゲートを使ってフックを作っている。保存したら実行
        delegate?.saved()
    }
    
    func load() {
        if let data = userDefaults.data(forKey: "locations") {
           let locations = try! PropertyListDecoder().decode([Location].self, from: data)
            self.locations  = locations
        }
    }
    
    
    
}
