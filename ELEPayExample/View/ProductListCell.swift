//
// Created on 2018/08/15, by Yin Tan
// Copyright © 2018 ELESTYLE, Inc. All rights reserved.
//

import UIKit

protocol ProductListCellActionDelegate: class {
    func productListCellDidTapPayButton(cell: ProductListCell)
}

final class ProductListCell: UITableViewCell {
    weak var actionDelegate: ProductListCellActionDelegate? = nil

    private let productImageView: UIImageView = {
        let ret = UIImageView()
        ret.translatesAutoresizingMaskIntoConstraints = false
        return ret
    }()
    private let titleView: UILabel = {
        let ret = UILabel()
        ret.translatesAutoresizingMaskIntoConstraints = false
        ret.numberOfLines = 0
        ret.font = UIFont.boldSystemFont(ofSize: 20)
        return ret
    }()
    private let priceView: UILabel = {
        let ret = UILabel()
        ret.translatesAutoresizingMaskIntoConstraints = false
        ret.numberOfLines = 1
        ret.font = UIFont.systemFont(ofSize: 14)
        ret.textColor = UIColor.darkGray
        return ret
    }()
    private let payButton: UIButton = {
        let ret = UIButton(type: .custom)
        ret.setTitle("Buy", for: .normal)
        ret.backgroundColor = UIColor.elepayGreen
        ret.setTitleColor(UIColor.white, for: .normal)
        ret.translatesAutoresizingMaskIntoConstraints = false
        ret.titleLabel?.leadingAnchor.constraint(equalTo: ret.leadingAnchor).isActive = true
        ret.titleLabel?.trailingAnchor.constraint(equalTo: ret.trailingAnchor).isActive = true
        ret.titleLabel?.topAnchor.constraint(equalTo: ret.topAnchor).isActive = true
        ret.titleLabel?.bottomAnchor.constraint(equalTo: ret.bottomAnchor).isActive = true
        ret.titleLabel?.textAlignment = .center
        ret.layer.cornerRadius = 20
        return ret
    }()

    private var data: Product = Product(imageUrl: "", title: "", price: "")

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        selectionStyle = .none

        contentView.addSubview(productImageView)
        contentView.addSubview(titleView)
        contentView.addSubview(priceView)
        contentView.addSubview(payButton)

        let views: [String: Any] = ["image": productImageView, "title": titleView, "price": priceView, "pay": payButton]
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[image(80)]-[title]-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[price]-[pay(100)]-|", options: .alignAllFirstBaseline, metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-(>=8)-[image(80)]-(>=8)-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[title]-(>=8)-[price]-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[title]-(>=8)-[pay(40)]-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate([
            priceView.leftAnchor.constraint(equalTo: titleView.leftAnchor),
            productImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])

        payButton.addTarget(self, action: #selector(handlePayButtonTap), for: .touchUpInside)
    }

    var priceData: String {
        return data.price
    }

    public func config(product: Product) {
        data = product
        
        // TODO: load image url?
        productImageView.image = UIImage(named: "product_sample_img")
        titleView.text = product.title
        priceView.text = "¥" + product.price
    }

    @objc private func handlePayButtonTap() {
        actionDelegate?.productListCellDidTapPayButton(cell: self)
    }
}
