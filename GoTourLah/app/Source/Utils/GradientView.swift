//
//  GradientView.swift
//  Barg-InnoFest
//
//  Created by Ryan The on 22/8/20.
//  Copyright © 2020 Ryan The. All rights reserved.
//

import UIKit

class GradientView: UIView {

    override var layer: CAGradientLayer {
        return super.layer as! CAGradientLayer
    }
	
    init(topColor: UIColor, bottomColor: UIColor) {
		super.init(frame: .zero)

        backgroundColor = .clear

        layer.startPoint = CGPoint(x: 0.5, y: 0.0)
        layer.endPoint = CGPoint(x: 0.5, y: 1.0)

        layer.colors = [topColor.cgColor, bottomColor.cgColor]
    }
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    class var blackShadowOverlay: GradientView {
        GradientView(topColor: .clear, bottomColor: UIScreen.main.traitCollection.userInterfaceStyle == .dark ? .secondarySystemBackground : .black)
    }
}
