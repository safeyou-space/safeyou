//
//  RateSurveyViewController.swift
//  SafeYou
//
//  Created by armen sahakian on 30.10.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

import UIKit

class RateSurveyViewController: SurveyBaseViewController, DialogViewDelegate {
    

    @IBOutlet var ratingImages: [SYDesignableImageView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.questionIndex = currentQuestionIndex
        self.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func configureView() {
        self.titleLabel.text       = surveyTitle
        self.descriptionLabel.text = surveyQuestions[questionIndex].translation.title
        if(surveyQuestions[questionIndex].isRequired == 1) {
            self.descriptionLabel.text = surveyQuestions[questionIndex].translation.title + " *"
            self.answerIsRequired      = true
        }
        
        self.progressBackgroundView.layer.shadowColor   = UIColor.lightGray.cgColor
        self.progressBackgroundView.layer.shadowOpacity = 0.5
        self.progressBackgroundView.layer.shadowOffset  = CGSize(width: 0, height: 2)
        self.progressBackgroundView.layer.cornerRadius  = 13
        self.progressBackgroundView.layer.masksToBounds = false
        
        self.progressView.clipsToBounds      = true
        self.progressView.layer.cornerRadius = 4
        self.progressView.trackTintColor     = UIColor.mainTintColor5()
        self.progressView.progress           =  Float(questionIndex + 1) / Float(surveyQuestions.count)
        self.progressLabel.text              = "\(questionIndex + 1) of \(surveyQuestions.count)"
        
        self.previousButton.layer.borderWidth  = 1
        self.previousButton.layer.borderColor  = UIColor.mainTintColor1().cgColor
        
        self.previousButton.setTitle( Utilities.fetchTranslation(forKey: "previous_key"), for: .normal)
        if surveyQuestions.count == questionIndex + 1 {
            if quizIsAnswered {
                nextButton.setTitle( Utilities.fetchTranslation(forKey: "close_key"), for: .normal)
            } else {
                nextButton.setTitle( Utilities.fetchTranslation(forKey: "complete_key"), for: .normal)
            }
        } else {
            nextButton.setTitle( Utilities.fetchTranslation(forKey: "next_key"), for: .normal)
        }
        
        self.questionType = self.surveyQuestions[self.questionIndex].type
        self.configureRatingImages()
        let questionID = surveyQuestions[self.currentQuestionIndex].questionID
        if let currentRateString = self.answersDict.questions["\(questionID)"] as? String {
            self.drawSelectedImage(selectedRating: Int(currentRateString) ?? 0)
            self.isAnswered = true
        }
        
        if currentQuestionIndex == 0 {
            self.previousButton.isHidden = true
        } else {
            self.previousButton.isHidden = false
        }
    }
    
    func showConfirmActionDialog() {
        let activateCamouflageIconDialogView = DialogViewController.instansiateDialogView(with: .buttonAction)
        activateCamouflageIconDialogView.showCancelButton = true
        activateCamouflageIconDialogView.delegate         = self
        activateCamouflageIconDialogView.continueButtonText = NSLocalizedString("close_key", comment: "")
        activateCamouflageIconDialogView.titleText = NSLocalizedString("close_survey_title_key", comment: "")
        activateCamouflageIconDialogView.message   = NSLocalizedString("close_survey_description_key", comment: "")
        addChild(activateCamouflageIconDialogView)
        self.view.addSubview(activateCamouflageIconDialogView.view)
    }
    
    // MARK: - Actions
    @IBAction func closeButtonTap(_ sender: Any) {
        showConfirmActionDialog()
    }
    
    @IBAction func previousButtonTap(_ sender: Any) {
        delegate?.saveUserAnswersOnBackNavigation(answersDict)
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func nextButtonTap(_ sender: Any) {
        if !isAnswered && answerIsRequired {
            self.showPopup()
            return
        }

        self.showNextQuestion()

//        switch surveyQuestions[questionIndex + 1].type {
//        case "text_answer":
//            let viewController = UIStoryboard.init(name: "OpenSurvey", bundle: Bundle.main).instantiateViewController(withIdentifier: "TextSurveyViewController") as? TextSurveyViewController
//            viewController?.surveyQuestions = surveyQuestions
//            viewController?.currentQuestionIndex = questionIndex + 1
//            viewController?.surveyId = surveyId
//            viewController?.surveyTitle = surveyTitle
//            viewController?.answersDict = answersDict
//            viewController?.delegate = self
//            self.navigationController?.pushViewController(viewController!, animated: false)
//            
//        case "multiple_choice", "checkbox":
//            let viewController = UIStoryboard.init(name: "OpenSurvey", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChooseOptionSurveyViewController") as? ChooseOptionSurveyViewController
//            viewController?.surveyQuestions = surveyQuestions
//            viewController?.currentQuestionIndex = questionIndex + 1
//            viewController?.surveyId = surveyId
//            let isCheckbox = surveyQuestions[questionIndex + 1].type == "multiple_choice" ? true : false
//            viewController?.multipleChoice = isCheckbox
//            viewController?.surveyTitle = surveyTitle
//            viewController?.answersDict = answersDict
//            viewController?.delegate = self
//            self.navigationController?.pushViewController(viewController!, animated: false)
//            
//        default:
//            let viewController = UIStoryboard.init(name: "OpenSurvey", bundle: Bundle.main).instantiateViewController(withIdentifier: "RateSurveyViewController") as? RateSurveyViewController
//            viewController?.surveyQuestions = surveyQuestions
//            viewController?.currentQuestionIndex = questionIndex + 1
//            viewController?.surveyId = surveyId
//            viewController?.surveyTitle = surveyTitle
//            viewController?.answersDict = answersDict
//            viewController?.delegate = self
//            self.navigationController?.pushViewController(viewController!, animated: false)
//        }
    }
    
    private func configureRatingImages() {
        let imageName = self.getCurrentImage(filled: false)
        ratingImages.forEach {
            $0.image = UIImage(named: imageName)
            $0.imageColorType = Int(SYColorType.colorTypeMain1.rawValue)
            $0.imageColorAlpha = 1
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(rateImageTapped(tapGestureRecognizer:)))
            
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    private func drawSelectedImage(selectedRating: Int) {
        let imageName = self.getCurrentImage(filled: false)
        ratingImages.forEach {
            $0.image = UIImage(named: imageName)
            $0.imageColorType = Int(SYColorType.colorTypeMain1.rawValue)
            $0.imageColorAlpha = 1
        }
        
        let filledImageName = self.getCurrentImage(filled: true)
        for i in 0..<selectedRating {
            ratingImages[i].image = UIImage(named: filledImageName)
            ratingImages[i].imageColorType = Int(SYColorType.colorTypeMain1.rawValue)
            ratingImages[i].imageColorAlpha = 1
        }
    }
    
    @objc func rateImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        self.drawSelectedImage(selectedRating: tappedImage.tag)
        
        let questionID = surveyQuestions[self.currentQuestionIndex].questionID
        answersDict.questions["\(questionID)"] = "\(tappedImage.tag)"
        self.isAnswered = true
    }
    
    private func getCurrentImage(filled: Bool) -> String {
        if (self.questionType == "rating_heart") {
            return filled ? "icon_rate_heart_full" : "icon_rate_heart_outline"
        }
        if (self.questionType == "rating_smiley_face") {
            return filled ? "icon_rate_smile_full" : "icon_rate_smile_outline"
        }
        return filled ? "icon_rate_star_full" : "icon_rate_star_outline"
    }
    
    // MARK: - DialogViewController
    func dialogViewDidPressActionButton(_ dialogView: DialogViewController) {
        popToSurveysList(animation: false)
    }
    
    func dialogViewDidCancel(_ dialogView: DialogViewController) {
        dialogView.dismiss(animated: false) {
            if let tabBarController = self.tabBarController as? MainTabbarController {
                tabBarController.hideTabbar(true)
            }
        }
    }
}

extension RateSurveyViewController: OpenSurveyDelegate {
    func saveUserAnswersOnBackNavigation(_ answersDict: OpenSurveyAnswersDataModel) {
        self.answersDict = answersDict
    }
}
