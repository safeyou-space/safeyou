//
//  SurveyListCollectionViewCell.swift
//  SafeYou
//
//  Created by armen sahakian on 30.10.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

import UIKit

class SurveyListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var takeButton: UIButton!
    
    let colorsArray = [UIColor.syrveyItemColor1(), UIColor.syrveyItemColor2(), UIColor.syrveyItemColor3(), UIColor.syrveyItemColor4()]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.takeButton.titleLabel?.textAlignment = NSTextAlignment.center
        self.takeButton.layer.cornerRadius = 5
        self.takeButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        self.takeButton.imageView?.isHidden = true
    }
    
    func configureCell(index: Int) {
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.masksToBounds = true
        
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = false
        
        let currentIndex = index % 4
        self.contentView.backgroundColor = colorsArray[currentIndex]
        
        self.layer.shadowRadius = 8.0
        self.layer.shadowOpacity = 0.2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    func configSurvey(checking: Bool) {
        if checking {
            let origImage = UIImage(named: "icon-check")
            let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
            self.takeButton.setImage(tintedImage, for: .normal)
            self.takeButton.setTitle("", for: .normal)
            self.takeButton.imageView?.isHidden = false
        } else {
            let title = Utilities.fetchTranslation(forKey: "take_survey_key")
            self.takeButton.setTitle(title, for: .normal)
            let origImage = UIImage()
            let tintedImage = origImage.withRenderingMode(.alwaysTemplate)
            self.takeButton.setImage(tintedImage, for: .normal)
            self.takeButton.imageView?.isHidden = true
        }
    }
    
    func configQuiz(checking: Bool) {
        let origImage = UIImage()
        let tintedImage = origImage.withRenderingMode(.alwaysTemplate)
        self.takeButton.setImage(tintedImage, for: .normal)
        self.takeButton.imageView?.isHidden = true
        if checking {
            let title = Utilities.fetchTranslation(forKey: "see_result_key")
            self.takeButton.setTitle(title, for: .normal)
        } else {
            let title = Utilities.fetchTranslation(forKey: "take_quiz_key")
            self.takeButton.setTitle(title, for: .normal)
        }
    }
    
    @IBAction func takeButtonTap(_ sender: Any) {
    }
}
