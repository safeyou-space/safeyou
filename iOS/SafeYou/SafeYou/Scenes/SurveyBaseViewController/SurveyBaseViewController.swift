//
//  SurveyBaseViewController.swift
//  SafeYou
//
//  Created by Garnik Simonyan on 5/12/24.
//  Copyright © 2024 Garnik Simonyan. All rights reserved.
//

import UIKit

class SurveyBaseViewController: SYViewController {

    @IBOutlet weak var progressBackgroundView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var previousButton: SYCorneredButton!
    @IBOutlet weak var nextButton: SYCorneredButton!

    var surveyData: OpenSurveyItemDataModel?
    var delegate: OpenSurveyDelegate?
    var surveyQuestions:[Question] = []
    var surveyTitle: String = ""
    var surveyId: NSNumber = 0
    var questionIndex = 0
    var currentQuestionIndex = 0
    var answerIsRequired = false
    var isAnswered = false
    var quizIsAnswered = false
    var surveyService: SYOpenSurveyService = SYOpenSurveyService()
    var answersDict: OpenSurveyAnswersDataModel = OpenSurveyAnswersDataModel()
    var questionType: String = ""
    var currentQuestion: Question?

    var isQuiz = false
    var trueAnswers: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.questionIndex = currentQuestionIndex
    }

    // MARK: functionality

    func showNextQuestion() {
        guard let surveyItem = self.surveyData else { return }

        if surveyItem.questions.count == questionIndex + 1 {
            if quizIsAnswered {
                self.popToSurveysList(animation: true)
            } else {
                if answersDict.questions.values.isEmpty {
                    self.popToSurveysList(animation: true)
                } else {
                    self.sendAnswersData()
                }
            }
            return
        }

        var surveyViewController: SurveyBaseViewController?
        let nextQuestion = surveyItem.questions[questionIndex + 1]
        switch nextQuestion.type {
        case "text_answer":

            surveyViewController = UIStoryboard.init(name: "OpenSurvey", bundle: Bundle.main).instantiateViewController(withIdentifier: "TextSurveyViewController") as? TextSurveyViewController

        case "multiple_choice", "checkbox":
            let chooseOptionSurveyVC = UIStoryboard.init(name: "OpenSurvey", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChooseOptionSurveyViewController") as? ChooseOptionSurveyViewController
            let isCheckbox = surveyItem.questions[0].type == "multiple_choice" ? true : false
            chooseOptionSurveyVC?.multipleChoice = isCheckbox
            chooseOptionSurveyVC?.userAnswer = surveyItem.userAnswer
            chooseOptionSurveyVC?.isQuiz = surveyItem.isQuiz == 1 ? true : false
            surveyViewController = chooseOptionSurveyVC

        default:
            surveyViewController = UIStoryboard.init(name: "OpenSurvey", bundle: Bundle.main).instantiateViewController(withIdentifier: "RateSurveyViewController") as? RateSurveyViewController

        }

        surveyViewController?.currentQuestionIndex = questionIndex + 1
        surveyViewController?.surveyData = surveyItem
        surveyViewController?.currentQuestion = nextQuestion
        surveyViewController?.surveyQuestions = surveyItem.questions
        surveyViewController?.questionIndex = 0
        surveyViewController?.surveyId = surveyItem.id
        surveyViewController?.surveyTitle = surveyItem.translation.title
        surveyViewController?.quizIsAnswered = surveyItem.isAnswered == 1 ? true : false
        self.navigationController?.pushViewController(surveyViewController!, animated: false)
    }

    func popToSurveysList(animation: Bool) {
        let mainViewControllerVC = self.navigationController?.viewControllers.first(where: { (viewcontroller) -> Bool in
            return viewcontroller is SurveysListViewController
        })
        if let mainViewControllerVC = mainViewControllerVC {
            navigationController?.popToViewController(mainViewControllerVC, animated: animation)
        }
    }

    func getPerecantage() -> Double {
        var userAnswersArray: [Int] = []
        for question in answersDict.questions {
            if let answers = question.value as? [Int] {
                for item in answers {
                    userAnswersArray.append(item)
                }
            }
        }
        let filteredArray = trueAnswers.filter { userAnswersArray.contains($0) }
        return Double(filteredArray.count) / Double(trueAnswers.count)
    }

    func pushToFinish() {
        if isQuiz {
            let guizPerecantage = getPerecantage()
            let viewController = UIStoryboard.init(name: "CompleteFinishViewController", bundle: Bundle.main).instantiateViewController(withIdentifier: "QuizPercentageViewController") as? QuizPercentageViewController
            viewController?.percentage = guizPerecantage
            viewController?.surveyId = surveyId
            self.navigationController?.pushViewController(viewController!, animated: true)
        } else {
            let viewController = UIStoryboard.init(name: "CompleteFinishViewController", bundle: Bundle.main).instantiateViewController(withIdentifier: "SurveyFinishViewController") as? SurveyFinishViewController
            self.navigationController?.pushViewController(viewController!, animated: true)
        }
    }

    func sendAnswersData() {
        self.answersDict.surveyID = surveyId
        self.surveyService.sendSurveyAnswers(withComplition: answersDict, withComplition:
                                                { [self] openSurveysDataModels in
            self.pushToFinish()

        }, failure: {error in
            self.pushToFinish()
        })
    }

    // MARK: private

    func showPopup() {
        let errorTextKey = Utilities.fetchTranslation(forKey: "error_text_key")
        let errorString  = Utilities.fetchTranslation(forKey: "required_question_need_to_answer_key")
        showAlertView(
            withTitle: errorTextKey,
            withMessage: errorString,
            cancelButtonTitle: NSLocalizedString("ok", comment: ""),
            okButtonTitle: nil,
            cancelAction: nil,
            okAction: nil
        )
    }
}
