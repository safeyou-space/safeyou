//
//  ChooseLocationTableViewCell.swift
//  SafeYou
//
//  Created by armen sahakian on 02.08.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

import UIKit

class ChooseLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var designableview: SYDesignableView!
    @IBOutlet weak var nameLabel: SYDesignableLabel!
    @IBOutlet weak var deselectImageView: SYDesignableImageView!
    @IBOutlet weak var selectImageview: SYDesignableImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectImageview.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(for optionName: String) {
        nameLabel.text = optionName
    }
     
    func setSelect(selected: Bool) {
        self.selectImageview.isHidden = !selected
        self.deselectImageView.isHidden = selected
    }
}
