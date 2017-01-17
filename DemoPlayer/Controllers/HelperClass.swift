//
//  Helper.swift
//  DemoPlayer
//
//  Created by Chandan Singh on 10/11/16.
//  Copyright © 2016 Chandan Singh. All rights reserved.
//

import Foundation

struct PlayerList {
    var name: String?
    var identifier: String?
    init(name: String, identifier:String) {
        self.name = name
        self.identifier = identifier
    }
}

class PlayerListData {
    func getPlayerList() -> [PlayerList] {
        let player = ["AV Player", "Movie Player", "VLC Player"]
        let storybord = ["avController","mpController","vlcController"]
        var playList = [] as [PlayerList]
        for index in 0...2 {
            let item = PlayerList(name:player[index] ,identifier:storybord[index])
            playList.append(item)
        }
        return playList
    }
}

struct VideoList {
    var heading : String
    var items : [String]
    init(title: String, objects : [String]) {
        heading = title
        items = objects
    }
}

class VideoSectionsData {
   
    /* VLC support video list */
    func getVLCPlayListFArrayFromData() -> [VideoList] {
        var sectionsArray = [VideoList]()
        let DownloadUrl = VideoList(title: "Offline videos", objects: ["trailer_720p.mov"])
        let liveUrl = VideoList(title: "Online videos", objects: ["http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4",
            "http://www.sample-videos.com/video/flv/720/big_buck_bunny_720p_1mb.flv",
            "http://www.sample-videos.com/video/mkv/720/big_buck_bunny_720p_20mb.mkv",
            "http://www.sample-videos.com/video/3gp/144/big_buck_bunny_144p_10mb.3gp","http://trailers.divx.com/divx_prod/profiles/Micayala_DivX1080p_ASP.divx"])
        sectionsArray.append(DownloadUrl)
        sectionsArray.append(liveUrl)
        return sectionsArray
    }
    
    /* AVPlayer support video list */
    func getAVPlayerPlayListArrayFromData() -> [VideoList] {
        var sectionsArray = [VideoList]()
        let DownloadUrl = VideoList(title: "Offline videos", objects: ["trailer_720p.mov"])
        let liveUrl = VideoList(title: "Online videos", objects: ["http://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4"])
        sectionsArray.append(DownloadUrl)
        sectionsArray.append(liveUrl)
        return sectionsArray
    }
}