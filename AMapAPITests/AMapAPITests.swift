//
//  AMapAPITests.swift
//  AMapAPITests
//
//  Created by modao on 2018/3/11.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import XCTest
import CoreLocation
@testable import AMapAPI

class AMapAPITests: XCTestCase {

    let apiKey = "08e16d6e813d70419d0f59d1379ffbe7"
    override func setUp() {
        super.setUp()
        AMapManager.initialize(key: apiKey)
    }
    
    func testGeo() {
        let decoder = JSONDecoder()
        let expection = XCTestExpectation(description: "地理编码")
        var req = GeoRequest(address: ["方恒国际中心A座"])
        req.city = "北京"
        URLSession.shared.dataTask(with: req.toURLComponents().url!) { data, response, error in
            if let jsonData = data {
                guard let geocode = try? decoder.decode(GeoResponse.self, from: jsonData) else {
                    XCTFail("转换失败")
                    return expection.fulfill()
                }
                print(geocode)
            }
            expection.fulfill()
            }.resume()
        wait(for: [expection], timeout: 300)
    }

    func testRegeo() {
        let decoder = JSONDecoder()
        let expection = XCTestExpectation(description: "逆地理编码")
        let location = CLLocation.init(latitude: 116.310003, longitude: 39.991957)
        var req = RegeoRequest(location: [location])
        req.poitype = ["商务写字楼"]
        req.radius = 1000
        req.extensions = .all
        req.batch = false
        req.roadlevel = .none
        URLSession.shared.dataTask(with: req.toURLComponents().url!) { data, response, error in
            if let jsonData = data {
                do {
                    let geocode = try decoder.decode(RegeoResponse.self, from: jsonData)
                    print(geocode)
                } catch(let e) {
                    let ddd = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                    print(ddd ?? "Empty")
                    XCTFail(e.localizedDescription)
                }
            }
            expection.fulfill()
        }.resume()
        wait(for: [expection], timeout: 300)
    }

    func testSearch() {
        let decoder = JSONDecoder()
        let expection = XCTestExpectation(description: "搜索")
        var req = GeoSearchService(keywords: ["北京大学"], types: ["高等院校"])
        req.city = "北京"
        req.showChildren = true
        req.offset = 20
        req.page = 1
        req.extensions = .all
        URLSession.shared.dataTask(with: req.toURLComponents().url!) { data, response, error in
            if let jsonData = data {
                do {
                    let geocode = try decoder.decode(GeoSearchResponse.self, from: jsonData)
                    print(geocode)
                } catch(let e) {
                    let ddd = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
                    print(ddd ?? "Empty")
                    XCTFail(e.localizedDescription)
                }
            }
            expection.fulfill()
            }.resume()
        wait(for: [expection], timeout: 300)
    }
}
