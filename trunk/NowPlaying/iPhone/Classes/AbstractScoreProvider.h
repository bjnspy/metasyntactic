//Copyright 2008 Cyrus Najmabadi
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.

#import "ScoreProvider.h"

@interface AbstractScoreProvider : NSObject<ScoreProvider> {
    ScoreCache* parentCache;
    NSLock* lock;
    
    // Mapping from score title to score.
    NSDictionary* scoresData;
    NSString* hashData;
    
    NSLock* movieMapLock;
    NSArray* movies;
    
    // Mapping from google movie title to score provider title
    NSDictionary* movieMapData;
    
    NSString* reviewsDirectory;
}

@property (assign) ScoreCache* parentCache;
@property (retain) NSLock* lock;
@property (retain) NSDictionary* scoresData;
@property (retain) NSString* hashData;

@property (retain) NSLock* movieMapLock;
@property (retain) NSArray* movies;
@property (retain) NSDictionary* movieMapData;

@property (retain) NSString* reviewsDirectory;

- (id) initWithCache:(ScoreCache*) cache;

@end