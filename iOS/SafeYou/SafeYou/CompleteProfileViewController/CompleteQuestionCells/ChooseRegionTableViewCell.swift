//
//  ChooseRegionTableViewCell.swift
//  SafeYou
//
//  Created by armen sahakian on 09.08.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

import UIKit

class ChooseRegionTableViewCell: UITableViewCell {

    @IBOutlet weak var designableview: SYDesignableView!
    
    @IBOutlet weak var nameLabel: SYLabelRegular!
    
    @IBOutlet weak var deselectImageView: SYDesignableImageView!

    @IBOutlet weak var selectImageview: SYDesignableImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectImageview.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(for optionName: String) {
        nameLabel.text = optionName
//        setIsSelect(isSelect)
//        setIsMultiSelect(isMultiSelect)
    }
     
    func setSelect(selected: Bool) {
        self.selectImageview.isHidden = !selected
        self.deselectImageView.isHidden = selected
    }
}

