//
//  CanvasStreetViewController.swift
//  HandyNation
//
//  Created by Nirav Shukla on 29/08/18.
//  Copyright © 2018 Corway Solution. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class CanvasStreetViewController: UIViewController,GMSMapViewDelegate {
    @IBOutlet weak var panoramaView : GMSPanoramaView!
    
    public var objPeopleList : PeopleList?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.panoramaView.delegate = self
        if self.objPeopleList != nil {
            let position = CLLocationCoordinate2D(latitude: (self.objPeopleList?.cllocation?.coordinate.latitude)!, longitude: (self.objPeopleList?.cllocation?.coordinate.longitude)!)
//            let marker = GMSMarker(position: position)
//            marker.panoramaView = self.panoramaView
            self.panoramaView.moveNearCoordinate(position)
        }else {
            self.panoramaView.moveNearCoordinate(CLLocationCoordinate2D(latitude: AppDelegate.delegate().currentLocation.coordinate.latitude, longitude: AppDelegate.delegate().currentLocation.coordinate.longitude))
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.panoramaView.camera = GMSPanoramaCamera(heading: 180, pitch: -10, zoom: 10)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
    }
    // MARK: - backButton
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CanvasStreetViewController: GMSPanoramaViewDelegate {
    func panoramaView(_ view: GMSPanoramaView, error: Error, onMoveNearCoordinate coordinate: CLLocationCoordinate2D) {
//        print(error.localizedDescription)
        print("\(coordinate.latitude) \(coordinate.longitude) not available")
        let alert = UIAlertController(title: "Alert", message: "Can't get the streetView, try after sometimes.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
