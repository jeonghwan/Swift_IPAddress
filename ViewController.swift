//
//  ViewController.swift
//  Swift_IPAddress
//
//  Created by ImJeonghwan on 10/12/16.
//  Copyright © 2016 ImJeonghwan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var ipv4Address: UILabel!
    @IBOutlet weak var ipv6Address: UILabel!
    
    @IBAction func handleGetInfo(_ sender: AnyObject) {
        var ipv4Value = "Not Available"
        var ipv6Value = "Not Available"
        
        var ifAddr: UnsafeMutablePointer<ifaddrs>? = nil
        
        var found4: Bool = false
        var found6: Bool = false
        
        var getSuccess = getifaddrs(&ifAddr)
        
        if getSuccess == 0 {
            var ptr = ifAddr
            
            while ptr != nil {
                let flags = Int32((ptr?.pointee.ifa_flags)!)
                var address = ptr?.pointee.ifa_addr.pointee
                
                if flags & IFF_LOOPBACK == 0 {
                    if flags & IFF_UP > 0 || flags & IFF_RUNNING > 0 {
                        var addressName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getSuccess = getnameinfo(&address!, socklen_t((address?.sa_len)!), &addressName, socklen_t(addressName.count), nil, socklen_t(0), NI_NUMERICHOST)
                        if getSuccess == 0 {
                            if address?.sa_family == UInt8(AF_INET) {
                                ipv4Value = String(cString: addressName)
                                found4 = true
                            } else if address?.sa_family == UInt8(AF_INET6) {
                                ipv6Value = String(cString: addressName)
                                found6 = true
                            }
                        }
                    }
                }
                
                if found4 && found6 {
                    break
                } else {
                    ptr = ptr?.pointee.ifa_next
                }
            }
            
            freeifaddrs(ifAddr)
        }
        
        if found4 == true {
            ipv4Address.text = ipv4Value
        }
        
        if found6 == true {
            ipv6Address.text = ipv6Value
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

