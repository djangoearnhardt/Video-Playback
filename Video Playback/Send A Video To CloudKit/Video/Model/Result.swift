//
//  Result.swift
//  Send A Video To CloudKit
//
//  Created by Sam LoBue on 6/12/20.
//  Copyright © 2020 DjangoEarnhardt. All rights reserved.
//

import Foundation
import AVFoundation
import CloudKit

extension Video {
    struct Result {
        let name: String
//        let ckRecordReference: CKRecord.Reference
//        let ckRecordID: CKRecord.ID
        // MARK: TODO - GET MODEL IN LINE W/ SOUND ADVICE, SET URL ETC
//        var url: URL?
        var videoAsset: CKAsset?
//        {
//            get {
//                guard let videoURL = url else { return nil }
//                return CKAsset(fileURL: videoURL)
//            }
//            set {
//                url = newValue?.fileURL
//            }
//        }
        
        // MARK: - DESIGNATED INIT
        // A recording needs a name, CKRecord.Reference, CKRecordID, URL, and empty array of comments (to be used later)
        init(name: String, videoAsset: CKAsset) {
            
            self.name = name
            self.videoAsset = videoAsset
//            self.ckRecordReference = ckRecordReference
//            self.ckRecordID = ckRecordID
//            self.url = url
        }
        
        // MARK: - FAILABLE INIT
        // When we grab from the cloud we need to match keys up with values
        init?(record: CKRecord) {
            
            guard let name = record[Constants.nameKey] as? String,
                let videoAsset = record[Constants.videoKey] as? CKAsset else { return nil }
            
            self.init(name: name, videoAsset: videoAsset)
        }
    }
}

// MARK: - CKRecord Convenience Init

/*
 Extend CKRecord. Initialize a Video, then initialize a CKRecord, and pass it directly in.
 let video = Video.Result(name: name, )...
 let ckRecord = CKRecord(record: video)
*/

 extension CKRecord {
    convenience init(video: Video.Result) {
        self.init(recordType: Constants.VideoTypeKey)
        self.setValue(video.name, forKey: Constants.nameKey)
        self.setValue(video.videoAsset, forKey: Constants.videoKey)
    }
}

// MARK: - Equatable
extension Video.Result: Equatable {
    static func == (lhs: Video.Result, rhs: Video.Result) -> Bool {
        guard lhs.name == rhs.name else { return false }
        guard lhs.videoAsset == rhs.videoAsset else { return false }
        return true
    }
}
