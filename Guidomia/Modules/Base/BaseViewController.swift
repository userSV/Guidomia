//
//  BaseViewController.swift
//  Guidomia
//
//  Created by Shilpa on 08/10/21.
//

import UIKit

// The Base View controller class of type UIViewController

class BaseViewController: UIViewController {

    //MARK:- Properties
    private let navBarHeight: CGFloat = 88.0
    var navigationBarView: NavigationBarView?
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Helper Functions
    
    /// Add navigation bar on the view
    func addNavigationBar() {
        
        navigationBarView = UINib(nibName: NavigationBarView.reuseIdentifier, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? NavigationBarView
        navigationBarView?.frame = CGRect(x: 0,
                                         y: 0,
                                         width: self.view.frame.width,
                                         height: navBarHeight)
        navigationBarView?.delegate = self
        if let _ = navigationBarView {
            self.view.addSubview(navigationBarView!)
        }
    }
    
    /// override this method in the child class to override the action funtionality
    func rightButtonOnNavigationBarTapped() {}
    
    
    /// show alert controller
    /// - Parameters:
    ///   - title: title of the alert
    ///   - message: message of the alert
    ///   - parentVC: parent view on which alert is to be presented
    ///   - action: action handler
    ///   - hasSingleAction: true if cancel action is to be added, else false by default
    func showAlertWith(title: String = "", message: String, hasSingleAction: Bool = false, action: @escaping () -> ()) {
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.AlertTitle.ok,
                                     style: .default) { _ in
            action()
        }
        alert.addAction(okAction)
        if hasSingleAction == false {
            let cancelAction = UIAlertAction(title: Constants.AlertTitle.cancel,
                                             style: .default,
                                             handler: nil)
            alert.addAction(cancelAction)
        }
        self.present(alert, animated: true,
                         completion: nil)
    }
}

//MARK:- NavigationBarViewDelegate
extension BaseViewController: NavigationBarViewDelegate {
    
    func didClickOnRightButton() {
        self.rightButtonOnNavigationBarTapped()
    }
}
