//
//  ngoReviewViewController.swift
//  SafeYou
//
//  Created by Edgar on 15.02.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

import UIKit

class NGOReviewViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var ngoDetailsView: UIView!
    @IBOutlet weak var ngoImageView: UIImageView!
    @IBOutlet weak var ngoTitleLabel: UILabel!
    @IBOutlet weak var askToRateLabel: SYDesignableLabel!
    @IBOutlet weak var reviewCountsLabel: SYDesignableLabel!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var reviewInfoLabel: SYDesignableLabel!
    @IBOutlet weak var submitButton: SYCorneredButton!
    @IBOutlet weak var cancelButton: SYDesignableButton!
    
    @IBOutlet weak var editButton: SYDesignableButton!
    @IBOutlet var ratingImages: [SYDesignableImageView]!
    
    var ngoData: EmergencyServiceDataModel?
    var ngoService: EmergencyServicesApi?
    
    private var userRate: Int?
    private var userReviewComment: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureDetailsView()
        configureNgoImages()
        
        self.ngoTitleLabel.text = self.ngoData?.name
        
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Utilities.fetchTranslation(forKey: "my_review")
    }
    
    // MARK: - Actions
    
    @IBAction func submitButtonAction(_ sender: SYDesignableButton) {
        if let ngoId = self.ngoData?.serviceId,
            let rating = self.userRate,
            let reviewComment = self.userReviewComment {

            let ngoReviewData: [String: Any] = [
                "emergency_service_id": ngoId,
                "rate": rating,
                "comment": reviewComment
            ]
            ngoService?.addReview(ngoReviewData, success: { success in
                let okButtonTitle = Utilities.fetchTranslation(forKey: "ok")
                self.ngoData?.reviewData.rate = rating
                self.ngoData?.reviewData.comment = self.userReviewComment

                self.showAlertView(withTitle: "",
                                   withMessage: success,
                                   cancelButtonTitle: nil,
                                   okButtonTitle: okButtonTitle,
                                   cancelAction: nil,
                                   okAction: self.closePresentedView)
            }, failure: { error in
                self.handleRatingError(error: error!)
            })
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.closePresentedView()
    }
    
    @IBAction func editButtonAction(_ sender: SYDesignableButton) {
        configureViewAsNeedUpdate()
    }
    
    
    // MARK: - objc functions
    
    @objc func setNgoData(_ data: EmergencyServiceDataModel) {
        self.ngoData = data
    }

    @objc func rateImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        ratingImages.forEach {
            $0.image = UIImage(systemName: "star")
        }
        
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        for i in 0..<tappedImage.tag {
            ratingImages[i].image = UIImage(systemName: "star.fill")
        }
        
        userRate = tappedImage.tag
        updateSubmitButton()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func closePresentedView() {
        self.navigationController?.popViewController(animated: true)
    }

    
    // MARK: - Configs
    
    private func configureDetailsView() {
        self.ngoDetailsView.layer.cornerRadius = 10
        self.ngoDetailsView.layer.masksToBounds = false
        self.ngoDetailsView.layer.shadowColor = UIColor.black.cgColor
        self.ngoDetailsView.layer.shadowOpacity = 1
        self.ngoDetailsView.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.ngoDetailsView.layer.shadowRadius = 3
    }
    
    private func configureNgoImages() {
        DispatchQueue.global().async {
            if let url = self.ngoData?.image.imageFullURL(),
                let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.ngoImageView.image = image
                    }
                }
            }
        }
    }
    
    private func configureView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        updateLocalizations()
        ratingImages.forEach {
            $0.tintColor = UIColor.mainTintColor1()
        }
        
        let currentRating = self.ngoData?.reviewData.rate ?? 0
        if currentRating > 0 {
            configureViewAsReviewed(currentRating: currentRating)
        } else {
            configureViewAsNeedReview()
        }
    }
    
    private func configureViewAsNeedReview() {
        self.ngoService = EmergencyServicesApi()
        self.reviewTextView.delegate = self
        self.reviewTextView.textColor = UIColor.darkGray()
        self.editButton.isHidden = true
        
        configureRatingImages()
        updateSubmitButton()
        updateMinimumReviewCountText(length: 0)
    }
    
    private func configureViewAsNeedUpdate() {
        self.ngoService = EmergencyServicesApi()
        self.reviewTextView.delegate = self
        self.reviewTextView.textColor = UIColor.black
        self.editButton.isHidden = true
        
        self.askToRateLabel.isHidden = false
        self.reviewCountsLabel.isHidden = false
        self.reviewInfoLabel.isHidden = false
        self.submitButton.isHidden = false
        self.cancelButton.isHidden = false
        self.reviewTextView.text = self.ngoData?.reviewData.comment
        self.reviewTextView.isEditable = true
        
        
        configureRatingImages()
        updateSubmitButton()
        updateMinimumReviewCountText(length: self.ngoData?.reviewData.comment.count ?? 0)
    }
    
    private func configureViewAsReviewed(currentRating: Int) {
        self.askToRateLabel.isHidden = true
        self.reviewCountsLabel.isHidden = true
        self.reviewInfoLabel.isHidden = true
        self.submitButton.isHidden = true
        self.cancelButton.isHidden = true
        self.reviewTextView.text = self.ngoData?.reviewData.comment
        self.reviewTextView.isEditable = false
        self.editButton.isHidden = false
        
        for i in 0..<currentRating {
            self.ratingImages[i].image = UIImage(systemName: "star.fill")
        }
    }
    
    private func updateSubmitButton() {
        if userRate != nil && userReviewComment?.count ?? 0 >= 25 {
            submitButton.isEnabled = true
        } else {
            submitButton.isEnabled = false
        }
    }
    
    private func updateMinimumReviewCountText(length: Int) {
        if length < 25 {
            self.reviewCountsLabel.text = "\(Utilities.fetchTranslation(forKey: "review")) (\(String(format: Utilities.fetchTranslation(forKey: "min_rate_characters"), (25 - length))))"
        } else {
            self.reviewCountsLabel.text = ""
        }
    }
    
    private func configureRatingImages() {
        ratingImages.forEach {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(rateImageTapped(tapGestureRecognizer:)))
            
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    private func updateLocalizations() {
        self.askToRateLabel.text = Utilities.fetchTranslation(forKey: "what_rate_forum")
        self.reviewTextView.text = Utilities.fetchTranslation(forKey: "rate_placeholder")
        self.reviewInfoLabel.text = Utilities.fetchTranslation(forKey: "review_visible_text")
        self.submitButton.setTitle(Utilities.fetchTranslation(forKey: "submit_title_key"), for: .normal)
        self.cancelButton.setTitle(Utilities.fetchTranslation(forKey: "cancel"), for: .normal)
    }
    
    func handleRatingError(error: Error) {
        var errorMessage = ""
        let errorInfo = (error as NSError).userInfo
        let errorsDict = errorInfo["errors"] as? Dictionary<String, Any>
        if let message = (errorsDict?.values.first as? Array<String>)?.first {
            errorMessage = message
        } else {
            errorMessage = errorInfo["message"] as? String ?? ""
        }
        
        let okButtonTitle = Utilities.fetchTranslation(forKey: "ok")
        self.showAlertView(withTitle: nil,
                           withMessage: errorMessage,
                           cancelButtonTitle: nil,
                           okButtonTitle: okButtonTitle,
                           cancelAction: nil,
                           okAction: closePresentedView)
    }
    
    // MARK: - Text View delegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.darkGray() {
            textView.text = nil
            textView.textColor = UIColor.black
            updateSubmitButton()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        userReviewComment = textView.text
        if textView.text.isEmpty {
            userReviewComment = nil
            self.reviewTextView.textColor = UIColor.darkGray()
            self.reviewTextView.text = Utilities.fetchTranslation(forKey: "rate_placeholder")
        }
        updateSubmitButton()
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if textView.textColor != UIColor.darkGray() {
            updateMinimumReviewCountText(length: textView.text.count)
        }
        userReviewComment = textView.text
        updateSubmitButton()
    }

}
