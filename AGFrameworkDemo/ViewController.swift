//
//  ViewController.swift
//  AGIOSFramework
//
//  Created by 13377999 on 07/15/2024.
//  Copyright (c) 2024 13377999. All rights reserved.
//

import UIKit
import CoreLocation
import AGEngineKit
import Alamofire
import AVFoundation

class ViewController: UIViewController, AGEngineUserDelegate, AGEngineAuthDelegate {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var verifyStatusLabel: UILabel!
    @IBOutlet weak var useridLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    
    private let locationManager = CLLocationManager()
    
    private var token = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 可选：设置环境
        AGEngineKit.sharedEngine().setEnvironment(.debug)
        
        // 1. 初始化 SDK
        AGEngineKit.sharedEngine().initWithAppId("9cdbd018abe641ea9456f2ee4c65ef49")
        
        // 1-1 （可选，推荐）添加自定义定位模块
        AGEngineKit.sharedEngine().addLoactionModule(AMapMoudle())
        
        // 2. 获取 metaInfo
        let metaInfo = AGEngineKit.getMetaInfo()
        
        getAccessToken(metaInfo: metaInfo)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func getAccessToken(metaInfo: String) {
        // 接入放需要在此使用服务端对接获取 token
        token = """
eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJpc3MiOiJodHRwOi8vdGVzdC1hcGkuYWdhbnl1bmtlLmNvbS9wbXMvYWNjb3VudC9vcGVuQXBpL3Rvb2wvaW50ZXJuYWxBY2Nlc3NUb2tlbiIsImlhdCI6MTcyMTAyODI5MCwiZXhwIjoxNzIxMDI4NTkwLCJuYmYiOjE3MjEwMjgyOTAsImp0aSI6ImduSktVOXpBaU45WVZzeHoiLCJzdWIiOiJpZCIsInBydiI6ImNmNGFmYmU0MjgxN2E4ZjJkMmMyYmJiMzdiZmUwZjczYjkwNTE3N2IiLCJpZCI6MjcwNDI3LCJ0aXRsZSI6IuiWr-eJhzAxIiwiY29tcGFueUlkIjoxMTMxOTEsIm9wZXJhdG9ySWQiOjI3MDQyNywib3BlcmF0b3JUaXRsZSI6IuiWr-eJhzAxIiwib3BlcmF0b3JUeXBlIjoiY29tcGFueV91c2VyIiwicGFzc3dvcmQiOiIxYWYxNmQ3ZTEyMWE2ZDNjMmVkNDU1ZDlhNTk4ZmJkNyJ9.7nczw2NprtXpk4yo72UCIuDGfTf6DcOI4BxzGLQlsx2-_qxuBckMUy-PbY6kpvKOm5rn4tLGjVYIWKRrnKSWGw
"""
    }
    
    @IBAction func login(_ sender: Any) {
        // 这里只做演示，具体业务需求提前拿到地理位置权限
        locationManager.requestWhenInUseAuthorization()
        AGEngineKit.sharedEngine().login(withAccessToken: token, delegate: self)
    }
    
    
    @IBAction func auth(_ sender: Any) {
        AGEngineKit.sharedEngine().authAccount(from: self, delegate: self)
    }
    
    @IBAction func makeCall(_ sender: Any) {
        // 这里只做演示，具体业务需求提前拿到麦克风权限
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            guard granted else { return }
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "callpush", sender: self)
            }
        }
    }
    
    @IBAction func uploadLog(_ sender: Any) {
        AGEngineKit.sharedEngine().uploadLog()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "callpush" else { return }
        let vc = segue.destination as! CallingViewController
        vc.phone = phoneTextField.text ?? ""
    }
    
    // MARK: - AGEngineUserDelegate, AGEngineAuthDelegate
    func agEngine(_ engine: AGEngineKit, userLoginError error: (any Error)) {
        print("登录报错: \(String(describing: error))")
    }
    
    func agEngine(_ engine: AGEngineKit, didUserLoginSuccess user: AGAccount) {
        useridLabel.text = "用户id：\(user.userId)"
        usernameLabel.text = "用户名：\(user.name)"
        verifyStatusLabel.text = "用户认证状态：\(user.verifyStatus.rawValue)"
    }
    
    func agEngine(_ engine: AGEngineKit, didUserLogout userId: AGAccount) {
        print("用户登出")
    }
    
    func agEngine(_ engine: AGEngineKit, didUserAuthError error: (any Error)) {
        print("认证报错: \(String(describing: error))")
    }
    
    func agEngine(_ engine: AGEngineKit, didUserAuthSuccess account: AGAccount) {
        print("用户认证成功")
    }
}

