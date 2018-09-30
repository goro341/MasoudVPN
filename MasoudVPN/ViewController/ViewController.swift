//
//  ViewController.swift
//  MasoudVPN
//
//  Created by Masoud on 2018-01-03.
//  Copyright © 2018 Masoud. All rights reserved.
//

import UIKit
import NetworkExtension
import PKHUD

class ViewController:UIViewController {
    
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var vpnTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var serverSegmentedControl: UISegmentedControl!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var switcher: UISwitch!
    var timer = Timer()
    @IBOutlet weak var backgroundLoad: UIImageView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var connection = Connection()
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            print(vpnTypeSegmentedControl.titleForSegment(at: vpnTypeSegmentedControl.selectedSegmentIndex)!)
            print(serverSegmentedControl.titleForSegment(at: serverSegmentedControl.selectedSegmentIndex)!)
            connection.connect(username: usernameTextField.text! , password: passwordTextField.text!, serverName: serverSegmentedControl.titleForSegment(at: serverSegmentedControl.selectedSegmentIndex)!, connectionType: vpnTypeSegmentedControl.titleForSegment(at: vpnTypeSegmentedControl.selectedSegmentIndex)!)
            connectButton.setTitle("Disconnect", for : .normal)
            sender.tag = 0
        case 0:
            connection.disconnect()
            connectButton.setTitle("Connect", for : .normal)
            sender.tag = 1
        default:
            print("error")
        }
        //var connection: NEVPNManager = NEVPNManager.shared();
        //let p = NEVPNProtocolIKEv2();
    }
    @IBAction func disconnectVPN(_ sender: Any) {
        connection.disconnect()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        vpnTypeSegmentedControl.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        serverSegmentedControl.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        
        HUD.flash(HUDContentType.systemActivity, onView: self.view, delay : 2.0)
        /*
         switcher.transform = CGAffineTransform(scaleX: 1.25, y: 1.25);
         self.progressView.transform = CGAffineTransform(scaleX: 1.0, y: 3.0)
         DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
         /*self.timer = Timer.scheduledTimer(timeInterval: 0.0065, target: self, selector: #selector(ViewController.progress), userInfo: nil, repeats: true)*/
         }
         */
        // Do any additional setup after loading the view, typically from a nib.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // change 2 to desired number of seconds
            // Your code with delay
            self.backgroundLoad.removeFromSuperview()
            //HUD.show(.progress)
            
            //success
            HUD.flash(.success, delay: 1.0)
            //failure
            //HUD.flash(HUDContentType.error, onView: self.view)
            //HUD.flash(HUDContentType.label("Connecting..."), onView: self.view, delay : 2.0)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func progress(){
        progressView.progress += 0.0045
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        print("in dismissKeyboard")
        view.endEditing(true)
    }
    
}
