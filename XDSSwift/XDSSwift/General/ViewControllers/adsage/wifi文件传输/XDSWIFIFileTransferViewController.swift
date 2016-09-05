//
//  XDSWIFIFileTransferViewController.swift
//  Practice_swift
//
//  Created by xudosom on 16/6/25.
//  Copyright © 2016年 上海优蜜科技有限公司. All rights reserved.
//

import UIKit

class XDSWIFIFileTransferViewController: UIViewController {
    
    @IBOutlet weak var IPAndPortLabel: UILabel!
    @IBOutlet weak var uploadProgressLabel: UILabel!
    @IBOutlet weak var uploadProgressView: UIProgressView!
    let httpServer = HTTPServer()

    var _fileCount:Int = 0   //文件数量  许杜生添加 2015.12.22
    var _curentDownloadFileName = ""    //正在下载的文件名称  许杜生添加 2016.06.25
    var _curentDownloadFileCount = 0    //第几个文件正在被下载  许杜生添加 2016.06.25
    var _contentDownloadFileTotleLength:Int = 0    //文件内容总大小  许杜生添加 2015.12.22
    var _downloadLength:Int = 0   //已下载的文件内容大小  许杜生添加 2015.12.22
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.WIFIFileTransferViewControllerDataInit();
        self.createWIFIFileTransferViewControllerUI();
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.receiveANewFileNotification(_:)), name: kGetContentLengthNotificationName, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.receiveDownloadProcessBodyDataNotification(_:)), name: kDownloadProcessBodyDataNotificationName, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.processStartOfPartWithHeaderNotificationName(_:)), name: kGetProcessStartOfPartWithHeaderNotificationName, object: nil)

    }
    
    //MARK:创建UI
    func createWIFIFileTransferViewControllerUI() -> Void {
        uploadProgressView.progress = 0.0;
        httpServer.setType("_http._tcp.")

        // webPath是server搜寻HTML等文件的路径
        let webPath = NSBundle.mainBundle().resourcePath;
        httpServer.setDocumentRoot(webPath)
        httpServer.setConnectionClass(MyHTTPConnection);
        NSLog("\(httpServer.connectionClass())")

        do{
            try httpServer.start()
            NSLog("IP: \(XDSIPHelper.deviceIPAdress())")
            NSLog("port: \(httpServer.listeningPort())")
            IPAndPortLabel.text = "http://\(XDSIPHelper.deviceIPAdress()):\(httpServer.listeningPort())"
        }catch let err as NSError{
            NSLog(err.description)
        }
    }
    //MARK:网络请求
    
    //MARK:代理方法
    
    //MARK:事件响应
    func receiveANewFileNotification(notification:NSNotification) -> Void {
        _fileCount += 1;
        _contentDownloadFileTotleLength = (notification.object?.integerValue)!;
        _downloadLength = 0
    }
    func receiveDownloadProcessBodyDataNotification(notification:NSNotification) -> Void {
        _downloadLength += (notification.object?.integerValue)!
        // 主线程执行
        dispatch_async(dispatch_get_main_queue(),{
            self.uploadProgressView.progress = Float(self._downloadLength)/Float(self._contentDownloadFileTotleLength);
            self.uploadProgressLabel!.text = "正在下载：\(self._curentDownloadFileName)"
        })
    }
    func processStartOfPartWithHeaderNotificationName(notification:NSNotification) -> Void {
        _curentDownloadFileName = String(notification.object!)
        _curentDownloadFileCount += 1
    }
    
    //MARK:其他方法
    
    //MARK:内存管理
    func WIFIFileTransferViewControllerDataInit() -> Void {
        
    }
}
