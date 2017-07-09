////
////  GameScoreManager.swift
////  Crystal Boom
////
////  Created by per thoresson on 17/01/2017.
////  Copyright © 2017 SAMBAVIKING. All rights reserved.
////
//
//import Foundation
//
//class GameScoreManager {
//    var scores:Array<HighScore> = [];
//    
//    init() {
//        // load existing high scores or set up an empty array
//        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
//        let documentsDirectory = paths[0] as String
//        let path = documentsDirectory.stringByAppendingPathComponent("HighScores.plist")
//        let fileManager = NSFileManager.defaultManager()
//        
//        // check if file exists
//        if !fileManager.fileExistsAtPath(path) {
//            // create an empty file if it doesn't exist
//            if let bundle = NSBundle.mainBundle().pathForResource("DefaultFile", ofType: "plist") {
//                fileManager.copyItemAtPath(bundle, toPath: path, error:nil)
//            }
//        }
//        
//        if let rawData = NSData(contentsOfFile: path) {
//            // do we get serialized data back from the attempted path?
//            // if so, unarchive it into an AnyObject, and then convert to an array of HighScores, if possible
//            var scoreArray: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(rawData);
//            self.scores = scoreArray as? [HighScore] ?? [];
//        }
//    }
//    
//    func save() {
//        // find the save directory our app has permission to use, and save the serialized version of self.scores - the HighScores array.
//        let saveData = NSKeyedArchiver.archivedDataWithRootObject(self.scores);
//        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as NSArray;
//        let documentsDirectory = paths.objectAtIndex(0) as NSString;
//        let path = documentsDirectory.stringByAppendingPathComponent("HighScores.plist");
//        
//        saveData.writeToFile(path, atomically: true);
//    }
//    
//    // a simple function to add a new high score, to be called from your game logic
//    // note that this doesn't sort or filter the scores in any way
//    func addNewScore(newScore:Int) {
//        let newHighScore = HighScore(score: newScore, dateOfScore: NSDate());
//        self.scores.append(newHighScore);
//        self.save();
//    }
//}
