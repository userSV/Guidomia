//
//  CustomActionSheet.swift
//  Guidomia
//
//  Created by Shilpa on 07/10/21.
//

import UIKit

enum CustomActionSheetContentType {
    case vehicleMake, vehicleModel
}

protocol CustomActionSheetDelegate: AnyObject {
    func didSelectAnItemFromActionSheet(value: Any, contentType: CustomActionSheetContentType)
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
    private let rowHeight: CGFloat = 44.0
    weak var delegate: CustomActionSheetDelegate?
    var contentType: CustomActionSheetContentType = .vehicleMake
    private let topSpaceSize: CGFloat = 200.0
    private let animationDuration: TimeInterval = 0.3
    
    //MARK:- Initialize
    /// set up the view and provide data source
    /// - Parameter data: array of strings
    func initializeWith(data: [String], delegateView: CustomActionSheetDelegate, frame: CGRect) {
        self.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: frame.height)
        self.dataSource = data
        self.delegate = delegateView
        self.fadedView.alpha = 0
        self.setTableViewHeight(mainFrameHeight: frame.height)
        tableView.reloadData()
    }
    
    private func setTableViewHeight(mainFrameHeight: CGFloat) {
        let totalHeight = CGFloat(self.dataSource.count) * rowHeight
        if totalHeight > mainFrameHeight {
            tableViewHeightConstraint.constant = mainFrameHeight - topSpaceSize
            tableView.isScrollEnabled = true
        } else {
            tableViewHeightConstraint.constant = totalHeight
            tableView.isScrollEnabled = false
        }
    }
    
    func setUpView() {
        self.addTapGesture()
        let actionSheetTableCell = UINib(nibName: ActionSheetTableViewCell.reuseIdentifier, bundle: nil)
        self.tableView.register(actionSheetTableCell, forCellReuseIdentifier: ActionSheetTableViewCell.reuseIdentifier)
    }
    
    //MARK:- Helper Functions
    /// removes the current view from superview with animating alpha
    func removeCurrentView() {
        self.fadedView.alpha = 0
        UIView.animate(withDuration: animationDuration) {
            self.frame.origin.y = self.frame.height
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    /// this will load and return the CustomActionSheet instance
    /// - Returns: CustomActionSheet
    static func loadFromNib() -> CustomActionSheet {
        return UINib(nibName: CustomActionSheet.reuseIdentifier, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CustomActionSheet
    }
    
    func addActionSheetOnParentViewWith(frame: CGRect, view: UIView) {
        UIView.animate(withDuration: animationDuration) {
            self.frame.origin.y = self.frame.origin.y - frame.height
            self.delegate?.didCompleteViewPresentation()
            self.alpha = 1.0
        } completion: { _ in
            UIView.animate(withDuration: self.animationDuration) {
                self.fadedView.alpha = 0.6
            }
        }
    }
    
    //MARK:- Gesture Recognizer
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(gestureTapped))
        fadedView.isUserInteractionEnabled = true
        self.fadedView.addGestureRecognizer(tapGesture)
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
            cell.selectionStyle = .none
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
        self.delegate?.didSelectAnItemFromActionSheet(value: dataSource[indexPath.row], contentType: self.contentType)
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0
        } completion: {_ in self.removeCurrentView()}

    }
}
