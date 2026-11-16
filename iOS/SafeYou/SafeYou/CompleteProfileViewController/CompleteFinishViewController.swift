//
//  CompleteFinishViewController.swift
//  SafeYou
//
//  Created by armen sahakian on 18.07.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

import UIKit

class CompleteFinishViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var backProfileButton: UIButton!
    @IBOutlet weak var thanksLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureView() {
        
        let agreementGif = UIImage.gifImageWithName("agreement")
        self.logoImageView.image = agreementGif
        
        backProfileButton.setTitle( Utilities.fetchTranslation(forKey: "back_to_profile_key"), for: .normal)
        thanksLabel.text = Utilities.fetchTranslation(forKey: "complete_profile_title")
    }

    // MARK: - Navigation
    @IBAction func backProfileButtonTap(_ sender: Any) {
        self.popToProfile()
    }
    
    func popToProfile() {
        let mainViewControllerVC = self.navigationController?.viewControllers.first(where: { (viewcontroller) -> Bool in
            return viewcontroller is ProfileViewController
        })
        if let mainViewControllerVC = mainViewControllerVC {
            navigationController?.popToViewController(mainViewControllerVC, animated: true)
        }
    }
}
