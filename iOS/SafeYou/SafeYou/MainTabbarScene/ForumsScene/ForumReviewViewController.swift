//
//  ForumReviewViewController.swift
//  SafeYou
//
//  Created by Edgar on 14.02.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

import UIKit

class ForumReviewViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var forumDetailsView: UIView!
    @IBOutlet weak var forumImageView: UIImageView!
    @IBOutlet weak var forumTitleLabel: UILabel!
    @IBOutlet weak var forumAuthorLabel: SYDesignableLabel!
    @IBOutlet weak var forumDateLabel: UILabel!
    @IBOutlet weak var askToRateLabel: SYDesignableLabel!
    @IBOutlet weak var reviewCountsLabel: SYDesignableLabel!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var reviewInfoLabel: SYDesignableLabel!
    @IBOutlet weak var submitButton: SYCorneredButton!
    @IBOutlet weak var cancelButton: SYDesignableButton!
    
    @IBOutlet var ratingImages: [SYDesignableImageView]!
    
    var forumItemData: ForumItemDataModel?
    var forumService: SYForumService?
    
    private var userRate: Int?
    private var userReviewComment: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureForumView()
        downloadUserImage()
        
        self.forumTitleLabel.text = self.forumItemData?.title
        self.forumAuthorLabel.text = self.forumItemData?.author
        self.forumDateLabel.text = convertDate(self.forumItemData?.createdAt)
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Utilities.fetchTranslation(forKey: "my_review")
    }
    
    // MARK: - Actions
    
    @IBAction func submitButtonAction(_ sender: SYCorneredButton) {
        if let forumId = self.forumItemData?.forumItemId,
           let rating = self.userRate {
            
            var forumReviewData: [String: Any] = [
                "forum_id": forumId,
                "rate": rating
            ]
            if userReviewComment != nil {
                forumReviewData["comment"] = self.userReviewComment
            }
            
            forumService?.addReview(forumReviewData, success: { success in
                let okButtonTitle = Utilities.fetchTranslation(forKey: "ok")
                self.forumItemData?.reviewData.rate = rating
                self.forumItemData?.reviewData.comment = self.userReviewComment
                
                self.showAlertView(withTitle: "",
                                   withMessage: success,
                                   cancelButtonTitle: nil,
                                   okButtonTitle: okButtonTitle,
                                   cancelAction: nil,
                                   okAction: self.closePresentedView)
            }, failure: { error in
                self.handleRatingError(error: error)
            })
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.closePresentedView()
    }
    
    // MARK: - objc functions
    
    @objc func setForumItemData(_ data: ForumItemDataModel) {
        self.forumItemData = data
    }
    
    @objc func rateImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        ratingImages.forEach {
            $0.image = UIImage(named: "icon_like")
            $0.imageColorType = Int(SYColorType.colorTypeMain1.rawValue)
            $0.imageColorAlpha = 1
        }
        
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        for i in 0..<tappedImage.tag {
            ratingImages[i].image = UIImage(named: "icon_like_selected")
            ratingImages[i].imageColorType = Int(SYColorType.colorTypeMain1.rawValue)
            ratingImages[i].imageColorAlpha = 1
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
    
    // MARK: - Private functions
    
    private func configureView() {
        let currentRating = self.forumItemData?.reviewData.rate ?? 0
        
        if currentRating > 0 {
            self.askToRateLabel.isHidden = true
            self.reviewCountsLabel.isHidden = true
            self.reviewInfoLabel.isHidden = true
            self.submitButton.isHidden = true
            self.cancelButton.isHidden = true
            self.reviewTextView.text = self.forumItemData?.reviewData.comment
            self.reviewTextView.isEditable = false
            
            for i in 0..<currentRating {
                self.ratingImages[i].image = UIImage(named: "icon_like_selected")
                self.ratingImages[i].imageColorType = Int(SYColorType.colorTypeMain1.rawValue)
                self.ratingImages[i].imageColorAlpha = 1
            }
        } else {
            self.forumService = SYForumService()
            self.reviewTextView.delegate = self
            self.reviewTextView.textColor = UIColor.darkGray()
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
            view.addGestureRecognizer(tap)
            
            configureRatingImages()
            updateSubmitButton()
            updateLocalizations()
            updateMinimumReviewCountText(length: 0)
        }
    }
    
    private func configureRatingImages() {
        ratingImages.forEach {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(rateImageTapped(tapGestureRecognizer:)))
            
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    private func configureForumView() {
        self.forumDetailsView.layer.cornerRadius = 10
        self.forumDetailsView.layer.masksToBounds = false
        self.forumDetailsView.layer.shadowColor = UIColor.black.cgColor
        self.forumDetailsView.layer.shadowOpacity = 1
        self.forumDetailsView.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.forumDetailsView.layer.shadowRadius = 3
    }
    
    private func convertDate(_ date: String?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ssssZ"
        dateFormatter.locale = Locale.current
        
        if let date = date,
           let receivedDate = dateFormatter.date(from: date) {
            dateFormatter.dateFormat = "dd/MM/yyyy, HH:mm"
            let formatedDateString = dateFormatter.string(from: receivedDate)
            return formatedDateString
        }
        return ""
    }
    
    private func updateMinimumReviewCountText(length: Int) {
        let v = String(format: Utilities.fetchTranslation(forKey: "min_rate_characters"))
        if length < 25 {
            self.reviewCountsLabel.text = "\(Utilities.fetchTranslation(forKey: "review")) (\(String(format: Utilities.fetchTranslation(forKey: "min_rate_characters"), (25 - length))))"
        } else {
            self.reviewCountsLabel.text = ""
        }
    }
    
    private func updateSubmitButton() {
        if userRate != nil && (userReviewComment == nil || userReviewComment?.count ?? 0 >= 25) {
            submitButton.isEnabled = true
        } else {
            submitButton.isEnabled = false
        }
    }
    
    private func updateLocalizations() {
        self.askToRateLabel.text = Utilities.fetchTranslation(forKey: "what_rate_forum")
        self.reviewTextView.text = Utilities.fetchTranslation(forKey: "rate_placeholder")
        self.reviewInfoLabel.text = Utilities.fetchTranslation(forKey: "review_visible_text")
        self.submitButton.setTitle(Utilities.fetchTranslation(forKey: "submit_title_key"), for: .normal)
        self.cancelButton.setTitle(Utilities.fetchTranslation(forKey: "cancel"), for: .normal)
    }
    
    private func downloadUserImage() {
        DispatchQueue.global().async {
            if let url = self.forumItemData?.imageData.imageFullURL(),
                let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.forumImageView.image = image
                    }
                }
            }
        }
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
            userReviewComment = textView.text
        }
        if textView.text.isEmpty {
            userReviewComment = nil
        }
        updateSubmitButton()
    }

}
