//
//  SlideMenu.swift
//  Hausa
//
//  Created by Emre Can Bolat on 08.01.18.
//  Copyright © 2018 MNM Team. All rights reserved.
//

import UIKit

class SlideMenu: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var properties: NSMutableArray!
    var visibleRows = [Int:[Int]]()

    @IBOutlet weak var navBar: UINavigationBar!
    var interactor: Interactor? = nil
    
    @IBOutlet weak var tableView: UITableView!
    let logoImage = #imageLiteral(resourceName: "logo-black")
    
    @IBOutlet weak var portraitWidth: NSLayoutConstraint!
    @IBOutlet weak var landscapeWidth: NSLayoutConstraint!
    
    class func instanceFromNib() -> UIViewController {
        return UINib(nibName: "SlideMenu", bundle: Bundle(for: SlideMenu.self)).instantiate(withOwner: self, options: nil)[0] as! UIViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateCells), name: .gotDBTime, object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        if UIScreen.main.bounds.width < UIScreen.main.bounds.height {
            self.portraitWidth.isActive = true
            self.landscapeWidth.isActive = false
            self.tableView.isScrollEnabled = false
        } else {
            self.portraitWidth.isActive = false
            self.landscapeWidth.isActive = true
            self.tableView.isScrollEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProperties()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.dismiss(animated: false)
    }
    
    @objc func updateCells() {
        DispatchQueue.main.sync {
            self.tableView.reloadData()
        }
    }
    
    func loadProperties() {
        if let path = Bundle.main.path(forResource: "SettingsProperties", ofType: "plist") {
            properties = NSMutableArray(contentsOfFile: path)
            getVisibleRows()
            tableView.tableFooterView = UIView(frame: .zero)
            tableView.reloadData()
        }
    }
    
    func getVisibleRows() {
        visibleRows.removeAll()

        for (index, row) in properties.enumerated()  {
        
            if let row = row as? [String: AnyObject] {
                
                
                if row["visible"] as! Bool {
                    let a = (row["section"] as! Int)
                    
                    if visibleRows[a] == nil {
                        visibleRows[a] = []
                    }
                    visibleRows[a]?.append(index)

                }
            }
        }
    }
    
    func getPropertyForIndexPath(indexPath: IndexPath) -> [String: AnyObject] {
        let index = visibleRows[indexPath.section]![indexPath.row]
        let property = properties[index] as! [String: AnyObject]
        return property
    }
    
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .left)
        
        MenuHelper.mapGestureStateToInteractor(
            sender.state,
            progress: progress,
            interactor: interactor){
                self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func closeMenu(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentProperty = getPropertyForIndexPath(indexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: currentProperty["cellIdentifier"] as! String, for: indexPath) as! CustomCell
        
        cell.section = currentProperty["section"] as? Int
        cell.id = currentProperty["id"] as? Int
        cell.childRows = currentProperty["childRows"] as? Int
        cell.visible = currentProperty["visible"] as? Bool
        cell.expandable = currentProperty["expandable"] as? Bool
        cell.expanded = currentProperty["expanded"] as? Bool
        
        if cell.reuseIdentifier == "menuCell" {
            if cell.id == 0 {
                cell.setIconWithLabel(#imageLiteral(resourceName: "update_ico"), text: "Update")
                cell.setTintForUpdate()
            } else if cell.id == 7 {
                cell.setIconWithLabel(#imageLiteral(resourceName: "design_ico"), text: "Design Settings")
            } else if cell.id == 12 {
                cell.setIconWithLabel(#imageLiteral(resourceName: "contact"), text: "Contact")
            }
            
        } else if cell.reuseIdentifier == "updateCell" {
            cell.updateInformations()
            
            cell.buttonHandler = {
                switch Config.updateAvailable() {
                case .available:
                    StartupController.instance.networkManager.sendData(HN_requestUpdatedEntries())
                    cell.startUpdate()
                    break
                default:
                    StartupController.instance.networkManager.sendData(HN_requestDatabaseDate())
                    cell.startUpdate()
                    break;
                }
            }
            
        } else if cell.reuseIdentifier == "switchCell" || cell.reuseIdentifier == "switchCellDouble" {
            if cell.id == 2 {
                cell.setIconWithLabel(text: "Update only on Wifi", withSwitch: true)
                cell.switchBttn.isOn = UserConfig.isUpdateOnlyOnWifi()
                cell.switchHandler = {
                    UserConfig.setUpdateOnlyOnWifi(onlyWifi: !UserConfig.isUpdateOnlyOnWifi())
                    tableView.reloadData()
                }
            } else if cell.id == 3 {
                cell.setIconWithLabel(text: "Check for updates on startup", withSwitch: true)
                cell.switchBttn.isOn = UserConfig.isCheckForUpdatesOnStartup()
                cell.switchHandler = {
                    UserConfig.setCheckForUpdatesOnStartup(check: !UserConfig.isCheckForUpdatesOnStartup())
                    tableView.reloadData()
                }
            } else if cell.id == 13 {
                cell.setIconWithLabel(text: "Open website", withSwitch: false)
            } else if cell.id == 14 {
                cell.setLabel(text: "Contact via e-Mail")
            }
        } else if cell.reuseIdentifier == "designCell" {
            if cell.id == 8 {
                cell.setLabel(text: "Main theme color")
                cell.colorSlider.value = Float(cell.colorArray.index(of: UserConfig.getMainThemeColor())!)
                cell.sliderHandler = {
                    UserConfig.setMainThemeColor(colorHex: cell.colorArray[Int(cell.colorSlider.value)])
                }
                cell.resetHandler = {
                    UserConfig.setMainThemeColor(colorHex: 0x295b2f)
                    cell.colorSlider.value = Float(cell.colorArray.index(of: 0x295b2f)!)
                }
            } else if cell.id == 9 {
                cell.setLabel(text: "\"Most popular\"")
                cell.colorSlider.value = Float(cell.colorArray.index(of: UserConfig.getMostPopularColor())!)
                cell.sliderHandler = {
                    UserConfig.setMostPopularColor(colorHex: cell.colorArray[Int(cell.colorSlider.value)])
                }
                cell.resetHandler = {
                    UserConfig.setMostPopularColor(colorHex: 0x295b2f)
                    cell.colorSlider.value = Float(cell.colorArray.index(of: 0x295b2f)!)
                }
            } else if cell.id == 10 {
                cell.setLabel(text: "\"Recent searches\"")
                cell.colorSlider.value = Float(cell.colorArray.index(of: UserConfig.getRecentSearchesColor())!)
                cell.sliderHandler = {
                    UserConfig.setRecentSearchesColor(colorHex: cell.colorArray[Int(cell.colorSlider.value)])
                }
                cell.resetHandler = {
                    UserConfig.setRecentSearchesColor(colorHex: 0x295b2f)
                    cell.colorSlider.value = Float(cell.colorArray.index(of: 0x295b2f)!)
                }
            } else if cell.id == 11 {
                cell.setLabel(text: "\"Recent views\"")
                cell.colorSlider.value = Float(cell.colorArray.index(of: UserConfig.getRecentViewsColor())!)
                cell.sliderHandler = {
                    UserConfig.setRecentViewsColor(colorHex: cell.colorArray[Int(cell.colorSlider.value)])
                }
                cell.resetHandler = {
                    UserConfig.setRecentViewsColor(colorHex: 0x295b2f)
                    cell.colorSlider.value = Float(cell.colorArray.index(of: 0x295b2f)!)
                }
            }
        }
        
        else {
            cell.isUserInteractionEnabled = false
        }
        return cell
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return visibleRows.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleRows[section]!.count
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentProperty = getPropertyForIndexPath(indexPath: indexPath)
        
        switch currentProperty["cellIdentifier"] as! String {
        case "menuCell", "switchCell":
            return 50.0
        case "switchCellDouble":
            return 70.0
        case "updateCell":
            return 100.0
        case "shadowCell":
            return 12.0
        case "designCell":
            return 85.0
        case "copyrightCell":
            return 65
        default:
            return 44.0
        }
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! CustomCell
        let index = visibleRows[indexPath.section]![indexPath.row]
        
        if cell.expandable! {
            var shouldExpand = false
            if !cell.expanded! {
                shouldExpand = true
            }
            
            var indices: [IndexPath] = []
            for item in tableView.visibleCells.filter({ ($0 as! CustomCell).expanded! }) {
                if let item = item as? CustomCell {
                    if (properties[index] as! [String: AnyObject])["expanded"] as! Bool == true {
                        return
                    }
                    item.expanded = false
                    
                    let path = tableView.indexPath(for: item)
                    let itemIndex = visibleRows[(path?.section)!]![(path?.row)!]
                    var temp = properties[itemIndex] as! [String: AnyObject]
                    temp["expanded"] = false as AnyObject
                    self.properties.replaceObject(at: itemIndex, with: temp)
                    
                    
                    
                    let cells = tableView.visibleCells.filter({ ($0 as! CustomCell).section == item.section && $0 != item && ($0 as! CustomCell).id != nil })
                    for child in cells {
                        if let child = child as? CustomCell {
                            child.visible = false
                            
                            let path = tableView.indexPath(for: child)
                            let itemIndex = visibleRows[(path?.section)!]![(path?.row)!]
                            
                            var temp = self.properties[itemIndex] as! [String: AnyObject]
                            temp["visible"] = false as AnyObject
                            self.properties.replaceObject(at: itemIndex, with: temp)
                            indices.append(path!)
                        }
                    }
                }
            }
            
            var temp = properties[index] as! [String: AnyObject]
            temp["expanded"] = shouldExpand as AnyObject
            self.properties.replaceObject(at: index, with: temp)
            cell.expanded = shouldExpand
            
            for i in (index+1)...(index + (temp["childRows"] as! Int)) {
                var temp = self.properties[i] as! [String: AnyObject]
                temp["visible"] = shouldExpand as AnyObject
                self.properties.replaceObject(at: i, with: temp)
            }
            
            getVisibleRows()
            
            tableView.beginUpdates()
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .fade)
            if !indices.isEmpty { tableView.deleteRows(at: indices, with: .fade) }
            tableView.endUpdates()
        }
        
        if cell.id == 13 {
            UIApplication.shared.openURL(URL(string: "https://maganar-hannu.herokuapp.com/")!)
        } else if cell.id == 14 {
            //Mail senden
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserConfig.save(true)
    }
}
