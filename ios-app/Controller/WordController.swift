//
//  WordController.swift
//  Hausa
//
//  Created by Emre Can Bolat on 17.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import UIKit

class WordController: UIViewController, UIScrollViewDelegate {
    
    let screenMng: ScreenManager = ScreenManager.instance
    
    @IBOutlet weak var hausaLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    
    public var selectedEntry: Entry!
    public var activeList: [Entry]!
    
    @IBOutlet var pageControl: UIPageControl!
    
    @IBOutlet weak var scrollContainer: UIScrollView!
    @IBOutlet weak var caption: UIStackView!
    
    var index: Int!
    var activeImgIndex: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pageControl.hidesForSinglePage = true
        updateEntry(true)
        
        scrollContainer.minimumZoomScale = 1.0
        scrollContainer.maximumZoomScale = 2.5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: {
            _ in
            self.layout()
        })
    }
    
    override func viewWillLayoutSubviews() {
        self.layout()
    }
    
    func layout() {
        print(self.scrollContainer.frame)
        for (index, view) in self.scrollContainer.subviews.filter({ if $0 is UIImageView { return false } else { return true }}).enumerated() {
            view.frame = CGRect(x: CGFloat(index) * scrollContainer.frame.width, y: 0, width: self.scrollContainer.frame.width, height: self.scrollContainer.frame.height)
            for image in view.subviews {
                image.frame = CGRect(x: 0, y: 0, width: self.scrollContainer.frame.width, height: self.scrollContainer.frame.height)
                image.contentMode = .scaleAspectFit
            }
        }
    }
    
    func getAsString(list: [String]) -> String {
        var string = ""
        for a in list {
            string.append(a)
            if list.last != a {
                string.append(", ")
            }
        }
        return string
    }
    
    @IBAction func setFavorite(_ sender: Any) {
        screenMng.setFavorited(entry: selectedEntry)
        selectedEntry.favorite == true ? (favoriteButton.image = #imageLiteral(resourceName: "favorite_selected")) : (favoriteButton.image = #imageLiteral(resourceName: "favorite"))
    }
    
    @IBAction func exitWordScreen(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func share(_ sender: UIBarButtonItem) {
        // text to share
        let text = "Look at the sign for the word \"" + selectedEntry.word + "\". \n That's amazing! \n" + "https://maganar-hannu.herokuapp.com/#/word/" + String(selectedEntry.id) +
        "\n You can also download the app on the website!"
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.saveToCameraRoll, UIActivityType.addToReadingList,
                                                         UIActivityType.assignToContact, UIActivityType.openInIBooks, UIActivityType.postToVimeo, UIActivityType.print ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func onNext(_ sender: UIButton) {
        self.selectedEntry = activeList[index + 1]
        updateEntry()
    }
    
    @IBAction func onPrevious(_ sender: UIButton) {
        self.selectedEntry = activeList[index - 1]
        updateEntry()
    }
    
    func updateEntry(_ updateAL: Bool? = false) {
        if updateAL! { self.activeList = screenMng.getActiveEntryList() }
        if let index = activeList.index(of: selectedEntry) {
            self.index = index
        }
        
        if selectedEntry is EnglishEntry {
            self.hausaLabel.text = getAsString(list: (selectedEntry.translationList)!)
            self.englishLabel.text = selectedEntry.word
        } else {
            self.hausaLabel.text = selectedEntry.word
            self.englishLabel.text = getAsString(list: (selectedEntry.translationList)!)
        }
        
        selectedEntry.favorite == true ? (favoriteButton.image = #imageLiteral(resourceName: "favorite_selected")) : (favoriteButton.image = #imageLiteral(resourceName: "favorite"))
        screenMng.addHit(entry: selectedEntry)

        if index == 0 {
            previousButton.isHidden = true;
            nextButton.isHidden = false
        }
        if index == activeList.count - 1 {
            nextButton.isHidden = true
            previousButton.isHidden = false;
        }
        if (index != 0) && (index != activeList.count - 1) {
            nextButton.isHidden = false; previousButton.isHidden = false;
        }
        
        if index == 0 && index == activeList.count - 1{
            previousButton.isHidden = true;
            nextButton.isHidden = true
        }
        
        for view in self.scrollContainer.subviews {
            view.removeFromSuperview()
        }
        
        self.pageControl.numberOfPages = selectedEntry.imageList.count
        for (idx, media) in selectedEntry.imageList.enumerated() {
            scrollContainer.addSubview(self.createImage(index: CGFloat(idx), media))
            scrollContainer.contentSize = CGSize(width: scrollContainer.frame.width * CGFloat(idx+1), height: scrollContainer.frame.height)
        }
    }
    
    func createImage(index: CGFloat, _ signImage: SignImage) -> UIView {
        let view = UIView(frame: CGRect(x: index * scrollContainer.frame.width, y: 0, width: scrollContainer.frame.width, height: scrollContainer.frame.height))
        
        if signImage.media == nil {
            OperationQueue().addOperation(BlockOperation { () -> Void in
                signImage.setMedia()
                
                OperationQueue.main.addOperation({
                    let originalImage = signImage.media
                    let image = UIImageView(frame: CGRect(x: 0, y: 0, width: self.scrollContainer.frame.width, height: self.scrollContainer.frame.height))
                    image.contentMode = .scaleAspectFit
                    image.image = originalImage
                    view.addSubview(image)
                })
            })
        } else {
            let originalImage = signImage.media
            let image = UIImageView(frame: CGRect(x: 0, y: 0, width: scrollContainer.frame.width, height: scrollContainer.frame.height))
            image.contentMode = .scaleAspectFit
            image.image = originalImage
            view.addSubview(image)
        }
        
        return view
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollContainer.contentSize = CGSize(width: scrollContainer.frame.width * CGFloat(pageControl.numberOfPages), height: scrollContainer.frame.height)
        if !scrollView.isScrollEnabled {
            scrollView.contentOffset.x = scrollView.frame.width * CGFloat((self.pageControl?.currentPage)!)
            return
        }

        let pageSize = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        self.pageControl?.currentPage = lround(Double(pageSize))
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.isScrollEnabled = false
        for (idx, view) in scrollView.subviews.filter({ if $0 is UIImageView { return false } else { return true }}).enumerated() {
            if idx != self.pageControl?.currentPage { view.isHidden = true }
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale >= scrollView.maximumZoomScale {
            scrollView.zoomScale = scrollView.maximumZoomScale
        }
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollView.zoomScale = 1.0
        for view in scrollView.subviews.filter({ if $0 is UIImageView { return false } else { return true }}) {
            view.isHidden = false
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(pageControl.numberOfPages), height: scrollView.frame.height)
        scrollView.isScrollEnabled = true;
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return scrollView.subviews.filter({ if $0 is UIImageView { return false } else { return true }})[(self.pageControl?.currentPage)!]
    }
}
