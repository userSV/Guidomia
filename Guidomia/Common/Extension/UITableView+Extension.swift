//
//  UITableView+Extension.swift
//  Guidomia
//
//  Created by Shilpa on 08/10/21.
//

import Foundation
import UIKit

extension UITableView {
    
    /// Set the size of header view of tableview as per its content size
    func sizeHeaderViewToFit() {
        
        guard let headerView = self.tableHeaderView else { return }
        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var frame = headerView.frame
        frame.size.height = height
        headerView.frame = frame
        self.tableHeaderView = headerView
    }
}

