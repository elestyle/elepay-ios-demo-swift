//
// Created on 2018/08/14, by Yin Tan
// Copyright © 2018 ELESTYLE, Inc. All rights reserved.
//

import UIKit

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}

final class ProductListViewController: UIViewController {
    private let CELL_ID = "elepay.example.ProductListCellId"
    private let products = [
        Product(imageUrl: "", title: "MOORING SMART MATTRESS PAD S", price: "1"),
        Product(imageUrl: "", title: "MOORING SMART MATTRESS PAD D", price: "100"),
        Product(imageUrl: "", title: "MOORING SMART MATTRESS PAD D * 10", price: "1,000"),
        Product(imageUrl: "", title: "MOORING SMART MATTRESS PAD D * 100", price: "10,000"),
        Product(imageUrl: "", title: "MOORING SMART MATTRESS PAD D * 1000", price: "100,000"),
        Product(imageUrl: "", title: "MOORING SMART MATTRESS PAD D * 10000", price: "1,000,000")
    ]

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.register(ProductListCell.classForCoder(), forCellReuseIdentifier: CELL_ID)
        tableView.tableFooterView = UIView()

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension ProductListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        guard let productCell = cell as? ProductListCell else { return cell }

        if productCell.actionDelegate == nil {
            productCell.actionDelegate = self
        }
        productCell.config(product: products[indexPath.row])

        return productCell
    }
}

extension ProductListViewController: ProductListCellActionDelegate {
    func productListCellDidTapPayButton(cell: ProductListCell) {
        let paymentController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "PaymentViewController")
            as! PaymentViewController
        paymentController.priceData = cell.priceData
        present(paymentController, animated: true, completion: nil)
    }
}
