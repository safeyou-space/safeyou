//
//  progressBarView.swift
//  SafeYou
//
//  Created by armen sahakian on 19.07.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

import UIKit

final class progressBarView: UIView {
    var leftLabelText = "1"
    var rightLabelText = "4"
    
    // MARK: - View Properties
    private var progressView: UIProgressView {
        let progress = UIProgressView(progressViewStyle: .bar)
        progress.trackTintColor = UIColor.blue
        return progress
    }
    
    private var leftLabel: UILabel {
        let label = UILabel()
        label.text = leftLabelText
        return label
    }
    
    private var rightLabel: UILabel {
        let label = UILabel()
        label.text = rightLabelText
        return label
    }

    // MARK: - Lifecycle
    init(frame: CGRect = .zero, leftLabelText: String, rightLabelText: String) {
      self.leftLabelText = leftLabelText
        self.rightLabelText = rightLabelText
      super.init(frame: frame)
      
      setupView()
      addSubviews()
      makeConstraints()
    }
    
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupView() {
     // backgroundColor = viewMetrics.backgroundColor
    }
    
    private func addSubviews() {
      addSubview(progressView)
    }
    
    private func makeConstraints() {
//      descriptionLabel.snp.makeConstraints { (make) in
//        make.left.right.top.equalToSuperview().inset(viewMetrics.descriptionLabelInsets)
//      }
    }
}
