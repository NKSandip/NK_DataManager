//
//  LocationDetailsVc.swift
//  Rytzee
//
//  Created by Nirav Shukla on 23/08/18.
//  Copyright © 2018 Rameshbhai Patel. All rights reserved.
//

import UIKit

class LocationDetailsVc: UIViewController {
    @IBOutlet weak var collectionTopView: UICollectionView!
    @IBOutlet weak var collectionBottomView: UICollectionView!
    @IBOutlet weak var pageLocation : UIPageControl?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView() // setUp CollectionView
        self.registerNibs() // setUp register Nibs
        
        // Do any additional setup after loading the view.
    }
    //MARK: - CollectionView UI Setup
    func setupCollectionView(){
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        self.collectionTopView.alwaysBounceVertical = false
        self.collectionTopView.collectionViewLayout = layout
        
        let bottomLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        bottomLayout.minimumInteritemSpacing = 5
        bottomLayout.minimumLineSpacing = 5
        bottomLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        self.collectionBottomView.alwaysBounceVertical = false
        self.collectionBottomView.collectionViewLayout = bottomLayout
    }
    
    //MARK: - Register CollectionView Nibs
    func registerNibs(){
        self.collectionTopView.register(UINib(nibName: "LocationCell", bundle: nil), forCellWithReuseIdentifier: "LocationCell")
        self.collectionBottomView.register(UINib(nibName: "LocationCell", bundle: nil), forCellWithReuseIdentifier: "LocationCell")
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
extension LocationDetailsVc: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionTopView {
            let cell : LocationCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationCell", for: indexPath) as! LocationCell
            cell.imgLocation?.image = UIImage.init(named: "SignUp_Nav_Logo")
            return cell
        }
        let cell : LocationCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationCell", for: indexPath) as! LocationCell
        cell.imgLocation?.image = UIImage.init(named: "SignUp_Nav_Logo")
        return cell
    }
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(0, 0, 0, 0)
        //(_ top: CGFloat, _ left: CGFloat, _ bottom: CGFloat, _ right: CGFloat)
    }
    
    //** Size for the cells in the Waterfall Layout */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: SCREEN_WIDTH, height: SCREEN_HEIGHT * 0.30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
}
