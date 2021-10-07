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
    
    //MARK:- IBActions
    @IBAction func anyMakeTapped(sender: UIButton) {
    }
    
    @IBAction func anyModelTapped(sender: UIButton) {
    }
    
    //MARK:- Properties
    var viewModel: VehicleListingViewModel!
    private var lastSelectedIndex: Int = 0
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initializeOnLoad()
    }
    
    //MARK:- Initializer
    private func initializeOnLoad() {
        self.registerNibs()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { UITableView.automaticDimension }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat { 50 }
}

//MARK:- VehicleListViewPresenter
extension VehiclesListingViewController: VehicleListViewPresenter {
    func updateViewState(isExpanded: Bool, atIndex index: Int) {
        let indexPath = IndexPath(row: 0, section: index)
        let lastIndexPath = IndexPath(row: 0, section: lastSelectedIndex)
        if isExpanded {
            self.vehiclesTableView.insertRows(at: [indexPath], with: .automatic)
        } else {
            //self.vehiclesTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        self.vehiclesTableView.reloadData()
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
    func didSelectAnItemFromActionSheet(value: Any) {
        if let valueAsString = value as? String {
            self.currentMakeLabel.text = valueAsString
        }
    }
}
