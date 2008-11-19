// Copyright 2008 Cyrus Najmabadi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "XmlDocument.h"

@interface XmlDocument()
@property (retain) XmlElement* root;
@property (copy) NSString* version;
@property (copy) NSString* encoding;
@end


@implementation XmlDocument

@synthesize root;
@synthesize version;
@synthesize encoding;

- (void) dealloc {
    self.root = nil;
    self.version = nil;
    self.encoding = nil;
    [super dealloc];
}


+ (XmlDocument*) documentWithRoot:(XmlElement*) root {
    return [[[XmlDocument alloc] initWithRoot:root] autorelease];
}


- (id) initWithRoot:(XmlElement*) root_ {
    return [self initWithRoot:root_ version:@"1.0" encoding:@"UTF-8"];
}


- (id) initWithRoot:(XmlElement*) root_
            version:(NSString*) version_
           encoding:(NSString*) encoding_ {
    if (self = [super init]) {
        self.root = root_;
        self.version = version_;
        self.encoding = encoding_;
    }
    return self;
}

@end