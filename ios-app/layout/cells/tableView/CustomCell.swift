//
//  ImageLabelCell.swift
//  Hausa
//
//  Created by Emre Can Bolat on 09.01.18.
//  Copyright © 2018 MNM Team. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    
    // The UIView connected to all containers of UITableViewCells consisting of all subviews
    @IBOutlet weak var container: UIView!
    
    // The UIImageView for the icon of the MenuCell
    @IBOutlet weak var icon: UIImageView!
    
    // The UILabel defining the text of the MenuCell, SwitchCell and the DesignCell
    @IBOutlet weak var label: UILabel!
    
    // The UISwitch for the SwitchCell
    @IBOutlet weak var switchBttn: UISwitch!
    
    // The UIImageView for the "expanded" image of the MenuCell
    @IBOutlet weak var expandIco: UIImageView!
    
    // The UISlider used for the DesignCell to determine the chosen color
    @IBOutlet weak var colorSlider: UISlider!
    
    // The function getting called when the slider is being moved
    var sliderHandler: () -> () = { }
    
    // The function getting called when the reset button is being pushed
    var resetHandler: () -> () = { }
    
    // The function getting called when the switch button is being used
    var switchHandler: () -> () = { }
    
    // The function getting called when the button of the UpdateCell is being pushed
    var buttonHandler: () -> () = { }
    
    // An array consisting of HEX codes for the colors that can be chosen
    let colorArray = [ 0x000000, 0xfe0000, 0xff7900, 0xffb900, 0xffde00, 0xd2ff00, 0x05c000, 0x295b2f, 0x00c0a7, 0x0600ff, 0x6700bf, 0x9500c0, 0xbf0199 ]
    
    // A Int variable determining the current section the cell is nested in
    var section: Int?
    
    // A Int variable determining the current id of the cell in the ListView
    var id: Int?
    
    // A Int variable determining the available expandable childs (if cell is expandable/MenuCell)
    var childRows: Int?
    
    // A Bool variable determining the visibility of the cell
    var visible: Bool?
    
    // A Bool variable determining the availability to expand the cell
    var expandable: Bool?
    
    // A Bool variable determining the current state of the expandable cell
    // sets the "expand" image to expanded image or /expanded image
    var expanded: Bool? {
        didSet {
            if expandable! {
                if expanded! {
                    expandIco.image = #imageLiteral(resourceName: "up_ico")
                } else {
                    expandIco.image = #imageLiteral(resourceName: "down_ico")
                }
            }
        }
    }
    
    // The overridden function getting called when view is being build.
    // Sets the selectionStyle to .none, so no animation while selecting occurs.
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    /**
     Sets the label of the MenuCell, DesignCell and Switch Cell, brings also the availability to disable the
     switch button and also can set the icon of the MenuCell. Last two availabilities are optional.
     
     - Parameters:
     - image: (optional) The image for the icon of the MenuCell
     - text: The text used for the label
     - withSwitch: (optional) The bool value setting the switch button
     */
    func setIconWithLabel(_ image: UIImage? = nil, text: String, withSwitch: Bool = false) {
        if icon != nil { icon.image = image }
        label.text = text
        if (switchBttn != nil) { switchBttn.isHidden = !withSwitch }
    }
    
    func setLabel(text: String) {
        label.text = text
        if (switchBttn != nil) { switchBttn.isHidden = true }
    }
    
    // The function connected to the InterfaceBuilder that executes the predefined function when the slider is being moved
    @IBAction func sliderMoved(_ sender: UISlider) {
        sliderHandler()
    }

    // The function connected to the InterfaceBuilder that executes the predefined function when the reset button is being touched
    @IBAction func resetRequest(_ sender: UIButton) {
        resetHandler()
    }
    
    // The UILabel determining the text in the UpdateCell defining the database time
    @IBOutlet weak var databaseText: UILabel!
    @IBOutlet weak var updateHeader: UILabel!
    @IBOutlet weak var lastChecked: UILabel!
    @IBOutlet weak var updateImage: UIImageView!
    @IBOutlet weak var updateButton: UIButton!
    
    let downloadImage = #imageLiteral(resourceName: "download")
    let utdImage = #imageLiteral(resourceName: "uptodate")
    let checkImage = #imageLiteral(resourceName: "question_ico")
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    func updateInformations() {
        updateImage.isHidden = false
        
        let databaseTimestamp = UserConfig.getDatabaseTimestamp()
        if databaseTimestamp == 332145240 {
            databaseText.text = "Initial Version"
        } else { databaseText.text = databaseTimestamp.toDate().format() }
        
        switch Config.updateAvailable() {
        case .available:
            updateHeader.text = "Update available!"
            updateImage.image = downloadImage
            break
        case .upToDate:
            updateHeader.text = "Everything up to date!"
            updateImage.image = utdImage
            break
        case .notChecked:
            updateImage.image = checkImage
            break;
        }
        if AppConfig.getLastCheckedDBTimestampServer() == nil { lastChecked.text = "Last checked: never"}
        else { lastChecked.text = "Last checked: " + Utilities.buildTime(Date().toInt() - AppConfig.getLastCheckedDBTimestampServer()!) }
        updateHeader.underline()
        
        let status = StartupController.instance.networkManager.checkNetworkAvailability()
        switch status {
        case .online(.wiFi):
            updateButton.isEnabled = true
            updateImage.alpha = 1.0
            break
        default:
            if UserConfig.updateOnlyOnWifi {
                updateButton.isEnabled = false
                updateImage.alpha = 0.25
            } else {
                updateButton.isEnabled = true
                updateImage.alpha = 1.0
            }
            break
        }
    }
    
    func setTintForUpdate() {
        if Config.updateAvailable() == .available {
            icon.tintColor = .red
            label.textColor = .red
        }
    }
    
    func startUpdate() {
        updateImage.isHidden = true
        indicator.startAnimating()
    }
    
    // The function connected to the InterfaceBuilder that executes the predefined function when the switch value is being changed
    @IBAction func pushSwitch(_ sender: UISwitch) {
        switchHandler()
    }
    
    // The function connected to the InterfaceBuilder that executes the predefined function when the button is being pushed
    @IBAction func pushButton(_ sender: UIButton) {
        buttonHandler()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if icon != nil { icon.tintColor = .black }
        if label != nil { label.textColor = .black }
        if (switchBttn != nil) { switchBttn.isHidden = true }
    }

}
