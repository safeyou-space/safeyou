//
//  CompleteProfileDialogViewController.swift
//  SafeYou
//
//  Created by armen sahakian on 17.09.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

import UIKit

@objc protocol CompleteProfileDialogDelegate {
    func didCompleteProfile()
}

class CompleteProfileDialogViewController: UIViewController {

    @IBOutlet weak var closeButton: SYDesignableButton!
    @IBOutlet weak var progressview: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var completeTitleLabel: UILabel!
    @IBOutlet weak var completeLabel: UILabel!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var completeButton: SYCorneredButton!
    @IBOutlet weak var remineButton: SYDesignableButton!
    
    @objc var progressPercentage: Double = 0.6
    @objc var progressPercentageString: String = "60%"
    @objc var delegate: CompleteProfileDialogDelegate?

    
    fileprivate(set) lazy var circularProgressBarView: CircularProgressBarView = {
      let circularProgressBarView = CircularProgressBarView()

      return circularProgressBarView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    func configureView() {
        self.progressLabel.text = progressPercentageString
        self.progressview.addSubview(circularProgressBarView)
        circularProgressBarView.translatesAutoresizingMaskIntoConstraints = false
        circularProgressBarView.centerXAnchor.constraint(equalTo: progressview.centerXAnchor).isActive = true
        circularProgressBarView.centerYAnchor.constraint(equalTo: progressview.centerYAnchor).isActive = true
        // Start the progress animation
        circularProgressBarView.progressAnimation(duration: 0.3, toValue: progressPercentage)
        
        completeTitleLabel.text = Utilities.fetchTranslation(forKey: "profile_completeness")
        completeLabel.text = Utilities.fetchTranslation(forKey: "profile_completeness_description")
        completeButton.setTitle( Utilities.fetchTranslation(forKey: "profile_complete_key"), for: .normal)
        remineButton.setTitle( Utilities.fetchTranslation(forKey: "remind_me_later"), for: .normal)
    }


    @IBAction func closeButtonTap(_ sender: Any) {
        self.hideDialog()
    }
    
    @IBAction func completeButtonTap(_ sender: Any) {
        self.delegate?.didCompleteProfile()
        self.hideDialog()
    }
    
    @IBAction func remineButtonTap(_ sender: Any) {
        self.hideDialog()
    }
    
    func hideDialog() {
        if self.parent != nil {
            willMove(toParent: nil)
            removeFromParent()
            view.removeFromSuperview()
        } else if presentingViewController != nil {
            dismiss(animated: true, completion: nil)
        }
    }

}
