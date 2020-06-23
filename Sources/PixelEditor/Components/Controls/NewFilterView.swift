//
//  NewFilterView.swift
//  PixelEngine
//
//  Created by Batuhan Saygili on 2020-06-23.
//  Copyright © 2020 muukii. All rights reserved.
//

import Foundation

open class NewFilterViewBase : ControlBase {
  
  public required init(context: PixelEditContext, colorCubeControl: ColorCubeControlBase) {
    super.init(context: context)
  }
}

public final class NewFilterView : NewFilterViewBase {

  private let navigationView = NavigationView()
  
  
  private let containerView = UIView()
  
  public let colorCubeControl: ColorCubeControlBase
  
  
  
  public required init(context: PixelEditContext, colorCubeControl: ColorCubeControlBase) {

    self.colorCubeControl = colorCubeControl

    super.init(context: context, colorCubeControl: colorCubeControl)

    backgroundColor = Style.default.control.backgroundColor

    layout: do {

      addSubview(containerView)

      containerView.translatesAutoresizingMaskIntoConstraints = false

      NSLayoutConstraint.activate([

        containerView.topAnchor.constraint(equalTo: containerView.superview!.topAnchor),
        containerView.leftAnchor.constraint(equalTo: containerView.superview!.leftAnchor),
        containerView.rightAnchor.constraint(equalTo: containerView.superview!.rightAnchor),
        containerView.bottomAnchor.constraint(equalTo: navigationView.topAnchor)
        ])

     }
       colorCubeControl.frame = containerView.bounds
       colorCubeControl.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       containerView.addSubview(colorCubeControl)

  }

  public override func setup() {

    super.setup()

    backgroundColor = Style.default.control.backgroundColor

    addSubview(navigationView)

    navigationView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      navigationView.rightAnchor.constraint(equalTo: navigationView.superview!.rightAnchor),
      navigationView.leftAnchor.constraint(equalTo: navigationView.superview!.leftAnchor),
      navigationView.bottomAnchor.constraint(equalTo: navigationView.superview!.bottomAnchor),
      navigationView.topAnchor.constraint(greaterThanOrEqualTo: navigationView.superview!.topAnchor),
      ])

    navigationView.didTapCancelButton = { [weak self] in

      self?.pop(animated: true)
    }

    navigationView.didTapDoneButton = { [weak self] in

      self?.pop(animated: true)
    }
  }
}
