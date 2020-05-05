//
//  FilterVibrance.swift
//  PixelEngine
//
//  Created by Batuhan Saygili on 2020-05-05.
//  Copyright © 2020 muukii. All rights reserved.
//


import Foundation
import CoreImage

public struct FilterVibrance: Filtering, Equatable, Codable {
  
  public enum Params {
    public static let vibrance: ParameterRange<Double, FilterVibrance> = .init(min: 0, max: 20)
  }

  public var vibrance: Double = 0

  public init() {

  }

  public func apply(to image: CIImage, sourceImage: CIImage) -> CIImage {

    let _vibrance = RadiusCalculator.radius(value: vibrance, max: FilterGaussianBlur.range.max, imageExtent: image.extent)

    return
      image
        .applyingFilter(
          "CIVibrance", parameters: [
            "inputAmount" : _vibrance,
            ])
  }
}
