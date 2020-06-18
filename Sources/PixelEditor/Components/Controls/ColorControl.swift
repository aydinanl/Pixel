//
//  ColorControl.swift
//  PixelEngine
//
//  Created by Batuhan Saygili on 2020-05-12.
//  Copyright © 2020 muukii. All rights reserved.
//


import Foundation

import PixelEngine

open class ColorControlViewBase : ControlBase {

  public required override init(context: PixelEditContext) {
    super.init(context: context)
  }
}

open class ColorControlView : ColorControlViewBase {
  
  public enum DisplayType {
    case shadows
    case highlights
  }
  
  public var displayType: DisplayType = .shadows {
    didSet {
      guard oldValue != displayType else { return }
      set(displayType: displayType)
    }
  }
  
  var regularConstraints: [NSLayoutConstraint] = []
  
  var compactConstraints: [NSLayoutConstraint] = []
  
  private let containerView = UIView()
  
  public var shadowsColorControl:ColorShadowsControlBase!
  
  public var highlightsColorControl:ColorHighlightsControlBase!
  
  public let shadowsButton = UIButton(type: .system)
  
  public let highlightsButton = UIButton(type: .system)

  private let navigationView = NavigationView()
  
  open override func setup() {
    super.setup()
    
    backgroundColor = Style.default.control.backgroundColor
    
    shadowsColorControl = ColorShadowsControl(context: context)
    highlightsColorControl = ColorHighlightsControl(context: context)

    navigationView.didTapCancelButton = { [weak self] in
      self?.context.action(.revert)
      self?.pop(animated: true)
    }

    navigationView.didTapDoneButton = { [weak self] in
      self?.context.action(.commit)
      self?.pop(animated: true)
    }
    
    layout: do {
      let stackView = UIStackView(arrangedSubviews: [shadowsButton, highlightsButton])
      stackView.axis = .horizontal
      stackView.distribution = .fillEqually
      
      
      addSubview(stackView)
      addSubview(containerView)
      addSubview(navigationView)
      
      stackView.translatesAutoresizingMaskIntoConstraints = false
      containerView.translatesAutoresizingMaskIntoConstraints = false
      navigationView.translatesAutoresizingMaskIntoConstraints = false
      
      
      NSLayoutConstraint.activate([
        stackView.topAnchor.constraint(equalTo: stackView.superview!.topAnchor),
        stackView.leftAnchor.constraint(equalTo: stackView.superview!.leftAnchor),
        stackView.rightAnchor.constraint(equalTo: stackView.superview!.rightAnchor),
        
        containerView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
        containerView.rightAnchor.constraint(equalTo: containerView.superview!.rightAnchor),
        containerView.leftAnchor.constraint(equalTo: containerView.superview!.leftAnchor),
        
        navigationView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
        navigationView.rightAnchor.constraint(equalTo: navigationView.superview!.rightAnchor),
        navigationView.leftAnchor.constraint(equalTo: navigationView.superview!.leftAnchor),
        navigationView.bottomAnchor.constraint(equalTo: navigationView.superview!.bottomAnchor),
      ])
      
      regularConstraints = [stackView.heightAnchor.constraint(equalToConstant: 50)]
      compactConstraints = [stackView.heightAnchor.constraint(equalToConstant: 20)]
      
      activateCurrentConstraints()
    }
    
    body: do {
      shadowsButton.backgroundColor = UIColor.clear //Style.default.textColor.withAlphaComponent(0.1)
      highlightsButton.backgroundColor = UIColor.clear //Style.default.textColor.withAlphaComponent(0.1)
      
      shadowsButton.setTitle(L10n.editShadows, for: .normal)
      highlightsButton.setTitle(L10n.editHighlights, for: .normal)
      
      shadowsButton.tintColor = .clear
      highlightsButton.tintColor = .clear
      
      shadowsButton.setTitleColor(Style.default.textColor.withAlphaComponent(0.5), for: .normal)
      highlightsButton.setTitleColor(Style.default.textColor.withAlphaComponent(0.5), for: .normal)
      
      shadowsButton.setTitleColor(Style.default.textColor, for: .selected)
      highlightsButton.setTitleColor(Style.default.textColor, for: .selected)
      
      shadowsButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 17)
      highlightsButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 17)
      
      shadowsButton.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
      highlightsButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
    }
  }
  
  private func activateCurrentConstraints() {
    NSLayoutConstraint.deactivate(self.compactConstraints + self.regularConstraints)
    
    if self.traitCollection.verticalSizeClass == .regular {
      NSLayoutConstraint.activate(self.regularConstraints)
    }
    else {
      NSLayoutConstraint.activate(self.compactConstraints)
    }
  }
  
  open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    activateCurrentConstraints()
  }
  
  override open func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    if superview != nil {
      set(displayType: displayType)
    }
  }
  
  @objc
  private func didTapFilterButton() {
    displayType = .shadows
  }
  
  @objc
  private func didTapEditButton() {
    displayType = .highlights
  }
  
  private func set(displayType: DisplayType) {

    containerView.subviews.forEach { $0.removeFromSuperview() }

    shadowsButton.isSelected = false
    highlightsButton.isSelected = false

    
    switch displayType {
    case .shadows:

      shadowsColorControl.frame = containerView.bounds
      shadowsColorControl.autoresizingMask = [.flexibleWidth, .flexibleHeight]

      containerView.addSubview(shadowsColorControl)
      subscribeChangedEdit(to: shadowsColorControl)

      shadowsButton.isSelected = true

    case .highlights:

      highlightsColorControl.frame = containerView.bounds
      highlightsColorControl.autoresizingMask = [.flexibleWidth, .flexibleHeight]

      containerView.addSubview(highlightsColorControl)
      subscribeChangedEdit(to: highlightsColorControl)

      highlightsButton.isSelected = true
    }
  }
}
