//
//  VideoRecordingController.swift
//  Send A Video To CloudKit
//
//  Created by Sam LoBue on 6/14/20.
//  Copyright © 2020 DjangoEarnhardt. All rights reserved.
//
import Foundation
import AVFoundation
import CloudKit

class VideoRecordingController {
    
    // MARK: - Singleton
    static let sharedInstance = VideoRecordingController()
    
    // MARK: - Properties
    let publicDB = CKContainer.default().publicCloudDatabase
    var videoURL: URL? {
        didSet {
            print(self.videoURL as Any)
        }
    }
    var videos: [Video.Result?] = []
    
    // MARK: - CRUD
    // MARK: - Create
    func save(video: Video.Result, completion: @escaping (Bool) -> Void) {
        let container = CKContainer(identifier: "iCloud.CKVideo")
        let videoCKRecord = CKRecord(video: video)
        // Save the videoCKRecord to the cloud
        container.publicCloudDatabase.save(videoCKRecord) { (videoCKRecord, error) in
//        publicDB.save(videoCKRecord) { (videoCKRecord, error) in
            // Handle the error if there is one
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            // Unwrap the record that we saved
            guard let record = videoCKRecord,
                // Ensure that we can init a Video.Result from that recor
                let savedVideo = Video.Result(record: record)
                else { completion (false); return }
            // Add to our SoT array
            print("Saved video successfully")
            self.videos.insert(savedVideo, at: 0)
            completion(true)
        }
    }
    
        
        // MARK: - Read
        func fetchVideos(completion: @escaping (Bool) -> Void) {
            
            let predicate = NSPredicate(value: true)
            
            let query = CKQuery(recordType: Constants.VideoTypeKey, predicate: predicate)
            
            let queryOperation = CKQueryOperation(query: query)
            queryOperation.queuePriority = .veryHigh
            queryOperation.qualityOfService = .userInteractive
            guard let fastQuery = queryOperation.query else { return }
            
            let container = CKContainer(identifier: "iCloud.CKVideo")
            container.publicCloudDatabase.perform(fastQuery, inZoneWith: nil) { (records, error) in
                if let error = error {
                    print("Error fetching recordings: \(error)")
                    completion(false)
                    return
                }
                
                guard let records = records else { completion(false); return }
                let videos = records.compactMap({ Video.Result(record: $0) })
                self.videos = videos
                print("\(videos.count) VIDEOS SUCCESSFULLY FETCHED")
                completion(true)
            }
        }
        
        // MARK: - Delete
//        func delete(video: Video.Result, completion: @escaping (Bool) -> Void) {
//
//            guard let videoIndex = videos.firstIndex(of: video) else { completion(false); return }
//
//            if videos.contains(video) {
//                videos.remove(at: videoIndex)
//                publicDB.delete(withRecordID: video.ckRecordID) { (_, error) in
//                    if let error = error {
//                        print("Error fetching students: \(error)")
//                        completion(false)
//                        return
//                    }
//                    completion(true)
//                }
//            }
//        }
    }
