//
//  Connection.swift
//  MasoudVPN
//
//  Created by Masoud on 2018-07-15.
//  Copyright © 2018 Masoud. All rights reserved.
//

import Foundation
class Connection{
    let pickerData = ["IPSec", "IKEv2"]
    let servers : [String: String] = ["Canada" : "free-ca.hide.me", "Netherlands" : "free-nl.hide.me"]
    var selectedVpnType : String = "IPSec"
    var prevValue: String = "IPSec"
    var isConnected: Bool = false
    var serverName : String = "Canada"
    //var vpnConnection = VPN(servers[serverName]!, selectedVpnType)
    var vpnConnection = VPN()
    
    func connect(username : String, password: String, serverName : String, connectionType : String){
        
        prevValue = selectedVpnType
        selectedVpnType = connectionType
        if (selectedVpnType != prevValue){
            vpnConnection = VPN()
        }
        vpnConnection.connectVPN(serverAddress: servers[serverName]!, vpnType: self.selectedVpnType,username: username, password: password)
    }
    
    func disconnect(){
        self.vpnConnection.disconnectVPN()
        
    }
    
}
