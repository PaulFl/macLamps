//
//  TodayViewController.swift
//  macLamps Widget
//
//  Created by Paul Fleury on 24/09/15.
//  Copyright © 2015 Paul Fleury. All rights reserved.
//

import Cocoa
import NotificationCenter

struct Actions {
    static let onDesktop = 1
    static let offDesktop = 2
    static let onBed = 3
    static let offBed = 4
}

let serverAddress: CFString = "78.227.97.91"
let serverPort: UInt32 = 1024

var inputStream: NSInputStream!
var outputStream: NSOutputStream!
var readStream:  Unmanaged<CFReadStream>?
var writeStream: Unmanaged<CFWriteStream>?

class TodayViewController: NSViewController, NCWidgetProviding {

    override var nibName: String? {
        return "TodayViewController"
    }

    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Update your data and prepare for a snapshot. Call completion handler when you are done
        // with NoData if nothing has changed or NewData if there is new data since the last
        // time we called you
        completionHandler(.NoData)
    }
    @IBAction func onDesktop(sender: AnyObject) {
        connectToServer()
        sendData(Actions.onDesktop)
    }
    
    @IBAction func offDesktop(sender: AnyObject) {
        connectToServer()
        sendData(Actions.offDesktop)
    }
    
    @IBAction func onBed(sender: AnyObject) {
        connectToServer()
        sendData(Actions.onBed)
    }
    
    @IBAction func offBed(sender: AnyObject) {
        connectToServer()
        sendData(Actions.offBed)
    }
    
    
    func connectToServer() {
        CFStreamCreatePairWithSocketToHost(nil, serverAddress, serverPort, &readStream, &writeStream)
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        outputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        inputStream.open()
        outputStream.open()
    }
    
    func sendData(action: Int) {
        let signal = String(action)
        let data = signal.dataUsingEncoding(NSUTF8StringEncoding)
        outputStream.write(UnsafePointer<UInt8>(data!.bytes), maxLength: data!.length)
    }

}
