//
//  Socket.swift
//  RPiProject
//
//  Created by wonderworld on 16/8/24.
//  Copyright © 2016年 haozhang. All rights reserved.
//

import Foundation

class Client: NSObject {
    
    static let shared = Client()
    
    var inputStream: NSInputStream!
    var outputStream: NSOutputStream!
    
    func connect(host: String, port: UInt32) {
        var readStream: Unmanaged<CFReadStreamRef>?
        var writeStream: Unmanaged<CFWriteStreamRef>?
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, host, port, &readStream, &writeStream)
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        inputStream.delegate = self
        outputStream.delegate = self
        inputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        outputStream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        inputStream.open()
        outputStream.open()
    }
    
    func disconnect() {
        inputStream.close()
        outputStream.close()
        inputStream.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        outputStream.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        inputStream = nil
        outputStream = nil
    }
    
    func sendMessage(msg: String) {
        if let data = msg.dataUsingEncoding(NSUTF8StringEncoding) {
            outputStream.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
        }
    }
}

extension Client: NSStreamDelegate {
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        switch eventCode {
        case NSStreamEvent.OpenCompleted:
            switch aStream {
            case inputStream:
                print("InputStream opened!")
            case outputStream:
                print("OutputStream opened!")
            default: break
            }
        case NSStreamEvent.HasBytesAvailable:
            guard aStream == inputStream else {
                return
            }
            print("Has bytes!")
            if let stream = inputStream {
                var buffer: UInt8 = 0
                var len: Int! = 0
                while stream.hasBytesAvailable {
                    len = inputStream?.read(&buffer, maxLength: 1024)
                    if len > 0 {
                        if let text = NSString(bytes: &buffer, length: len, encoding: NSASCIIStringEncoding) {
                            print("Server said: \(text)")
                        }
                    }
                }
            }
        case NSStreamEvent.HasSpaceAvailable:
            guard aStream == outputStream else {
                return
            }
            print("Outputstream is ready!")
        case NSStreamEvent.ErrorOccurred:
            print("Can not connect to the host!")
            disconnect()
        case NSStreamEvent.EndEncountered:
            print("Stream closed!")
            disconnect()
        default:
            disconnect()
            print("Unknown event")
        }
    }
}