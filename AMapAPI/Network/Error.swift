//
//  Error.swift
//  AMapAPI
//
//  Created by modao on 2018/3/12.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import Foundation

public enum ServiceError: Int, Error {
    case INVALID_USER_KEY = 10001, SERVICE_NOT_AVAILABLE, DAILY_QUERY_OVER_LIMIT, ACCESS_TOO_FREQUENT, INVALID_USER_IP, INVALID_USER_DOMAIN,
    INVALID_USER_SIGNATURE, INVALID_USER_SCODE, USERKEY_PLAT_NOMATCH, IP_QUERY_OVER_LIMIT, NOT_SUPPORT_HTTPS, INSUFFICIENT_PRIVILEGES,
    USER_KEY_RECYCLED, QPS_HAS_EXCEEDED_THE_LIMIT, GATEWAY_TIMEOUT, SERVER_IS_BUSY, RESOURCE_UNAVAILABLE, CQPS_HAS_EXCEEDED_THE_LIMIT,
    CKQPS_HAS_EXCEEDED_THE_LIMIT, CIQPS_HAS_EXCEEDED_THE_LIMIT, CIKQPS_HAS_EXCEEDED_THE_LIMIT, KQPS_HAS_EXCEEDED_THE_LIMIT
    case INVALID_PARAMS = 20000, MISSING_REQUIRED_PARAMS, ILLEGAL_REQUEST, UNKNOWN_ERROR, OUT_OF_SERVICE, NO_ROADS_NEARBY,
    ROUTE_FAIL, OVER_DIRECTION_RANGE
    case ENGINE_RESPONSE_DATA_ERROR

    public init?(code: Int) {
        if code >= 30000 {
            self = .ENGINE_RESPONSE_DATA_ERROR
        } else {
            self.init(rawValue: code)
        }
    }
}

extension ServiceError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .INVALID_USER_KEY: return "开发者发起请求时，传入的key不正确或者过期"
        case .SERVICE_NOT_AVAILABLE: return """
        1.开发者没有权限使用相应的服务，例如：开发者申请了WEB定位功能的key，却使用该key访问逆地理编码功能时，就会返回该错误。反之亦然。
        2.开发者请求接口的路径拼写错误。例如：正确的http://restapi.amap.com/v3/ip在程序中被拼装写了http://restapi.amap.com/vv3/ip"
        """
        case .DAILY_QUERY_OVER_LIMIT: return "开发者的日访问量超限，被系统自动封停，第二天0:00会自动解封"
        case .ACCESS_TOO_FREQUENT: return "开发者的单位时间内（1分钟）访问量超限，被系统自动封停，下一分钟自动解封"
        case .INVALID_USER_IP: return "开发者在LBS官网控制台设置的IP白名单不正确。白名单中未添加对应服务器的出口IP。可到`控制台>配置`中设定IP白名单。"
        case .INVALID_USER_DOMAIN: return "开发者绑定的域名无效，需要在官网控制台重新设置"
        case .INVALID_USER_SIGNATURE: return "开发者签名未通过开发者在key控制台中，开启了“数字签名”功能，但没有按照指定算法生成“数字签名”。"
        case .INVALID_USER_SCODE: return "需要开发者判定key绑定的SHA1,package是否与sdk包里的一致。"
        case .USERKEY_PLAT_NOMATCH: return "请求中使用的key与绑定平台不符，例如：开发者申请的是js api的key，却用来调web服务接口。"
        case .IP_QUERY_OVER_LIMIT: return "未设定IP白名单的开发者使用key发起请求，从单个IP向服务器发送的请求次数超出限制，被系统自动封停。封停后无法自动恢复，需要提交工单联系我们。"
        case .NOT_SUPPORT_HTTPS: return "服务不支持https请求，如果需要申请支持，请提交工单联系我们"
        case .INSUFFICIENT_PRIVILEGES: return "由于不具备请求该服务的权限，所以服务被拒绝。"
        case .USER_KEY_RECYCLED: return "开发者删除了key，key被删除后无法正常使用."
        case .GATEWAY_TIMEOUT: return "受单机QPS限流限制时出现该问题，建议降低请求的QPS或在控制台提工单联系我们"
        case .SERVER_IS_BUSY: return "服务器负载过高，请稍后再试"
        case .RESOURCE_UNAVAILABLE: return "所请求的资源不可用"
        case .CQPS_HAS_EXCEEDED_THE_LIMIT, .CKQPS_HAS_EXCEEDED_THE_LIMIT, .CIQPS_HAS_EXCEEDED_THE_LIMIT,
             .CIKQPS_HAS_EXCEEDED_THE_LIMIT, .KQPS_HAS_EXCEEDED_THE_LIMIT, .QPS_HAS_EXCEEDED_THE_LIMIT:
            return "QPS超出限制，超出部分的请求被拒绝。限流阈值内的请求依旧会正常返回"
        case .INVALID_PARAMS: return "请求参数的值没有按照规范要求填写。例如，某参数值域范围为[1,3],开发者误填了’4’"
        case .MISSING_REQUIRED_PARAMS: return "缺少接口中要求的必填参数"
        case .ILLEGAL_REQUEST: return "请求协议非法。比如某接口仅支持get请求，结果用了POST方式"
        case .UNKNOWN_ERROR: return "其他未知错误"
        case .OUT_OF_SERVICE: return "使用路径规划服务接口时可能出现该问题，规划点（包括起点、终点、途经点）不在中国陆地范围内"
        case .NO_ROADS_NEARBY: return "使用路径规划服务接口时可能出现该问题，划点（起点、终点、途经点）附近搜不到路"
        case .ROUTE_FAIL: return "使用路径规划服务接口时可能出现该问题，路线计算失败，通常是由于道路连通关系导致"
        case .OVER_DIRECTION_RANGE: return "使用路径规划服务接口时可能出现该问题，路线计算失败，通常是由于道路起点和终点距离过长导致。"
        case .ENGINE_RESPONSE_DATA_ERROR: return """
        出现3开头的错误码，建议先检查传入参数是否正确，若无法解决，请详细描述错误复现信息，提工单给我们。
        如，30001、30002、30003、32000、32001、32002、32003、32200、32201、32202、32203。
        """
        }
    }

    public var failureReason: String? {
        switch self {
        case .INVALID_USER_KEY: return "请求正常"
        case .SERVICE_NOT_AVAILABLE: return "key不正确或过期"
        case .DAILY_QUERY_OVER_LIMIT: return "没有权限使用相应的服务或者请求接口的路径拼写错误"
        case .ACCESS_TOO_FREQUENT: return "访问已超出日访问量"
        case .INVALID_USER_IP: return "IP白名单出错，发送请求的服务器IP不在IP白名单内"
        case .INVALID_USER_DOMAIN: return "绑定域名无效"
        case .INVALID_USER_SIGNATURE: return "数字签名未通过验证"
        case .INVALID_USER_SCODE: return "MD5安全码未通过验证"
        case .USERKEY_PLAT_NOMATCH: return "请求key与绑定平台不符。"
        case .IP_QUERY_OVER_LIMIT: return "IP访问超限"
        case .NOT_SUPPORT_HTTPS: return "服务不支持https请求"
        case .INSUFFICIENT_PRIVILEGES: return "权限不足，服务请求被拒绝"
        case .USER_KEY_RECYCLED: return "Key被删除"
        case .QPS_HAS_EXCEEDED_THE_LIMIT: return "云图服务QPS超限"
        case .GATEWAY_TIMEOUT: return "受单机QPS限流限制"
        case .SERVER_IS_BUSY: return "服务器负载过高"
        case .RESOURCE_UNAVAILABLE: return "所请求的资源不可用"
        case .CQPS_HAS_EXCEEDED_THE_LIMIT: return "使用的某个服务总QPS超限"
        case .CKQPS_HAS_EXCEEDED_THE_LIMIT: return "某个Key使用某个服务接口QPS超出限制"
        case .CIQPS_HAS_EXCEEDED_THE_LIMIT: return "来自于同一IP的访问，使用某个服务QPS超出限制"
        case .CIKQPS_HAS_EXCEEDED_THE_LIMIT: return "某个Key，来自于同一IP的访问，使用某个服务QPS超出限制"
        case .KQPS_HAS_EXCEEDED_THE_LIMIT: return "某个KeyQPS超出限制"
        case .INVALID_PARAMS: return "请求参数非法"
        case .MISSING_REQUIRED_PARAMS: return "缺少必填参数"
        case .ILLEGAL_REQUEST: return "请求协议非法"
        case .UNKNOWN_ERROR: return "其他未知错误"
        case .OUT_OF_SERVICE: return "规划点（包括起点、终点、途经点）不在中国陆地范围内"
        case .NO_ROADS_NEARBY: return "划点（起点、终点、途经点）附近搜不到路"
        case .ROUTE_FAIL: return "路线计算失败，通常是由于道路连通关系导致"
        case .OVER_DIRECTION_RANGE: return "起点终点距离过长"
        case .ENGINE_RESPONSE_DATA_ERROR: return "服务响应失败"
        }
    }
}
