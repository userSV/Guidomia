//
//  VehiclesListingViewController.swift
//  Guidomia
//
//  Created by Shilpa on 05/10/21.
//

import UIKit

// Home screen which shows the vehicles listing with their respective details

class VehiclesListingViewController: BaseViewController {

    //MARK:- IBOutlets
    @IBOutlet var vehiclesTableView: UITableView!
    @IBOutlet var vehicleMakeFilterView: UIView!
    @IBOutlet var vehicleModelFilterView: UIView!
    @IBOutlet var currentMakeLabel: UILabel!
    @IBOutlet var currentModelLabel: UILabel!
    @IBOutlet var errorView: UIView!
    @IBOutlet var errorLabel: UILabel!
    
    //MARK:- Properties
    var viewModel = VehicleListingViewModel()
    private var lastSelectedIndex: Int = 0
    lazy var customActionSheet: CustomActionSheet? = {
        
        guard let actionSheet = CustomActionSheet.loadFromNib() else { return nil }
        actionSheet.setUpView()
        return actionSheet
    }()
    private let shadowOffset = CGSize(width: 0, height: 3)
    private let headerEstimatedHeight: CGFloat = 100.0
    private let rowEstimatedHeight: CGFloat = 30.0
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initializeOnLoad()
    }
    
    //MARK:- IBActions
    @IBAction func anyMakeTapped(sender: UIButton) {
        self.presentActionSheet(withData: viewModel.makesListOfVehicles(),
                                type: .vehicleMake)
    }
    
    @IBAction func anyModelTapped(sender: UIButton) {
        self.presentActionSheet(withData: viewModel.modelListOfVehicles(),
                                type: .vehicleModel)
    }
    
    //MARK:- Initializer
    private func initializeOnLoad() {
        self.addNavigationBar()
        self.errorView.isHidden = true
        self.viewModel.initializeWith(delegate: self)
        self.registerNibs()
        self.navigationBarView?.enableRightButton = false
        self.vehicleMakeFilterView.addShadow(offset: shadowOffset)
        self.vehicleModelFilterView.addShadow(offset: shadowOffset)
        self.viewModel.getVehicleDetails()
    }
    
    //MARK:- Register Nibs
    /// Register the nibs with the tableview
    private func registerNibs() {
        let headerView = UINib(nibName: VehicleDescriptionHeaderView.reuseIdentifier,
                               bundle: nil)
        let footerView = UINib(nibName: SeparatorView.reuseIdentifier,
                               bundle: nil)
        self.vehiclesTableView.register(headerView,
                                        forHeaderFooterViewReuseIdentifier: VehicleDescriptionHeaderView.reuseIdentifier)
        self.vehiclesTableView.register(footerView,
                                        forHeaderFooterViewReuseIdentifier: SeparatorView.reuseIdentifier)
        let prosConsCell = UINib(nibName: VehicleProsConsTableViewCell.reuseIdentifier,
                                 bundle: nil)
        self.vehiclesTableView.register(prosConsCell,
                                        forCellReuseIdentifier: VehicleProsConsTableViewCell.reuseIdentifier)
    }
    
    //MARK:- Helper Functions
    private func presentActionSheet(withData data: [String], type: CustomActionSheetContentType) {
        guard let actionSheet = customActionSheet else { return }
        actionSheet.initializeWith(data: data,
                                         delegateView: self,
                                         frame: self.view.frame)
        actionSheet.contentType = type
        self.view.addSubview(actionSheet)
        actionSheet.addActionSheetOnParentViewWith(frame: view.frame,
                                                         view: view)
    }
    
    /// Reload the view with the updated data
    private func reloadView() {
        DispatchQueue.main.async {
            if self.viewModel.numberOfVehicles() == 0 {
                self.displayErrorView(withError: Constants.AppMessages.noRecordsFound,
                                      isVisible: true)
            } else {
                self.displayErrorView(withError: nil,
                                      isVisible: false)
            }
            self.vehiclesTableView.reloadData()
        }
    }
    
    /// Display error view
    /// - Parameters:
    ///   - error: error message
    ///   - isVisible: true if error is to be shown, else false
    private func displayErrorView(withError error: String?, isVisible: Bool) {
        self.errorView.isHidden = !isVisible
        self.errorLabel.text = error
        self.vehiclesTableView.sizeHeaderViewToFit()
    }
    
    /// Action on the click of reset filters button
    override func rightButtonOnNavigationBarTapped() {
        
        self.showAlertWith(message: Constants.VehicleInfo.resetFilter) {
            //reset filters and update view
            self.viewModel.setSelectedMake(value: nil)
            self.viewModel.setSelectedModel(value: nil)
            self.currentMakeLabel.text = Constants.VehicleInfo.anyMake
            self.currentModelLabel.text = Constants.VehicleInfo.anyModel
            self.navigationBarView?.enableRightButton = self.viewModel.isFilterApplied
        }
    }
}

//MARK:- UITableViewDataSource
extension VehiclesListingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfVehicles()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VehicleProsConsTableViewCell.reuseIdentifier, for: indexPath) as? VehicleProsConsTableViewCell else {
            return UITableViewCell()
        }
        cell.setData(prosList: viewModel.prosListAt(index: indexPath.section), consList: viewModel.consListAt(index: indexPath.section))
        return cell
    }
}

//MARK:- UITableViewDelegate
extension VehiclesListingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { UITableView.automaticDimension }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat { headerEstimatedHeight }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { rowEstimatedHeight }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerview = tableView.dequeueReusableHeaderFooterView(withIdentifier: VehicleDescriptionHeaderView.reuseIdentifier) as? VehicleDescriptionHeaderView else {
            return nil
        }
        headerview.sectionTapDelegate = self
        let headerViewModel = viewModel.viewModelForVehicleAt(section)
        headerview.setDataWith(viewModel: headerViewModel, atIndex: section)
        return headerview
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SeparatorView.reuseIdentifier) as? SeparatorView else {
            return nil
        }
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard !viewModel.isExpanded(index: indexPath.section) else {
            return UITableView.automaticDimension
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat { rowEstimatedHeight }
}

//MARK:- VehicleListViewDelegate
extension VehiclesListingViewController: VehicleListViewDelegate {
    
    /// reload tableview with the updated data source
    func didUpdateFilterList() {
        self.reloadView()
    }
    
    func updateViewState(isExpanded: Bool, atIndex index: Int) {
        let indexSet = IndexSet(integer: index)
        self.vehiclesTableView.reloadSections(indexSet, with: .automatic)
        lastSelectedIndex = index
    }
    
    func didReceiveVehiclesList() {
        self.reloadView()
    }
    
    func didReceiveErrorOnVehiclesListFetch(errorMessage: String) {
        DispatchQueue.main.async {
            self.showAlertWith(message: errorMessage,
                                  hasSingleAction: true) {}
        }
    }
}

//MARK:- VehicleSectionTapDelegate
extension VehiclesListingViewController: VehicleSectionTapDelegate {
    
    /// calls on the click of a sectionview
    /// - Parameter index: current index of section
    func didTapOnSectionAt(index: Int) {
        self.viewModel.toggleOpenStateAt(index: index, lastSelectedIndex: lastSelectedIndex)
    }
}

//MARK:- CustomActionSheetDelegate
extension VehiclesListingViewController: CustomActionSheetDelegate {
    
    /// this method call updates any layout changes
    func didCompleteViewPresentation() {
        self.view.layoutIfNeeded()
    }
    
    /// This is called on the click of a row on the action sheet
    /// - Parameter value: value of the item selected
    func didSelectAnItemFromActionSheet(value: Any, contentType: CustomActionSheetContentType) {
        let value = "\(value)"
        switch contentType {
        case .vehicleMake:
            self.currentMakeLabel.text = value
            self.viewModel.setSelectedMake(value: value)
        case .vehicleModel:
            self.currentModelLabel.text = value
            self.viewModel.setSelectedModel(value: value)
        }
        navigationBarView?.enableRightButton = viewModel.isFilterApplied
    }
}
