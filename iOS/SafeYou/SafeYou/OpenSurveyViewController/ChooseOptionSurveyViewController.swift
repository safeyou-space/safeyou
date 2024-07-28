//
//  ChooseOptionSurveyViewController.swift
//  SafeYou
//
//  Created by armen sahakian on 30.10.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

import UIKit

class ChooseOptionSurveyViewController: SurveyBaseViewController, DialogViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var questionAnswer = false
    var userAnswer: UserAnswer?
    let cellSpacingHeight: CGFloat = 5.0

    var multipleChoice = false


    var checkboxAnswersArray:[Int] = []
    var selectedOption: Option?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let question =  self.currentQuestion {
            let questionID = question.questionID
            if let userSavedAnswer = self.answersDict.questions["\(questionID)"] as? [Int] {
                self.checkboxAnswersArray = userSavedAnswer
                self.questionAnswer = true
            }
        } else {
            self.currentQuestion = self.surveyQuestions[self.questionIndex]
            let questionID = surveyQuestions[currentQuestionIndex].questionID
            if let userSavedAnswer = self.answersDict.questions["\(questionID)"] as? [Int] {
                self.checkboxAnswersArray = userSavedAnswer
                self.questionAnswer = true
            }
        }

        self.configureView()
    }
    
    override func loadView() {
        super.loadView()
        self.tableView.sectionFooterHeight = cellSpacingHeight
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
        if let question = self.currentQuestion {
            self.descriptionLabel.text = self.currentQuestion?.translation.title
            if(question.isRequired == 1) {
                self.descriptionLabel.text = question.translation.title + " *"
                self.answerIsRequired = true
            }
        }
        
        self.progressBackgroundView.layer.shadowColor   = UIColor.lightGray.cgColor
        self.progressBackgroundView.layer.shadowOpacity = 0.5
        self.progressBackgroundView.layer.shadowOffset  = CGSize(width: 0, height: 2)
        self.progressBackgroundView.layer.cornerRadius  = 13
        self.progressBackgroundView.layer.masksToBounds = false
        
        self.progressView.clipsToBounds      = true
        self.progressView.layer.cornerRadius = 4
        self.progressView.trackTintColor     = UIColor.mainTintColor5()
        self.progressView.progress           =  Float(questionIndex + 1) / Float(self.surveyData!.numberOfQuestions())
        self.progressLabel.text              = "\(questionIndex + 1) of \(self.surveyData!.numberOfQuestions())"

        self.previousButton.layer.borderWidth  = 1
        self.previousButton.layer.borderColor  = UIColor.mainTintColor1().cgColor
        
        self.previousButton.setTitle( Utilities.fetchTranslation(forKey: "previous_key"), for: .normal)
        if self.surveyData?.numberOfQuestions() == self.currentQuestionIndex + 1 {
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
        
    // MARK: - Actions
    @IBAction func closeButtonTap(_ sender: Any) {
        if (quizIsAnswered) {
            self.popToSurveysList(animation: true)
        } else {
            self.showConfirmActionDialog()
        }
    }
    
    @IBAction func previousButtonTap(_ sender: Any) {
        delegate?.saveUserAnswersOnBackNavigation(answersDict)
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func nextButtonTap(_ sender: Any) {

        if !quizIsAnswered && (!questionAnswer && answerIsRequired) {
            self.showPopup()
            return
        }

        self.showNextQuestion()
//        if self.surveyData?.numberOfQuestions() == currentQuestionIndex + 1 {
//            if quizIsAnswered {
//                self.popToSurveysList(animation: true)
//            } else {
//                if answersDict.questions.values.isEmpty {
//                    self.popToSurveysList(animation: true)
//                } else {
//                    self.sendAnswersData()
//                }
//            }
//            return
//        }
//        
//        var nextQuestion: Question?
//        var isReferential = false
//        if selectedOption?.referralQuestionId != nil {
//            isReferential = true
//            nextQuestion = self.surveyData?.referralQuestions.first { question in
//                question.questionID == self.selectedOption?.referralQuestionId
//            }
//        } else {
//            nextQuestion = self.surveyData?.questions[questionIndex + 1]
//        }
//
//        switch nextQuestion?.type {
//
//        case "text_answer":
//            let viewController = UIStoryboard.init(name: "OpenSurvey", bundle: Bundle.main).instantiateViewController(withIdentifier: "TextSurveyViewController") as? TextSurveyViewController
//            viewController?.surveyQuestions      = surveyQuestions
//            viewController?.currentQuestionIndex = questionIndex + 1
//            viewController?.surveyId             = surveyId
//            viewController?.surveyTitle          = surveyTitle
//            viewController?.answersDict          = answersDict
//            viewController?.quizIsAnswered       = quizIsAnswered
//            viewController?.delegate = self
//            self.navigationController?.pushViewController(viewController!, animated: false)
//            
//        case "multiple_choice", "checkbox":
//            let viewController = UIStoryboard.init(name: "OpenSurvey", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChooseOptionSurveyViewController") as? ChooseOptionSurveyViewController
//
//            if !isReferential {
//                viewController?.currentQuestionIndex = questionIndex + 1
//            }
//            let isCheckbox = nextQuestion?.type == "multiple_choice" ? true : false
//
//            viewController?.surveyData = self.surveyData
//            viewController?.currentQuestion = nextQuestion
//            viewController?.surveyQuestions      = surveyQuestions
//            viewController?.surveyId             = surveyId
//            viewController?.multipleChoice       = isCheckbox
//            viewController?.surveyTitle          = surveyTitle
//            viewController?.answersDict          = answersDict
//            viewController?.quizIsAnswered       = quizIsAnswered
//            viewController?.isQuiz               = isQuiz
//            viewController?.userAnswer           = userAnswer
//            viewController?.trueAnswers          = trueAnswers
//            viewController?.delegate = self
//            self.navigationController?.pushViewController(viewController!, animated: false)
//            
//        default:
//            let viewController = UIStoryboard.init(name: "OpenSurvey", bundle: Bundle.main).instantiateViewController(withIdentifier: "RateSurveyViewController") as? RateSurveyViewController
//            viewController?.surveyQuestions      = surveyQuestions
//            viewController?.currentQuestionIndex = questionIndex + 1
//            viewController?.surveyId             = surveyId
//            viewController?.surveyTitle          = surveyTitle
//            viewController?.answersDict          = answersDict
//            viewController?.quizIsAnswered       = quizIsAnswered
//            viewController?.delegate = self
//            self.navigationController?.pushViewController(viewController!, animated: false)
//        }
    }
    
    // MARK: - DialogViewController
    func dialogViewDidPressActionButton(_ dialogView: DialogViewController) {
        self.popToSurveysList(animation: false)
    }

    func dialogViewDidCancel(_ dialogView: DialogViewController) {
        dialogView.dismiss(animated: false) {
            if let tabBarController = self.tabBarController as? MainTabbarController {
                tabBarController.hideTabbar(true)
            }
        }
    }
    
    private func checkAndCelectCellAsDefault(tableView: UITableView, indexPath: IndexPath, question: Question) {
        if let currentSelectedOption = self.answersDict.questions["\(question.questionID)"] as? [Int] {
            let optionId = question.options[indexPath.section].id
            if currentSelectedOption.contains(Int(truncating: optionId)) {
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.none)
            }
        }
    }
}

extension ChooseOptionSurveyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.currentQuestion?.options.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if multipleChoice {
            let cell: ChooseSurveyOptionTableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "SurveyOptionsTableViewCell") as! ChooseSurveyOptionTableViewCell?)!
            let question = self.currentQuestion ?? surveyQuestions[currentQuestionIndex]
            cell.descriptionLabel.text = question.options[indexPath.section].translation.title
            cell.selectionStyle = .none
            cell.isUserInteractionEnabled = !quizIsAnswered
            if quizIsAnswered {
                let optionId = question.options[indexPath.section].id
                if let userAnswerDetails = userAnswer?.userAnswerDetails {
                    for index in 0 ..< userAnswerDetails.count {
                        guard let userAnswer = userAnswer else {return cell}
                        if Int(truncating: optionId) == Int(truncating: userAnswer.userAnswerDetails[index].optionId)
                        {
                            cell.showSelectedAnswer()
                        }
                    }
                }
            } else {
                checkAndCelectCellAsDefault(tableView: tableView, indexPath: indexPath, question: question)
            }
            if quizIsAnswered && question.options[indexPath.section].correctAnswer == 1 {
                cell.showCorrectAnswer()
            }
            if question.options[indexPath.section].correctAnswer == 1 {
                trueAnswers.append(Int(truncating: question.options[indexPath.section].id))
            }
            return cell
        } else {
            let cell: ChooseCheckboxTableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "ChooseCheckboxTableViewCell") as! ChooseCheckboxTableViewCell?)!
            let question = surveyQuestions[currentQuestionIndex]
            cell.descriptionLabel.text = question.options[indexPath.section].translation.title
            cell.selectionStyle = .none
            cell.checkboxButton.isUserInteractionEnabled = false
            cell.isUserInteractionEnabled = !quizIsAnswered
            if quizIsAnswered {
                let optionId = question.options[indexPath.section].id
                if let userAnswerDetails = userAnswer?.userAnswerDetails {
                    for index in 0 ..< userAnswerDetails.count {
                        guard let userAnswer = userAnswer else {return cell}
                        if Int(truncating: optionId) == Int(truncating: userAnswer.userAnswerDetails[index].optionId)
                        {
                            cell.showSelectedAnswer()
                        }
                    }
                }
            } else {
                checkAndCelectCellAsDefault(tableView: tableView, indexPath: indexPath, question: question)
            }
            if quizIsAnswered && question.options[indexPath.section].correctAnswer == 1 {
                cell.showCorrectAnswer()
            }
            if question.options[indexPath.section].correctAnswer == 1 {
                trueAnswers.append(Int(truncating: question.options[indexPath.section].id))
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let questionID = surveyQuestions[currentQuestionIndex].questionID
        self.selectedOption = currentQuestion?.options[indexPath.section]
        let answerId = Int(truncating: surveyQuestions[currentQuestionIndex].options[indexPath.section].id)
        if multipleChoice {
            if let userSavedAnswer = self.answersDict.questions["\(questionID)"] as? [Int] {
                if userSavedAnswer[0] == answerId {
                    answersDict.questions.removeValue(forKey: "\(questionID)")
                } else {
                    answersDict.questions["\(questionID)"] = [(answerId)]
                }
            } else {
                answersDict.questions["\(questionID)"] = [(answerId)]
            }
        } else {
            if checkboxAnswersArray.contains(answerId) {
                checkboxAnswersArray.removeAll(where: { $0 == answerId })
            } else {
                checkboxAnswersArray.append(answerId)
            }
            if checkboxAnswersArray.isEmpty {
                answersDict.questions.removeValue(forKey: "\(questionID)")
            } else {
                answersDict.questions["\(questionID)"] = checkboxAnswersArray
            }
        }
        self.questionAnswer = (answersDict.questions["\(questionID)"] as? [Int])?.count ?? 0 > 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ChooseOptionSurveyViewController: OpenSurveyDelegate {
    func saveUserAnswersOnBackNavigation(_ answersDict: OpenSurveyAnswersDataModel) {
        self.answersDict = answersDict
    }
}
