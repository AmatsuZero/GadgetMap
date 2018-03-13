//
//  GeoClusterAnnotationView.swift
//  AMapAPI
//
//  Created by modao on 2018/3/13.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import MapKit

public class GeoClusterAnnotationView: MKAnnotationView {

    var count: Int = 1 {
        didSet {
            let size = round(44*CGFloat(count).scaledValue)
            let newBounds = CGRect(x: 0, y: 0, width: size, height: size)
            let newLabelBounds = CGRect(x: 0, y: 0, width: newBounds.width/1.3, height: newBounds.height/1.3)
            lable.frame = newLabelBounds.centerRect(aCenter: newBounds.center)
            lable.text = "\(count)"
            setNeedsDisplay()
        }
    }
    private let lable = UILabel()

    public override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        lable.backgroundColor = .clear
        lable.textColor = .white
        lable.textAlignment = .center
        lable.shadowColor = UIColor(white: 0, alpha: 0.75)
        lable.shadowOffset = CGSize(width: 0, height: -1)
        lable.adjustsFontSizeToFitWidth = true
        lable.numberOfLines = 1
        lable.font = UIFont.systemFont(ofSize: 12)
        lable.baselineAdjustment = .alignCenters
        self.addSubview(lable)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()

        ctx?.setAllowsAntialiasing(true)

        let outerCircleStrokeColor = UIColor(white: 0, alpha: 0.25)
        let innserCircleStrokeColor = UIColor.white
        let innerCircleFillColor = UIColor(red: 1, green: 95/255, blue: 42/255, alpha: 1)

        let circleFrame = rect.insetBy(dx: 4, dy: 4)

        outerCircleStrokeColor.setStroke()
        ctx?.setLineWidth(5)
        ctx?.strokeEllipse(in: circleFrame)

        innserCircleStrokeColor.setStroke()
        ctx?.setLineWidth(4)
        ctx?.strokeEllipse(in: circleFrame)

        innerCircleFillColor.setStroke()
        ctx?.fillEllipse(in: circleFrame)
    }
}
