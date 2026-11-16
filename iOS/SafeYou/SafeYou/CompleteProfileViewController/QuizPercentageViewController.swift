//
//  QuizPercentageViewController.swift
//  SafeYou
//
//  Created by armen sahakian on 17.11.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

import UIKit

class QuizPercentageViewController: UIViewController {
    
    @IBOutlet weak var percentageAnimationView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var percentage: Double = 0.0
    var surveyService: SYOpenSurveyService = SYOpenSurveyService()
    var surveyData: OpenSurveyItemDataModel = OpenSurveyItemDataModel()
    var surveyId: NSNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.addPercentageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func addPercentageView() {
        let view = CircularProgressBarView()
        view.center = progressLabel.center
        view.progressAnimation(duration: 0.5, toValue: percentage)
        percentageAnimationView.addSubview(view)
        let perecentageValie = Int(percentage * 100)
        progressLabel.text = "\(perecentageValie)" + " %"
    }
    
    func configureView() {
        self.descriptionLabel.text = Utilities.fetchTranslation(forKey: "thanks_for_quiz_text")
        self.backButton.setTitle( Utilities.fetchTranslation(forKey: "see_result_key"), for: .normal)
        self.percentageAnimationView.backgroundColor = UIColor.clear
    }
    
    // MARK: - Navigation
    @IBAction func backButtonTap(_ sender: Any) {
        loadSurvey()
    }
    
    func loadSurvey() {
        self.surveyService.getOpenSurveyItem(byId: surveyId) { [self] openSurveyItem in
            self.surveyData = openSurveyItem!
            self.openSurveyPage(surveyData: openSurveyItem!)
        } failure: { error in
            print(error as Any)
        }
    }
    
    func openSurveyPage(surveyData: OpenSurveyItemDataModel) {
        switch surveyData.questions[0].type {
        case "text_answer":
            
            let viewController = UIStoryboard.init(name: "OpenSurvey", bundle: Bundle.main).instantiateViewController(withIdentifier: "TextSurveyViewController") as? TextSurveyViewController
            viewController?.surveyData = surveyData
            viewController?.surveyQuestions = surveyData.questions
            viewController?.questionIndex = 0
            viewController?.surveyId = surveyData.id
            viewController?.surveyTitle = surveyData.translation.title
            viewController?.quizIsAnswered = surveyData.isAnswered == 1 ? true : false
            self.navigationController?.pushViewController(viewController!, animated: true)
            
        case "multiple_choice", "checkbox":
            let viewController = UIStoryboard.init(name: "OpenSurvey", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChooseOptionSurveyViewController") as? ChooseOptionSurveyViewController
            viewController?.surveyData = surveyData
            viewController?.surveyQuestions = surveyData.questions
            viewController?.questionIndex = 0
            let isCheckbox = surveyData.questions[0].type == "multiple_choice" ? true : false
            viewController?.multipleChoice = isCheckbox
            viewController?.surveyId = surveyData.id
            viewController?.surveyTitle = surveyData.translation.title
            viewController?.quizIsAnswered = surveyData.isAnswered == 1 ? true : false
            viewController?.userAnswer = surveyData.userAnswer
            viewController?.isQuiz = surveyData.isQuiz == 1 ? true : false
            self.navigationController?.pushViewController(viewController!, animated: true)
            
        default:
            let viewController = UIStoryboard.init(name: "OpenSurvey", bundle: Bundle.main).instantiateViewController(withIdentifier: "RateSurveyViewController") as? RateSurveyViewController
            viewController?.surveyData = surveyData
            viewController?.surveyQuestions = surveyData.questions
            viewController?.questionIndex = 0
            viewController?.surveyId = surveyData.id
            viewController?.surveyTitle = surveyData.translation.title
            viewController?.quizIsAnswered = surveyData.isAnswered == 1 ? true : false
            self.navigationController?.pushViewController(viewController!, animated: true)
        }
    }
}
