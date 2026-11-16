//
//  CompleteQuestionTableViewCell.swift
//  SafeYou
//
//  Created by armen sahakian on 19.07.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

import UIKit

class CompleteQuestionTableViewCell: UITableViewCell {
    @IBOutlet weak var optionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        optionButton.layer.cornerRadius = 8
       // optionButton.setTitleColor(UIColor.black, for: .normal)
        optionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        optionButton.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    // MARK: - Navigation
    @IBAction func optionButtonTap(_ sender: Any) {
//        isSelected = !isSelected
//        isSelected ? self.setSelectedStyle() : self.setDeselectedStyle()
//       // self.setSelectedStyle()
    }
    
    func setSelectedStyle() {
        optionButton.layer.borderWidth = 1
        optionButton.layer.borderColor = UIColor.mainTintColor1().cgColor
        optionButton.setTitleColor(UIColor.mainTintColor1(), for: .normal)
    }
    func setDeselectedStyle() {
        optionButton.layer.borderWidth = 0
        optionButton.setTitleColor(UIColor.black, for: .normal)
    }
    func setSelect(selected: Bool) {
        selected ? setSelectedStyle() : setDeselectedStyle()
    }
}
