//
//  BasicInfo.swift
//  AMapAPI
//
//  Created by modao on 2018/3/12.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import Foundation

public struct GeoBuilding: Codable {
    let name: String?
    let type: String?
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try? values.decode(String.self, forKey: .name)
        type = try? values.decode(String.self, forKey: .type)
    }
}

public struct GeoNeighborhood: Codable {
    let name: String?
    let type: String?
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try? values.decode(String.self, forKey: .name)
        type = try? values.decode(String.self, forKey: .type)
    }
}

public struct GeoStreet: Codable {
    let street: String
    let number: String
    let location: String
    let direction: String
    let distance: String
}

public struct GeoBusiness: Codable {
    let location: String
    let name: String
    let id: String
}

public struct GeoRoad: Codable {
    let id: String
    let name: String
    let distance: String
    let direction: String
    let location: String
}

public struct GeoRoadinter: Codable {
    let distance: String
    let direction: String
    let location: String
    let firstId: String
    let firstName: String
    let secondId : String
    let secondName: String
    enum CodingKeys: String, CodingKey {
        case firstId = "first_id"
        case firstName = "first_name"
        case secondId = "second_id"
        case secondName = "second_name"
        case distance, direction, location
    }
}

public struct GeoPOI: Codable {
    let id: String
    let name: String
    let type: String
    /// 电话。电话这个地方太坑了，有数据就是字符串，没数据就是空数组
    let tel: String?
    let distance: String
    let direction: String
    let address: String
    let location: String
    let businessarea: String
    let poiweight: String

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        type = try values.decode(String.self, forKey: .type)
        tel = try? values.decode(String.self, forKey: .tel)
        distance = try values.decode(String.self, forKey: .distance)
        direction = try values.decode(String.self, forKey: .direction)
        address = try values.decode(String.self, forKey: .address)
        location = try values.decode(String.self, forKey: .location)
        businessarea = try values.decode(String.self, forKey: .businessarea)
        poiweight = try values.decode(String.self, forKey: .poiweight)
    }
}

public struct GeoAOI: Codable {
    let id: String
    let name: String
    let adcode: String
    let location: String
    let area: String
    let distance: String
    let type: String
}
