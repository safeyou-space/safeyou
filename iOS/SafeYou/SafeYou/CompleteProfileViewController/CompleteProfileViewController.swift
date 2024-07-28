//
//  CompleteProfileViewController.swift
//  SafeYou
//
//  Created by armen sahakian on 19.07.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

import UIKit

class CompleteProfileViewController: UIViewController, ChooseOptionsViewDelegate {
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var skipButton: SYDesignableButton!
    @IBOutlet weak var completeButton: SYCorneredButton!
    
    var questionsData: [ProfileQuestionsDataModel]?
    var questionDataForSettlement: ProfileQuestionsDataModel?
    var questionDataForCityVillage: ProfileQuestionsDataModel?
    var addedSettlementProvince = false
    var addedSettlementCityVillage = false
    var isAlreadySelected = false
    var questionOfLocation = false
    var isSelectedValue = false
    var questionIndex = 0
    var selectedOptionName = ""
    var selectedOptions:[ String] = []
    var delegate = ChooseOptionsViewDelegate.self
    var selectedRow: Int?  = nil
    var profileService: SYProfileService = SYProfileService()
    var optionsArray: [ProfileQuestionsOption]?
    var selectedOption: ProfileQuestionsOption?
    var selectedRows:[String: Int] = [:]
    var searchCityKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let questionsData = questionsData else { return }
        if questionsData.isEmpty {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.configureView()
            self.configureSearchBar()
            optionsArray = questionsData[questionIndex].options
        }
        addDoneButtonOnKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let searchTextField:UITextField = searchBar.value(forKey: "searchField") as? UITextField ?? UITextField()
        searchTextField.textAlignment  = NSTextAlignment.left
        let image:UIImage              = UIImage(named: "icon-search")!
        let imageView:UIImageView      = UIImageView.init(image: image)
        searchTextField.leftView       = nil
        searchTextField.rightView      = imageView
        searchTextField.rightViewMode   = UITextField.ViewMode.always
    }
    
    func configureView() {
        self.progressView.clipsToBounds         = true
        progressView.layer.cornerRadius         = 4
        progressView.progress                   = Float (1 / Float (questionsData?.count ?? 4))
        self.progressView.trackTintColor        = UIColor.mainTintColor5()
        completeButtonActivity(activity: true)
        
        guard let questionsData = questionsData else { return }
        progressLabel.text      = "1 of \(questionsData.count)"
        titleLabel.text         = questionsData[0].title
        descriptionLabel.text   = questionsData[0].title2
        
        let type           = questionsData[questionIndex].type
        let questionType   = (type == "province" || type == "city_village") ? false : true
        questionOfLocation = !questionType
        
        self.tableView.separatorStyle = .none
        self.skipButton.isHidden      = questionIndex == 0
        self.searchBar.isHidden       = questionOfLocation ? false : true
        
        skipButton.setTitle( Utilities.fetchTranslation(forKey: "previous_key"), for: .normal)
        completeButton.setTitle( Utilities.fetchTranslation(forKey: "next_key"), for: .normal)
        
        if questionsData.count == 1 {
            completeButton.setTitle( Utilities.fetchTranslation(forKey: "complete_key"), for: .normal)
        } else {
            completeButton.setTitle( Utilities.fetchTranslation(forKey: "next_key"), for: .normal)
        }
    }
    
    func configureSearchBar() {
        searchBar.backgroundImage = UIImage()
        searchBar.layer.borderWidth                   = 1
        searchBar.layer.borderColor                   = UIColor.clear.cgColor
        searchBar.searchTextField.layer.cornerRadius  = 15
        searchBar.searchTextField.layer.masksToBounds = true
        searchBar.searchTextField.backgroundColor     = UIColor.white
        searchBar.searchTextField.layer.borderWidth   = 1
        searchBar.searchTextField.layer.borderColor   = UIColor.purpleColor1().cgColor
        searchBar.searchTextField.textColor = UIColor.purpleColor1()
        searchBar.searchTextField.placeholder         = Utilities.fetchTranslation(forKey: "search")
        UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = UIColor.purpleColor1()
        searchBar.setImage(UIImage(), for: .search, state: .normal)
    }
    
    func updateQuestionView() {
        questionIndex+=1
        isSelectedValue  = false
        self.selectedRow = nil
        skipButton.isHidden = questionIndex == 0
        guard let questionsData = questionsData else { return }
        if questionIndex < questionsData.count {
            optionsArray = questionsData[questionIndex].options
        }
        if questionIndex == questionsData.count - 1 {
            completeButton.setTitle( Utilities.fetchTranslation(forKey: "complete_key"), for: .normal)
        }else {
            completeButton.setTitle( Utilities.fetchTranslation(forKey: "next_key"), for: .normal)
        }
        if questionIndex > questionsData.count - 1 {
            if selectedRows.count == 0 {
                if let navigationController = self.navigationController {
                    navigationController.popViewController(animated: true)
                    return
                }
            } else {
                self.pushToFinish()
                return
            }
        }
        
        progressLabel.text      = "\(questionIndex + 1) of \(questionsData.count)"
        titleLabel.text         = questionsData[questionIndex].title
        descriptionLabel.text   = questionsData[questionIndex].title2
        progressView.progress   =  Float (questionIndex + 1) / Float (questionsData.count)
        
        let type = questionsData[questionIndex].type
        let questionType = (type == "province" || type == "city_village") ? false : true
        questionOfLocation = !questionType
        
        self.searchBar.isHidden = questionOfLocation ? false : true
        
        tableView.reloadData()
        
        if type == "city_village" {
            self.searchBar.text = searchCityKey
            findLocation(findText: searchCityKey)
        }
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        searchBar.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        searchBar.resignFirstResponder()
    }
    
    func completeButtonActivity(activity: Bool) {
        let alpha = activity ? 1.0 : 0.4
        self.completeButton.isUserInteractionEnabled = activity
        self.completeButton.backgroundColor = UIColor.mainTintColor1().withAlphaComponent(alpha)
    }
    
    func findLocation(findText: String) {
        profileService.findTownOrCity(withComplition: findText, { optionsArray in
            self.optionsArray = optionsArray
            if self.searchBar.searchTextField.text?.count ?? 0 < 2 {
                self.optionsArray = []
            }
            self.tableView.reloadData()
            
        }, failure: { error in
            
            return
        })
    }
    
    // MARK: - Navigation
    @IBAction func closeButtonTap(_ sender: Any) {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    @IBAction func skipButtonTap(_ sender: Any) {
        self.searchBar.text = ""
        let perviousKey = questionsData?[questionIndex - 1].id
        if  selectedRows[perviousKey!.stringValue] == nil {
            isAlreadySelected = false
        } else {
            isAlreadySelected = true
        }
        questionIndex-=2
        self.updateQuestionView()
    }
    
    @IBAction func completeButtonTap(_ sender: Any) {
        self.searchBar.text = ""
        let key = questionsData?[questionIndex].id
        if selectedRow != nil {
            selectedRows[key!.stringValue] = selectedRow
        } else {
            if let key = key {
                selectedRow = selectedRows[key.stringValue]
                if selectedRow != nil {
                    isAlreadySelected = true
                }
            }
        }
        switch isAlreadySelected {
        case true:
            let type = questionsData?[questionIndex].type
            var typeOfNext = ""
            if questionIndex < questionsData!.count - 1 { typeOfNext = (questionsData?[questionIndex+1].type)! }
            
            if type == "settlement" && typeOfNext == "city_village" && selectedRow == 2 {
                questionsData = questionsData?.filter { $0.type != "city_village" }
            }
            if type == "settlement" && selectedRow != 2 {
                if let questionDataForCityVillage = questionDataForCityVillage {
                    self.questionsData = self.questionsData?.filter{ $0.type != "city_village"}
                    self.questionsData?.insert(questionDataForCityVillage, at: questionIndex+1)
                }
            }
            
            if type == "province" {
                if typeOfNext == "settlement" {
                    self.questionsData?.remove(at: questionIndex+1)
                    addedSettlementProvince = false
                }

                if let questionDataForCityVillage = questionDataForCityVillage {
                    self.questionsData = self.questionsData?.filter{ $0.type != "city_village"}
                    self.questionsData?.insert(questionDataForCityVillage, at: questionIndex+1)
                }
            }
            if type == "city_village" && typeOfNext == "settlement"{
                self.questionsData?.remove(at: questionIndex+1)
                addedSettlementCityVillage = false
            }
            
            if type == "city_village" {
                if optionsArray?.count ?? 0 > 0 {
                    self.profileService.updateUserDataField("profile_question", questionsData?[questionIndex].id, selectedOption?.type, selectedOption?.id,  withComplition: {_ in
                        self.updateQuestionView()}, failure: {_ in })
                }
                else { self.updateQuestionView()
                    isAlreadySelected = false
                    return
                }
            } else {
                if let selectedRow = selectedRow {
                    self.profileService.updateUserDataField("profile_question", questionsData?[questionIndex].id, questionsData?[questionIndex].type, questionsData?[questionIndex].options[selectedRow].id,  withComplition: {_ in
                        self.updateQuestionView()}, failure: {_ in })
                }
            }
            isAlreadySelected = false
            
        case false:
            let type = questionsData?[questionIndex].type
            var typeOfPrevious = ""
            if questionIndex > 0 { typeOfPrevious = (questionsData?[questionIndex-1].type)! }
            
            if type == "province" && !addedSettlementProvince {
                questionsData?.insert(questionDataForSettlement!, at: questionIndex+1)
                addedSettlementProvince = true
            } else if type == "settlement" && typeOfPrevious == "province" {
                let questionData = questionsData?.filter { $0.type == "city_village" }
                if questionData?.count ?? 0 > 0 {
                    questionDataForCityVillage = questionData?[0]
                }
                questionsData = questionsData?.filter { $0.type != "city_village" }
                
            } else  if type == "city_village" && !addedSettlementCityVillage &&
                        !addedSettlementProvince {
                questionsData?.insert(questionDataForSettlement!, at: questionIndex+1)
                addedSettlementCityVillage = true
            }
            updateQuestionView()
        }
    }
    
    func pushToFinish() {
        let viewController = UIStoryboard.init(name: "CompleteFinishViewController", bundle: Bundle.main).instantiateViewController(withIdentifier: "CompleteFinishViewController") as? CompleteFinishViewController
        self.navigationController?.pushViewController(viewController!, animated: true)
    }
    
    @objc static func instantiateChooseOptionController(data: NSArray ) -> CompleteProfileViewController {
        let chooseOptionStoryboard = UIStoryboard(name: "CompleteProfileViewController", bundle: nil)
        let chooseOptionController = chooseOptionStoryboard.instantiateViewController(withIdentifier: "CompleteProfileViewController") as! CompleteProfileViewController
        chooseOptionController.questionsData = data as? [ProfileQuestionsDataModel]
        if data != [] {
            chooseOptionController.questionDataForSettlement = data.lastObject as? ProfileQuestionsDataModel
            chooseOptionController.questionsData?.removeLast()
        }
        return chooseOptionController
    }
}

extension CompleteProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if questionsData == []{
            return 0
        } else {
            return questionOfLocation ? optionsArray?.count ?? 4 : questionsData?[questionIndex].options.count ?? 4
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return questionOfLocation ? 60 : 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let key = questionsData?[questionIndex].id
        var selecredQuestion: Int?
        
        if let key = key {
            if let selectedItem = selectedRows[key.stringValue] {
                selecredQuestion = selectedItem
            }
        }
        
        if questionOfLocation {
            let cell: ChooseLocationTableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "ChooseLocationTableViewCell") as! ChooseLocationTableViewCell? ?? ChooseLocationTableViewCell())
            cell.selectionStyle = .none
            if let optionName = optionsArray?[indexPath.row].name {
                cell.configure(for: optionName)
            }
            
            if questionsData![questionIndex].type == "city_village" {
                if selectedOption?.id == optionsArray?[indexPath.row].id {
                    cell.setSelect(selected: true)
                    isSelectedValue = true
                } else {
                    cell.setSelect(selected: false)
                }
            } else {
                if indexPath.row  == selectedRow {
                    cell.setSelect(selected: true)
                    isSelectedValue = true
                } else {
                    cell.setSelect(selected: false)
                }
                
            }
            
            if selecredQuestion == indexPath.row && isSelectedValue == false {
                cell.setSelect(selected: true)
            }
            return cell
        }
        else {
            let cell: CompleteQuestionTableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "completeQuestionCell") as! CompleteQuestionTableViewCell?)!
            let name = questionsData?[questionIndex].options[indexPath.row].name
            cell.optionButton.setTitle(name, for: UIControl.State.normal)
            
            if indexPath.row == selectedRow {
                cell.setSelect(selected: true)
                isSelectedValue = true
            } else {
                cell.setSelect(selected: false)
            }
            
            if selecredQuestion == indexPath.row && isSelectedValue == false {
                cell.setSelect(selected: true)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow       = indexPath.row
        if questionsData![questionIndex].type == "city_village" {
            selectedOption = optionsArray?[indexPath.row]
        }
        isAlreadySelected = true
        isSelectedValue   = true
        tableView.reloadData()
    }
}

extension CompleteProfileViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        optionsArray = questionsData![questionIndex].options.filter({$0.name!.prefix(searchText.count) == searchText})
        self.tableView.reloadData()
        if questionsData![questionIndex].type == "city_village"  && searchText.count > 1 {
            searchCityKey = searchText
            findLocation(findText: searchText)
        }
    }
}
