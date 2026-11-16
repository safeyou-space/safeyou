//
//  ChooseCheckboxTableViewCell.swift
//  SafeYou
//
//  Created by armen sahakian on 08.11.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

import UIKit

class ChooseCheckboxTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellBackgroundView: SYDesignableView!
    @IBOutlet weak var checkboxButton: SYDesignableCheckBoxButton!
    @IBOutlet weak var descriptionLabel: SYDesignableLabel!
    
    var isSelectedBox = false
    var correctAnswer = false
    var selectedAnswer = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellBackgroundView.layer.masksToBounds = true
        cellBackgroundView.clipsToBounds       = true
        cellBackgroundView.layer.cornerRadius  = 8
        cellBackgroundView.layer.borderColor   = UIColor.mainTintColor2().cgColor
        descriptionLabel.textColor             = UIColor.black
        cellBackgroundView.layer.borderWidth   = 0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected && !isSelectedBox {
            cellSecelcted(selected: true)
        } else if selected && isSelectedBox {
            cellSecelcted(selected: false)
        }
    }
    
    @IBAction func checkboxButtonTap(_ sender: Any) {
        if isSelectedBox {
            cellSecelcted(selected: false)
        } else {
            cellSecelcted(selected: true)
        }
    }
    
    func cellSecelcted(selected: Bool) {
        if selected {
            cellBackgroundView.layer.borderWidth = 1
            cellBackgroundView.layer.borderColor = UIColor.purpleColor2().cgColor
            checkboxButton.isSelected = true
            isSelectedBox = true
        } else if !correctAnswer {
            cellBackgroundView.layer.borderWidth  = 0
            checkboxButton.isSelected = false
            isSelectedBox = false
        }
    }
    
    func showCorrectAnswer() {
        cellBackgroundView.layer.borderWidth = 1
        cellBackgroundView.layer.borderColor = UIColor.greenColor2().cgColor
        cellBackgroundView.backgroundColor   = UIColor.greenColor2().withAlphaComponent(0.2)
        correctAnswer = true
    }
    
    func showSelectedAnswer() {
        cellBackgroundView.layer.borderWidth = 1
        cellBackgroundView.layer.borderColor = UIColor.redColor3().cgColor
        cellBackgroundView.backgroundColor   = UIColor.redColor3().withAlphaComponent(0.5)
        selectedAnswer = true
        checkboxButton.isSelected = true
    }
}
