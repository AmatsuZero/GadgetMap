//
//  ValueExtensions.swift
//  AMapAPI
//
//  Created by modao on 2018/3/13.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import Foundation

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
    var centerRect: CGRect {
        return CGRect(x: center.x-width/2, y: center.y-height/2, width: width, height: height)
    }
    func centerRect(aCenter: CGPoint) -> CGRect {
        return CGRect(x: aCenter.x-width/2, y: aCenter.y-height/2, width: width, height: height)
    }
}

extension CGFloat {
    static var scaledFactorAlpha: CGFloat { return 0.3 }
    static var scaledFactorBeta: CGFloat {  return 0.4 }
    var scaledValue: CGFloat {
        return 1.0 / (1.0 + exp(-1*CGFloat.scaledFactorAlpha*pow(self, CGFloat.scaledFactorBeta)))
    }
}
