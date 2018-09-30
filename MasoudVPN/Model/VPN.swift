//
//  VPN.swift
//  MasoudVPN
//
//  Created by Masoud on 2018-06-08.
//  Copyright © 2018 Masoud. All rights reserved.
//

import Foundation
import NetworkExtension

class VPN {
    let vpnManager = NEVPNManager.shared()
    var username: String = ""
    var password: String = ""
    var vpnType : String = "IPSec"
    var serverAddress : String = ""
    

    
    private var vpnLoadHandler: (Error?) -> Void { return
    { (error:Error?) in
        if ((error) != nil) {
            print("Could not load VPN Configurations")
            return;
        }
        //let vpnType = "IKEV2"; //or "IPSEC"
        let kcs = KeychainService();
        var p = NEVPNProtocolIPSec();
        switch self.vpnType {
        case "IPSec":
            p.authenticationMethod = NEVPNIKEAuthenticationMethod.sharedSecret
            kcs.save(key: "SHARED", value: "hide.io")
            p.sharedSecretReference = kcs.load(key: "SHARED")
            self.vpnManager.localizedDescription = "MasCo IPSec"
        case "IKEv2":
            p = NEVPNProtocolIKEv2();
            p.remoteIdentifier = "hide.me"
            p.authenticationMethod = NEVPNIKEAuthenticationMethod.none
            self.vpnManager.localizedDescription = "MasCo IKEv2"
        default:
            break
        }
        //p.username = "goro341"
        p.username = self.username;
        let password = self.password//"nalannalan"
        p.serverAddress = self.serverAddress
        
        kcs.save(key: "VPN_PASSWORD", value: password)
        p.passwordReference = kcs.load(key: "VPN_PASSWORD")
        p.useExtendedAuthentication = true
        p.disconnectOnSleep = false
        self.vpnManager.protocolConfiguration = p
        
        self.vpnManager.isEnabled = true
        self.vpnManager.saveToPreferences(completionHandler: self.vpnSaveHandler)
        }
    }
    
    private var vpnSaveHandler: (Error?) -> Void { return
    { (error:Error?) in
        if (error != nil) {
            print("Could not save VPN Configurations")
            return
        } else {
            do {
                try self.vpnManager.connection.startVPNTunnel()
            } catch let error {
                print("Error starting VPN Connection \(error.localizedDescription)");
            }
        }
        }
        //self.vpnlock = false
    }
    
    public func connectVPN(serverAddress : String, vpnType : String, username : String, password: String) {
        self.username = username
        self.password = password
        self.serverAddress = serverAddress
        self.vpnType = vpnType
        //For no known reason the process of saving/loading the VPN configurations fails.On the 2nd time it works
        do {
            try self.vpnManager.loadFromPreferences(completionHandler: self.vpnLoadHandler)
        } catch let error {
            print("Could not start VPN Connection: \(error.localizedDescription)" )
        }
    }
    public func disconnectVPN() ->Void {
        self.vpnManager.connection.stopVPNTunnel()
        print("VPN disconnected")
    }
}

