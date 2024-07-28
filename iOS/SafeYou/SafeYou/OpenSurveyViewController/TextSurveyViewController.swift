//
//  TextSurveyViewController.swift
//  SafeYou
//
//  Created by armen sahakian on 30.10.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

import UIKit

class TextSurveyViewController: SurveyBaseViewController, DialogViewDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!

    var textViewPlaceholder = Utilities.fetchTranslation(forKey: "short_text_answer_hint")
    var textViewHeightConstraint = 40.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.questionIndex = currentQuestionIndex
        if self.surveyQuestions[questionIndex].isLongAnswer == 1 {
            textViewPlaceholder = Utilities.fetchTranslation(forKey: "long_text_answer_hint")
            textViewHeightConstraint = 144.0
        }
        self.textView.delegate = self
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)

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
        
        self.textViewHeight.constant = textViewHeightConstraint
        self.textView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        self.textView.layer.borderColor  = UIColor.purpleColor4().cgColor
        self.textView.layer.borderWidth  = 1.0
        self.textView.layer.cornerRadius = 8.0
        let questionID = surveyQuestions[currentQuestionIndex].questionID
        if let filledText = self.answersDict.questions["\(questionID)"] as? String {
            self.isAnswered = true
            self.textView.textColor = UIColor.black
            self.textView.text = filledText
        } else {
            self.isAnswered = false
            self.textView.textColor = UIColor.darkGray()
            self.textView.text = textViewPlaceholder
        }
        
        previousButton.setTitle( Utilities.fetchTranslation(forKey: "previous_key"), for: .normal)
        if surveyQuestions.count == questionIndex + 1 {
            if quizIsAnswered {
                nextButton.setTitle( Utilities.fetchTranslation(forKey: "close_key"), for: .normal)
            } else {
                nextButton.setTitle( Utilities.fetchTranslation(forKey: "complete_key"), for: .normal)
            }
        } else {
            nextButton.setTitle( Utilities.fetchTranslation(forKey: "next_key"), for: .normal)
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
        activateCamouflageIconDialogView.delegate = self
        activateCamouflageIconDialogView.continueButtonText = NSLocalizedString("close_key", comment: "")
        activateCamouflageIconDialogView.titleText = NSLocalizedString("close_survey_title_key", comment: "")
        activateCamouflageIconDialogView.message = NSLocalizedString("close_survey_description_key", comment: "")
        addChild(activateCamouflageIconDialogView)
        self.view.addSubview(activateCamouflageIconDialogView.view)
    }
    
    func saveAnswer() {
        if textView.text.count > 0 &&
            textView.textColor == UIColor.black &&
            !textView.text.trimmingCharacters(in: .whitespaces).isEmpty {
            self.isAnswered = true
            let questionID = surveyQuestions[currentQuestionIndex].questionID
            answersDict.questions["\(questionID)"] = "\(textView.text ?? "")"
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Actions
    @IBAction func closeButtonTap(_ sender: Any) {
        self.showConfirmActionDialog()
    }
    
    @IBAction func previousButtonTap(_ sender: Any) {
        self.saveAnswer()
        delegate?.saveUserAnswersOnBackNavigation(answersDict)
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func nextButtonTap(_ sender: Any) {
        self.saveAnswer()
        
        if !isAnswered && answerIsRequired {
            self.showPopup()
            return
        }

        self.showNextQuestion()

//        switch surveyQuestions[questionIndex + 1].type {
//            
//        case "text_answer":
//            let viewController = UIStoryboard.init(name: "OpenSurvey", bundle: Bundle.main).instantiateViewController(withIdentifier: "TextSurveyViewController") as? TextSurveyViewController
//            viewController?.surveyQuestions = surveyQuestions
//            viewController?.currentQuestionIndex = questionIndex + 1
//            viewController?.surveyId = surveyId
//            viewController?.surveyTitle = surveyTitle
//            viewController?.quizIsAnswered = quizIsAnswered
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
//            viewController?.quizIsAnswered = quizIsAnswered
//            viewController?.answersDict = answersDict
//            viewController?.delegate = self
//            self.navigationController?.pushViewController(viewController!, animated: false)
//        }
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

extension TextSurveyViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.darkGray() {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count > 0 && !textView.text.trimmingCharacters(in: .whitespaces).isEmpty {
            self.isAnswered = true
        } else {
            self.textView.textColor = UIColor.darkGray()
            self.textView.text = textViewPlaceholder
            self.isAnswered = false
        }
    }
}

extension TextSurveyViewController: OpenSurveyDelegate {
    func saveUserAnswersOnBackNavigation(_ answersDict: OpenSurveyAnswersDataModel) {
        self.answersDict = answersDict
    }
}
