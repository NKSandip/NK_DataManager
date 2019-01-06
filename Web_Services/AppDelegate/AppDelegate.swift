
//  AppDelegate.swift
//  Rytzee
//
//  Created by Rameshbhai Patel on 03/07/18.
//  Copyright © 2018 Rameshbhai Patel. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import IQKeyboardManagerSwift
import FAPanels
import Reachability
import FBSDKCoreKit
import FBSDKLoginKit
import UserNotifications
import GoogleSignIn
import KYDrawerController

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

let DEVICE_TOKEN =  UserDefaults.standard.string(forKey: "deviceToken")
let googleClientID =  "989997387549-9vnl4j8vl9g3ohu62nhs6g6gmglu5tt5.apps.googleusercontent.com"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,FAPanelStateDelegate {
    var window: UIWindow?
    var mainVC = FAPanelController()

    /// Used for determinig the current status of the device's internet connection
    var isNoNetworkAtLunch : Bool? = false
    var isNetworkScreenPresent : Bool? = false
    var reachability = Reachability()!

    var objSignUpVc : SignUpViewController?
    var objSignInVc : SignInViewController?
    
    //Keeping reference of iOS default UITabBarController.
    let tabBarController = UITabBarController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = googleClientID
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

//        GIDSignIn.sharedInstance().delegate = self as! GIDSignInDelegate
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        application.isStatusBarHidden = true
        
        self.callAllDelegateMethods() // call all delegate Methods
        return true
    }
    // [END openurl]
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation]) || FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    // [START openurl]
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation) || GIDSignIn.sharedInstance().handle(url,sourceApplication: sourceApplication,annotation: annotation)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        UserDefaults.standard.set(tokenString, forKey: "deviceToken") //setObject
        UserDefaults.standard.synchronize()
        print("tokenString: \(tokenString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        let uuid = UUID().uuidString
        UserDefaults.standard.set(uuid, forKey: "deviceToken") //setObject
        UserDefaults.standard.synchronize()
        print("i am not available in simulator \(error)")
    }
    func applicationWillResignActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()

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
    
    // MARK: - call All Delegate Methods
    func callAllDelegateMethods() {
        Fabric.with([Crashlytics.self])
        self.reachability = Reachability()!
        
        // Override point for customization after application launch.
        self.changeNavigationAttribute()
        self.enableInputAccessoryView()
        self.configureNavigationItems()
        
        self.setUpViewController() // SetUp SignUp ViewController
        self.checkInternetConnection() // check internet connection
        
    }
    
    //MARK: - setUpViewController
    /*  Setup ViewController as a root View Controller */
    public func setUpViewController() {
        if UserDefaults.standard.isLoggedIn() == true {
            if UserDefaults.standard.isSurvey() == false {
                let objSurvey : SurveyViewController  = SurveyViewController(nibName:"SurveyViewController",bundle:nil)
                let navigationController = UINavigationController(rootViewController: objSurvey)
                navigationController.isNavigationBarHidden = true
                self.setUpWindow(Controller: navigationController)
            }else {
                self.setUpTabbar()
                /*if UserDefaults.standard.getHasSelectedSurveyID() == 0 {
                    let objHome : HomeViewController  = HomeViewController(nibName:"HomeViewController",bundle:nil)
                    self.openViewController(Controller: objHome)
                }else {
                    let objHome : HomeSecondVc  = HomeSecondVc(nibName:"HomeSecondVc",bundle:nil)
                    self.openViewController(Controller: objHome)
                }*/
            }
        }else{
            if UserDefaults.standard.isSurvey() == false && UserDefaults.standard.isLoggedIn() == false || UserDefaults.standard.isSurvey() == true && UserDefaults.standard.isLoggedIn() == false{
                let objHome:WelcomeViewController  = WelcomeViewController(nibName:"WelcomeViewController",bundle:nil)
                let navigationController = UINavigationController(rootViewController: objHome)
                navigationController.isNavigationBarHidden = true
                self.setUpWindow(Controller: navigationController)
            }else {
                let objSurvey : SurveyViewController  = SurveyViewController(nibName:"SurveyViewController",bundle:nil)
                let navigationController = UINavigationController(rootViewController: objSurvey)
                navigationController.isNavigationBarHidden = true
                self.setUpWindow(Controller: navigationController)
            }
            
        }
    }
    
    // MARK: - Open SideViewController
    public func openViewController(Controller : UIViewController) {
        let objSideViewController : SideMenuViewController = SideMenuViewController(nibName:"SideMenuViewController",bundle:nil)
        
//        let centerNavVC = UINavigationController(rootViewController: Controller)
        let tabBarNavVC = UINavigationController(rootViewController: tabBarController)
        let btnHome = UIImage(named: "Home_Side")
        Controller.navigationItem.rightBarButtonItem = UIBarButtonItem(image: btnHome, style: .plain, target: self, action:  #selector(barButtonDidTap(_:)))
        //        mainVC.configs = FAPanelConfigurations()
        mainVC.leftPanelPosition = .back
        
        _ = mainVC.center(tabBarNavVC).left(objSideViewController).right(nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.setUpWindow(Controller: self.mainVC)
        })
    }
    @objc func barButtonDidTap(_ sender: UIBarButtonItem)
    {
        mainVC.openLeft(animated: true)
    }
    
    // MARK: - SetUp Window Screen
    func setUpWindow(Controller : UIViewController) {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = Controller
        self.window?.makeKeyAndVisible()
    }
    // MARK: - setUp Tabbar Controller
    public func setUpTabbar(){
        // Create Tab one
        let navWelCome = UINavigationController()
        let tabWelCome = FavouriteListVc(nibName: "FavouriteListVc",bundle: nil)
        tabWelCome.tabBarItem = UITabBarItem(title: "Favourite", image: UIImage(named: "tab-1"), selectedImage: UIImage(named: "tab-1"))
        navWelCome.viewControllers = [tabWelCome]
        
        let navHomeVc = UINavigationController()
        let tabHomeVc = HomeViewController(nibName:"HomeViewController",bundle: nil)
        tabHomeVc.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "tab-2"), selectedImage: UIImage(named: "tab-2"))
        navHomeVc.viewControllers = [tabHomeVc]
        
        let navHomeSecondVc = UINavigationController()
        let tabHomeSecondVc = HomeSecondVc(nibName: "HomeSecondVc",bundle: nil)
        tabHomeSecondVc.tabBarItem = UITabBarItem(title: "Second", image: UIImage(named: "tab-3"), selectedImage: UIImage(named: "tab-3"))
        navHomeSecondVc.viewControllers = [tabHomeSecondVc]
        
        let navHomeThirdVc = UINavigationController()
        let tabHomeThirdVc = HomeSecondVc(nibName: "HomeSecondVc",bundle: nil)
        tabHomeThirdVc.tabBarItem = UITabBarItem(title: "Third", image: UIImage(named: "tab-4"), selectedImage: UIImage(named: "tab-4"))
        navHomeThirdVc.viewControllers = [tabHomeThirdVc]
        
        let navHomeFourthVc = UINavigationController()
        let tabHomeFourthVc = HomeSecondVc(nibName: "HomeSecondVc",bundle: nil)
        tabHomeFourthVc.tabBarItem = UITabBarItem(title: "Fourth", image: UIImage(named: "tab-5"), selectedImage: UIImage(named: "tab-5"))
        navHomeFourthVc.viewControllers = [tabHomeFourthVc]
        
        self.tabBarController.tabBar.barTintColor = UIColor(hexString: "#000000")
        self.tabBarController.tabBar.tintColor = .white
        self.tabBarController.tabBar.isTranslucent = true
        self.tabBarController.viewControllers = [navWelCome, navHomeVc, navHomeSecondVc, navHomeThirdVc, navHomeFourthVc]

        let drawerViewController = SideMenuViewController()
        let drawerController     = KYDrawerController.init(drawerDirection: .left, drawerWidth: SCREEN_WIDTH * 0.85)
        drawerController.mainViewController = UINavigationController(
            rootViewController: tabBarController
        )
//        let btnHome = UIImage(named: "Home_Side")
//        drawerController.navigationItem.rightBarButtonItem = UIBarButtonItem(image: btnHome, style: .plain, target: self, action:  #selector(barButtonDidTap(_:)))

        drawerController.drawerViewController = drawerViewController
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = drawerController
        self.window?.makeKeyAndVisible()
    }
    
    // MARK: - App Delegate Ref
    class func delegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    public func changeNavigationAttribute(){
        UINavigationBar.appearance().barTintColor = Color.navBlueColor.value
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font: CustomFont.font_Raleway_Bold.of(size: 18) as Any]
        UINavigationBar.appearance().isTranslucent = true
    }
    
    // MARK: - Configure IQKeyboardManager
    public func enableInputAccessoryView() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarTintColor = Color.navBlueColor.value
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    //MARK: - Configure Navigation items
    func configureNavigationItems(){
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.clear,NSAttributedStringKey.font: CustomFont.font_Raleway_Bold.of(size: 18) as Any]
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .highlighted)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, 0), for: .default)
    }
    
    //MARK: - checkInternetConnection
    /*  checkInternetConnection as a root View Controller */
    public func checkInternetConnection(){
        //declare this property where it won't go out of scope relative to your listener
        self.reachability.whenReachable = { reachability in
            DispatchQueue.main.async {
                if self.isNoNetworkAtLunch == true {
                    self.isNoNetworkAtLunch = false;
                }
                if (self.isNetworkScreenPresent == false) {
                    self.hideNetworkWindow()
                }
            }
        }
        self.reachability.whenUnreachable = { reachability in
            DispatchQueue.main.async {
                if self.isNetworkScreenPresent == true {
                    self.showNetworkwindow()
                }
            }
            print("Not reachable")
        }
        
        do {
            // Here we set up a NSNotification observer. The Reachability that caused the notification
            // is passed in the object parameter
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(reachabilityChanged),
                name: NSNotification.Name.reachabilityChanged,
                object: nil
            )
            try self.reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func reachabilityChanged(notification: NSNotification) {
        if self.reachability.connection == .wifi || self.reachability.connection == .cellular {
            self.isNetworkScreenPresent = false
            print("Service avalaible!!!")
        } else {
            self.isNetworkScreenPresent = true
            print("No service avalaible!!!")
        }
        delay(delay: 5) {
            self.checkInternetConnection() // check internet connection
        }
    }
    /*  delay */
    func delay(delay: Double, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    
    //MARK: - showNetworkwindow
    /*  showNetworkwindow */
    func showNetworkwindow() {
        self.isNetworkScreenPresent = false
        let controller = NoInternetconnectionVc()
        let navcontroller = UINavigationController(rootViewController: controller)
        topViewController?.present(navcontroller, animated: true)
    }
    func hideNetworkWindow() {
        isNetworkScreenPresent = true
        window?.rootViewController?.dismiss(animated: true)
    }
    //MARK: - topViewController
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

//MARK: - UIBarButtonItem
extension UIBarButtonItem {
    class func itemWith(colorfulImage: UIImage?, target: AnyObject, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(colorfulImage, for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        button.addTarget(target, action: action, for: .touchUpInside)
        
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }
}

//MARK: - UIScreen
extension UIScreen {
    var isPhone4: Bool {
        return UIScreen.main.nativeBounds.size.height == 960;
    }
    
    var isPhone5: Bool {
        
        return UIScreen.main.nativeBounds.size.height == 1136;
    }
    
    var isPhone6: Bool {
        return UIScreen.main.nativeBounds.size.height == 1334;
    }
    
    var isPhone6Plus: Bool {
        return UIScreen.main.nativeBounds.size.height == 2208;
    }
    
}

//MARK: - UIApplication
extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
