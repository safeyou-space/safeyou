//
//  SurveyFinishViewController.swift
//  SafeYou
//
//  Created by armen sahakian on 29.10.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

import UIKit

class SurveyFinishViewController: UIViewController {

    @IBOutlet weak var animationImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
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
        self.animationImageView.image = agreementGif
        self.descriptionLabel.text = Utilities.fetchTranslation(forKey: "survey_completed_description")
        self.backButton.setTitle( Utilities.fetchTranslation(forKey: "back_to_surveys_key"), for: .normal)
    }
    
    @IBAction func backButtonTap(_ sender: Any) {
         self.navigationController?.popToViewController((self.navigationController?.viewControllers[1]) as! SurveysListViewController, animated: true)
    }
}
