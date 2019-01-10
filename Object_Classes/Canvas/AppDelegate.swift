
//
//  AppDelegate.swift
//  HandyNation
//
//  Created by coreway solution on 29/11/17.
//  Copyright © 2017 Corway Solution. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import Firebase

let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
let IS_RETINA = UIScreen.main.scale >= 2.0

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let SCREEN_MAX_LENGTH = max(SCREEN_WIDTH, SCREEN_HEIGHT)
let SCREEN_MIN_LENGTH = min(SCREEN_WIDTH, SCREEN_HEIGHT)

let IS_IPHONE_4_OR_LESS = (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
let IS_IPHONE_5 = (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
let IS_IPHONE_6 = (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
let IS_IPHONE_6P = (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    var obj = CheckAuthenticationVC()
    var drawer = MMDrawerController()
    var strPeopleCount = "0" // it store people count.
    var urlRedirect : String = String() // it stores the redirect url for the authentication
    
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    func setStatusBarColor(){
        
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor))
        {
            statusBar.backgroundColor = Constants.appStatusBarColor
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        FirebaseApp.configure()
        self.setupLocationManager() // setUp Location Manager for getting current location
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor))
        {
            statusBar.backgroundColor = UIColor.clear//Constants.appHeaderColor
        }
        UIApplication.shared.statusBarStyle = .lightContent
        
                        //// old google key ////
        GMSPlacesClient.provideAPIKey("AIzaSyCrAdDYIZROqNy1NAHrCjUjY3_3rRPdrLs")
        GMSServices.provideAPIKey("AIzaSyCrAdDYIZROqNy1NAHrCjUjY3_3rRPdrLs")
        
//        GMSPlacesClient.provideAPIKey("AIzaSyC0zS_YML0ZkXtOxEt2Ilrc46YSo5U0PWU") // sandip ID
//        GMSServices.provideAPIKey("AIzaSyC0zS_YML0ZkXtOxEt2Ilrc46YSo5U0PWU") // sandip ID

        
        if(UserDefaults.standard.object(forKey: "txtNationSlug") != nil)
        {
            let navigationVC = UINavigationController()
            let NextVW = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CheckAuthenticationVC") as! CheckAuthenticationVC
            navigationVC.pushViewController(NextVW, animated: true)
        }
        else
        {
            let Mainstoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = Mainstoryboard.instantiateViewController(withIdentifier: "SlugFormVC") as! SlugFormVC
            
            let leftVC = Mainstoryboard.instantiateViewController(withIdentifier: "SlideMenuVC") as! SlideMenuVC
            
            let navigationVC = UINavigationController(rootViewController: vc)
            navigationVC.isNavigationBarHidden = true
            let drawer:MMDrawerController =
                MMDrawerController(center: navigationVC,
                                   leftDrawerViewController:leftVC)
            
            // drawer.setCenterView(vc, withCloseAnimation: false, completion: nil) // changed
            // drawer.leftDrawerViewController = nil
            
            drawer.navigationController?.isNavigationBarHidden = true
            drawer.maximumLeftDrawerWidth = UIScreen.main.bounds.size.width-min((20.0*max(UIScreen.main.scale,2.0)),50.0);
            MMExampleDrawerVisualStateManager.shared().leftDrawerAnimationType
                = MMDrawerAnimationType.parallax
            // drawer.openDrawerGestureModeMask = MMOpenDrawerGestureMode.all
            drawer.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.all
            drawer.setDrawerVisualStateBlock { (drawerVC, drawerSide,
                percentVisible) -> Void in
                let block:MMDrawerControllerDrawerVisualStateBlock =
                    MMExampleDrawerVisualStateManager.shared().drawerVisualStateBlock(for: drawerSide)
            }
            
            let naVC = UINavigationController(rootViewController: drawer)
            naVC.isNavigationBarHidden = true
            
            self.window?.rootViewController = naVC
            
        }
             
        return true
    }
    
   
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

// This extenstion create for some delegate common methods used.
extension AppDelegate {
    // MARK: - App Delegate Ref
    class func delegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    // setUp Location Manager
    func setupLocationManager(){
        // check permission of location
        self.locationManager.requestWhenInUseAuthorization()
        // For use in foreground
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                self.locationAlertMessage() // setUp Location Alert Message
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.delegate = self // setUp Location Manager delegate
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters // get Location ten meter
                locationManager.startUpdatingLocation() // star updating location
            }
        } else {
            self.locationAlertMessage() // setUp Location Alert Message
        }
    }
    
    // MARK: - location failed Alert Message
    func locationAlertMessage() {
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in settings to find out people nearby your location.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        topViewController?.present(alert, animated: true, completion: nil)
    }
    // MARK: - setUp rootview controller
    var topViewController: UIViewController? {
        return topViewController(withRootViewController: UIApplication.shared.keyWindow?.rootViewController)
    }
    
    func topViewController(withRootViewController rootViewController: UIViewController?) -> UIViewController? {
        if (rootViewController is UITabBarController) {
            let tabBarController1 = rootViewController as? UITabBarController
            return topViewController(withRootViewController: tabBarController1?.selectedViewController)
        } else if (rootViewController is UINavigationController) {
            let navigationController = rootViewController as? UINavigationController
            return topViewController(withRootViewController: navigationController?.visibleViewController)
        } else if rootViewController?.presentedViewController != nil {
            let presentedViewController: UIViewController? = rootViewController?.presentedViewController
            return topViewController(withRootViewController: presentedViewController)
        } else {
            return rootViewController
        }
    }
    
}
// # mark - CLLocation Manage Delegagte
extension AppDelegate : CLLocationManagerDelegate {
    
    // Below method will provide you current location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.last != nil{
            currentLocation = locations.last!  // set Last current location to CurrentLocation var
        }
        
    }
    
    // Below Mehtod will print error if not able to update location.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let location: CLLocation = manager.location {
//            var coordinate1: CLLocationCoordinate2D = location.coordinate
            currentLocation = location
        }
        print("Error",error.localizedDescription)
    }
}

