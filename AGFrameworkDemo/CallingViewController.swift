//
//  CallingViewController.swift
//  AGIOSFramework_Example
//
//  Created by 沈晓鹏 on 2024/7/15.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit
import AGEngineKit

class CallingViewController: UIViewController, AGEngineCallDelegate {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var muteButton: UIButton!
    @IBOutlet weak var handfreeButton: UIButton!
    @IBOutlet weak var hangupButton: UIButton!
    
    var phone: String = ""
    
    var call: AGCall?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        muteButton.setTitle("静音", for: .normal)
        muteButton.setTitle("已静音", for: .selected)
        
        handfreeButton.setTitle("免提", for: .normal)
        handfreeButton.setTitle("已免提", for: .selected)
        call = AGEngineKit.sharedEngine().callPhone(phone, callDelegate: self)
//        call = AGEngineKit.sharedEngine().callPhone(phone, payload: "", callDelegate: self)
        updateState()
        
    }
    
    private func updateState() {
        guard let call else { return }
        numberLabel.text = call.phone
        switch call.state {
        case .idle:
            statusLabel.text = "准备中"
            break
        case .linking:
            statusLabel.text = "连接中"
            break
        case .ring:
            statusLabel.text = "响铃中"
            break
        case .calling:
            statusLabel.text = "通话中"
            break
        case .disconnect:
            statusLabel.text = "已挂断"
            DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            break
        @unknown default: break
        }
    }
    
    @IBAction func onTapMuteAction(_ sender: Any) {
        guard let call else { return }
            if (muteButton.isSelected) {
                AGEngineKit.sharedEngine().unmuteMicrophone(with: call)
            } else {
                AGEngineKit.sharedEngine().muteMicrophone(with: call)
            }
    }
    
    @IBAction func onTapHandsfreeAction(_ sender: Any) {
        guard let call else { return }
        if (handfreeButton.isSelected) {
            AGEngineKit.sharedEngine().unHandsFree(with: call)
        } else {
            AGEngineKit.sharedEngine().handsFree(with: call)
        }
    }
    
    @IBAction func onTapHangupAction(_ sender: Any) {
        guard let call else { return }
        AGEngineKit.sharedEngine().hangupCall(call, error: nil)
    }
    
    // MARK: - AGEngineCallDelegate
    func agCall(_ call: AGCall?, didCallFailure error: (any Error)) {
        print("拨号错误：\(String(describing: error))")
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func agCall(_ call: AGCall?, didCallStateChange state: AGCallState) {
        updateState()
    }
    
    func agCall(_ call: AGCall?, didMuteStateChange isMute: Bool) {
        muteButton.isSelected = isMute
    }
    
    func agCall(_ call: AGCall?, didHandsFreeStateChange isHandsFree: Bool) {
        handfreeButton.isSelected = isHandsFree
    }
    
    
    
    
}
