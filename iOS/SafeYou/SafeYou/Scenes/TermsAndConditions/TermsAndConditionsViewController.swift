//
//  TermsAndConditionsViewController.swift
//  SafeYou
//
//  Created by Edgar on 13.05.22.
//  Copyright © 2022 Garnik Simonyan. All rights reserved.
//

import UIKit

class TermsAndConditionsViewController: SYViewController, TTTAttributedLabelDelegate {

    @IBOutlet weak var mainTitleLabel: SYLabelBold!
    @IBOutlet weak var termsAndConditionsLabel: SYLabelBold!
    @IBOutlet weak var checkBoxButton: SYDesignableCheckBoxButton!
    @IBOutlet weak var submitButton: SYDesignableButton!
    @IBOutlet weak var agreementView: UIView!
    @IBOutlet weak var agreementTextLabel: SYLabelBold!

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

    // MARK - Localizations

    override func updateLocalizations() {
        self.mainTitleLabel.text = Utilities.fetchTranslation(forKey: "terms_and_conditions")
    }

    // MARK - Actions

    @IBAction func checkBoxButtonAction(_ sender: SYDesignableCheckBoxButton) {
        submitButton.isEnabled = checkBoxButton.isSelected
    }

    @IBAction func submitButtonAction(_ sender: SYDesignableButton) {
        if let registrationData = registrationDataDict {
            self.showLoader()
            self.registrationService?.registerUser(withData: registrationData, withComplition: { _ in
                self.hideLoader()
                self.performSegue(withIdentifier: "showVerificationView", sender: self)
            }, failure: { error in
                self.hideLoader()
                self.handleRegistrationError(error: error)
            })
        }
    }

    @IBAction func backButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }

// MARK: - Navigation
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

    // MARK Private
    private func configureAgreementView() {
        agreementView.isHidden = false
        let agreementText = Utilities.fetchTranslation(forKey: "terms_and_conditions_agreement_text")
        let privacyPolicy = Utilities.fetchTranslation(forKey: "privacy_policy_txt").lowercased()
        
        self.agreementTextLabel.text = agreementText
        guard let range = agreementText.range(of: privacyPolicy) else { return }
        let urlRange = NSRange(range, in: agreementText)
//        self.agreementTextLabel.addLink(to: URL(string: "https://www.google.com/"), with: urlRange)
//        self.agreementTextLabel.delegate = self
        
        let submitButtonTitle = Utilities.fetchTranslation(forKey: "submit_title_key")
        submitButton.setTitle(submitButtonTitle.uppercased(), for: UIControl.State.normal)
    }
    

    // MARK - TTTAttributedLableDelegate
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
