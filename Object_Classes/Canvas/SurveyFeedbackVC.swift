//
//  SurveyFeedbackVC.swift
//  HandyNation
//
//  Created by admin on 21/08/18.
//  Copyright © 2018 Corway Solution. All rights reserved.
//

import UIKit


enum JSONError: String, Error {
    case NoData = "ERROR: no data"
    case ConversionFailed = "ERROR: conversion from JSON failed"
}

class SurveyFeedbackVC: UIViewController
{
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    var tagCell = Int() // to give the tag for the tableview cell.
    /*var dictSurveyResult = NSMutableDictionary()
    var arrQues = [String]() // it store the question.
    var arrChoice = [Int]()
    var arrChoiceName = [String]() // it stores the choice answers
    var arrSurveyDetail = NSArray() // it stores the details of survey
    var arrType = [String]() // it stores the types of answer of survey
    */
    
    var objSurvey = SurveyList()
    var objPeopleList = PeopleList()
    var isNationSlug = String()
    var isAccessToken = String()
    var isSlug = String()
    var peopleID = Int()
    
    var radioButtonIndexPath = [Int:IndexPath]() //for radiobutton

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.submitButton.backgroundColor = UIColor.gray
        self.submitButton.isUserInteractionEnabled = false
        
        
     //   self.surveyQuesDetails()
        
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackAction(_ sender: UIButton)
    {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func skipButtonAction(_ sender: UIButton)
    {
        
    }
    
    @IBAction func submitButtonAction(_ sender: UIButton)
    {
        /*
        DispatchQueue.background(delay: 1.5, completion:
            {
                let alert = UIAlertController(title: "Survey recorded", message: "Thanks for answering all our questions.", preferredStyle: UIAlertControllerStyle.alert)
                // alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                    self.view.endEditing(true)
                    let _ = self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
        })
        
        */
        
        /*{"survey_response": {"person_id": "5869","survey_id": 3,
                "question_responses": [{"question_id": "6","response": "15"},
                ]
            }
        }*/
        
        var strParam = ""
        let strFilterOptionsName : NSMutableString = ""
        print(self.objPeopleList.peopleId)
        if self.objSurvey.arrQuestion.count > 0 {
            strParam = String(format: "{\"survey_response\":{\"person_id\": %d,\"survey_id\": %d,\"question_responses\":[",self.objPeopleList.peopleId,self.objSurvey.surveyID)
            strFilterOptionsName.append(strParam)
            for optionValue in self.objSurvey.arrQuestion{
                strFilterOptionsName.append(String(format:"{\"question_id\":%d,\"response\":\"%@\"},",(optionValue as! QuestionList).questionID,(optionValue as! QuestionList).questionAnswer))
            }

            let range :NSRange = NSMakeRange(strFilterOptionsName.length-1, 1)
            strFilterOptionsName.deleteCharacters(in: range)
            strFilterOptionsName.append("]}}")
            print(strFilterOptionsName)
            let strURL: String = "https://"+isNationSlug+".nationbuilder.com/api/v1/survey_responses?&access_token="+isAccessToken
            getDataFromServer(strFilterOptionsName as NSString, strURL , "POST" as String) {
                (success:Bool, responseDict: NSDictionary?) in
                
                print(responseDict as Any)
                
                let alert = UIAlertController(title: "Survey recorded", message: "Thanks for answering all our questions.", preferredStyle: UIAlertControllerStyle.alert)
                // alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
                    self.view.endEditing(true)
                    let _ = self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Web-Services
    public func getDataFromServer(_ strParams :NSString,_ strUrl :String, _ strMethod :String ,completionHandler:@escaping (_ success:Bool, _ data: NSDictionary?) -> Void){
        print(strParams)
        let url = URL(string: strUrl)
        var request = URLRequest(url: url!)
        request.httpMethod = strMethod
        if strParams.length > 0{
            let strParam = strParams;
            request.httpBody = strParam.data(using: String.Encoding.utf8.rawValue);
        }
        let session :URLSession = URLSession.shared
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //This is just an example, put the Content-request.addValue(User.sharedManager.selectedCurrency, forHTTPHeaderField: "currency")
        request.addValue("UTF-8", forHTTPHeaderField: "charset")
        print(request);
        session.dataTask(with: request, completionHandler: { data, response, error in
            do {
                print(String.init(data: data!, encoding:.utf8) as Any);
                guard let data = data else {
                    return
                }
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                    return
                }
                completionHandler(true, json)
//                if !self.showAlertView(_dict: json){
//                    completionHandler(true, json)
//                }
//                else{
//                    completionHandler(false, nil)
//                }
            } catch let error as JSONError {
                print(error.rawValue)
                completionHandler(false, nil)
            } catch let error as NSError {
                print(error.debugDescription)
                completionHandler(false, nil)
            }
        }).resume()
        
    }
    
    public func showAlertView(_dict : NSDictionary) -> Bool{
        if (_dict["StatusCode"] as! NSInteger == 200){
            return false
        }
        else{
            DispatchQueue.main.async {
                let alert = UIAlertView()
                alert.title = "Error"
                let array : NSArray = (_dict.value(forKey:"ErrorList") as! NSArray?)!
                alert.message = array[0] as? String;
                alert.addButton(withTitle: "Ok")
                alert.show()
            }
            return true
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

extension SurveyFeedbackVC : UITableViewDataSource, UITableViewDelegate{
    // MARK: - Tableview Methods
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.objSurvey.arrQuestion.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let objQuestion : QuestionList = self.objSurvey.arrQuestion[section] as! QuestionList
        if objQuestion.questionType == "multiple" {
            return objQuestion.arrChoice.count
        }
        return 1
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return UITableViewAutomaticDimension
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 63
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let cellSection = tableView.dequeueReusableCell(withIdentifier: "SurveySectionCell") as! SurveyFeedbackCell
        cellSection.lblQuesNo.text = "Question : " + String(section + 1)
        let objQuestion : QuestionList = self.objSurvey.arrQuestion[section] as! QuestionList
        cellSection.lblQuestion.text = objQuestion.questionName
        return cellSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let objQuestion : QuestionList = self.objSurvey.arrQuestion[indexPath.section] as! QuestionList
        if objQuestion.questionType == "multiple" {
            let cell = tableView.dequeueReusableCell(withIdentifier:"SurveyChoiceCell", for: indexPath) as! SurveyFeedbackCell
            let objChoice : ChoicesList = objQuestion.arrChoice[indexPath.row] as! ChoicesList
            
            if radioButtonIndexPath.keys.contains(indexPath.section) {
                if radioButtonIndexPath[indexPath.section] == indexPath {
                    cell.imgSurvey.image = UIImage(named: "imgSurveySelect")
                }else{
                    cell.imgSurvey.image = UIImage(named: "imgSurveyUnselect")
                }
            }else{
                cell.imgSurvey.image = UIImage(named: "imgSurveyUnselect")
            }
            cell.lblChoiceSurvey.text = objChoice.choiceName
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"SurveyTextCell", for: indexPath) as! SurveyFeedbackCell
        cell.txtSurveyFeedback.superview?.tag = indexPath.section
        cell.txtSurveyFeedback?.tag = indexPath.row
        cell.txtSurveyFeedback.delegate = self
        if cell.txtSurveyFeedback.text != "this is textfield text" {
         cell.txtSurveyFeedback.text = objQuestion.questionAnswer
        }else {
            cell.txtSurveyFeedback.text = "this is textfield text"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let objQuestion : QuestionList = self.objSurvey.arrQuestion[indexPath.section] as! QuestionList
        let objChoice : ChoicesList = objQuestion.arrChoice[indexPath.row] as! ChoicesList
        radioButtonIndexPath[indexPath.section] = indexPath
        if objQuestion.questionType == "multiple"
        {
            objQuestion.questionAnswer = String(objChoice.choicesID)
            self.submitButton.backgroundColor = Constants.appThemeColor
            self.submitButton.isUserInteractionEnabled = true
        }
        tableView.reloadData()
    }
}
extension SurveyFeedbackVC : UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        // do whatever you want here
        let name: String = textView.text!
        let objQuestion : QuestionList = self.objSurvey.arrQuestion[(textView.superview?.tag)!] as! QuestionList
        objQuestion.questionAnswer = name
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        let name: String = textView.text!
        let objQuestion : QuestionList = self.objSurvey.arrQuestion[(textView.superview?.tag)!] as! QuestionList
        objQuestion.questionAnswer = name
    }
}
