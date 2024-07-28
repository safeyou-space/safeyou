//
//  ChooseLocationViewController.swift
//  SafeYou
//
//  Created by armen sahakian on 07.08.23.
//  Copyright © 2023 Garnik Simonyan. All rights reserved.
//

import UIKit

class ChooseLocationViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var continueButton: SYCorneredButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    
    var profileService:     SYProfileService = SYProfileService()
    var profileQuestion:    ProfileQuestionsDataModel?
    var selectedOption:     ProfileQuestionsOption?
    var optionsArray:       [ProfileQuestionsOption]?
    var optionsFilterArray: [ProfileQuestionsOption]?
    var pageTitle:          NSString?
    var selectedRow:        Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.optionsFilterArray = self.optionsArray
        self.configureView()
        self.configureSearchBar()
        self.addDoneButtonOnKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let searchTextField:UITextField = searchBar.value(forKey: "searchField") as? UITextField ?? UITextField()
        searchTextField.textAlignment = NSTextAlignment.left
        let image:UIImage = UIImage(named: "icon-search")!
        let imageView:UIImageView = UIImageView.init(image: image)
        searchTextField.leftView = nil
        searchTextField.rightView = imageView
        searchTextField.rightViewMode = UITextField.ViewMode.always
    }
    
    func configureView() {
        continueButton.setTitle( Utilities.fetchTranslation(forKey: "save_key"), for: .normal)
        cancelButton.setTitle( Utilities.fetchTranslation(forKey: "cancel"), for: .normal)
        
        self.continueButton.isUserInteractionEnabled = false
        if profileQuestion?.type != "city_village" && profileQuestion?.type != "province" {
            searchBar.isHidden = true
        }
        let backButton   = UIBarButtonItem()
        backButton.title = pageTitle as String?
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        completeButtonActivity(activity: false)
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
        self.continueButton.isUserInteractionEnabled = activity
        self.continueButton.backgroundColor = UIColor.mainTintColor1().withAlphaComponent(alpha)
    }
    
    func findLocation(findText: String) {
        profileService.findTownOrCity(withComplition: findText, { optionsArray in
            self.optionsFilterArray = optionsArray
            if self.searchBar.searchTextField.text?.count ?? 0 < 2 {
                self.optionsFilterArray = []
            }
            self.tableView.reloadData()
        }, failure: { error in
            return
        })
    }
    
    @IBAction func continueButtonTap(_ sender: Any) {
        guard let selectedOption = selectedOption else { return }
        var type = profileQuestion?.type
        
        if profileQuestion?.type == "city_village" {
            type = selectedOption.type
        }
        
        self.profileService.updateUserDataField("profile_question", profileQuestion?.id, type, selectedOption.id,  withComplition: {_ in self.navigationController?.popViewController(animated: true)}, failure: {_ in
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    @IBAction func cancelButtonTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    @objc static func instantiateChooseOptionController(data: NSArray , pageTitle: NSString) -> ChooseLocationViewController {
        let chooseOptionStoryboard = UIStoryboard(name: "ChooseLocationViewController", bundle: nil)
        let chooseOptionController = chooseOptionStoryboard.instantiateViewController(withIdentifier: "ChooseLocationViewController") as! ChooseLocationViewController
        chooseOptionController.pageTitle = pageTitle
        chooseOptionController.profileQuestion = data[0] as? ProfileQuestionsDataModel
        chooseOptionController.optionsArray = chooseOptionController.profileQuestion?.options
        
        return chooseOptionController
    }
    
}

extension ChooseLocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsFilterArray?.count ?? 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChooseRegionTableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "ChooseRegionTableViewCell") as! ChooseRegionTableViewCell?)!
        cell.selectionStyle = .none
        let optionName = optionsFilterArray?[indexPath.row].name
        cell.configure(for: optionName!)
        
        if selectedOption?.id == optionsFilterArray?[indexPath.row].id {
            cell.setSelect(selected: true)
        } else {
            cell.setSelect(selected: false)
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        selectedOption = optionsFilterArray?[indexPath.row]
        completeButtonActivity(activity: true)
        tableView.reloadData()
    }
}

extension ChooseLocationViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        optionsFilterArray = optionsArray?.filter({$0.name!.prefix(searchText.count) == searchText})
        self.tableView.reloadData()
        
        if searchText.count > 1 && profileQuestion?.type == "city_village" {
            findLocation(findText: searchText)
        }
    }
}
