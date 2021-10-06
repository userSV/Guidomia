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

    //MARK:- Properties
    var viewModel: VehicleListingViewModel!
    
    //MARK:- IBOutlets
    @IBOutlet var vehiclesTableView: UITableView!
    @IBOutlet var vehicleMakeFilterView: UIView!
    @IBOutlet var vehicleModelFilterView: UIView!
    
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
    }
}

//MARK:- UITableViewDataSource
extension VehiclesListingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            let headerViewModel = viewModel.viewModelForVehicleAt(section)
            headerview.setDataWith(viewModel: headerViewModel)
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
}

extension VehiclesListingViewController: VehicleListViewPresenter {
    func didReceiveVehiclesList() {
        DispatchQueue.main.async {
            self.vehiclesTableView.reloadData()
        }
    }
    
    func didReceiveErrorOnVehiclesListFetch(errorMessage: String) {
        
    }
}
