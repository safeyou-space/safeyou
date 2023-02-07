//
//  TermsAndConditionsViewController.swift
//  SafeYou
//
//  Created by Edgar on 13.05.22.
//  Copyright © 2022 Garnik Simonyan. All rights reserved.
//

import UIKit

class TermsAndConditionsViewController: SYViewController, TTTAttributedLabelDelegate {
    @IBOutlet weak var termsAndConditionsLabel: UILabel!
    @IBOutlet weak var checkBoxButton: SYDesignableCheckBoxButton!
    @IBOutlet weak var submitButton: SYDesignableButton!
    @IBOutlet weak var agreementView: UIView!
    @IBOutlet weak var agreementTextLabel: SYDesignableAttributedLabel!
    
    var registrationService: SYAuthenticationService?
    var htmlContent: String?
    var registrationDataDict: [AnyHashable: Any]?
    var userBirthday: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentService = ContentService()
        registrationService = SYAuthenticationService()
        var contentType = SYRemotContentType.termsAndConditionsForAdults
        if let bithDate = self.registrationDataDict?["birthday"] as? String {
            self.userBirthday = bithDate
            if !(Helper.isUserAdult(birthday: self.userBirthday!, isRegisteration: true)) {
                contentType = SYRemotContentType.termsAndConditionsForMinors
            }
        }
        
        self.agreementTextLabel.activeLinkAttributes = nil

        self.configureNavigationBar()
        self.showLoader()

        contentService.getContent(contentType, complition: { htmlContent in
            self.hideLoader()
            self.termsAndConditionsLabel.attributedText = htmlContent.htmlToAttributedString
            self.configureAgreementView()
        }, failure: { error in
            print("error \(error)")
            self.hideLoader()
        })
    }

// MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "showVerificationView" {
             if let destinationVC = segue.destination as? VerifyPhoneNumberViewController {
                 destinationVC.phoneNumber = self.registrationDataDict?["phone"] as! String
                 destinationVC.password = self.registrationDataDict?["password"] as! String
             }
         } else if segue.identifier == "showPrivacyPolicyView" {
             if let destinationVC = segue.destination as? PrivacyPolicyViewController {
                 destinationVC.userBirthday = self.userBirthday
             }
         }
     }

    @IBAction func checkBoxButtonAction(_ sender: SYDesignableCheckBoxButton) {
        if checkBoxButton.isSelected {
            submitButton.isEnabled = true
            submitButton.backgroundColorType = Int(SYColorType.colorTypeMain1.rawValue)
            submitButton.borderColorType = Int(SYColorType.colorTypeMain1.rawValue)
            submitButton.titleColorType = Int(SYColorType.colorTypeWhite.rawValue)
        } else {
            submitButton.isEnabled = false
            submitButton.backgroundColorType = Int(SYColorType.colorTypeOtherGray.rawValue)
            submitButton.borderColorType = Int(SYColorType.colorTypeOtherGray.rawValue)
            submitButton.titleColorType = Int(SYColorType.colorTypeDarkGray.rawValue)
        }
    }

    @IBAction func submitButtonAction(_ sender: SYDesignableButton) {
        if let registrationData = registrationDataDict {
            self.showLoader()
            self.registrationService?.registerUser(withData: registrationData, withComplition: { _ in
                self.hideLoader()
                print("Registered")
                self.performSegue(withIdentifier: "showVerificationView", sender: self)
            }, failure: { error in
                self.hideLoader()
                print("Registraion error \(error.localizedDescription)")
                self.handleRegistrationError(error: error)
            })
        }
    }

    func configureNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundColor = UIColor.mainTintColor2()
        
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        let leftItem = UIBarButtonItem(image: UIImage(named: "arrow_left_icon"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(closePresentedView))
        self.navigationItem.leftBarButtonItem = leftItem
        
        if let navigationBar = self.navigationController?.navigationBar {
            let lbNavTitle = UILabel (frame: CGRect(x: 0, y: 0, width: navigationBar.frame.width, height: navigationBar.frame.height))
            lbNavTitle.textColor = .white
            lbNavTitle.textAlignment = .left
            lbNavTitle.text = Utilities.fetchTranslation(forKey: "terms_and_conditions")
            self.navigationItem.titleView = lbNavTitle
        }
    }
    
    func configureAgreementView() {
        agreementView.isHidden = false
        let agreementText = Utilities.fetchTranslation(forKey: "terms_and_conditions_agreement_text")
        let privacyPolicy = Utilities.fetchTranslation(forKey: "privacy_policy_txt").lowercased()
        
        self.agreementTextLabel.text = agreementText
        guard let range = agreementText.range(of: privacyPolicy) else { return }
        let urlRange = NSRange(range, in: agreementText)
        self.agreementTextLabel.addLink(to: URL(string: "https://www.google.com/"), with: urlRange)
        self.agreementTextLabel.delegate = self
        
        let submitButtonTitle = Utilities.fetchTranslation(forKey: "submit_title_key")
        submitButton.setTitle(submitButtonTitle.uppercased(), for: UIControl.State.normal)
    }
    
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        if (label == self.agreementTextLabel) {
            self.performSegue(withIdentifier: "showPrivacyPolicyView", sender: self)
        }
    }
    
    @objc func closePresentedView() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func registrationDataDict(_ dict: [AnyHashable: Any]) {
        self.registrationDataDict = dict
    }
    
    @objc func handleRegistrationError(error: Error) {
        var errorMessage = ""
        let title = Utilities.fetchTranslation(forKey: "registration_error_key")
        let cancelButtonTitle = Utilities.fetchTranslation(forKey: "ok")
        let errorInfo = (error as NSError).userInfo
        let errorsDict = errorInfo["errors"] as? Dictionary<String, Any>
        if let message = (errorsDict?.values.first as? Array<String>)?.first {
            errorMessage = message
        } else {
            errorMessage = errorInfo["message"] as? String ?? ""
        }
        self.showAlertView(withTitle: title,
                           withMessage: errorMessage,
                           cancelButtonTitle: cancelButtonTitle,
                           okButtonTitle: nil,
                           cancelAction: closePresentedView,
                           okAction: nil)
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
}
