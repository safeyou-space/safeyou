//
//  ChooseSurveyOptionTableViewCell.swift
//  SafeYou
//
//  Created by armen sahakian on 02.11.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

import UIKit

class ChooseSurveyOptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellBackgroundView: SYDesignableView!
    @IBOutlet weak var selectedimageView: SYDesignableImageView!
    @IBOutlet weak var unselectedImageView: SYDesignableImageView!
    @IBOutlet weak var descriptionLabel: SYDesignableLabel!
    
    var correctAnswer = false
    var selectedAnswer = false

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectedimageView.isHidden = true
        cellBackgroundView.layer.masksToBounds = true
        cellBackgroundView.clipsToBounds = true
        cellBackgroundView.layer.cornerRadius = 8
        cellBackgroundView.layer.borderWidth  = 1
        cellBackgroundView.layer.borderColor  = UIColor.mainTintColor2().cgColor
        descriptionLabel.textColor = UIColor.black
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            if selectedimageView.isHidden {
                cellBackgroundView.layer.borderWidth = 1
                cellBackgroundView.layer.borderColor = UIColor.purpleColor2().cgColor
                selectedimageView.isHidden = false
            } else {
                cellBackgroundView.layer.borderWidth = 0
                selectedimageView.isHidden = true
            }
        } else if !correctAnswer  && !selectedAnswer {
            cellBackgroundView.layer.borderWidth = 0
            selectedimageView.isHidden = true
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
        selectedimageView.isHidden = false
        selectedAnswer = true
    }
}
