//
//  FilterNoiseReductionControl.swift
//  PixelEngine
//
//  Created by Batuhan Saygili on 2020-05-06.
//  Copyright © 2020 muukii. All rights reserved.
//


import Foundation

import PixelEngine

open class  NoiseReductionControlBase: FilterControlBase {
  
  public required init(context: PixelEditContext) {
    super.init(context: context)
  }
}

open class NoiseReductionControl : NoiseReductionControlBase {
  
  open override var title: String {
    return L10n.editNoiseReduction
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
    
    slider.set(value: edit.filters.noiseReduction?.noiseLevel ?? 0, in: FilterNoiseReduction.Params.noiseLevel)
    
  }
  
  @objc
  private func valueChanged() {
    
    let value = slider.transition(in: FilterNoiseReduction.Params.noiseLevel)
    
    guard value != 0 else {
      context.action(.setFilter({ $0.noiseReduction = nil }))
      return
    }
    
    var f = FilterNoiseReduction()
    f.noiseLevel = value
    context.action(.setFilter({ $0.noiseReduction = f }))
  }
  
}
