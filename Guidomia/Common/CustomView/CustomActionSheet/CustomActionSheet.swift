//
//  CustomActionSheet.swift
//  Guidomia
//
//  Created by Shilpa on 07/10/21.
//

import UIKit

protocol CustomActionSheetDelegate: AnyObject {
    func didSelectAnItemFromActionSheet(value: Any)
    func didCompleteViewPresentation()
}

class CustomActionSheet: UIView {

    //MARK:- IBOutlets
    @IBOutlet var fadedView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewHeightConstraint: NSLayoutConstraint!
    
    //MARK:- Properties
    /// data source for the tableview
    private var dataSource = [String]()
    private let rowHeight: CGFloat = 44
    weak var delegate: CustomActionSheetDelegate?
    
    //MARK:- Initialize
    /// set up the view and provide data source
    /// - Parameter data: array of strings
    func initializeWith(data: [String], delegateView: CustomActionSheetDelegate) {
        self.dataSource = data
        self.delegate = delegateView
        self.addTapGesture()
        let nib = UINib(nibName: ActionSheetTableViewCell.reuseIdentifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: ActionSheetTableViewCell.reuseIdentifier)
        self.fadedView.alpha = 0
        tableViewHeightConstraint.constant = CGFloat(self.dataSource.count * 44)
    }
    
    //MARK:- Helper Functions
    /// removes the current view from superview with animating alpha
    func removeCurrentView() {
        UIView.animate(withDuration: 0.2) {
            self.removeFromSuperview()
        } completion: { _ in }
    }
    
    /// this will load and return the CustomActionSheet instance
    /// - Returns: CustomActionSheet
    static func loadFromNib() -> CustomActionSheet {
        return UINib(nibName: CustomActionSheet.reuseIdentifier, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomActionSheet
    }
    
    func addActionSheetOnParentViewWith(frame: CGRect, view: UIView) {
        UIView.animate(withDuration: 0.3) {
            self.frame.origin.y = self.frame.origin.y - frame.height
            //view.layoutIfNeeded()
            self.delegate?.didCompleteViewPresentation()
            self.alpha = 1.0
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.fadedView.alpha = 0.6
            }
        }
    }
    
    //MARK:- Gesture Recognizer
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(gestureTapped))
        fadedView.isUserInteractionEnabled = true
        self.fadedView.addGestureRecognizer(tap)
    }
    
    //removes the current view from the parent view on tap
    @objc func gestureTapped() {
        self.removeCurrentView()
    }
}

//MARK:- UITableViewDataSource
extension CustomActionSheet: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ActionSheetTableViewCell.reuseIdentifier, for: indexPath) as? ActionSheetTableViewCell {
            cell.setData(dataSource[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

//MARK:- UITableViewDelegate
extension CustomActionSheet: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelectAnItemFromActionSheet(value: dataSource[indexPath.row])
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0
        } completion: {_ in self.removeCurrentView()}

    }
}
