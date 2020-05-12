//
//  FilterHue.swift
//  PixelEngine
//
//  Created by Batuhan Saygili on 2020-05-12.
//  Copyright © 2020 muukii. All rights reserved.
//


import Foundation

public struct FilterHue : Filtering, Equatable, Codable {
  
  public static let range: ParameterRange<Double, FilterHue> = .init(min: 0, max: 100)

  public var value: Double = 0
  
  public init() {
    
  }
  
  public func apply(to image: CIImage, sourceImage: CIImage) -> CIImage {
    return image.applyingFilter("CIHueAdjust",
               parameters: [
                 "inputImage" : image,
                 "inputAngle" : value
                ])
  }
  
}
