//
//  CanvasMapVC.swift
//  HandyNation
//
//  Created by admin on 05/07/18.
//  Copyright © 2018 Corway Solution. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class CanvasMapVC: UIViewController {
    @IBOutlet weak var mapCanvas: GMSMapView?
    @IBOutlet weak var btnOpenSortList: UIButton?
    @IBOutlet weak var navTitleLabel: UILabel?
    
    /* == CanvasingView PopUp == */
    @IBOutlet weak var walkCompletedView: UIView?
    @IBOutlet weak var dismissButton: UIButton?
    @IBOutlet weak var startCanvassingView: UIView?
    @IBOutlet weak var startCanvassingButton: UIButton?
    
    /* == People Details PopUp == */
    @IBOutlet weak var peopleDetailView: UIView?
    @IBOutlet weak var phoneStackView = UIStackView()
    
    @IBOutlet weak var markasCompletedButton: UIButton?
    @IBOutlet weak var startWalkButton: UIButton?
    
    @IBOutlet weak var addressLabel: UILabel?
    @IBOutlet weak var nameLabel: UILabel?
    
    @IBOutlet weak var callButton: UIButton?
    @IBOutlet weak var streetButton: UIButton?
    
    @IBOutlet weak var distancekmLabel: UILabel?
    @IBOutlet weak var durationTimeLabel: UILabel?
    @IBOutlet weak var arrowButton: UIButton?
    
    @IBOutlet weak var currentTimeLabel: UILabel?
    @IBOutlet weak var moreButton: UIButton?
    @IBOutlet weak var moreImage: UIImageView?
    @IBOutlet weak var peopleListBottomConstraint: NSLayoutConstraint!
    
    /* == currentView PopUp == */
    @IBOutlet weak var allButtonView: UIView?
    @IBOutlet weak var currentLocationButton: UIButton?
    @IBOutlet weak var trafficButton: UIButton?
    @IBOutlet weak var mapTypeButton: UIButton?
    @IBOutlet weak var walkButton: UIButton?
    
    /* == draw path with animation == */
    var polyline = GMSPolyline()
    var animationPolyline = GMSPolyline()
    
    var animationPath = GMSMutablePath() // animated path
    var path = GMSPath()
    
    var i: UInt = 0
    var timerCount : Int = 0 // draw path only two time
    var timerAnimationPath: Timer! // set Timer for draw animated path
    
    var polypoints : String = ""
    var oldPolylineArr = [GMSPolyline]() // set highlight path remove and re assign
    /* ==================================== */
    
    /* == Loader == */
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    /* ==================================== */
    
    var objList : PeopleList? // get List Id from previous controller

    var arrPeople =  NSMutableArray() // get people list from array
    var arrMarkAsPeople =  NSMutableArray() // get people list from array
    var locationmarker = GMSMarker() // marker object
    
    var timer = Timer() // setTimer for get current time
    var infoWindow = canvasMarker()
    var currentZoom: Float = 18
    
    var currentLocationMarker = GMSMarker() // setUp currentLocation Marker Pin
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("ListID" + PeopleList.sharedManager.listID)
        self.navTitleLabel?.text = PeopleList.sharedManager.navTitle
        self.addressLabel?.sizeToFit() // address Label Size to fix text
        self.peopleListBottomConstraint.constant = 300;
        self.peopleDetailView?.isHidden = true
        self.allButtonView?.isHidden = true
        self.showHideButtonWithAnimation(isHide : 0)
        self.changeMapType() // check map type and setUp image into Map Type Button
        self.mapCanvas?.delegate = self
        self.setUpSlugWithWebservices() // getting all pins from webservices
        
        self.startCanvassingView?.isHidden = true
        if PeopleList.sharedManager.isStartCanvasing == false{
            self.startCanvassingView?.isHidden = false
        }
        
        let recognizer = UITapGestureRecognizer(target: self,action:#selector(self.handleTap(recognizer:)))
        self.peopleDetailView?.isUserInteractionEnabled = true
        self.arrowButton?.isUserInteractionEnabled = false
        recognizer.delegate = self as? UIGestureRecognizerDelegate
        self.peopleDetailView?.addGestureRecognizer(recognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CanvasMapVC.methodOfReceivedNotification(notification:)), name: Notification.Name("reloadCanvasingMarkAsCompletedListNotification"), object: nil)
    }
    func handleTap(recognizer:UITapGestureRecognizer) {
        self.setArrowUpAndDown() // start Animate Bottom View
    }
    func methodOfReceivedNotification(notification: Notification){
        PeopleList.sharedManager.objSelectedPeople?.isPeopleSelected = true
        self.arrowButton?.setImage(UIImage(named: "canvas_Top_Arrow"), for: .normal)
        self.mapAddAnnotation(obj: PeopleList.sharedManager.objSelectedPeople!)
        PeopleList.sharedManager.objSelectedPeople = nil
        self.startCanvasing()
        self.drawPathNearByCurrentLocation()
        
        self.infoWindow.removeFromSuperview()
        //Take Action on Notification
    }
    // MARK: - backButton
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        let alert = UIAlertController(title: "Are you sure ?", message: "Do you want to stop canvassing ?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "NO", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "YES", style: UIAlertActionStyle.default, handler: { action in
            self.view.endEditing(true)
            let _ = self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - ShortButton tapped
    @IBAction func btnShortAction(_ sender: UIButton)
    {
        if PeopleList.sharedManager.isStartCanvasing == true {
            let canvasNearByVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CanvasNearByVC") as! CanvasNearByListVc
            canvasNearByVc.arrCanvasPeople = self.arrPeople
            self.present(canvasNearByVc, animated: true, completion: nil)
        }else {
            self.alertMessage()
        }
    }
    
    // MARK: - startCanVassing
    @IBAction func startCanvassingButtonTapped(_ sender: Any) {
        if self.arrPeople.count > 0 {
            if self.arrMarkAsPeople.count == self.arrPeople.count {
                PeopleList.sharedManager.isStartCanvasing = true
                self.walkCompletedView?.isHidden = false
                self.peopleListBottomConstraint.constant = 210
                self.allButtonView?.isHidden = false
                self.showHideButtonWithAnimation(isHide: 0)
                self.startCanvassingButton?.isHidden = true
            }else {
                self.startCanvasing()
                self.drawPathNearByCurrentLocation() // draw path near by current Location
            }
        }
    }
    // MARK: - walk completed dismissview
    @IBAction func dismissButtonAction(_ sender: UIButton)
    {
        self.peopleListBottomConstraint.constant = 290
        self.peopleDetailView?.isHidden = true
        self.startCanvassingView?.isHidden = true
        self.hideAllView(view: self.walkCompletedView!, hidden: true)
        self.hideAllView(view: self.startCanvassingView!, hidden: true)
        
    }
    // MARK: - Mark as Completed tapped
    @IBAction func btnmarkAsCompletedAction(_ sender: UIButton)
    {
        if let Slug:String = UserDefaults.standard.string(forKey: "txtNationSlug")
        {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self.activityIndicator("Please wait...")
            
            let lati = String(format: "%f", (self.objList?.cllocation?.coordinate.latitude)!)
            let long = String(format: "%f", (self.objList?.cllocation?.coordinate.longitude)!)
            
            let params = ["person_id":self.objList?.peopleId as Any, "person_name":self.objList?.fullName as Any , "canvass_slug":Slug, "lat":lati , "lng":long , "list_id":PeopleList.sharedManager.listID] as [String : Any]
            
            var request = URLRequest(url: URL(string: "https://www.handynationapp.com/wp-json/my_rest_server/v1/canvass_marked_user")!)
            request.httpMethod = "POST"
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options:.mutableContainers)
                    if let jsonResult = json as? NSMutableArray {
                        print(jsonResult)
                    } else if let jsonResult = json as? NSMutableDictionary {
                        if let dictResponse = jsonResult.object(forKey: "response") as? NSMutableDictionary{
                                DispatchQueue.main.async(execute: { () -> Void in
                                    if dictResponse.object(forKey: "status") as! String == "1" {
                                        self.arrowButton?.setImage(UIImage(named: "canvas_Top_Arrow"), for: .normal)
                                        self.objList?.isPeopleSelected = true
                                        self.mapAddAnnotation(obj: self.objList!)
                                        self.objList = nil
                                        self.startCanvasing()
                                        self.drawPathNearByCurrentLocation()
                                    }
                                })
                            }
                        }
                } catch {
                    print("error")
                }
                
                DispatchQueue.background(delay: 2.5, completion:
                    {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.effectView.removeFromSuperview()
                })
            })
            task.resume()
        }
    }
    
    // MARK: - start Walk tapped
    @IBAction func btnStartWalkAction(_ sender: UIButton)
    {
        let lati = String(format: "%f", (self.objList?.cllocation?.coordinate.latitude)!)
        let long = String(format: "%f", (self.objList?.cllocation?.coordinate.longitude)!)
        self.openMapApp(latitude: lati, longitude: long, address: (self.objList?.primary_address)!)
    }
    
    // MARK: - call button tapped
    @IBAction func btnCallAction(_ sender: UIButton)
    {
        self.callNumber(phoneNumber: (self.objList?.phone)!)
    }
    
    func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    // MARK: - Street View tapped
    @IBAction func btnStreetViewAction(_ sender: UIButton)
    {
        let canvasStreetView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CanvasStreetVc") as! CanvasStreetViewController
        if self.objList != nil {
            canvasStreetView.objPeopleList = self.objList
        }
        self.present(canvasStreetView, animated: true, completion: nil)
    }
    
    // MARK: - Arrow Button tapped
    @IBAction func btnArrowAction(_ sender: UIButton)
    {
        self.setArrowUpAndDown()
    }
    // MARK : - SetUp Arrow Up and down Animation
    func setArrowUpAndDown() {
        if self.arrowButton?.isSelected == true {
            self.phoneStackView?.isHidden = true
            self.arrowButton?.isSelected = false
            self.arrowButton?.setImage(UIImage(named: "canvas_Top_Arrow"), for: .normal)
            self.peopleListBottomConstraint.constant = 210
        }else {
            self.arrowButton?.isSelected = true
            self.phoneStackView?.isHidden = false
            self.arrowButton?.setImage(UIImage(named: "canvas_Bottom_Arrow"), for: .normal)
            self.peopleListBottomConstraint.constant = 0
        }
        self.viewAnimation() // setUp POPUP animate
    }
    // MARK: - More Button tapped
    @IBAction func btnMoreAction(_ sender: UIButton)
    {
        self.moreButton?.isSelected = !sender.isSelected
        if self.moreButton?.isSelected == false {
            self.showHideButtonWithAnimation(isHide : 1)
            self.moreImage?.image = UIImage(named: "canvas_Deselected_More")
        }else {
            self.showHideButtonWithAnimation(isHide : 0)
            self.moreImage?.image = UIImage(named: "canvas_Selected_More")
        }
    }
    
    // MARK: - currentLocation tapped
    @IBAction func currentLocationButtonAction(_ sender: UIButton)
    {
        if self.walkButton?.isSelected == false {
            self.drawRoute(points: self.polypoints)
        }else {
            let camera = GMSCameraPosition.camera(withLatitude: AppDelegate.delegate().currentLocation.coordinate.latitude ,longitude: AppDelegate.delegate().currentLocation.coordinate.longitude , zoom: currentZoom)
            self.mapCanvas?.camera = camera
            self.mapCanvas?.animate(to: camera)
            self.mapCanvas?.isMyLocationEnabled = true
        }
    }
    
    // MARK: - Traffic Button tapped
    @IBAction func trafficButtonAction(_ sender: UIButton)
    {
        self.trafficButton?.isSelected = !sender.isSelected
        if self.trafficButton?.isSelected == true {
            mapCanvas?.isTrafficEnabled = true
            self.trafficButton?.setImage(UIImage(named: "canvas_Selected_Trafic"), for: .normal)
        }else {
            mapCanvas?.isTrafficEnabled = false
            self.trafficButton?.setImage(UIImage(named: "canvas_UnSelected_Trafic"), for: .normal)
        }
    }
    
    // MARK: - MapType tapped
    @IBAction func mapTypeButtonAction(_ sender: UIButton)
    {
        //Create the AlertController and add Its action like button in Actionsheet
        let actionSheetMapType: UIAlertController = UIAlertController(title: "Select Map Type", message: "", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        
        let standardMapButton = UIAlertAction(title: "NORMAL", style: .default)
        { _ in
            self.mapCanvas?.mapType = .normal
            self.mapTypeButton?.setImage(UIImage(named: "canvas_White_Map"), for: .normal)
            self.startAnimateTimer() // start Timer and draw Animated Path again
            UserDefaults.standard.setValue("normal", forKey: "mapType")
            UserDefaults.standard.synchronize()
        }
        
        let satelliteButton = UIAlertAction(title: "SATELLITE", style: .default)
        { _ in
            self.mapCanvas?.mapType = .satellite
            self.mapTypeButton?.setImage(UIImage(named: "canvas_White_Satellite"), for: .normal)
            self.startAnimateTimer() // start Timer and draw Animated Path again
            UserDefaults.standard.setValue("satellite", forKey: "mapType")
            UserDefaults.standard.synchronize()
        }
        
        actionSheetMapType.addAction(cancelActionButton)
        actionSheetMapType.addAction(standardMapButton)
        actionSheetMapType.addAction(satelliteButton)
        
        self.present(actionSheetMapType, animated: true, completion: nil)
    }
    
    // MARK: - changeZoom tapped
    @IBAction func walkZoomButtonAction(_ sender: UIButton)
    {
        self.walkButton?.isSelected = !sender.isSelected
        if self.walkButton?.isSelected == false {
            self.drawRoute(points: self.polypoints)
            self.walkButton?.setImage(UIImage(named: "canvas_White_walk"), for: .normal)
        }else {
            self.showAllMarker()
            self.walkButton?.setImage(UIImage(named: "canvas_walk"), for: .normal)
        }
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

// MARK: - Main View Extenstion
extension CanvasMapVC {
    // MARK: - hide show view and start canvasing
    func startCanvasing(){
        self.peopleDetailView?.isHidden = false
        self.allButtonView?.isHidden = false
        self.phoneStackView?.isHidden = true
//        self.arrowButton?.isSelected = true
        self.showHideButtonWithAnimation(isHide : 1)
        self.startCanvassingView?.isHidden = true
        PeopleList.sharedManager.isStartCanvasing = true
        
        self.peopleListBottomConstraint.constant = 210
        self.viewAnimation() // setUp POPUP animate
        self.getCurrentTime() // set Current Time in poup screen
        self.setUpCurrentLocationMarkerPin() // setUp current marker pins
    }
    
    // MARK: - get Slug details from Userdefault
    func setUpSlugWithWebservices(){
        var isNationSlug : String = ""
        var isAccessToken : String = ""
        
        if let Slug:String = UserDefaults.standard.string(forKey: "txtNationSlug")
        {
            isNationSlug = Slug
        }
        if let Token:String = UserDefaults.standard.string(forKey: "accessToken")
        {
            isAccessToken = Token
        }
        
        self.ListPeopleData(nationalSlug: isNationSlug, accessToken: isAccessToken)
    }

    // MARK: - getting people list from webservices
    func ListPeopleData(nationalSlug : String, accessToken : String){
        let params: NSDictionary = NSDictionary()
            let url: String = "https://"+nationalSlug+".nationbuilder.com/api/v1/lists/"+PeopleList.sharedManager.listID+"/people?limit=25&access_token="+accessToken
            
            WSManager().requestAPI(params: params,url:url as String,method:"GET",postCompleted:
                { (succeeded: Bool, msg: String, responsedata1:NSDictionary) -> () in
                    DispatchQueue.main.async(execute: { () -> Void in
                        if(succeeded){
                            self.getAllCompletedPeopleList(dict: responsedata1) // check get all mark as completed people list
                        }
                    })
            })
    }
    
    // MARK: - get all mark as done people list from webservices
    func getAllCompletedPeopleList(dict : NSDictionary) {
        let params: NSDictionary = NSDictionary()
        var isSlug : String = "corewaysolution"
        if let Slug:String = UserDefaults.standard.string(forKey: "txtNationSlug")
        {
            isSlug = Slug
        }
        let url: String = "https://www.handynationapp.com/wp-json/my_rest_server/v1/canvass_marked_user?canvass_slug="+isSlug
        
        WSManager().requestAPI(params: params,url:url as String,method:"GET",postCompleted:
            { (succeeded: Bool, msg: String, responsedata1:NSDictionary) -> () in
                DispatchQueue.main.async(execute: { () -> Void in
                    if(succeeded){
//                        print("Dict : ",dict)
//                        print("All Completed Dict : ",responsedata1)
                        if let dictPeople = responsedata1 as? NSMutableDictionary{
                            if let arr = dictPeople.object(forKey: "response") as? NSMutableArray{
                                let arrData =  NSMutableArray()
                                for dict in arr {
                                    let objPeople : MarkAsDonePeopleList = MarkAsDonePeopleList().initWithDictionary(dict as! NSDictionary) as! MarkAsDonePeopleList
                                    arrData.add(objPeople)
                                }
                                self.getAllMarker(dictPeople: dict, arrSelectedPeople: arrData)
                            }
                        }
                    }
                })
        })
    }
    
    // MARK: - getting people list from webservices
    func getAllMarker(dictPeople : NSDictionary, arrSelectedPeople : NSMutableArray){
        if let dictPeople = dictPeople as? NSMutableDictionary {
            if let arr = dictPeople.object(forKey: "results") as? NSMutableArray{
                let arrData =  NSMutableArray()
                for dict in arr {
                    let objPeople : PeopleList = PeopleList().initWithDictionary(dict as! NSDictionary) as! PeopleList
                    objPeople.isPeopleSelected = false
                    for index in (0..<arrSelectedPeople.count) {
                        let objMark : MarkAsDonePeopleList = arrSelectedPeople[index] as! MarkAsDonePeopleList
                        if objMark.person_id == objPeople.peopleId && objMark.list_id == PeopleList.sharedManager.listID {
                            objPeople.isPeopleSelected = true
                            self.arrMarkAsPeople.add(arrSelectedPeople)
                        }
                    }
                    self.mapAddAnnotation(obj: objPeople)
                    let camera = GMSCameraPosition.camera(withLatitude: (objPeople.cllocation?.coordinate.latitude)!, longitude: (objPeople.cllocation?.coordinate.longitude)!, zoom: 7.0)
                    self.mapCanvas?.camera = camera
                    DispatchQueue.main.async {
                        self.mapCanvas?.animate(to: camera)
                    }
//                    self.mapCanvas?.camera = GMSCameraPosition.camera(withLatitude: (objPeople.cllocation?.coordinate.latitude)!, longitude: (objPeople.cllocation?.coordinate.longitude)!, zoom: 7);
                    arrData.add(objPeople)
                }
                if arrData.count > 0 {
                    if arrSelectedPeople.count == self.arrPeople.count {
                        self.startCanvassingButton?.isHidden = true
                        PeopleList.sharedManager.isStartCanvasing = true
                    }
//                    self.showAllMarker()
                    self.arrPeople.addObjects(from: (arrData.sorted { ($0 as! PeopleList).userDistance < ($1 as! PeopleList).userDistance}))
                }
            }
        }
    }
    // MARK: - setUp Map Pin with Distance and camera zooming
    func mapAddAnnotation(obj : PeopleList)
    {
        let position = CLLocationCoordinate2D(latitude: (obj.cllocation?.coordinate.latitude)!, longitude: (obj.cllocation?.coordinate.longitude)!) // setUp people location
        let distances =  obj.cllocation?.distance(from: AppDelegate.delegate().currentLocation) // get distance with current location
        obj.userDistance = Double(distances!/1000) // divide distance with 1000 and result in KM
        
        // setUp marker with name and city and country
        locationmarker = GMSMarker(position: position)
        locationmarker.userData = obj
        locationmarker.tracksInfoWindowChanges = true
        locationmarker.title = obj.fullName!
        locationmarker.snippet = obj.city! + "," + obj.county!
        if obj.isPeopleSelected == true {
            locationmarker.icon = UIImage(named: "canvas_doneIndication_Pin")
        }else {
            locationmarker.icon = UIImage(named: "imgMapPin")
        }
        locationmarker.map = mapCanvas
    }
    
    // MARK: - draw Path Near By current Location
    func drawPathNearByCurrentLocation() {
        for index in (0..<self.arrPeople.count) {
            let objPeopleList : PeopleList = self.arrPeople[index] as! PeopleList
            if objPeopleList.isPeopleSelected == false {
                self.objList = objPeopleList
                if objPeopleList.isNoPhoneNumber == true {
                    callButton?.isHidden = true
                }
                self.getPolylineRoute(from: AppDelegate.delegate().currentLocation.coordinate, to: (objPeopleList.cllocation?.coordinate)!, objPeopleList: objPeopleList)
                break
            }
        }
    }
    
    // MARK: - Pass your source and destination coordinates in this method.
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, objPeopleList : PeopleList){
        let strUrl = "http://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving"
        let url = URL(string: strUrl)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "")
                    return
                }
                /*========== get Routes and other details ==========*/
                if let result = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String:Any],
                    let routes = result["routes"] as? [[String:Any]],
                    let route = routes.first,
                    let legs = route["legs"] as? [[String:Any]],
                    let leg = legs.first,
                    let distance = leg["distance"] as? [String:Any],let distanceText = distance["text"] as? String,
                    let timeDuration = leg["duration"] as? [String:Any],let timeText = timeDuration["text"] as? String {
                    
                    self.distancekmLabel?.text = distanceText // setUp Distance
                    self.durationTimeLabel?.text = timeText // setUp Duration
                    self.addressLabel?.text = objPeopleList.primary_address // setUp Person address
                    self.nameLabel?.text = objPeopleList.fullName // setUp name
                    /*========== setUp Polyline ==========*/
                    let routes = (routes.first as Dictionary<String, AnyObject>?) ?? [:]
                    let overviewPolyline = (routes["overview_polyline"] as? Dictionary<String,AnyObject>) ?? [:]
                    self.polypoints = (overviewPolyline["points"] as? String) ?? ""
                    self.drawRoute(points: self.polypoints)
                    /*========== ========== ==========*/
                }else {
                    let string = NSMutableAttributedString(string: objPeopleList.fullName! + " " + "Can't find a way there")
                    string.setColorForText("Can't find a way there", with: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
                    self.nameLabel?.attributedText = string
                }
            }
        })
        task.resume()
    }
     // MARK: - draw your path here
    func drawRoute(points: String) {
        for p in (0 ..< oldPolylineArr.count) {
            oldPolylineArr[p].map = nil
            self.timerAnimationPath.invalidate()
        }

        self.path = GMSPath.init(fromEncodedPath: points )!
        self.polyline = GMSPolyline()
        self.polyline.path = path
        self.oldPolylineArr.append(polyline)
        self.polyline.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.polyline.strokeWidth = 3.0
        self.polyline.map = self.mapCanvas
        DispatchQueue.main.async {
            self.mapCanvas?.animate(with: GMSCameraUpdate.fit(GMSCoordinateBounds(path: self.path), withPadding: 80))
        }
        self.timerAnimationPath = Timer.scheduledTimer(timeInterval: 0.003, target: self, selector: #selector(animatePolylinePath), userInfo: nil, repeats: true)
    }
    // MARK: - animate highlight Path
    func animatePolylinePath() {

        if (self.i < self.path.count()) {
            self.animationPath.add(self.path.coordinate(at: self.i))
            self.animationPolyline.path = self.animationPath
            self.changeMapType() // check map type and setUp image into Map Type Button
            self.animationPolyline.strokeWidth = 3
            self.animationPolyline.map = self.mapCanvas
            self.i += 1
        }
        else {
            self.i = 0
            self.animationPath = GMSMutablePath()
            self.animationPolyline.map = nil
            
            if timerCount >= 1{
                if let mapType:String = UserDefaults.standard.string(forKey: "mapType") {
                    if mapType == "satellite" {
                        self.polyline.strokeColor = .green
                    }else {
                        self.polyline.strokeColor = .black
                    }
                }else {
                    self.polyline.strokeColor = .black
                }
                self.timerAnimationPath.invalidate()
            }
            timerCount += 1
        }
    }
    
    // MARK: - setUp currentLocation Marker Pin
    func setUpCurrentLocationMarkerPin() {
        currentLocationMarker.map = nil
        currentLocationMarker = GMSMarker(position: AppDelegate.delegate().currentLocation.coordinate)
        currentLocationMarker.title = "Origin Point"
        currentLocationMarker.snippet = "Your traveling start from here"
        currentLocationMarker.icon = UIImage(named: "canvas_Car")
        currentLocationMarker.map = mapCanvas
    }
    // MARK: - open Google Map App or Browser and show route
    func openMapApp(latitude:String, longitude:String, address:String) {
        //Working in Swift new versions.
        // if GoogleMap installed
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.openURL(NSURL(string:
                "comgooglemaps://?saddr=\(AppDelegate.delegate().currentLocation.coordinate.latitude),\(AppDelegate.delegate().currentLocation.coordinate.longitude)&daddr=\(latitude),\(longitude)&directionsmode=driving")! as URL)
            
        } else {
            // if GoogleMap App is not installed
            UIApplication.shared.openURL(NSURL(string:
                "https://www.google.co.in/maps/dir/?saddr=\(AppDelegate.delegate().currentLocation.coordinate.latitude),\(AppDelegate.delegate().currentLocation.coordinate.longitude)&daddr=\(latitude),\(longitude)&directionsmode=driving")! as URL)
        }
            return
    }
    
    // MARK: - show / hide all more buttons list
    func showHideButtonWithAnimation(isHide : Int) {
        self.hideAllButton(button: self.trafficButton!, hidden: isHide)
        self.hideAllButton(button: self.mapTypeButton!, hidden: isHide)
        self.hideAllButton(button: self.walkButton!, hidden: isHide)
    }
    func hideAllButton(button: UIButton, hidden: Int) {
        UIView.transition(with: button, duration: 0.5, options: .showHideTransitionViews, animations: {
            button.alpha = CGFloat(hidden)
        })
    }
    func hideAllView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 0.5, options: .showHideTransitionViews, animations: {
            view.isHidden = hidden
        })
    }
    // MARK: - get current Time
    func getCurrentTime() {
        currentTimeLabel?.text = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.tick) , userInfo: nil, repeats: true)
    }
    
    @objc func tick() {
        currentTimeLabel?.text = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .short)
    }
    
    // MARK: - Alert Message
    func alertMessage() {
        let alert = UIAlertController(title: "Alert", message: "Start canvasing first", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            self.view.endEditing(true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - show all marker when tapped Walktozoom button
    func showAllMarker() {
        var bounds = GMSCoordinateBounds()
        for location in self.arrPeople
        {
            let latitude = ((location as! PeopleList).cllocation?.coordinate.latitude)
            let longitude = ((location as! PeopleList).cllocation?.coordinate.longitude)
            
            let marker = GMSMarker()
            let markAsDone = (location as! PeopleList).isPeopleSelected
            if markAsDone == true {
                marker.icon = UIImage(named: "canvas_doneIndication_Pin")
            }else {
                marker.icon = UIImage(named: "imgMapPin")
            }
            marker.position = CLLocationCoordinate2D(latitude:latitude!, longitude:longitude!)
            marker.map = self.mapCanvas
            bounds = bounds.includingCoordinate(marker.position)
        }
        let update = GMSCameraUpdate.fit(bounds, withPadding: 100)
        self.mapCanvas?.animate(with: update)
//        self.mapCanvas?.moveCamera(update)
    }
    // MARK: - Start Animate Timer and draw Animated Path Again
    func startAnimateTimer(){
        self.timerCount = 0
        self.timerAnimationPath.invalidate()
        
        self.i = 0
        self.animationPath = GMSMutablePath()
        self.animationPolyline.map = nil
        self.polyline.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.timerAnimationPath = Timer.scheduledTimer(timeInterval: 0.003, target: self, selector: #selector(self.animatePolylinePath), userInfo: nil, repeats: true)
    }
    // MARK: - check Map Type and setUp accordinglly
    func changeMapType(){
        if let mapType:String = UserDefaults.standard.string(forKey: "mapType") {
            if mapType == "satellite" {
                self.mapCanvas?.mapType = .satellite
                self.animationPolyline.strokeColor = .green// UIColor(red: 0, green: 236, blue: 188, alpha: 1.0)
                self.mapTypeButton?.setImage(UIImage(named: "canvas_White_Satellite"), for: .normal)
            }else {
                self.mapCanvas?.mapType = .normal
                self.animationPolyline.strokeColor = .black
                self.mapTypeButton?.setImage(UIImage(named: "canvas_White_Map"), for: .normal)
            }
        }else {
            self.mapCanvas?.mapType = .normal
            self.animationPolyline.strokeColor = .black
            self.mapTypeButton?.setImage(UIImage(named: "canvas_White_Map"), for: .normal)
            UserDefaults.standard.setValue("normal", forKey: "mapType")
            UserDefaults.standard.synchronize()
        }
    }
    // MARK: - Animate POPUP
    func viewAnimation() {
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Current Location Methods
    func activityIndicator(_ title: String) {
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        //strLabel.font = .systemFont(ofSize: 14, weight: .medium)
        strLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.contentView.addSubview(activityIndicator)
        effectView.contentView.addSubview(strLabel)
        view.addSubview(effectView)
    }
    /*
    // MARK: - setUp Total KM and Duration
    func setUpSelectedPeopleDetailsInBottomView(objPeople : PeopleList) {
        addressLabel?.text = objPeople.primary_address
        distancekmLabel?.text = String(objPeople.userDistance) + "km"
        durationTimeLabel?.text = String(objPeople.userTimeDuration)
    }
    */
    
}


// MARK: - Notification Name
extension Notification.Name {
    static let updatePoliLine = Notification.Name(
        rawValue: "updatePolyLineNotification")
}
extension CanvasMapVC : GMSMapViewDelegate {
    public func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView?
    {
        if marker.userData == nil
        {
            return nil
        }
        infoWindow = (Bundle.main.loadNibNamed("canvasMarker", owner: self, options: nil)?[0] as? canvasMarker)!
        guard let data = marker.userData! as? PeopleList else {
            return nil
        }
//            marker.tracksInfoWindowChanges = true
            infoWindow.objPeopleList = data
            infoWindow.titleLabel.text = data.fullName
            infoWindow.subtitleLabel.text = data.city! + "," + data.county!
            infoWindow.imgPicture?.sd_setImage(with: NSURL(string: data.profile_image_url_ssl!) as URL?,placeholderImage:UIImage(named: "imgPlaceHolder"))
        marker.tracksInfoWindowChanges = false
        infoWindow.setUpView()
        return infoWindow
    }
    
    public func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let zoom = mapView.camera.zoom
        print("map zoom is ",String(zoom))
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool
    {
        if marker.userData == nil
        {
            return false // change
        }
        mapView.selectedMarker = marker
        let point = mapView.projection.point(for: marker.position)
        let camera = mapView.projection.coordinate(for: point)
        let position = GMSCameraUpdate.setTarget(camera)
        DispatchQueue.main.async {
            mapView.animate(with: position)
        }
        return true
    }
    
    public func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker)
    {
        if let data = marker.userData! as? PeopleList
        {
            print(data.peopleId as Any)
            if data.isPeopleSelected == false {
                let NextVW = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CanvasPeopleDetailVC") as! CanvasPeopleDetailVC
                NextVW.objPeople = data
                self.objList = data
                self.navigationController?.pushViewController(NextVW, animated: true)
            }
        }
    }
}

extension NSMutableAttributedString{
    func setColorForText(_ textToFind: String, with color: UIColor) {
        let range = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound {
            addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        }
    }
}
