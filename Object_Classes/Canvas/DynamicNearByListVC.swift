//
//  DynamicNearByListVC.swift
//  HandyNation
//
//  Created by admin on 07/09/18.
//  Copyright © 2018 Corway Solution. All rights reserved.
//

import UIKit

class DynamicNearByListVC: UIViewController
{
    @IBOutlet weak var btnCreateList: UIButton!
    @IBOutlet weak var lblPeopleCount: UILabel!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var txtName: JVFloatLabeledTextField!
    @IBOutlet weak var txtSlug: JVFloatLabeledTextField!
    
    var isNationSlug = String()
    var isAccessToken = String()
    var isSlug = String()

    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    var strNearDistance = "1"
    var nearByDist = String()
    var nextNearByRecord = String() // People_NearBY
    
    var intCount = 0
    var intPaginationCount = 0
    var arrPeopleIDs = [String]() // To Store the IDs of the people.
    var listID = String() // To store the value get from the create list func.

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let Slug:String = UserDefaults.standard.string(forKey: "txtNationSlug")
        {
            isNationSlug = Slug
        }
        if let Token:String = UserDefaults.standard.string(forKey: "accessToken")
        {
            isAccessToken = Token
        }
        if let Slug:String = UserDefaults.standard.string(forKey: "siteSlug")
        {
            isSlug = Slug
        }
        
        
        if nearByDist == "1"
        {
            strNearDistance = "50"
            distanceSlider.value = 50.0
            lblDistance.text = "Distance : "+"\(strNearDistance) Miles"
        }
        else
        {
            strNearDistance = nearByDist
            distanceSlider.value = Float(strNearDistance)!
            lblDistance.text = "Distance : "+"\(strNearDistance) Miles"
        }
        
        self.btnCreateList.layer.masksToBounds = true
        self.btnCreateList.layer.cornerRadius = 3
        self.btnCreateList.backgroundColor = UIColor.gray
        self.btnCreateList.isUserInteractionEnabled = false
        self.txtName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.txtName.becomeFirstResponder()
        self.PeopleNearBy()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITextField Methods
    
    func textFieldDidChange(_ textField: UITextField)
    {
        if (txtName.text?.isEmpty)!
        {
            self.btnCreateList.backgroundColor = UIColor.gray
            self.btnCreateList.isUserInteractionEnabled = false
        }
        else
        {
            self.btnCreateList.backgroundColor = Constants.appThemeColor
            self.btnCreateList.isUserInteractionEnabled = true
        }
        
    }
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        self.btnCreateList.backgroundColor = UIColor.gray
        self.btnCreateList.isUserInteractionEnabled = false
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        self.view.endEditing(true)
        return true;
    }
    
    
      // MARK: - Loader Method
    
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
    
    // MARK: - Button Action
    
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        self.view.endEditing(true)
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCancelAction(_ sender: UIButton)
    {
        
    }
    
    @IBAction func btnCreateListAction(_ sender: Any)
    {
        self.createList()
       // performSegue(withIdentifier: "unwindToHomeVW", sender: self)

    }
    
    @IBAction func btnSliderAction(_ sender: UISlider)
    {
        self.arrPeopleIDs.removeAll()
        let currentValue = Int(distanceSlider.value)
        strNearDistance = String(currentValue)
        
        lblDistance.text = "Distance : "+"\(strNearDistance) Miles"
        self.PeopleNearBy()
    }
    
    
    // MARK: - Web-Service
    
    
    func PeopleNearBy()
    {
        activityIndicator("Loading People")
        
        if let isNationSlug:String = UserDefaults.standard.string(forKey: "txtNationSlug")
        {
            if let isAccessToken:String = UserDefaults.standard.string(forKey: "accessToken")
            {
                let params: NSDictionary = NSDictionary()
                
                let strLatitude = String(AppDelegate.delegate().currentLocation.coordinate.latitude)
                let strLongitude = String(AppDelegate.delegate().currentLocation.coordinate.longitude)
                let url: String = "https://"+isNationSlug+".nationbuilder.com/api/v1/people/nearby?limit=25&location="+strLatitude+","+strLongitude+"&access_token="+isAccessToken+"&distance="+strNearDistance
                
                print(url)
                
                WSManager().requestAPI(params: params,url:url as String,method:"GET",postCompleted:
                    { (succeeded: Bool, msg: String, responsedata1:NSDictionary) -> () in
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            if(succeeded)
                            {
                                if let dictPeople = responsedata1 as? NSDictionary
                                {
                                  
                                    if let arrNear = dictPeople.object(forKey: "results") as? NSMutableArray
                                    {
                                        
                                        for i in 0..<arrNear.count
                                        {
                                            if let ID = (arrNear.object(at: i) as AnyObject).value(forKey: "id") as? Int
                                            {
                                                let strID = String(ID)
                                                self.arrPeopleIDs.append(strID)
                                            }
                                        }
                                        
                                    }
                                    
                                    if let nxtRecord = dictPeople.object(forKey: "next") as? String
                                    {
                                        self.nextNearByRecord = nxtRecord
                                        
                                        self.PeoplePagination()
                                    }
                                    else
                                    {
                                        let count = String(self.arrPeopleIDs.count)
                                        self.lblPeopleCount.text = "  "+count+" People Selected"
                                    }
                                }
                            }
                            DispatchQueue.background(delay: 2.5, completion:
                                {
                                    
                                    self.effectView.removeFromSuperview()
                            })
                            
                        })
                })
            }
        }
    }
    
    func PeoplePagination()
    {
        if let isNationSlug:String = UserDefaults.standard.string(forKey: "txtNationSlug")
        {
            if let isAccessToken:String = UserDefaults.standard.string(forKey: "accessToken")
            {
                let params: NSDictionary = NSDictionary()
                var url = String()
                
                url = "https://"+isNationSlug+".nationbuilder.com"+nextNearByRecord+"&access_token="+isAccessToken
                
                print(url)
                
                WSManager().requestAPI(params: params,url:url as String,method:"GET",postCompleted:
                    { (succeeded: Bool, msg: String, responsedata1:NSDictionary) -> () in
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            if(succeeded)
                            {
                                if let dictPeople = responsedata1 as? NSDictionary
                                {
                                    self.nextNearByRecord = ""
                                    if let arr = dictPeople.object(forKey: "results") as? NSMutableArray
                                    {
                                        for i in 0..<arr.count
                                        {
                                            if let ID = (arr.object(at: i) as AnyObject).value(forKey: "id") as? Int
                                            {
                                                let strID = String(ID)
                                                self.arrPeopleIDs.append(strID)
                                               // print(self.arrPeopleIDs)
                                            }
                                        }
                                        print(self.arrPeopleIDs.count)
                                    }
                                    if let nxtRecord = dictPeople.object(forKey: "next") as? String
                                    {
                                        self.nextNearByRecord = nxtRecord
                                        
                                        self.PeoplePagination()
                                    }
                                    else
                                    {
                                        let count = String(self.arrPeopleIDs.count)
                                        self.lblPeopleCount.text = "  "+count+" People Selected"
                                    }
                                }
                            }
                            
                        })
                })
            }
        }
    }
    
    func createList()
    {
        MyAppManager().showLoaderWithtext("Loading...")
        let params = NSMutableDictionary()
        
        var adminID = String()
        
        var strSlug = String()
        
        if txtSlug.text == ""
        {
            strSlug = txtName.text!
        }
        else
        {
            strSlug = txtSlug.text!
        }
        
        if let strID = UserDefaults.standard.integer(forKey:"adminID") as? Int
        {
            adminID = String(strID)
        }
        
        let json:[String:Any] = ["list":["name":txtName.text!.removeNull(),"slug":strSlug, "author_id": adminID]]
        
        let url: String = "https://"+isNationSlug+".nationbuilder.com/api/v1/lists?&access_token="+isAccessToken
        
        WSManager().requestJsonAPI(json:json,params: params,url:url as String,method:"POST",postCompleted:
            { (succeeded: Bool, msg: String, responsedata1:NSDictionary) -> () in
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    MyAppManager().dismissProgress()
                    
                    if(succeeded)
                    {
                        print(responsedata1)
                        
                        if let dict = responsedata1.value(forKey: "list_resource") as? NSDictionary
                        {
                            if let id = dict.value(forKey: "id") as? Int
                            {
                                self.listID = String(id)
                            }
                            
                             self.addPeopleToList()
                        }
                        
                        else
                        {
                            let alert = UIAlertController(title: "Duplication Error!", message: "It looks like, List already exist! Please Rename to re-generate it.", preferredStyle: UIAlertControllerStyle.alert)
                            // alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                                self.view.endEditing(true)
                                let _ = self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                       
                        
                    }
                    
                })
        })
    }

    func addPeopleToList()
    {
        MyAppManager().showLoaderWithtext("Loading...")
        let params = NSMutableDictionary()
        
        let json:[String:Any] = ["people_ids":self.arrPeopleIDs]
        
        let url: String = "https://"+isNationSlug+".nationbuilder.com/api/v1/lists/"+listID+"/people?&access_token="+isAccessToken
        
        WSManager().requestJsonAPI(json:json,params: params,url:url as String,method:"POST",postCompleted:
            { (succeeded: Bool, msg: String, responsedata1:NSDictionary) -> () in
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    MyAppManager().dismissProgress()
                    
                    if(succeeded)
                    {
                        print(responsedata1)
                        
                       // performSegue(withIdentifier: "unwindToHomeVW", sender:DynamicNearByListVC.self)

                        DisplayGhostAlert(str:" List Created.")

                        
                    }
                    
                })
        })
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
