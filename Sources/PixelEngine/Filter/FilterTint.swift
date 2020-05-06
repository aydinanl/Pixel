//
//  FilterTint.swift
//  PixelEngine
//
//  Created by Batuhan Saygili on 2020-05-06.
//  Copyright © 2020 muukii. All rights reserved.
//

import Foundation
import CoreImage

public struct FilterTint: Filtering, Equatable, Codable {

  public static let range: ParameterRange<Double, FilterTint> = .init(min: -3000, max: 3000)

  public var value: Double = 0

  public init() {

  }

  public func apply(to image: CIImage, sourceImage: CIImage) -> CIImage {
    return
      image
        .applyingFilter(
          "CITemperatureAndTint",
          parameters: [
            "inputNeutral": CIVector.init(x:  6500, y: CGFloat(value)),
            "inputTargetNeutral": CIVector.init(x: 6500, y: 0),
          ]
    )
  }


}
