//
//  CanvasList.swift
//  HandyNation
//
//  Created by admin on 09/07/18.
//  Copyright © 2018 Corway Solution. All rights reserved.
//

import UIKit

class CanvasList: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var tblCanvasPeople: UITableView!
    var arrPeople = NSMutableArray() // People
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

    override func viewDidLoad() {
        super.viewDidLoad()

        self.CanvasPeopleData()
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        DispatchQueue.background(delay: 0.2, completion:
            {
                self.CanvasPeopleData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    

    // MARK: - Tableview Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrPeople.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier:"CanvasListCell", for: indexPath) as! CanvasListCell
        
        if let peopleName = (self.arrPeople.object(at: indexPath.row) as AnyObject).value(forKey: "canvass_name") as? String
        {
            cell.lblPersonName.text = peopleName
            
            if  let updated_at:String = (self.arrPeople.object(at: indexPath.row) as AnyObject).value(forKey: "created_on") as? String
            {
                let date : String = ChangeDateFormat(fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat:"dd MMM,yyyy", strDate:updated_at)
                
                cell.lblPersonName.text = peopleName + " - " + date
            }
        }
        
        if  let marked_user:String = (self.arrPeople.object(at: indexPath.row) as AnyObject).value(forKey: "marked_users") as? String
        {
             cell.lblTotalLocPerson.text = marked_user
            
            if  let loc_users:String = (self.arrPeople.object(at: indexPath.row) as AnyObject).value(forKey: "loc_users") as? String
            {
                cell.lblTotalLocPerson.text = marked_user + "/" + loc_users
            }
        }
        
        if  let total_users:String = (self.arrPeople.object(at: indexPath.row) as AnyObject).value(forKey: "total_users") as? String
        {
            cell.lblTotalPerson.text = total_users + " Peoples"
        }
        
        if  let updated_at:String = (self.arrPeople.object(at: indexPath.row) as AnyObject).value(forKey: "updated_on") as? String
        {
            let date : String = ChangeDateFormat(fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat:"dd MMM,yyyy", strDate:updated_at)
            cell.lblLastUpdated.text = "Last Updated : " + date
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let NextVW = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CanvasMapVC") as! CanvasMapVC
//        NextVW.ListID = ((self.arrPeople[indexPath.row] as AnyObject).value(forKey: "list_id") as? String)!
        PeopleList.sharedManager.listID = ((self.arrPeople[indexPath.row] as AnyObject).value(forKey: "list_id") as? String)!
        PeopleList.sharedManager.navTitle = ((self.arrPeople.object(at: indexPath.row) as AnyObject).value(forKey: "canvass_name") as? String)!
        PeopleList.sharedManager.isStartCanvasing = false
        self.navigationController?.pushViewController(NextVW, animated: true)
    }
    
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if (editingStyle == UITableViewCellEditingStyle.delete)
        {
            if let isNationSlug:String = UserDefaults.standard.string(forKey: "txtNationSlug")
            {
                activityIndicator("Loading People")
                let params = NSMutableDictionary()
                var list_id  = String()
                
                if let pageID = (self.arrPeople.object(at: indexPath.row) as AnyObject).value(forKey: "list_id") as? String
                {
                    list_id = pageID
                }
                
                
                let json:[String:Any] = ["list_id":list_id,"canvass_slug":isNationSlug]
                let url: String = "https://www.handynationapp.com/wp-json/my_rest_server/v1/canvass_delete"
                
                print(url)
                
                WSManager().requestJsonAPI(json:json,params:params,url:url as String,method:"POST",postCompleted:
                    { (succeeded: Bool, msg: String, responsedata1:NSDictionary) -> () in
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            MyAppManager().dismissProgress()
                            
                            if(succeeded)
                            {
                                if let dict = responsedata1.value(forKey:"response") as? NSDictionary
                                {
                                    if let msg = dict.value(forKey:"message") as? String
                                    {
                                        DisplayGhostAlert(str:msg)
                                         self.CanvasPeopleData()
                                    }
                                }
                            }
                            self.effectView.removeFromSuperview()
                        })
                })
            }
        }
    }
    
    

    
     // MARK: - Web-Service
    
    func CanvasPeopleData()
    {
        if let isNationSlug:String = UserDefaults.standard.string(forKey: "txtNationSlug")
        {
            activityIndicator("Loading People")
            let params: NSDictionary = NSDictionary()
            
            let url: String = "https://www.handynationapp.com/wp-json/my_rest_server/v1/canvassing?canvass_slug="+isNationSlug
            
            WSManager().requestAPI(params: params,url:url as String,method:"GET",postCompleted:
                { (succeeded: Bool, msg: String, responsedata1:NSDictionary) -> () in
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        if(succeeded)
                        {
                            if let dictPeople =  responsedata1 as? NSDictionary
                            {
                                if let arr = dictPeople.object(forKey: "response") as? NSMutableArray
                                {
                                    self.arrPeople = arr
                                }
                            }
                            self.tblCanvasPeople.reloadData()
                        }
                        self.effectView.removeFromSuperview()
                })
            })
        }
    }
    
    
     // MARK: - Button Action Methods
    
    @IBAction func unwindToCanvasListVW(segue:UIStoryboardSegue)
    {
       // self.CanvasPeopleData()

    }
    
    
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        self.mm_drawerController.toggle(MMDrawerSide.left, animated:true, completion:nil)
    }
    
    @IBAction func btnAddAction(_ sender: UIButton)
    {
        let NextVW = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectCanvasListVC") as! SelectCanvasListVC
        self.navigationController?.pushViewController(NextVW, animated: true)
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
