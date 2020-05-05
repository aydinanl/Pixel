//
//  VibranceControl.swift
//  PixelEngine
//
//  Created by Batuhan Saygili on 2020-05-05.
//  Copyright © 2020 muukii. All rights reserved.
//


import Foundation

import PixelEngine

open class VibranceControlBase : FilterControlBase {
  
  public required init(context: PixelEditContext) {
    super.init(context: context)
  }
}

open class VibranceControl : VibranceControlBase {
  
  open override var title: String {
    return L10n.editVibrance
  }
  
  private let navigationView = NavigationView()
  
  public let slider = StepSlider(frame: .zero)
  
  open override func setup() {
    super.setup()
    
    backgroundColor = Style.default.control.backgroundColor
    
    TempCode.layout(navigationView: navigationView, slider: slider, in: self)
    
    slider.mode = .plus
    slider.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    
    navigationView.didTapCancelButton = { [weak self] in
      
      self?.context.action(.revert)
      self?.pop(animated: true)
    }
    
    navigationView.didTapDoneButton = { [weak self] in
      
      self?.context.action(.commit)
      self?.pop(animated: true)
    }
  }
  
  open override func didReceiveCurrentEdit(_ edit: EditingStack.Edit) {
    
    slider.set(value: edit.filters.vibrance?.vibrance ?? 0, in: FilterVibrance.Params.vibrance)
    
  }
  
  @objc
  private func valueChanged() {
    
    let value = slider.transition(in: FilterSharpen.Params.sharpness)
    
    guard value != 0 else {
      context.action(.setFilter({ $0.sharpen = nil }))
      return
    }
    
    var f = FilterVibrance()
    f.vibrance = value
    context.action(.setFilter({ $0.vibrance = f }))
  }
  
}
