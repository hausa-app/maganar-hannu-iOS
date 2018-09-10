//
//  MainAlertController.swift
//  Hausa
//
//  Created by Emre Can Bolat on 04.01.18.
//  Copyright © 2018 MNM Team. All rights reserved.
//

import UIKit

class MainAlertController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let tableView = UITableView()
    let popupView = UIView()
    let headerLabel = UILabel()
    let definitionLabel = UILabel()
    
    var const: NSLayoutConstraint!
    var heightConst: CGFloat = 0
    var constraint: NSLayoutConstraint!
    
    var innerView: UIView!
    
    override func loadView() {
        self.view = UIView()

        popupView.backgroundColor = UIColor.groupTableViewBackground
        popupView.layer.cornerRadius = 5
        
        innerView = UIView()
        innerView.backgroundColor = UIColor.white
        innerView.layer.cornerRadius = 5
        
        let titleStack = UIStackView()
        titleStack.axis = .vertical
        titleStack.alignment = .center
        titleStack.distribution = .fillEqually
        titleStack.spacing = 2
        
        headerLabel.text = "header"
        
        definitionLabel.text = "definition"
        definitionLabel.font = UIFont.systemFont(ofSize: 13)
        definitionLabel.textColor = UIColor.lightGray
        
        titleStack.addArrangedSubview(headerLabel)
        titleStack.addArrangedSubview(definitionLabel)
        
        let seperator = UIView()
        seperator.backgroundColor = .groupTableViewBackground
        
        tableView.backgroundColor = UIColor.gray
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.separatorInset.right = 15
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        
        let bottomButtons = UIStackView()
        bottomButtons.axis = .horizontal
        bottomButtons.alignment = .fill
        bottomButtons.distribution = .fill
        
        let cancel = UIButton()
        cancel.setTitle("Cancel", for: .normal)
        cancel.setTitleColor(UIColor.blue, for: .normal)
        cancel.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        cancel.addTarget(self, action: #selector(cancelRequest), for: .touchUpInside)
        
        let seperatorBB = UIView()
        seperatorBB.backgroundColor = .groupTableViewBackground
        
        let button = UIButton()
        button.setTitle("Confirm", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(confirmRequest), for: .touchUpInside)
        
        bottomButtons.addArrangedSubview(cancel)
        bottomButtons.addArrangedSubview(seperatorBB)
        bottomButtons.addArrangedSubview(button)
        
        let seperator2 = UIView()
        seperator2.backgroundColor = .groupTableViewBackground
        
        innerView.addSubview(titleStack)
        innerView.addSubview(seperator)
        innerView.addSubview(tableView)
        innerView.addSubview(bottomButtons)
        innerView.addSubview(seperator2)
        
        popupView.addSubview(innerView)
        self.view.addSubview(popupView)
        
        popupView.translatesAutoresizingMaskIntoConstraints = false
        innerView.translatesAutoresizingMaskIntoConstraints = false
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        seperator.translatesAutoresizingMaskIntoConstraints = false
        bottomButtons.translatesAutoresizingMaskIntoConstraints = false
        cancel.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        seperator2.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraint(NSLayoutConstraint(item: popupView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailingMargin, multiplier: 1, constant: -10))
        
        if view.frame.size.width < self.view.frame.size.height {
            view.addConstraint(NSLayoutConstraint(item: popupView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 80))
        } else {
            view.addConstraint(NSLayoutConstraint(item: popupView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
        }
        
        
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .leadingMargin, relatedBy: .equal, toItem: popupView, attribute: .leading, multiplier: 1, constant: -10))

        popupView.addConstraint(NSLayoutConstraint(item: innerView, attribute: .top, relatedBy: .equal, toItem: popupView, attribute: .top, multiplier: 1, constant: 2))
        popupView.addConstraint(NSLayoutConstraint(item: innerView, attribute: .leading, relatedBy: .equal, toItem: popupView, attribute: .leading, multiplier: 1, constant: 2))
        popupView.addConstraint(NSLayoutConstraint(item: popupView, attribute: .trailing, relatedBy: .equal, toItem: innerView, attribute: .trailing, multiplier: 1, constant: 2))
        popupView.addConstraint(NSLayoutConstraint(item: popupView, attribute: .bottom, relatedBy: .equal, toItem: innerView, attribute: .bottom, multiplier: 1, constant: 2))
        
        titleStack.addConstraint(NSLayoutConstraint(item: titleStack, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40))
        
        innerView.addConstraint(NSLayoutConstraint(item: titleStack, attribute: .leading, relatedBy: .equal, toItem: innerView, attribute: .leading, multiplier: 1, constant: 0))
        innerView.addConstraint(NSLayoutConstraint(item: innerView, attribute: .trailing, relatedBy: .equal, toItem: titleStack, attribute: .trailing, multiplier: 1, constant: 0))
        innerView.addConstraint(NSLayoutConstraint(item: titleStack, attribute: .top, relatedBy: .equal, toItem: innerView, attribute: .top, multiplier: 1, constant: 5))
        
        seperator.addConstraint(NSLayoutConstraint(item: seperator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1))
        seperator2.addConstraint(NSLayoutConstraint(item: seperator2, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1))
        
        innerView.addConstraint(NSLayoutConstraint(item: seperator, attribute: .leading, relatedBy: .equal, toItem: innerView, attribute: .leading, multiplier: 1, constant: 0))
        innerView.addConstraint(NSLayoutConstraint(item: seperator2, attribute: .leading, relatedBy: .equal, toItem: innerView, attribute: .leading, multiplier: 1, constant: 0))
        innerView.addConstraint(NSLayoutConstraint(item: seperator, attribute: .top, relatedBy: .equal, toItem: titleStack, attribute: .bottom, multiplier: 1, constant: 8))
        innerView.addConstraint(NSLayoutConstraint(item: seperator, attribute: .width, relatedBy: .equal, toItem: titleStack, attribute: .width, multiplier: 1, constant: 0))
        innerView.addConstraint(NSLayoutConstraint(item: innerView, attribute: .trailing, relatedBy: .equal, toItem: seperator, attribute: .trailing, multiplier: 1, constant: 0))
        
        innerView.addConstraint(NSLayoutConstraint(item: seperator2, attribute: .top, relatedBy: .equal, toItem: tableView, attribute: .bottom, multiplier: 1, constant: 0))
        innerView.addConstraint(NSLayoutConstraint(item: seperator2, attribute: .width, relatedBy: .equal, toItem: tableView, attribute: .width, multiplier: 1, constant: 0))
        innerView.addConstraint(NSLayoutConstraint(item: innerView, attribute: .trailing, relatedBy: .equal, toItem: seperator2, attribute: .trailing, multiplier: 1, constant: 0))
        innerView.addConstraint(NSLayoutConstraint(item: bottomButtons, attribute: .top, relatedBy: .equal, toItem: seperator2, attribute: .bottom, multiplier: 1, constant: 0))
        
        innerView.addConstraint(NSLayoutConstraint(item: tableView, attribute: .width, relatedBy: .equal, toItem: titleStack, attribute: .width, multiplier: 1, constant: 0))
        innerView.addConstraint(NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: innerView, attribute: .leading, multiplier: 1, constant: 0))
        innerView.addConstraint(NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: seperator, attribute: .bottom, multiplier: 1, constant: 0))

        innerView.addConstraint(NSLayoutConstraint(item: innerView, attribute: .trailing, relatedBy: .equal, toItem: tableView, attribute: .trailing, multiplier: 1, constant: 0))

                innerView.addConstraint(NSLayoutConstraint(item: bottomButtons, attribute: .width, relatedBy: .equal, toItem: tableView, attribute: .width, multiplier: 1, constant: 0))
        innerView.addConstraint(NSLayoutConstraint(item: bottomButtons, attribute: .leading, relatedBy: .equal, toItem: innerView, attribute: .leading, multiplier: 1, constant: 0))

        innerView.addConstraint(NSLayoutConstraint(item: innerView, attribute: .trailing, relatedBy: .equal, toItem: bottomButtons, attribute: .trailing, multiplier: 1, constant: 0))
        innerView.addConstraint(NSLayoutConstraint(item: innerView, attribute: .bottom, relatedBy: .equal, toItem: bottomButtons, attribute: .bottom, multiplier: 1, constant: 0))
        
        bottomButtons.addConstraint(NSLayoutConstraint(item: bottomButtons, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50))
        bottomButtons.addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: cancel, attribute: .height, multiplier: 1, constant: 0))
        bottomButtons.addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: cancel, attribute: .width, multiplier: 1, constant: 0))
        
        seperatorBB.addConstraint(NSLayoutConstraint(item: seperatorBB, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 1))
        
        const = NSLayoutConstraint(item: popupView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(const)

        heightConst = 2 + 5 + 40 + 8 + 1 + 1 + 50 + 2
        
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(white: 0.4, alpha: 0.8)
    }
    
    override func viewWillLayoutSubviews() {
        const.isActive = false
        if constraint != nil { constraint.isActive = false }
        
        var frame = self.tableView.frame;
        frame.size.height = self.tableView.contentSize.height;
        self.tableView.frame = frame;
        
        //constraint = NSLayoutConstraint(item: popupView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: tableView.contentSize.height + heightConst)
        //popupView.addConstraint(constraint)
        tableView.addConstraint(NSLayoutConstraint(item: tableView, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: tableView.frame.size.height))
    }
    
    @objc func cancelRequest(sender: UIButton!) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func confirmRequest(sender: UIButton!) {
        dismiss(animated: true, completion: nil)
    }
    
    var header: [String]? {
        didSet {
            self.headerLabel.text = header?[0]
            self.definitionLabel.text = header?[1]
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    
    
}
