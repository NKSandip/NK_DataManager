//
//  UIViewController+Additions.swift
//  OnDemandApp
//  Created by Pawan Joshi on 12/04/16.
//  Copyright © 2016 Appster. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
// MARK: - UIViewController Extension
extension UIViewController {
    @IBAction func openImagePickerController(_ sender: UIButton) {
        
        func setBackButton() {
            if self.navigationController != nil {
                self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
            }
        }
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        if status == AVAuthorizationStatus.denied {
            let alertController = UIAlertController(title: NSLocalizedString("You do not have permissions enabled for this.", comment: "You do not have permissions enabled for this."), message: NSLocalizedString("Would you like to change them in settings?", comment: "Would you like to change them in settings?"), preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) -> Void in
                guard let url = URL(string: UIApplicationOpenSettingsURLString) else {return}
                UIApplication.shared.openURL(url)
            })
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel, handler: nil)
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            presentAlert(alertController)
        }
        else {
            let imagePickerMessage: String =  "Where would you like to get photos from?"
            let alertController = UIAlertController(title: imagePickerMessage, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            alertController.popoverPresentationController?.sourceRect = sender.bounds
            alertController.popoverPresentationController?.sourceView = sender
            let cancel = "Cancel"
            let cancelAction = UIAlertAction(title: cancel, style: .cancel, handler: nil)
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePickerController.mediaTypes = [kUTTypeImage as String]
            imagePickerController.allowsEditing = true
            imagePickerController.modalPresentationStyle = UIModalPresentationStyle.popover
            imagePickerController.popoverPresentationController?.sourceView = sender
            imagePickerController.popoverPresentationController?.sourceRect = sender.bounds
            
            let takePhoto: String = "Take a Photo"
            let camera = UIAlertAction(title: takePhoto , style: .default) { (camera) -> Void in
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
            let libraryOption: String = "Choose from Library"
            let photoLibrary = UIAlertAction(title: libraryOption, style: .default) { (Photolibrary) -> Void in
                
                imagePickerController.sourceType = .photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                alertController.addAction(camera)
            }
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                alertController.addAction(photoLibrary)
            }
            alertController.addAction(cancelAction)
            presentAlert(alertController)
        }
    }
    
    fileprivate func presentAlert(_ sender: UIAlertController) {
        present(sender, animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    /**
     Shows a simple alert view with a title and dismiss button
     
     - parameter title:   title for alerview
     - parameter message: message to be shown
     */
    func showAlertViewWithMessage(_ title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    /**
     Shows a simple alert banner with a title and dismiss button
     
     - parameter title:   title for alerview
     - parameter message: message to be shown
     */
   /* func showAlertBannerWith(_ title: String, message: String, bannerStyle:ALAlertBannerStyle, timeDurationInSeconds:TimeInterval) {
        
        let bannerAlertPosition = ALAlertBannerPositionBottom
        let banner = ALAlertBanner(for: self.view, style: bannerStyle, position: bannerAlertPosition, title: title, subtitle: message)
        banner?.secondsToShow = timeDurationInSeconds
        self.view.makeToast(message, duration: 2.0, position: .bottom, title: title, image: nil, style: nil, completion: nil)
        //        self.view.makeToast(message, duration: 1.5, position: ToastPosition.bottom)
    }*/
    
    /**
     Shows a simple alert banner with auto hide
     
     - parameter message:     message description
     - parameter bannerStyle: bannerStyle description
     */
    /*func showAlertBannerWithMessage(_ message: String, bannerStyle: ALAlertBannerStyle) {
        
        let bannerAlertPosition = ALAlertBannerPositionTop
        let banner = ALAlertBanner(for: view, style: bannerStyle, position: bannerAlertPosition, title: message)
        banner?.show()
    }
    func showBRYXBanner(_ title: String, _ message: String, _ imageUrl: String?) {
        let banner = Banner(title: title, subtitle: message, image: UIImage(named: "notification-Icon"), backgroundColor: UIColor.black.withAlphaComponent(0.8))
        banner.dismissesOnTap = true
        banner.titleLabel.font = UIFont.init(name: "FSJoey-Bold", size: 15)
        banner.show(duration: 3.0)
    }*/
    /**
     Shows a simple alert view with a title, dismiss button and action handler for dismiss button
     
     - parameter title:         title for alerview
     - parameter message:       message description
     - parameter actionHandler: actionHandler code/closer/block
     */
    func showAlertViewWithMessageAndActionHandler(_ title: String, message: String, actionHandler:(() -> Void)?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let alAction = UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: .default) { (action) in
            
            if let _ = actionHandler {
                actionHandler!()
            }
        }
        alertController.addAction(alAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /*
    func alertWithOkAndCancel(_ title: String, message: String, actionHandler:(() -> Void)?) {
        let alertController = UIAlertController(title: title, message: Localization(message), preferredStyle: UIAlertControllerStyle.alert)
        let alAction = UIAlertAction(title: Localization("SIGN UP"), style: .default) { (action) in
            
            if let _ = actionHandler {
                actionHandler!()
            }
        }
        
        let cancel = UIAlertAction(title: Localization("CANCEL"), style: .cancel) { (action) in
        }
        
        alertController.addAction(alAction)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }*/
    /**
     Shows a simple alert view with a simple text field
     
     - parameter title:                title description
     - parameter message:              message description
     - parameter textFieldPlaceholder: placeholder text for text field in alert view
     - parameter submitActionHandler:  submitActionHandler block/closer/code
     */
    func showAlertViewWithTextField(_ title: String, message: String, textFieldPlaceholder:String, submitActionHandler:@escaping (_ textFromTextField:String?) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = textFieldPlaceholder
            textField.borderStyle = UITextBorderStyle.none
        }
        
        let submitAction = UIAlertAction(title: NSLocalizedString("Submit", comment: "Submit"), style: .default) {  (action: UIAlertAction!) in
            let answerTF = alertController.textFields![0]
            let text = answerTF.text
            submitActionHandler(text)
        }
        alertController.addAction(submitAction)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel) {  (action: UIAlertAction!) in
            
        }
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    /**
     Shows a simple alert view with a secure text field
     
     - parameter title:                title description
     - parameter message:              message description
     - parameter textFieldPlaceholder: placeholder text for text field in alert view
     - parameter submitActionHandler:  submitActionHandler block/closer/code
     */
    func showAlertViewWithSecureTextField(_ title: String, message: String, textFieldPlaceholder:String, submitActionHandler:@escaping (_ textFromTextField:String) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = textFieldPlaceholder
            textField.isSecureTextEntry = true
        }
        
        let submitAction = UIAlertAction(title: NSLocalizedString("Submit", comment: "Submit"), style: .default) {  (action: UIAlertAction!) in
            let answer = alertController.textFields![0]
            submitActionHandler(answer.text!)
        }
        alertController.addAction(submitAction)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .cancel) {  (action: UIAlertAction!) in
            
        }
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension UIViewController {
    /**
     shows activity controller with supplied items. at least one type of item must be supplied
     
     - parameter image:      image to be shared
     - parameter text:       text to be shared
     - parameter url:        url to be shared
     - parameter activities: array of UIActivity which you want to show in controller. nil value will show every available active by default
     */
    func showActivityController(_ image: UIImage?, text: String?, url: String?, activities: [UIActivity]? = nil ) {
        
        var array = [AnyObject]()
        
        if image != nil {
            array.append(image!)
        }
        if text != nil {
            array.append(text! as AnyObject)
        }
        if url != nil {
            array.append(URL(string: url!)! as AnyObject)
        }
        assert(array.count != 0, "Please specify at least element to share among image, text or url")
        
        let activityController = UIActivityViewController(activityItems: array, applicationActivities: activities)
        present(activityController, animated: true, completion: nil)
    }
}
