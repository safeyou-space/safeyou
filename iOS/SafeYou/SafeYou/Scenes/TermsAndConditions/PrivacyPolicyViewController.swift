//
//  PrivacyPolicyViewController.swift
//  SafeYou
//
//  Created by Edgar on 17.05.22.
//  Copyright © 2022 Garnik Simonyan. All rights reserved.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: SYViewController {
    @IBOutlet weak var webView: WKWebView!
    var userBirthday: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        var contentType = SYRemotContentType.privacyPolicyForAdults
        if self.userBirthday != nil {
            if !(Helper.isUserAdult(birthday: self.userBirthday!, isRegisteration: true)) {
                contentType = SYRemotContentType.privacyPolicyForMinors
            }
        }
        let contentService = ContentService()
        self.configureNavigationBar()
        self.showLoader()
        contentService.getContent(contentType, complition: { htmlContent in
            self.webView.loadHTMLString(htmlContent, baseURL: nil)
            self.hideLoader()
        }, failure: { error in
            print("error \(error)")
            self.hideLoader()
        })
    }

    override func configureNavigationBar() {
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
            lbNavTitle.text = Utilities.fetchTranslation(forKey: "privacy_policy")
            self.navigationItem.titleView = lbNavTitle
        }
    }

    @objc func closePresentedView() {
        navigationController?.popViewController(animated: true)
    }

}
