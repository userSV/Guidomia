//
//  VehiclesListingViewController.swift
//  Guidomia
//
//  Created by Shilpa on 05/10/21.
//

import UIKit
/*
 Home screen which shows the vehicles listing with their respective details
 */
class VehiclesListingViewController: UIViewController {

    //MARK:- IBOutlets
    @IBOutlet var vehiclesTableView: UITableView!
    @IBOutlet var vehicleMakeFilterView: UIView!
    @IBOutlet var vehicleModelFilterView: UIView!
    @IBOutlet var currentMakeLabel: UILabel!
    @IBOutlet var currentModelLabel: UILabel!
    @IBOutlet var resetFilterIcon: UIButton!
    
    //MARK:- Properties
    var viewModel: VehicleListingViewModel!
    private var lastSelectedIndex: Int = 0
    lazy var customActionSheet: CustomActionSheet = {
        let actionSheet = CustomActionSheet.loadFromNib()
        actionSheet.setUpView()
        return actionSheet
    }()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initializeOnLoad()
    }
    
    //MARK:- IBActions
    @IBAction func anyMakeTapped(sender: UIButton) {
        self.presentActionSheet(withData: viewModel.makesListOfVehicles(), type: .vehicleMake)
    }
    
    @IBAction func anyModelTapped(sender: UIButton) {
        self.presentActionSheet(withData: viewModel.modelListOfVehicles(), type: .vehicleModel)
    }
    
    @IBAction func resetFilterTapped(sender: UIButton) {
        Utility.showAlertWith(message: Constants.VehicleInfo.resetFilter, parentVC: self) {
            //reset filters and update view
            self.viewModel.setSelectedMake(value: nil)
            self.viewModel.setSelectedModel(value: nil)
            self.currentMakeLabel.text = Constants.VehicleInfo.anyMake
            self.currentModelLabel.text = Constants.VehicleInfo.anyModel
            self.resetFilterIcon.isHidden = !self.viewModel.isFilterApplied
        }
    }
    
    //MARK:- Initializer
    private func initializeOnLoad() {
        self.registerNibs()
        self.resetFilterIcon.isHidden = true
        self.vehicleMakeFilterView.addShadow(offset: CGSize(width: 0, height: 3))
        self.vehicleModelFilterView.addShadow(offset: CGSize(width: 0, height: 3))
        self.viewModel.getVehicleDetails()
    }
    
    //MARK:- Register Nibs
    /// Register the nibs with the tableview
    private func registerNibs() {
        let headerView = UINib(nibName: VehicleDescriptionHeaderView.reuseIdentifier, bundle: nil)
        let footerView = UINib(nibName: SeparatorView.reuseIdentifier, bundle: nil)
        self.vehiclesTableView.register(headerView, forHeaderFooterViewReuseIdentifier: VehicleDescriptionHeaderView.reuseIdentifier)
        self.vehiclesTableView.register(footerView, forHeaderFooterViewReuseIdentifier: SeparatorView.reuseIdentifier)
        let prosConsCell = UINib(nibName: VehicleProsConsTableViewCell.reuseIdentifier, bundle: nil)
        self.vehiclesTableView.register(prosConsCell, forCellReuseIdentifier: VehicleProsConsTableViewCell.reuseIdentifier)
    }
    
    //MARK:- Helper Functions
    private func presentActionSheet(withData data: [String], type: CustomActionSheet.CustomActionSheetContentType) {
        customActionSheet.initializeWith(data: data, delegateView: self, frame: self.view.frame)
        customActionSheet.contentType = type
        self.view.addSubview(customActionSheet)
        customActionSheet.addActionSheetOnParentViewWith(frame: view.frame, view: view)
    }
}

//MARK:- UITableViewDataSource
extension VehiclesListingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsAt(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: VehicleProsConsTableViewCell.reuseIdentifier, for: indexPath) as? VehicleProsConsTableViewCell {
            cell.setData(prosList: viewModel.prosListAt(index: indexPath.section), consList: viewModel.consListAt(index: indexPath.section))
            return cell
        }
        return UITableViewCell()
    }
}

//MARK:- UITableViewDelegate
extension VehiclesListingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { UITableView.automaticDimension }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat { 100 }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { 30 }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerview = tableView.dequeueReusableHeaderFooterView(withIdentifier: VehicleDescriptionHeaderView.reuseIdentifier) as? VehicleDescriptionHeaderView {
            headerview.sectionTapDelegate = self
            let headerViewModel = viewModel.viewModelForVehicleAt(section)
            headerview.setDataWith(viewModel: headerViewModel, atIndex: section)
            return headerview
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SeparatorView.reuseIdentifier) as? SeparatorView {
            return footerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !viewModel.isExpanded(section: indexPath.section) {
            return 0.00000001
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat { 50 }
}

//MARK:- VehicleListViewPresenter
extension VehiclesListingViewController: VehicleListViewPresenter {
    /// reload tableview with the updated data source
    func didUpdateFilterList() {
        self.vehiclesTableView.reloadData()
    }
    
    func updateViewState(isExpanded: Bool, atIndex index: Int) {
        let indexSet = IndexSet(integer: index)
        self.vehiclesTableView.reloadSections(indexSet, with: .automatic)
        lastSelectedIndex = index
    }
    
    func didReceiveVehiclesList() {
        DispatchQueue.main.async {
            self.vehiclesTableView.reloadData()
        }
    }
    
    func didReceiveErrorOnVehiclesListFetch(errorMessage: String) {}
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
    func didSelectAnItemFromActionSheet(value: Any, contentType: CustomActionSheet.CustomActionSheetContentType) {
        let value = "\(value)"
        switch contentType {
        case .vehicleMake:
            self.currentMakeLabel.text = value
            self.viewModel.setSelectedMake(value: value)
        case .vehicleModel:
            self.currentModelLabel.text = value
            self.viewModel.setSelectedModel(value: value)
        }
        resetFilterIcon.isHidden = !viewModel.isFilterApplied
    }
}
