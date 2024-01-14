//
//  Common.swift
//  KZCoreUILibrary
//
//  Created by Shane Whitehead on 25/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit
import KZCoreLibrary

public extension Float {
	var toCGFloat: CGFloat {
		return CGFloat(self)
	}
}

public extension Double {
	var toCGFloat: CGFloat {
		return CGFloat(self)
	}
}

public extension CGFloat {
	var toRadians : CGFloat {
        return CGFloat(self) * CGFloat(Double.pi) / 180.0
	}

	var toDegrees: CGFloat {
		return self * 180.0 / CGFloat(Double.pi)
	}
	
	var toDouble: Double {
		return Double(self)
	}
	
	var toFloat: Float {
		return Float(self)
	}
}

