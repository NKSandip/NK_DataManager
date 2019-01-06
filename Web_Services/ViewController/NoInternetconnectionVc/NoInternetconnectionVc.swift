//
//  NoInternetconnectionVc.swift
//  Rytzee
//
//  Created by Rameshbhai Patel on 16/07/18.
//  Copyright © 2018 Rameshbhai Patel. All rights reserved.
//

import UIKit

class NoInternetconnectionVc: UIViewController {

    @IBOutlet weak var lblTitle : UILabel?
    @IBOutlet weak var lblDesc : UILabel?
    
    override func viewDidLoad() {
        self.title = "No Internet Connection"
        self.lblTitle?.text = "Internet Connection Lost"
        self.lblDesc?.text = "Please check your internet connection and try again"
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
