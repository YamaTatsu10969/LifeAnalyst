//
//  location.swift
//  LifeAnalyst
//
//  Created by 山本竜也 on 2019/2/3.
//  Copyright © 2019 山本竜也. All rights reserved.
//

import Foundation

class Location:Codable {
    
    // その場所で何をしたかを記録するために、タイトル（行動）、ノート（詳細）、位置情報を記録する。
    var title: String = ""
    var note: String = ""
    var latitude: Double = 0.00
    var longitude: Double = 0.00
    
    enum CodingKeys: String, CodingKey {
        case title
        case note
        case latitude
        case longitude
    }
    
    init () {
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.note = try container.decode(String.self, forKey: .note)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(note, forKey: .note)
//        self.latitude = try container.decode(Double.self, forKey: .latitude)
//        self.longitude = try container.decode(Double.self, forKey: .longitude)
    }
}
