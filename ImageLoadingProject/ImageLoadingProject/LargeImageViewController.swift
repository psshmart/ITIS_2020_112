//
//  LargeImageViewController.swift
//  ImageLoadingProject
//
//  Created by Svetlana Safonova on 29.11.2020.
//

import UIKit

class LargeImageViewController: UIViewController, URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        let data = readDonwloadedData(of: location)
        
        setImageToImageView(from: data)
        
        DispatchQueue.main.async {
            if self.progress.progress == 1.0 {
                self.progress.isHidden = true
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let percentDownload = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async {
            print(percentDownload)
            self.progress.progress = percentDownload
        }
    }

    @IBOutlet private var image: UIImageView!
    
    @IBOutlet private var progress: UIProgressView!
        
            
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.contentMode = .scaleAspectFill
        
        DispatchQueue.main.async {
            self.progress.progress = 0.0
        }
        
        let url = "https://www.dropbox.com/s/vylo8edr24nzrcz/Airbus_Pleiades_50cm_8bit_RGB_Yogyakarta.jpg?dl=1"
        if let imgURL = getURLfromString(url) {
            download(from: imgURL)
        }
    }
    
    func download(from url: URL) {
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        
        let downloadTask = session.downloadTask(with: url)
        downloadTask.resume()
    }
    
    func getURLfromString(_ str: String) -> URL? {
        return URL(string: str)
    }

    func readDonwloadedData(of url: URL) -> Data? {
        do {
            let reader = try FileHandle(forReadingFrom: url)
            let data = reader.readDataToEndOfFile()
            
            return data
        } catch {
            print(error)
            return nil
        }
    }
    
    func getIUImageFromData(_ data: Data) -> UIImage? {
        return UIImage(data: data)
    }
    
    func setImageToImageView(from data: Data?) {
        guard let imageData = data else {return}
        guard let image = getIUImageFromData(imageData) else {return}
        
        DispatchQueue.main.async {
            self.image.image = image
        }
    }
}
