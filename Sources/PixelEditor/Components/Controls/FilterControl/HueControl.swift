//
//  HueControl.swift
//  PixelEngine
//
//  Created by Batuhan Saygili on 2020-05-12.
//  Copyright © 2020 muukii. All rights reserved.
//


import Foundation

import PixelEngine


open class HueControlBase : FilterControlBase {
  
  public required init(context: PixelEditContext) {
    super.init(context: context)
  }
}

open class HueControl : HueControlBase {
  
  open override var title: String {
    return L10n.editTint
  }
  
  private let navigationView = NavigationView()
  
  public let slider = StepSlider(frame: .zero)
  
  open override func setup() {
    super.setup()
    
    backgroundColor = Style.default.control.backgroundColor
    
    TempCode.layout(navigationView: navigationView, slider: slider, in: self)
    
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
    
    slider.set(value: edit.filters.hue?.value ?? 0, in: FilterHue.range)
    
  }
  
  @objc
  private func valueChanged() {
    
    let value = slider.transition(in: FilterHue.range)
    
    guard value != 0 else {
      context.action(.setFilter({ $0.hue = nil }))
      return
    }
    
    var f = FilterHue()
    f.value = value
    context.action(.setFilter({ $0.hue = f }))
  }
  
}
