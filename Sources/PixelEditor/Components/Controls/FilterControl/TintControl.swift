//
//  TintControl.swift
//  PixelEngine
//
//  Created by Batuhan Saygili on 2020-05-06.
//  Copyright © 2020 muukii. All rights reserved.
//

import Foundation

import PixelEngine


open class TintControlBase : FilterControlBase {
  
  public required init(context: PixelEditContext) {
    super.init(context: context)
  }
}

open class TintControl : TintControlBase {
  
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
    
    slider.set(value: edit.filters.tint?.value ?? 0, in: FilterTint.range)
    
  }
  
  @objc
  private func valueChanged() {
    
    let value = slider.transition(in: FilterTint.range)
    
    guard value != 0 else {
      context.action(.setFilter({ $0.tint = nil }))
      return
    }
    
    var f = FilterTint()
    f.value = value
    context.action(.setFilter({ $0.tint = f }))
  }
  
}
