//
//  GeoSearch.swift
//  GadgetMap
//
//  Created by modao on 2018/3/12.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import Foundation

public struct GeoSearchService {
    /// 查询关键字
    var keywords: [String]
    /// 查询POI类型
    var types: [String]
    /// 查询城市
    var city: String?
    /// 仅返回指定城市数据
    var cityLimit: Bool
    /// 是否按照层级展示子POI数据
    var showChildren: Bool
    /// 每页记录数据
    var offset: Int
    /// 当前页数
    var page: Int
    /// 搜索楼层
    var floor: String?
    /// 返回结果控制
    var extensions: GeoRequestExtension
    /// 数字签名
    var sig: Bool
    /// 返回数据格式类型
    var output: AMapOutputType
    /// 回调函数
    var callback: String?
    /// 建筑物的POI编号
    var building: String?

    init(keywords: [String], types: [String], city: String? = nil,
         cityLimit: Bool = false, showChildren: Bool = false, offset: Int = 20,
         page: Int = 1, building: String? = nil, floor: String? = nil,
         extensions: GeoRequestExtension = .base, useSig: Bool = false,
         outputType: AMapOutputType = .json, callback: String? = nil) {
        self.keywords = keywords
        self.types = types
        self.city = city
        self.cityLimit = cityLimit
        self.showChildren = showChildren
        self.page = page
        self.building = building
        self.offset = offset
        self.floor = floor
        self.extensions = extensions
        self.sig = useSig
        self.output = outputType
        self.callback = callback
    }
}

public struct GeoSearchResponse: Codable {
    struct GeoSuggestion: Codable {
        struct GeoCity: Codable {
            let name: String
            let num: String
            let citycode: String
            let adcode: String
        }
        let keywords: String?
        let cities: [GeoCity]
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            keywords = try? values.decode(String.self, forKey: .keywords)
            cities = try values.decode(Array<GeoCity>.self, forKey: .cities)
        }
    }
    struct GeoSearchPOI: Codable {
        struct GeoIndoorData: Codable {
            let cpid: String?
            let floor: String?
            let truefloor: String?
            let cmsid: String?
            public init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                cpid = try? values.decode(String.self, forKey: .cpid)
                floor = try? values.decode(String.self, forKey: .floor)
                truefloor = try? values.decode(String.self, forKey: .truefloor)
                cmsid = try? values.decode(String.self, forKey: .cmsid)
            }
        }
        struct GeoSearchPhoto: Codable {
            let title: String?
            let url: String?
            public init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                title = try? values.decode(String.self, forKey: .title)
                url = try? values.decode(String.self, forKey: .url)
            }
        }
        struct GeoBizExtension: Codable {
            let rating: String?
            let cost: String?
            let meal_ordering: String?
            let seat_ordering: String?
            let ticket_ordering: String?
            let hotel_ordering: String?
        }
        struct GeoChildren: Codable {
            let id: String
            let name: String
            let sname: String
            let location: String
            let address: String
            let distance: String
            let subtype: String
        }
        let id: String
        let name: String
        let type: String
        let typecode: String
        let biz_type: String?
        let address: String
        let location: String
        let distance: String?
        let tel: String?
        let postcode: String?
        let website: String?
        let email: String?
        let pcode: String?
        let pname: String?
        let citycode: String?
        let cityname: String
        let adcode: String?
        let adname: String
        let entr_location: String?
        let exit_location: String?
        let navi_poiid: String?
        let gridcode: String?
        let alias: String?
        let business_area: String?
        let parking_type: String?
        let tag: String?
        let indoor_map: String?
        let indoor_data: GeoIndoorData
        let groupbuy_num: String?
        let discount_num: String?
        let biz_ext: GeoBizExtension?
        let event: String?
        let importance: String?
        let shopid: String?
        let shopinfo: String?
        let poiweight: String?
        let match: String
        let recommend: String
        let timestamp: String?
        let children: [GeoChildren]
        let photos: [GeoSearchPhoto]
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decode(String.self, forKey: .id)
            name = try values.decode(String.self, forKey: .name)
            tag = try? values.decode(String.self, forKey: .tag)
            type = try values.decode(String.self, forKey: .type)
            typecode = try values.decode(String.self, forKey: .typecode)
            biz_type = try? values.decode(String.self, forKey: .biz_type)
            address = try values.decode(String.self, forKey: .address)
            location = try values.decode(String.self, forKey: .location)
            tel = try? values.decode(String.self, forKey: .tel)
            postcode = try? values.decode(String.self, forKey: .postcode)
            website = try? values.decode(String.self, forKey: .website)
            email = try? values.decode(String.self, forKey: .email)
            pcode = try? values.decode(String.self, forKey: .pcode)
            pname = try? values.decode(String.self, forKey: .pname)
            citycode = try? values.decode(String.self, forKey: .citycode)
            cityname = try values.decode(String.self, forKey: .cityname)
            adcode = try? values.decode(String.self, forKey: .adcode)
            adname = try values.decode(String.self, forKey: .adname)
            importance = try? values.decode(String.self, forKey: .importance)
            shopid = try? values.decode(String.self, forKey: .shopid)
            shopinfo = try? values.decode(String.self, forKey: .shopinfo)
            poiweight = try? values.decode(String.self, forKey: .poiweight)
            distance = try? values.decode(String.self, forKey: .distance)
            navi_poiid = try? values.decode(String.self, forKey: .navi_poiid)
            entr_location = try? values.decode(String.self, forKey: .entr_location)
            business_area = try? values.decode(String.self, forKey: .business_area)
            exit_location = try? values.decode(String.self, forKey: .exit_location)
            match = try values.decode(String.self, forKey: .match)
            recommend = try values.decode(String.self, forKey: .recommend)
            indoor_map = try? values.decode(String.self, forKey: .indoor_map)
            indoor_data = try values.decode(GeoIndoorData.self, forKey: .indoor_data)
            groupbuy_num = try? values.decode(String.self, forKey: .groupbuy_num)
            discount_num = try? values.decode(String.self, forKey: .discount_num)
            biz_ext = try? values.decode(GeoBizExtension.self, forKey: .biz_ext)
            event = try? values.decode(String.self, forKey: .event)
            children = try values.decode(Array<GeoChildren>.self, forKey: .children)
            photos = try values.decode(Array<GeoSearchPhoto>.self, forKey: .photos)
            timestamp = try? values.decode(String.self, forKey: .timestamp)
            alias = try? values.decode(String.self, forKey: .alias)
            gridcode = try? values.decode(String.self, forKey: .gridcode)
            parking_type = try? values.decode(String.self, forKey: .parking_type)
        }
    }
    private let status: String
    private let info: String
    private let infocode: Int
    let count: Int
    let suggestion: GeoSuggestion
    let pois: [GeoSearchPOI]
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decode(String.self, forKey: .status)
        infocode = (try Int(values.decode(String.self, forKey: .infocode)))!
        guard status == "1" else {
            throw ServiceError(code: infocode)!
        }
        info = try values.decode(String.self, forKey: .info)
        count = (try Int(values.decode(String.self, forKey: .count)))!
        suggestion = try values.decode(GeoSuggestion.self, forKey: .suggestion)
        pois = try values.decode(Array<GeoSearchPOI>.self, forKey: .pois)
    }
}
