//
//  DetailViewController.swift
//  YouthServices
//
//  Created by Southampton Dev on 9/15/16.
//  Copyright © 2016 TOS. All rights reserved.
//

import UIKit
import WebKit
import GoogleMaps


class DetailViewController: UIViewController, UIPopoverPresentationControllerDelegate, WKNavigationDelegate {

    /*
    @IBOutlet var nameField: UILabel!
    @IBOutlet var addressField: UILabel!
    @IBOutlet var telField: UILabel!
    @IBOutlet var descriptionField: UILabel!
    @IBOutlet var websiteField: UILabel!
    @IBOutlet var feeField: UILabel!
    */
    var webView: WKWebView!
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    var lat: Double? = 0
    var lon: Double? = 0
   
    
    var facility: Facility! {
        didSet {
            navigationItem.title = facility.Name

            if facility.URL! != "" {

            } else {
                let alertController = UIAlertController(title: "There is bad or non-existent coordinate information for this facility", message: "Click OK to continue", preferredStyle: .alert)

                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    //NSLog("OK Pressed")
                }

                alertController.addAction(okAction)
                self.presentViewController(alert: alertController, animated: true, completion: nil)

            }
        }
    }


   
    private func presentViewController(alert: UIAlertController, animated flag: Bool, completion: (() -> Void)?) -> Void {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        window?.rootViewController?.present(alert, animated: flag, completion: completion)
        //UIApplication.shared.windows.filter {$0.isKeyWindow}.first.rootViewController?.present(alert, animated: flag, completion: completion)
        //UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: flag, completion: completion)
    }
    

    func configureView() {
        
          webView = WKWebView()
              webView.navigationDelegate = self
              view = webView
              var url:URL

              if let facility = self.facility  {
                url = URL(string:facility.URL!)!

              }
              else
              {
                  url = URL(string:"https://www.southamptontownny.gov")!

              }


              webView.load(URLRequest(url:url))
              webView.allowsBackForwardNavigationGestures = true


/*
        if let facility = self.facility  {
            
            let info = facility.Address! + "\n" + "Fee: " + facility.Fee! + "\n" + facility.Telephone! + "\n\n"  + facility.Desc!

            let camera = GMSCameraPosition.camera(withLatitude: self.lat!, longitude: self.lon!, zoom: 15.0)
            mapView = GMSMapView.map(withFrame: .zero, camera: camera)
            
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: self.lat!, longitude: self.lon!)
            marker.title = facility.F_Name!
            marker.snippet = info
            marker.map = mapView

        }  else  {
            let camera = GMSCameraPosition.camera(withLatitude: 40.8875, longitude: -72.3853, zoom: 15.0)
            mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        }

          mapView.delegate = self
          self.view = mapView
        
        
        //Add a segmented control for selecting the map type.
        let items = ["Normal", "Hybrid"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        
        let frame = UIScreen.main.bounds
        segmentedControl.frame = CGRect(x: frame.minX + 10, y: frame.minY + 65, width: 350, height: frame.height*0.05)
        segmentedControl.layer.cornerRadius = 10.0
        segmentedControl.addTarget(self, action: #selector(DetailViewController.mapType(_:)), for: UIControl.Event.valueChanged)
        segmentedControl.addTarget(self, action: #selector(DetailViewController.segColor(_:)), for: UIControl.Event.valueChanged)

        self.view.addSubview(segmentedControl)
 */
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //making a button
        let lbutton: UIButton = UIButton()
        lbutton.setImage(UIImage(named: "Contact.png"), for: .normal)
        lbutton.frame = CGRect(x: 0,y: 0, width: 35, height: 35)
        lbutton.target(forAction: #selector(DetailViewController.showContactEmail), withSender: self)
        lbutton.addTarget(self, action: #selector(DetailViewController.showContactEmail), for: UIControl.Event.touchUpInside)
        
                //making a button
        let calbutton: UIButton = UIButton()
        calbutton.setImage(UIImage(named: "Calendar.png"), for: .normal)
        calbutton.frame = CGRect(x: -160,y: 0, width: 40, height: 40)
        calbutton.target(forAction: #selector(DetailViewController.showContactEmail), withSender: self)
        calbutton.addTarget(self, action: #selector(DetailViewController.calendarButtonTapped), for: UIControl.Event.touchUpInside)
        
        let rbutton: UIButton = UIButton()
        rbutton.setImage(UIImage(named: "Hotline.png"), for: .normal)
        rbutton.frame = CGRect(x: -80,y: 0, width: 40, height: 40)
        rbutton.target(forAction: #selector(DetailViewController.hotlineButtonTapped), withSender: self)
        rbutton.addTarget(self, action: #selector(DetailViewController.hotlineButtonTapped), for: UIControl.Event.touchUpInside)
        
        //making a UIBarbuttonItem on UINavigationBar
        let leftItem:UIBarButtonItem = UIBarButtonItem()
        leftItem.customView = lbutton
        
        //making a UIBarbuttonItem on UINavigationBar
        let calItem:UIBarButtonItem = UIBarButtonItem()
        calItem.customView = calbutton
        
        let rightItem:UIBarButtonItem = UIBarButtonItem()
        rightItem.customView = rbutton

        self.navigationItem.setRightBarButtonItems([leftItem,rightItem,calItem], animated:true)
        self.navigationItem.setHidesBackButton(false, animated:true)
        

        self.configureView()

    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return .none
        
    }
    
    func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        
        //print("prepare for presentation")
        
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
        //print("did dismiss")
        
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        
        //print("should dismiss")
        
        return true
        
    }
 
    @IBAction func calendarButtonTapped(_ sender: AnyObject) {
        
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "calendarViewController")
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        popController.preferredContentSize = CGSize(width: 400, height: 350)
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = (sender as! UIView)
        popController.popoverPresentationController?.sourceRect = sender.bounds
        
        // present the popover
        self.present(popController, animated: true, completion: nil)
    }
    
    
    @IBAction func hotlineButtonTapped(_ sender: AnyObject) {
        // get a reference to the view controller for the popover
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "hotlineViewController")
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        popController.preferredContentSize = CGSize(width: 400, height: 350)
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = (sender as! UIView)
        popController.popoverPresentationController?.sourceRect = sender.bounds
        
        // present the popover
        self.present(popController, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
    
    func orientationChanged()
    {
        if(UIDevice.current.orientation.isLandscape){
            
        }
        
        if(UIDevice.current.orientation.isPortrait){

        }
        
    }

    @objc func showContactEmail(sender:AnyObject)  {
        
        let url = URL(string: "mailto:gissupport@southamptontownny.gov")
        UIApplication.shared.open(url!)
    }
    
}







