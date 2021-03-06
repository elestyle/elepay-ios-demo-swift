//
//  ViewController.swift
//  ELEPayExample
//
//  Created by xuzhe on 2018/05/05.
//  Copyright © 2018 ELESTYLE, Inc. All rights reserved.
//

import UIKit
import ElepaySDK

class PaymentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var indicatorBg: UIVisualEffectView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gestureRecognizer: UITapGestureRecognizer!
    
    var priceData: String = ""
    
    fileprivate var paymentChannels: [PaymentChannel] = PaymentChannel.allCases

    override func viewDidLoad() {
        super.viewDidLoad()

        priceLabel.text = "JPY ¥" + priceData

        let closeView: UIImageView = {
            let ret = UIImageView(image: UIImage(named: "icon_close")?.withRenderingMode(.alwaysTemplate))
            ret.translatesAutoresizingMaskIntoConstraints = false
            ret.tintColor = UIColor.white
            ret.isUserInteractionEnabled = true
            ret.contentMode = .center
            return ret
        }()
        let closeViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleCloseViewTap))
        closeViewTapRecognizer.numberOfTapsRequired = 1
        closeViewTapRecognizer.numberOfTouchesRequired = 1
        closeView.addGestureRecognizer(closeViewTapRecognizer)
        view.addSubview(closeView)
        let views: [String: Any] = ["close": closeView]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[close(32)]-(12)-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate([closeView.heightAnchor.constraint(equalToConstant: 32)])
        if #available(iOS 11, *) {
            closeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        } else {
            closeView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 12)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if tableView.indexPathForSelectedRow == nil {
            let selectFirstIndex = IndexPath(row: 0, section: 0)
            tableView.cellForRow(at: selectFirstIndex)?.accessoryType = .checkmark
            tableView.selectRow(at: selectFirstIndex, animated: false, scrollPosition: .top)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func showLoadingIndicator() {
        indicatorBg.isHidden = false
        indicator.startAnimating()
    }

    func hideLoadingIndicator() {
        indicatorBg.isHidden = true
        indicator.stopAnimating()
    }

    @IBAction func continuePressed(_ sender: Any) {
        guard let selectedRowIndex = tableView.indexPathForSelectedRow?.row else {
            return
        }
        showLoadingIndicator()
        PaymentManager.makeCharge(amount: priceData.replacingOccurrences(of: ",", with: ""),
                                  channel: paymentChannels[selectedRowIndex],
                                  viewController: self)
    }

    @IBAction func tapGestureRecognized(_ sender: Any) {
        self.view.endEditing(true)
    }

    @objc func handleCloseViewTap() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentChannels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodTableViewCell", for: indexPath)

        let channel = paymentChannels[indexPath.row]
        cell.imageView?.image = channel.iconName
        cell.textLabel?.text = channel.paymentName
        cell.tintColor = UIColor.elepayGreen
        if tableView.indexPathForSelectedRow?.row == indexPath.row {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }

    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
        return indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
