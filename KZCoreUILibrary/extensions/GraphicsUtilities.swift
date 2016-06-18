//
//  GraphicsUtilities.swift
//  KZCoreUILibrary
//
//  Created by Shane Whitehead on 25/03/2016.
//  Copyright © 2016 KaiZen. All rights reserved.
//

import UIKit

// I'm wondering if this is actually a good idea...
// This is going to look weird, but I've done it
// deliberatly to show case the intention
//
// So I have these two methods, they take parameters
// and generate a result (UIImage), there's no
// good reason I can think of for having them included
// in a standalone class, apart from changing the internal
// implementation.
//
// I kind of like to "contain" the functions to make it easer
// to use (I like ImageUtilities.xxx of KZxxx but that's me)
//
// A struct wouldn't give me the flexibility I want and I though
// about using UIImage as the extension point, but does that make
// sense, they return a UIImage, but they aren't extending it's
// functionality in any real manner
//
// The class/extension mechanism provides me with a key starting
// point for "image/graphics related" utilities or effects
// and would make it easier to lookup via autocomplete, but is that
// a compeling enough reason?
public class KZGraphicsUtilities {
	
}

public extension KZGraphicsUtilities {
	/**
	This creates a conical fill effect of the specified size with the specified colors spread between the specified
	locations
	
	The intention is to return an image which is completely filled
	*/
	public class func createConicalGraidentOf(size: CGSize, withColors colors: [UIColor], withLocations locations: [Double]) -> UIImage {
//		let band = ColorBand(withColors: colors, andLocations: locations)
		let band = ColorBand(withColors: colors, andLocations: locations)
		return createConicalGraidentOf(size: size, withColorBand: band)
	}
	
	public class func createConicalGraidentOf(size: CGSize, withColorBand band: ColorBand) -> UIImage {
		
		var currentAngle: CGFloat = 0.0
		
		// workaround
		var limit: CGFloat = 1.0 // 32bit
		if sizeof(limit.dynamicType) == 8 {
			limit = 1.001 // 64bit
		}
		
		let arcRadius: CGFloat = size.maxDimension()
		let arcPoint: CGPoint = size.centerOf()
		
		let width = size.width
		let height = size.height
		UIGraphicsBeginImageContextWithOptions(
			CGSize(width: width, height: height),
			false,
			0.0)
		// Need to flip it horizontally
		let ctx = UIGraphicsGetCurrentContext()
		ctx?.translate(x: width,
		                      y: height);
		ctx?.scale(x: -1.0, y: -1.0);
		ctx?.setAllowsAntialiasing(true)
		ctx?.setShouldAntialias(true)
		
		for i in stride(from: 0.0, to: Double(limit), by: 0.001) {
			
			let arcStartAngle: CGFloat = -90.0.toRadians.toCGFloat
			let arcEndAngle: CGFloat = CGFloat(i) * 2.0 * CGFloat(M_PI) - arcStartAngle
			
			if currentAngle == 0.0 {
				currentAngle = arcStartAngle
			} else {
				currentAngle = arcEndAngle - 0.1
			}
			
			let fillColor: UIColor = band.colorAt(i)
			
			let path = UIBezierPath()
			path.move(to: arcPoint)
			let pointTo = CGPoint(
				x: (arcPoint.x) + (arcRadius * cos(currentAngle)),
				y: (arcPoint.y) + (arcRadius * sin(currentAngle)))
			path.addLine(to: pointTo)
			
			// This use to draw a circle, now I just want to paint
			// beyond the bounds of the available viewable area
			// this can then be masked or what ever...
			//			let arc: UIBezierPath = UIBezierPath(arcCenter: arcPoint,
			//			                                     radius: arcRadius,
			//			                                     startAngle: currentAngle,
			//			                                     endAngle: arcEndAngle,
			//			                                     clockwise: true)
			//			path.appendPath(arc)
			path.addLine(to: CGPoint(
				x: (arcPoint.x) + (arcRadius * cos(arcEndAngle)),
				y: (arcPoint.y) + (arcRadius * sin(arcEndAngle))))
			path.addLine(to: arcPoint)
			
			fillColor.setFill()
			
			UIColor.gray().setStroke()
			path.lineCapStyle = CGLineCap.round
			path.fill()
		}
		
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return image!
		
	}
	
}

public extension KZGraphicsUtilities {
	
	public class func createRadialGraidentOf(size: CGSize, withColors colors: [UIColor], withLocations locations: [Double]) -> UIImage {
		
		let width = size.width
		let height = size.height
		
		UIGraphicsBeginImageContextWithOptions(
			CGSize(width: width, height: height),
			false,
			0.0)
		// Need to flip it horizontally
		let ctx = UIGraphicsGetCurrentContext()
		
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		
		let floatLocations = locations.map {
			$0.toCGFloat
		}
		let cgColors = colors.map {
			$0.cgColor
		}
		let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors, locations: floatLocations)
		
		let center = size.centerOf()
		let radius = size.minDimension() / 2.0
		
		ctx?.drawRadialGradient(gradient!,
			startCenter: center,
			startRadius: 0,
			endCenter: center,
			endRadius: radius,
			options: CGGradientDrawingOptions.drawsAfterEndLocation)
		
		
		ctx?.setAllowsAntialiasing(true)
		ctx?.setShouldAntialias(true)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return image!
	}
	
}

public extension UIImage {
	
	public func maskWith(_ maskImage: UIImage) -> UIImage? {
		var cgMask = maskImage.cgImage
		cgMask = CGImage(
			maskWidth: (cgMask?.width)!,
			height: (cgMask?.height)!,
			bitsPerComponent: (cgMask?.bitsPerComponent)!,
			bitsPerPixel: (cgMask?.bitsPerPixel)!,
			bytesPerRow: (cgMask?.bytesPerRow)!,
			provider: (cgMask?.dataProvider!)!,
			decode: nil,
			shouldInterpolate: true)
		
		let cgMasked = cgImage?.masking(cgMask!)
		var imgMasked: UIImage?
		if let cgMasked = cgMasked {
			imgMasked = UIImage(cgImage: cgMasked)
		}
		return imgMasked
		
	}
	
}

public extension UIEdgeInsets {
	
	func verticalInsets() -> CGFloat {
		return top + bottom
	}
	
	func horizontalInsets() -> CGFloat {
		return left + right
	}
	
}

func scaleFactorFrom(_ original: CGFloat, to: CGFloat) -> CGFloat {
	return to / original
}

public extension CGRect {
	func withInsets(_ insets: UIEdgeInsets) -> CGRect {
		return CGRect(x: self.minX + insets.left,
		              y: self.minY + insets.top,
		              width: self.width - (insets.right + insets.left),
		              height: self.height - (insets.bottom + insets.top))
	}
	
	func maxDimension() -> CGFloat {
		return max(self.width, self.height)
	}
	
	func minDimension() -> CGFloat {
		return min(self.width, self.height)
	}
	
	func centerOf() -> CGPoint {
		return CGPoint(
			x: self.minX + (self.width / 2),
			y: self.minY + (self.height / 2))
	}
	
}

public extension CGSize {
	func maxDimension() -> CGFloat {
		return max(width, height)
	}
	
	func minDimension() -> CGFloat {
		return min(width, height)
	}
	
	func centerOf() -> CGPoint {
		return CGPoint(x: width / 2, y: height / 2)
	}
	
	func scaleToFit(_ target: CGSize) -> CGSize {
		return scaleBy(min(
			scaleFactorFrom(width, to: target.width),
			scaleFactorFrom(height, to: target.height)))
	}
	
	func scaleToFill(_ target: CGSize) -> CGSize {
		return scaleBy(max(
			scaleFactorFrom(width, to: target.width),
			scaleFactorFrom(height, to: target.height)))
	}
	
	func scaleBy(_ factor: CGFloat) -> CGSize {
		return CGSize(width: width * factor, height: height * factor)
	}
}


