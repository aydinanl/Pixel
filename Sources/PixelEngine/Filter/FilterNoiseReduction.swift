//
//  FilterNoiseReduction.swift
//  PixelEngine
//
//  Created by Batuhan Saygili on 2020-05-06.
//  Copyright © 2020 muukii. All rights reserved.
//


import Foundation
import CoreImage

public struct FilterNoiseReduction: Filtering, Equatable, Codable {
  
  public enum Params {
    public static let noiseLevel: ParameterRange<Double, FilterNoiseReduction> = .init(min: 0, max: 0.08)
    public static let sharpness: ParameterRange<Double, FilterNoiseReduction> = .init(min: 0, max: 1)
  }

  public var sharpness: Double = 0
  public var noiseLevel: Double = 0.2

  public init() {

  }

  public func apply(to image: CIImage, sourceImage: CIImage) -> CIImage {

    let _noiseLevel = RadiusCalculator.radius(value: noiseLevel, max: FilterGaussianBlur.range.max, imageExtent: image.extent)

    return
      image
        .applyingFilter(
          "CINoiseReduction", parameters: [
            "inputNoiseLevel" : _noiseLevel,
            "inputSharpness": sharpness,
            ])
  }
}
