//
//  SurveysListViewController.swift
//  SafeYou
//
//  Created by armen sahakian on 30.10.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

import UIKit

class SurveysListViewController: SYViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptySurveyListLabel: UILabel!
    
    var surveyService: SYOpenSurveyService = SYOpenSurveyService()
    let reuseIdentifier = "SurveyListCollectionViewCellId"
    var surveysData: [OpenSurveyItemDataModel] = []
    var paginationIndex = 1
    var surveysTotal = 0
    var currentCellIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureBackBarButtonItem()
        self.title = Utilities.fetchTranslation(forKey: "open_surveys_key")
        self.navigationItem.backButtonTitle = ""
        if !UserDefaults.standard.bool(forKey: IS_OPEN_SURVEY_NOTIFICATION_SHOWN) {
            UserDefaults.standard.set(true, forKey: IS_OPEN_SURVEY_NOTIFICATION_SHOWN)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.paginationIndex = 1
        self.currentCellIndex = 0
        surveysData.removeAll()
        self.collectionView.reloadData()
        self.loadSurveys()
        if let tabBarController = self.tabBarController as? MainTabbarController {
            tabBarController.hideTabbar(true)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.collectionView.collectionViewLayout.invalidateLayout()
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
    }
    
    func loadSurveys() {
        self.surveyService.getOpenSurveys(withComplition: NSNumber(value: paginationIndex), { [self] openSurveysDataModels in
            self.surveysData = surveysData + openSurveysDataModels!.data
            self.surveysTotal = Int(truncating: openSurveysDataModels?.total ?? 0)
            self.configureCollectionviewInData()
        }, failure: { error in
            print(error as Any)
        })
    }
    
    func configureCollectionviewInData() {
        if self.surveysData.isEmpty {
            emptySurveyListLabel.isHidden = false
            emptySurveyListLabel.text = Utilities.fetchTranslation(forKey: "empty_surveys_key")
        } else {
            emptySurveyListLabel.isHidden = true
            self.collectionView.reloadData()
        }
    }
    
    func openSurveyOnType(index:Int) {
        self.showLoader()
        let selectedSurvey = surveysData[index];
        self.surveyService.getOpenSurveyItem(byId: selectedSurvey.id) { [weak self] selectedItem in
            self?.hideLoader()
            if let surveyData = selectedItem {
                self?.showSelectedSurvey(surveyItem: surveyData)
            }
        } failure: { [weak self] error in
            self?.hideLoader()
        }
    }

    func showSelectedSurvey(surveyItem: OpenSurveyItemDataModel) {
        var surveyViewController: SurveyBaseViewController?
        switch surveyItem.questions[0].type {
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

        surveyViewController?.surveyData = surveyItem
        surveyViewController?.surveyQuestions = surveyItem.questions
        surveyViewController?.questionIndex = 0
        surveyViewController?.surveyId = surveyItem.id
        surveyViewController?.surveyTitle = surveyItem.translation.title
        surveyViewController?.quizIsAnswered = surveyItem.isAnswered == 1 ? true : false
        surveyViewController?.currentQuestion = surveyItem.questions[0]
        self.navigationController?.pushViewController(surveyViewController!, animated: true)
    }
}

extension SurveysListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    // MARK: - UICollectionViewDataSource protocol
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return surveysData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! SurveyListCollectionViewCell
        cell.configureCell(index: indexPath.row)
        cell.descriptionLabel.text = surveysData[indexPath.row].translation.title
    
        if surveysData[indexPath.row].isQuiz == 1 {
            if surveysData[indexPath.row].isAnswered != 0 {
                cell.configQuiz(checking: true)
            } else {
                cell.configQuiz(checking: false)
            }
            cell.isUserInteractionEnabled = true
            
        } else {
            if surveysData[indexPath.row].isAnswered != 0 {
                cell.configSurvey(checking: true)
                cell.isUserInteractionEnabled = false
            } else {
                cell.configSurvey(checking: false)
                cell.isUserInteractionEnabled = true
            }
        }
        self.currentCellIndex = indexPath.row

        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.openSurveyOnType(index: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width - 32, height: collectionView.bounds.size.height/5.0)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if currentCellIndex == surveysData.count - 1 {
            paginationIndex += 1
            if surveysTotal > surveysData.count {
                self.loadSurveys()
            }
        }
    }
}

protocol OpenSurveyDelegate {
    func saveUserAnswersOnBackNavigation(_ answersDict: OpenSurveyAnswersDataModel)
}
