//
//  SurveyViewController.swift
//  Rytzee
//
//  Created by Nirav Shukla on 09/08/18.
//  Copyright © 2018 Rameshbhai Patel. All rights reserved.
//

import UIKit

class SurveyViewController: UIViewController {

    @IBOutlet weak var survayTableView : UITableView?
    @IBOutlet weak var survayTitle : UILabel?

    @IBOutlet weak var viewDate : UIView?
    @IBOutlet weak var datePicker = UIDatePicker()
    @IBOutlet weak var doneButton : UIButton?
    
    var arrSurvay : NSMutableArray = []
    var arrSelectedOptions: NSMutableArray = NSMutableArray()
    var cell : SurveyCell!
    
    override func viewDidLoad() {
        self.arrSurvay = NSMutableArray.init()
        self.survayTableView?.estimatedRowHeight = 160
        self.survayTableView?.rowHeight = UITableViewAutomaticDimension
        self.getAllSurveryList()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - get All SurveryList
    func getAllSurveryList() {
        SwiftLoader.show(animated: true)
        DataManager.sharedManager.getSurvayList { (dictResponse: NSDictionary) in
            DispatchQueue.main.async{
                SwiftLoader.hide()
                guard let response = dictResponse["data"] as? NSDictionary else {
                    return
                }
                guard let arrData = response["questions"] as? NSArray else {
                    return
                }
                var select : Int = 0
                for addDict in arrData {
                    let objSurvery:SurveryList = SurveryList().initWithDictionary(addDict as! NSDictionary) as! SurveryList
                    if  select == 0 {
                        select = select + 1
                        objSurvery.isSelected = true
                    }else{
                        objSurvery.isSelected = false
                    }
                    
                    self.arrSurvay.add(objSurvery)
                }
                if self.arrSurvay.count > 0 {
                    self.survayTableView?.delegate = self
                    self.survayTableView?.dataSource = self
                }
                self.survayTableView?.reloadData()
            }
        }
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

extension SurveyViewController : UITableViewDelegate,UITableViewDataSource,surveyProtocol,UITextFieldDelegate{
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145;//UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return arrSurvay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "SurveyCell"
        var cell: SurveyCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? SurveyCell
        if cell == nil {
            tableView.register(UINib(nibName: "SurveyCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? SurveyCell
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        cell.delegate = self

        cell.answerTextfield?.tag = indexPath.row
        cell.okButton?.tag = indexPath.row
        cell.notDecidedButton?.tag = indexPath.row
        cell.calendarButton?.tag = indexPath.row
        let objSurvery = arrSurvay[indexPath.row] as! SurveryList

        if objSurvery.isSelected == true{
            cell.isUserInteractionEnabled = true
            cell.whiteView?.isHidden = true
        }else{
            cell.isUserInteractionEnabled = false
            cell.whiteView?.isHidden = false
        }
        
        if objSurvery.isCalender == true {
            cell.calendarButton?.isHidden = false
            cell.calenderImage?.isHidden = false
            cell.answerTextfield?.isEnabled = false
        }else{
            cell.calendarButton?.isHidden = true
            cell.calenderImage?.isHidden = true
            cell.answerTextfield?.isEnabled = true
        }
        cell.queTitleLabel?.text = String(format:"%ld). %@",indexPath.row + 1, objSurvery.title!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        AppDelegate.delegate().mainVC.closeLeft()
    }
    
    // MARK: - UITextfield Delegate Methods protocol
    func shouldChangeCharactersIn(answerText: UITextField, stringRange: NSRange, str: String, onCell cell: SurveyCell) {
        let userEnteredString = answerText.text
        let newString = (userEnteredString! as NSString).replacingCharacters(in: stringRange, with: str) as NSString
        if  newString != ""{
            if answerText.tag == cell.answerTextfield?.tag{
                if arrSelectedOptions.count == arrSurvay.count - 1 {
                    cell.okButton?.setTitle("SUBMIT", for: .normal)
                }
                cell.okButton?.isHidden = false
            }
        } else {
            cell.okButton?.setTitle(" NEXT ", for: .normal)
            cell.okButton?.isHidden = true
        }
    }
    // MARK: - calender Button Tapped - Protocol
    func surveyTableViewCellDidTapCalenderButton(_ cellSurvey: SurveyCell) {
        cell = cellSurvey
        viewDate?.isHidden = false
        datePicker?.setValue(Color.navBlueColor.value, forKeyPath: "textColor")
        datePicker?.setValue(false, forKey: "highlightsToday")
        datePicker?.datePickerMode = .date
        cellSurvey.answerTextfield?.inputView = datePicker
    }
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        viewDate?.isHidden = true
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let somedateString = formatter.string(from: (datePicker?.date)!)
        cell.answerTextfield?.text = somedateString
        self.selectSurveyAnswer(cellSurvey: cell)
    }
    
    // MARK: - Not decided Button Tapped - Protocol
    func surveyTableViewCellDidTapNotDecidedButton(_ sender: SurveyCell) {
       self.selectSurveyAnswer(cellSurvey: sender)
    }
    // MARK: - OK Button Tapped - Protocol
    func surveyTableViewCellDidTapOKButton(_ sender: SurveyCell) {
       self.selectSurveyAnswer(cellSurvey: sender)
    }
    // MARK: - Select Answer and save to arraySelectedOption
    func selectSurveyAnswer(cellSurvey : SurveyCell) {
        self.view.endEditing(true)
        guard let tappedIndexPath = survayTableView?.indexPath(for: cellSurvey) else {
            print("failed", cellSurvey)
            return
        }
        /* Next Survey Qustion Visible true */
        if arrSurvay.count > tappedIndexPath.row{
            let objSurvery = arrSurvay[tappedIndexPath.row] as! SurveryList
            objSurvery.isSelected = false
            objSurvery.answer = (cellSurvey.answerTextfield?.text)!
            arrSelectedOptions.add(objSurvery)
        }
        /* Current Survey Qustion InVisible true */
        if arrSurvay.count > tappedIndexPath.row + 1 {
            let objSurvery = arrSurvay[tappedIndexPath.row + 1] as! SurveryList
            objSurvery.isSelected = true
        }
        // selected answer array count and total survey question count match then call webservices
        if arrSelectedOptions.count == arrSurvay.count {
            self.postSurveryList()
        }
        
        cellSurvey.okButton?.isHidden = true
        cellSurvey.notDecidedButton?.isHidden = true
        survayTableView?.reloadData()
    }
    
    // MARK: - POST Survey to webservices
    func postSurveryList(){
        var strParam = ""
        let strFilterOptionsName : NSMutableString = ""
        
        if self.arrSelectedOptions.count > 0 {
            strParam = String(format: "{\"survey\":{")
            strFilterOptionsName.append(strParam)
            var select : Int = 0
            for optionValue in self.arrSelectedOptions{
                strFilterOptionsName.append(String(format:"\"%d\":{\"question_id\":%d,\"answer\":\"%@\",\"destination_related\":%d},", select,(optionValue as! SurveryList).id,(optionValue as! SurveryList).answer,(optionValue as! SurveryList).destinationRelated))
                select = select + 1
            }
            
            let range :NSRange = NSMakeRange(strFilterOptionsName.length-1, 1)
            strFilterOptionsName.deleteCharacters(in: range)
            strFilterOptionsName.append("}}")
        }
        
        SwiftLoader.show(animated: true)
        DataManager.sharedManager.postSurvey(arrSurvay, strSurveyOptions: strFilterOptionsName as String) { (dictResponse: NSDictionary) in
            DispatchQueue.main.async{
                SwiftLoader.hide()
                let dict : NSDictionary = dictResponse.value(forKey: "data") as! NSDictionary
                guard dict.value(forKey: "has_selected_destination") != nil else {
                    print("failed")
                    return
                }
                User.sharedManager.hasSelectedDestination = dict.value(forKey: "has_selected_destination") as! Int
                UserDefaults.standard.setHasSelectedSurveyID(value: User.sharedManager.hasSelectedDestination)
                UserDefaults.standard.setSurvey(value: true)
                UserDefaults.standard.synchronize()
                AppDelegate.delegate().setUpViewController()
            }
        }
    }
}
