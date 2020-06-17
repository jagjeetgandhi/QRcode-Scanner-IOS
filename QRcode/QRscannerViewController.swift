//
//  QRscannerViewController.swift
//  QRcode
//
//  Created by jagjeet on 25/02/20.
//  Copyright © 2020 jagjeet. All rights reserved.
//

import UIKit
import AVFoundation

class QRscannerViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var messagelabel:UILabel!
    var capturesession = AVCaptureSession()
    var videopreviewlayer: AVCaptureVideoPreviewLayer?
    var qrcode : UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // for operating camera or (getting back camera in work)
        let devicediscovery = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        guard let capturedevice = devicediscovery.devices.first
            else {
                print("Camera failed to operate")
                return
          }
        do {
            let input = try AVCaptureDeviceInput(device:capturedevice)
            capturesession.addInput(input)
            let capturemetadata = AVCaptureMetadataOutput()
            capturesession.addOutput(capturemetadata)
            capturemetadata.setMetadataObjectsDelegate(self, queue:DispatchQueue.main)
            capturemetadata.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            videopreviewlayer = AVCaptureVideoPreviewLayer(session: capturesession)
            videopreviewlayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videopreviewlayer?.frame = view.layer.bounds
            view.layer.addSublayer(videopreviewlayer!)
            capturesession.startRunning()
            qrcode = UIView()
             if let qrcode = qrcode {
                qrcode.layer.borderColor = UIColor.green.cgColor
                qrcode.layer.borderWidth = 2
                view.addSubview(qrcode)
                view.bringSubview(toFront:qrcode)
            }
        }catch {
            print(error)
            return
        }
        
     
    }
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            qrcode?.frame = CGRect.zero
            messagelabel.text! = "no text present"
            return
        }
        let metadataobj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metadataobj.type == AVMetadataObject.ObjectType.qr {
            let barcode = videopreviewlayer?.transformedMetadataObject(for: metadataobj)
            qrcode?.frame = barcode!.bounds
        }
        if metadataobj.stringValue != nil {
            messagelabel.text! = metadataobj.stringValue!
            capturesession.stopRunning()
            let alertPrompt = UIAlertController(title: "Open App", message: "You're going to open \(metadataobj.stringValue!)", preferredStyle: .actionSheet)
            let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.default, handler: { (action) -> Void in
                
                if let url = URL(string: metadataobj.stringValue!) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
            
            alertPrompt.addAction(confirmAction)
            alertPrompt.addAction(cancelAction)
            
            present(alertPrompt, animated: true, completion: nil)
        }
        
    }
 
}
