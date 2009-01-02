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

#import "MetaFlix.pb.h"

@implementation MetaFlixRoot
static PBFileDescriptor* descriptor = nil;
static PBDescriptor* internal_static_ShowtimeProto_descriptor = nil;
static PBFieldAccessorTable* internal_static_ShowtimeProto_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_ShowtimeProto_descriptor {
  return internal_static_ShowtimeProto_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_ShowtimeProto_fieldAccessorTable {
  return internal_static_ShowtimeProto_fieldAccessorTable;
}
static PBDescriptor* internal_static_AllShowtimesProto_descriptor = nil;
static PBFieldAccessorTable* internal_static_AllShowtimesProto_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_AllShowtimesProto_descriptor {
  return internal_static_AllShowtimesProto_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_AllShowtimesProto_fieldAccessorTable {
  return internal_static_AllShowtimesProto_fieldAccessorTable;
}
static PBDescriptor* internal_static_MovieProto_descriptor = nil;
static PBFieldAccessorTable* internal_static_MovieProto_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_MovieProto_descriptor {
  return internal_static_MovieProto_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_MovieProto_fieldAccessorTable {
  return internal_static_MovieProto_fieldAccessorTable;
}
static PBDescriptor* internal_static_TheaterProto_descriptor = nil;
static PBFieldAccessorTable* internal_static_TheaterProto_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_TheaterProto_descriptor {
  return internal_static_TheaterProto_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_TheaterProto_fieldAccessorTable {
  return internal_static_TheaterProto_fieldAccessorTable;
}
static PBDescriptor* internal_static_TheaterListingsProto_descriptor = nil;
static PBFieldAccessorTable* internal_static_TheaterListingsProto_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_TheaterListingsProto_descriptor {
  return internal_static_TheaterListingsProto_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_TheaterListingsProto_fieldAccessorTable {
  return internal_static_TheaterListingsProto_fieldAccessorTable;
}
static PBDescriptor* internal_static_TheaterListingsProto_TheaterAndMovieShowtimesProto_descriptor = nil;
static PBFieldAccessorTable* internal_static_TheaterListingsProto_TheaterAndMovieShowtimesProto_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_TheaterListingsProto_TheaterAndMovieShowtimesProto_descriptor {
  return internal_static_TheaterListingsProto_TheaterAndMovieShowtimesProto_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_TheaterListingsProto_TheaterAndMovieShowtimesProto_fieldAccessorTable {
  return internal_static_TheaterListingsProto_TheaterAndMovieShowtimesProto_fieldAccessorTable;
}
static PBDescriptor* internal_static_TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_descriptor = nil;
static PBFieldAccessorTable* internal_static_TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_descriptor {
  return internal_static_TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_fieldAccessorTable {
  return internal_static_TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_fieldAccessorTable;
}
static PBDescriptor* internal_static_ReviewProto_descriptor = nil;
static PBFieldAccessorTable* internal_static_ReviewProto_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_ReviewProto_descriptor {
  return internal_static_ReviewProto_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_ReviewProto_fieldAccessorTable {
  return internal_static_ReviewProto_fieldAccessorTable;
}
static PBDescriptor* internal_static_ReviewsListProto_descriptor = nil;
static PBFieldAccessorTable* internal_static_ReviewsListProto_fieldAccessorTable = nil;
+ (PBDescriptor*) internal_static_ReviewsListProto_descriptor {
  return internal_static_ReviewsListProto_descriptor;
}
+ (PBFieldAccessorTable*) internal_static_ReviewsListProto_fieldAccessorTable {
  return internal_static_ReviewsListProto_fieldAccessorTable;
}
+ (void) initialize {
  if (self == [MetaFlixRoot class]) {
    descriptor = [[MetaFlixRoot buildDescriptor] retain];
    internal_static_ShowtimeProto_descriptor = [[[self descriptor].messageTypes objectAtIndex:0] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"Time", @"Url", @"Dubbed", @"Subtitled", nil];
      internal_static_ShowtimeProto_fieldAccessorTable =
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_ShowtimeProto_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[ShowtimeProto class]
                                      builderClass:[ShowtimeProto_Builder class]] retain];
    }
    internal_static_AllShowtimesProto_descriptor = [[[self descriptor].messageTypes objectAtIndex:1] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"Showtimes", @"Vendor", @"Captioning", nil];
      internal_static_AllShowtimesProto_fieldAccessorTable =
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_AllShowtimesProto_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[AllShowtimesProto class]
                                      builderClass:[AllShowtimesProto_Builder class]] retain];
    }
    internal_static_MovieProto_descriptor = [[[self descriptor].messageTypes objectAtIndex:2] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"Identifier", @"Title", @"Length", @"Language", @"Genre", @"Description", @"RawRating", @"Score", @"IMDbUrl", @"Director", @"Cast", @"Dubbed", @"Subtitled", @"ReleaseDate", nil];
      internal_static_MovieProto_fieldAccessorTable =
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_MovieProto_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[MovieProto class]
                                      builderClass:[MovieProto_Builder class]] retain];
    }
    internal_static_TheaterProto_descriptor = [[[self descriptor].messageTypes objectAtIndex:3] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"Identifier", @"Name", @"StreetAddress", @"City", @"State", @"PostalCode", @"Country", @"Phone", @"Latitude", @"Longitude", nil];
      internal_static_TheaterProto_fieldAccessorTable =
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_TheaterProto_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[TheaterProto class]
                                      builderClass:[TheaterProto_Builder class]] retain];
    }
    internal_static_TheaterListingsProto_descriptor = [[[self descriptor].messageTypes objectAtIndex:4] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"Movies", @"TheaterAndMovieShowtimes", nil];
      internal_static_TheaterListingsProto_fieldAccessorTable =
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_TheaterListingsProto_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[TheaterListingsProto class]
                                      builderClass:[TheaterListingsProto_Builder class]] retain];
    }
    internal_static_TheaterListingsProto_TheaterAndMovieShowtimesProto_descriptor = [[[internal_static_TheaterListingsProto_descriptor nestedTypes] objectAtIndex:0] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"Theater", @"MovieAndShowtimes", nil];
      internal_static_TheaterListingsProto_TheaterAndMovieShowtimesProto_fieldAccessorTable =
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_TheaterListingsProto_TheaterAndMovieShowtimesProto_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[TheaterListingsProto_TheaterAndMovieShowtimesProto class]
                                      builderClass:[TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder class]] retain];
    }
    internal_static_TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_descriptor = [[[internal_static_TheaterListingsProto_TheaterAndMovieShowtimesProto_descriptor nestedTypes] objectAtIndex:0] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"MovieIdentifier", @"Showtimes", nil];
      internal_static_TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_fieldAccessorTable =
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto class]
                                      builderClass:[TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder class]] retain];
    }
    internal_static_ReviewProto_descriptor = [[[self descriptor].messageTypes objectAtIndex:5] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"Title", @"Url", @"Rating", @"Snippet", @"Content", @"Publisher", @"Author", @"Date", nil];
      internal_static_ReviewProto_fieldAccessorTable =
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_ReviewProto_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[ReviewProto class]
                                      builderClass:[ReviewProto_Builder class]] retain];
    }
    internal_static_ReviewsListProto_descriptor = [[[self descriptor].messageTypes objectAtIndex:6] retain];
    {
      NSArray* fieldNames = [NSArray arrayWithObjects:@"Reviews", nil];
      internal_static_ReviewsListProto_fieldAccessorTable =
        [[PBFieldAccessorTable tableWithDescriptor:internal_static_ReviewsListProto_descriptor
                                        fieldNames:fieldNames
                                      messageClass:[ReviewsListProto class]
                                      builderClass:[ReviewsListProto_Builder class]] retain];
    }
  }
}
+ (PBFileDescriptor*) descriptor {
  return descriptor;
}
+ (PBFileDescriptor*) buildDescriptor {
  static uint8_t descriptorData[] = {
    10,16,78,111,119,80,108,97,121,105,110,103,46,112,114,111,116,111,34,77,
    10,13,83,104,111,119,116,105,109,101,80,114,111,116,111,18,12,10,4,84,105,
    109,101,24,1,32,2,40,9,18,11,10,3,85,114,108,24,2,32,1,40,9,18,14,10,6,
    68,117,98,98,101,100,24,3,32,3,40,9,18,17,10,9,83,117,98,116,105,116,108,
    101,100,24,4,32,3,40,9,34,90,10,17,65,108,108,83,104,111,119,116,105,109,
    101,115,80,114,111,116,111,18,33,10,9,83,104,111,119,116,105,109,101,115,
    24,1,32,3,40,11,50,14,46,83,104,111,119,116,105,109,101,80,114,111,116,
    111,18,14,10,6,86,101,110,100,111,114,24,2,32,1,40,9,18,18,10,10,67,97,
    112,116,105,111,110,105,110,103,24,3,32,1,40,9,34,128,2,10,10,77,111,118,
    105,101,80,114,111,116,111,18,18,10,10,73,100,101,110,116,105,102,105,101,
    114,24,1,32,1,40,9,18,13,10,5,84,105,116,108,101,24,2,32,1,40,9,18,14,10,
    6,76,101,110,103,116,104,24,3,32,1,40,5,18,16,10,8,76,97,110,103,117,97,
    103,101,24,4,32,1,40,9,18,13,10,5,71,101,110,114,101,24,5,32,1,40,9,18,
    19,10,11,68,101,115,99,114,105,112,116,105,111,110,24,6,32,1,40,9,18,17,
    10,9,82,97,119,82,97,116,105,110,103,24,8,32,1,40,9,18,13,10,5,83,99,111,
    114,101,24,9,32,1,40,5,18,15,10,7,73,77,68,98,85,114,108,24,10,32,1,40,
    9,18,16,10,8,68,105,114,101,99,116,111,114,24,11,32,3,40,9,18,12,10,4,67,
    97,115,116,24,12,32,3,40,9,18,14,10,6,68,117,98,98,101,100,24,13,32,3,40,
    9,18,17,10,9,83,117,98,116,105,116,108,101,100,24,14,32,3,40,9,18,19,10,
    11,82,101,108,101,97,115,101,68,97,116,101,24,15,32,1,40,9,34,189,1,10,
    12,84,104,101,97,116,101,114,80,114,111,116,111,18,18,10,10,73,100,101,
    110,116,105,102,105,101,114,24,1,32,1,40,9,18,12,10,4,78,97,109,101,24,
    2,32,1,40,9,18,21,10,13,83,116,114,101,101,116,65,100,100,114,101,115,115,
    24,3,32,1,40,9,18,12,10,4,67,105,116,121,24,4,32,1,40,9,18,13,10,5,83,116,
    97,116,101,24,5,32,1,40,9,18,18,10,10,80,111,115,116,97,108,67,111,100,
    101,24,6,32,1,40,9,18,15,10,7,67,111,117,110,116,114,121,24,7,32,1,40,9,
    18,13,10,5,80,104,111,110,101,24,8,32,1,40,9,18,16,10,8,76,97,116,105,116,
    117,100,101,24,9,32,1,40,1,18,17,10,9,76,111,110,103,105,116,117,100,101,
    24,10,32,1,40,1,34,141,3,10,20,84,104,101,97,116,101,114,76,105,115,116,
    105,110,103,115,80,114,111,116,111,18,27,10,6,77,111,118,105,101,115,24,
    5,32,3,40,11,50,11,46,77,111,118,105,101,80,114,111,116,111,18,85,10,24,
    84,104,101,97,116,101,114,65,110,100,77,111,118,105,101,83,104,111,119,
    116,105,109,101,115,24,6,32,3,40,11,50,51,46,84,104,101,97,116,101,114,
    76,105,115,116,105,110,103,115,80,114,111,116,111,46,84,104,101,97,116,
    101,114,65,110,100,77,111,118,105,101,83,104,111,119,116,105,109,101,115,
    80,114,111,116,111,26,128,2,10,29,84,104,101,97,116,101,114,65,110,100,
    77,111,118,105,101,83,104,111,119,116,105,109,101,115,80,114,111,116,111,
    18,30,10,7,84,104,101,97,116,101,114,24,3,32,2,40,11,50,13,46,84,104,101,
    97,116,101,114,80,114,111,116,111,18,101,10,17,77,111,118,105,101,65,110,
    100,83,104,111,119,116,105,109,101,115,24,4,32,3,40,11,50,74,46,84,104,
    101,97,116,101,114,76,105,115,116,105,110,103,115,80,114,111,116,111,46,
    84,104,101,97,116,101,114,65,110,100,77,111,118,105,101,83,104,111,119,
    116,105,109,101,115,80,114,111,116,111,46,77,111,118,105,101,65,110,100,
    83,104,111,119,116,105,109,101,115,80,114,111,116,111,26,88,10,22,77,111,
    118,105,101,65,110,100,83,104,111,119,116,105,109,101,115,80,114,111,116,
    111,18,23,10,15,77,111,118,105,101,73,100,101,110,116,105,102,105,101,114,
    24,1,32,2,40,9,18,37,10,9,83,104,111,119,116,105,109,101,115,24,2,32,2,
    40,11,50,18,46,65,108,108,83,104,111,119,116,105,109,101,115,80,114,111,
    116,111,34,140,1,10,11,82,101,118,105,101,119,80,114,111,116,111,18,13,
    10,5,84,105,116,108,101,24,1,32,1,40,9,18,11,10,3,85,114,108,24,2,32,1,
    40,9,18,14,10,6,82,97,116,105,110,103,24,3,32,1,40,2,18,15,10,7,83,110,
    105,112,112,101,116,24,4,32,1,40,9,18,15,10,7,67,111,110,116,101,110,116,
    24,5,32,1,40,9,18,17,10,9,80,117,98,108,105,115,104,101,114,24,6,32,1,40,
    9,18,14,10,6,65,117,116,104,111,114,24,7,32,1,40,9,18,12,10,4,68,97,116,
    101,24,8,32,1,40,9,34,49,10,16,82,101,118,105,101,119,115,76,105,115,116,
    80,114,111,116,111,18,29,10,7,114,101,118,105,101,119,115,24,1,32,3,40,
    11,50,12,46,82,101,118,105,101,119,80,114,111,116,111,
  };
  NSArray* dependencies = [NSArray arrayWithObjects:nil];

  NSData* data = [NSData dataWithBytes:descriptorData length:1234];
  PBFileDescriptorProto* proto = [PBFileDescriptorProto parseFromData:data];
  return [PBFileDescriptor buildFrom:proto dependencies:dependencies];
}
@end

@interface ShowtimeProto ()
@property (retain) NSString* time;
@property (retain) NSString* url;
@property (retain) NSMutableArray* mutableDubbedList;
@property (retain) NSMutableArray* mutableSubtitledList;
@end

@implementation ShowtimeProto

- (BOOL) hasTime {
  return hasTime != 0;
}
- (void) setHasTime:(BOOL) hasTime_ {
  hasTime = (hasTime_ != 0);
}
@synthesize time;
- (BOOL) hasUrl {
  return hasUrl != 0;
}
- (void) setHasUrl:(BOOL) hasUrl_ {
  hasUrl = (hasUrl_ != 0);
}
@synthesize url;
@synthesize mutableDubbedList;
@synthesize mutableSubtitledList;
- (void) dealloc {
  self.time = nil;
  self.url = nil;
  self.mutableDubbedList = nil;
  self.mutableSubtitledList = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.time = @"";
    self.url = @"";
  }
  return self;
}
static ShowtimeProto* defaultShowtimeProtoInstance = nil;
+ (void) initialize {
  if (self == [ShowtimeProto class]) {
    defaultShowtimeProtoInstance = [[ShowtimeProto alloc] init];
  }
}
+ (ShowtimeProto*) defaultInstance {
  return defaultShowtimeProtoInstance;
}
- (ShowtimeProto*) defaultInstance {
  return defaultShowtimeProtoInstance;
}
- (PBDescriptor*) descriptor {
  return [ShowtimeProto descriptor];
}
+ (PBDescriptor*) descriptor {
  return [MetaFlixRoot internal_static_ShowtimeProto_descriptor];
}
- (PBFieldAccessorTable*) fieldAccessorTable {
  return [MetaFlixRoot internal_static_ShowtimeProto_fieldAccessorTable];
}
- (NSArray*) dubbedList {
  return mutableDubbedList;
}
- (NSString*) dubbedAtIndex:(int32_t) index {
  id value = [mutableDubbedList objectAtIndex:index];
  return value;
}
- (NSArray*) subtitledList {
  return mutableSubtitledList;
}
- (NSString*) subtitledAtIndex:(int32_t) index {
  id value = [mutableSubtitledList objectAtIndex:index];
  return value;
}
- (BOOL) isInitialized {
  if (!hasTime) {
    return NO;
  }
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasTime) {
    [output writeString:1 value:self.time];
  }
  if (hasUrl) {
    [output writeString:2 value:self.url];
  }
  for (NSString* element in self.mutableDubbedList) {
    [output writeString:3 value:element];
  }
  for (NSString* element in self.mutableSubtitledList) {
    [output writeString:4 value:element];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (hasTime) {
    size += computeStringSize(1, self.time);
  }
  if (hasUrl) {
    size += computeStringSize(2, self.url);
  }
  for (NSString* element in self.mutableDubbedList) {
    size += computeStringSize(3, element);
  }
  for (NSString* element in self.mutableSubtitledList) {
    size += computeStringSize(4, element);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (ShowtimeProto*) parseFromData:(NSData*) data {
  return (ShowtimeProto*)[[[ShowtimeProto builder] mergeFromData:data] build];
}
+ (ShowtimeProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (ShowtimeProto*)[[[ShowtimeProto builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (ShowtimeProto*) parseFromInputStream:(NSInputStream*) input {
  return (ShowtimeProto*)[[[ShowtimeProto builder] mergeFromInputStream:input] build];
}
+ (ShowtimeProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (ShowtimeProto*)[[[ShowtimeProto builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (ShowtimeProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (ShowtimeProto*)[[[ShowtimeProto builder] mergeFromCodedInputStream:input] build];
}
+ (ShowtimeProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (ShowtimeProto*)[[[ShowtimeProto builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (ShowtimeProto_Builder*) builder {
  return [[[ShowtimeProto_Builder alloc] init] autorelease];
}
+ (ShowtimeProto_Builder*) builderWithPrototype:(ShowtimeProto*) prototype {
  return [[ShowtimeProto builder] mergeFromShowtimeProto:prototype];
}
- (ShowtimeProto_Builder*) builder {
  return [ShowtimeProto builder];
}
@end

@interface ShowtimeProto_Builder()
@property (retain) ShowtimeProto* result;
@end

@implementation ShowtimeProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[ShowtimeProto alloc] init] autorelease];
  }
  return self;
}
- (ShowtimeProto*) internalGetResult {
  return result;
}
- (ShowtimeProto_Builder*) clear {
  self.result = [[[ShowtimeProto alloc] init] autorelease];
  return self;
}
- (ShowtimeProto_Builder*) clone {
  return [ShowtimeProto builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [ShowtimeProto descriptor];
}
- (ShowtimeProto*) defaultInstance {
  return [ShowtimeProto defaultInstance];
}
- (ShowtimeProto*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (ShowtimeProto*) buildPartial {
  ShowtimeProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (ShowtimeProto_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[ShowtimeProto class]]) {
    return [self mergeFromShowtimeProto:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (ShowtimeProto_Builder*) mergeFromShowtimeProto:(ShowtimeProto*) other {
  if (other == [ShowtimeProto defaultInstance]) {
    return self;
  }
  if (other.hasTime) {
    [self setTime:other.time];
  }
  if (other.hasUrl) {
    [self setUrl:other.url];
  }
  if (other.mutableDubbedList.count > 0) {
    if (result.mutableDubbedList == nil) {
      result.mutableDubbedList = [NSMutableArray array];
    }
    [result.mutableDubbedList addObjectsFromArray:other.mutableDubbedList];
  }
  if (other.mutableSubtitledList.count > 0) {
    if (result.mutableSubtitledList == nil) {
      result.mutableSubtitledList = [NSMutableArray array];
    }
    [result.mutableSubtitledList addObjectsFromArray:other.mutableSubtitledList];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (ShowtimeProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (ShowtimeProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        [self setTime:[input readString]];
        break;
      }
      case 18: {
        [self setUrl:[input readString]];
        break;
      }
      case 26: {
        [self addDubbed:[input readString]];
        break;
      }
      case 34: {
        [self addSubtitled:[input readString]];
        break;
      }
    }
  }
}
- (BOOL) hasTime {
  return result.hasTime;
}
- (NSString*) time {
  return result.time;
}
- (ShowtimeProto_Builder*) setTime:(NSString*) value {
  result.hasTime = YES;
  result.time = value;
  return self;
}
- (ShowtimeProto_Builder*) clearTime {
  result.hasTime = NO;
  result.time = @"";
  return self;
}
- (BOOL) hasUrl {
  return result.hasUrl;
}
- (NSString*) url {
  return result.url;
}
- (ShowtimeProto_Builder*) setUrl:(NSString*) value {
  result.hasUrl = YES;
  result.url = value;
  return self;
}
- (ShowtimeProto_Builder*) clearUrl {
  result.hasUrl = NO;
  result.url = @"";
  return self;
}
- (NSArray*) dubbedList {
  if (result.mutableDubbedList == nil) {
    return [NSArray array];
  }
  return result.mutableDubbedList;
}
- (NSString*) dubbedAtIndex:(int32_t) index {
  return [result dubbedAtIndex:index];
}
- (ShowtimeProto_Builder*) replaceDubbedAtIndex:(int32_t) index with:(NSString*) value {
  [result.mutableDubbedList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (ShowtimeProto_Builder*) addDubbed:(NSString*) value {
  if (result.mutableDubbedList == nil) {
    result.mutableDubbedList = [NSMutableArray array];
  }
  [result.mutableDubbedList addObject:value];
  return self;
}
- (ShowtimeProto_Builder*) addAllDubbed:(NSArray*) values {
  if (result.mutableDubbedList == nil) {
    result.mutableDubbedList = [NSMutableArray array];
  }
  [result.mutableDubbedList addObjectsFromArray:values];
  return self;
}
- (ShowtimeProto_Builder*) clearDubbedList {
  result.mutableDubbedList = nil;
  return self;
}
- (NSArray*) subtitledList {
  if (result.mutableSubtitledList == nil) {
    return [NSArray array];
  }
  return result.mutableSubtitledList;
}
- (NSString*) subtitledAtIndex:(int32_t) index {
  return [result subtitledAtIndex:index];
}
- (ShowtimeProto_Builder*) replaceSubtitledAtIndex:(int32_t) index with:(NSString*) value {
  [result.mutableSubtitledList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (ShowtimeProto_Builder*) addSubtitled:(NSString*) value {
  if (result.mutableSubtitledList == nil) {
    result.mutableSubtitledList = [NSMutableArray array];
  }
  [result.mutableSubtitledList addObject:value];
  return self;
}
- (ShowtimeProto_Builder*) addAllSubtitled:(NSArray*) values {
  if (result.mutableSubtitledList == nil) {
    result.mutableSubtitledList = [NSMutableArray array];
  }
  [result.mutableSubtitledList addObjectsFromArray:values];
  return self;
}
- (ShowtimeProto_Builder*) clearSubtitledList {
  result.mutableSubtitledList = nil;
  return self;
}
@end

@interface AllShowtimesProto ()
@property (retain) NSMutableArray* mutableShowtimesList;
@property (retain) NSString* vendor;
@property (retain) NSString* captioning;
@end

@implementation AllShowtimesProto

@synthesize mutableShowtimesList;
- (BOOL) hasVendor {
  return hasVendor != 0;
}
- (void) setHasVendor:(BOOL) hasVendor_ {
  hasVendor = (hasVendor_ != 0);
}
@synthesize vendor;
- (BOOL) hasCaptioning {
  return hasCaptioning != 0;
}
- (void) setHasCaptioning:(BOOL) hasCaptioning_ {
  hasCaptioning = (hasCaptioning_ != 0);
}
@synthesize captioning;
- (void) dealloc {
  self.mutableShowtimesList = nil;
  self.vendor = nil;
  self.captioning = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.vendor = @"";
    self.captioning = @"";
  }
  return self;
}
static AllShowtimesProto* defaultAllShowtimesProtoInstance = nil;
+ (void) initialize {
  if (self == [AllShowtimesProto class]) {
    defaultAllShowtimesProtoInstance = [[AllShowtimesProto alloc] init];
  }
}
+ (AllShowtimesProto*) defaultInstance {
  return defaultAllShowtimesProtoInstance;
}
- (AllShowtimesProto*) defaultInstance {
  return defaultAllShowtimesProtoInstance;
}
- (PBDescriptor*) descriptor {
  return [AllShowtimesProto descriptor];
}
+ (PBDescriptor*) descriptor {
  return [MetaFlixRoot internal_static_AllShowtimesProto_descriptor];
}
- (PBFieldAccessorTable*) fieldAccessorTable {
  return [MetaFlixRoot internal_static_AllShowtimesProto_fieldAccessorTable];
}
- (NSArray*) showtimesList {
  return mutableShowtimesList;
}
- (ShowtimeProto*) showtimesAtIndex:(int32_t) index {
  id value = [mutableShowtimesList objectAtIndex:index];
  return value;
}
- (BOOL) isInitialized {
  for (ShowtimeProto* element in self.showtimesList) {
    if (!element.isInitialized) {
      return NO;
    }
  }
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  for (ShowtimeProto* element in self.showtimesList) {
    [output writeMessage:1 value:element];
  }
  if (hasVendor) {
    [output writeString:2 value:self.vendor];
  }
  if (hasCaptioning) {
    [output writeString:3 value:self.captioning];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  for (ShowtimeProto* element in self.showtimesList) {
    size += computeMessageSize(1, element);
  }
  if (hasVendor) {
    size += computeStringSize(2, self.vendor);
  }
  if (hasCaptioning) {
    size += computeStringSize(3, self.captioning);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (AllShowtimesProto*) parseFromData:(NSData*) data {
  return (AllShowtimesProto*)[[[AllShowtimesProto builder] mergeFromData:data] build];
}
+ (AllShowtimesProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (AllShowtimesProto*)[[[AllShowtimesProto builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (AllShowtimesProto*) parseFromInputStream:(NSInputStream*) input {
  return (AllShowtimesProto*)[[[AllShowtimesProto builder] mergeFromInputStream:input] build];
}
+ (AllShowtimesProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (AllShowtimesProto*)[[[AllShowtimesProto builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (AllShowtimesProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (AllShowtimesProto*)[[[AllShowtimesProto builder] mergeFromCodedInputStream:input] build];
}
+ (AllShowtimesProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (AllShowtimesProto*)[[[AllShowtimesProto builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (AllShowtimesProto_Builder*) builder {
  return [[[AllShowtimesProto_Builder alloc] init] autorelease];
}
+ (AllShowtimesProto_Builder*) builderWithPrototype:(AllShowtimesProto*) prototype {
  return [[AllShowtimesProto builder] mergeFromAllShowtimesProto:prototype];
}
- (AllShowtimesProto_Builder*) builder {
  return [AllShowtimesProto builder];
}
@end

@interface AllShowtimesProto_Builder()
@property (retain) AllShowtimesProto* result;
@end

@implementation AllShowtimesProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[AllShowtimesProto alloc] init] autorelease];
  }
  return self;
}
- (AllShowtimesProto*) internalGetResult {
  return result;
}
- (AllShowtimesProto_Builder*) clear {
  self.result = [[[AllShowtimesProto alloc] init] autorelease];
  return self;
}
- (AllShowtimesProto_Builder*) clone {
  return [AllShowtimesProto builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [AllShowtimesProto descriptor];
}
- (AllShowtimesProto*) defaultInstance {
  return [AllShowtimesProto defaultInstance];
}
- (AllShowtimesProto*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (AllShowtimesProto*) buildPartial {
  AllShowtimesProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (AllShowtimesProto_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[AllShowtimesProto class]]) {
    return [self mergeFromAllShowtimesProto:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (AllShowtimesProto_Builder*) mergeFromAllShowtimesProto:(AllShowtimesProto*) other {
  if (other == [AllShowtimesProto defaultInstance]) {
    return self;
  }
  if (other.mutableShowtimesList.count > 0) {
    if (result.mutableShowtimesList == nil) {
      result.mutableShowtimesList = [NSMutableArray array];
    }
    [result.mutableShowtimesList addObjectsFromArray:other.mutableShowtimesList];
  }
  if (other.hasVendor) {
    [self setVendor:other.vendor];
  }
  if (other.hasCaptioning) {
    [self setCaptioning:other.captioning];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (AllShowtimesProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (AllShowtimesProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        ShowtimeProto_Builder* subBuilder = [ShowtimeProto builder];
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self addShowtimes:[subBuilder buildPartial]];
        break;
      }
      case 18: {
        [self setVendor:[input readString]];
        break;
      }
      case 26: {
        [self setCaptioning:[input readString]];
        break;
      }
    }
  }
}
- (NSArray*) showtimesList {
  if (result.mutableShowtimesList == nil) { return [NSArray array]; }
  return result.mutableShowtimesList;
}
- (ShowtimeProto*) showtimesAtIndex:(int32_t) index {
  return [result showtimesAtIndex:index];
}
- (AllShowtimesProto_Builder*) replaceShowtimesAtIndex:(int32_t) index with:(ShowtimeProto*) value {
  [result.mutableShowtimesList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (AllShowtimesProto_Builder*) addAllShowtimes:(NSArray*) values {
  if (result.mutableShowtimesList == nil) {
    result.mutableShowtimesList = [NSMutableArray array];
  }
  [result.mutableShowtimesList addObjectsFromArray:values];
  return self;
}
- (AllShowtimesProto_Builder*) clearShowtimesList {
  result.mutableShowtimesList = nil;
  return self;
}
- (AllShowtimesProto_Builder*) addShowtimes:(ShowtimeProto*) value {
  if (result.mutableShowtimesList == nil) {
    result.mutableShowtimesList = [NSMutableArray array];
  }
  [result.mutableShowtimesList addObject:value];
  return self;
}
- (BOOL) hasVendor {
  return result.hasVendor;
}
- (NSString*) vendor {
  return result.vendor;
}
- (AllShowtimesProto_Builder*) setVendor:(NSString*) value {
  result.hasVendor = YES;
  result.vendor = value;
  return self;
}
- (AllShowtimesProto_Builder*) clearVendor {
  result.hasVendor = NO;
  result.vendor = @"";
  return self;
}
- (BOOL) hasCaptioning {
  return result.hasCaptioning;
}
- (NSString*) captioning {
  return result.captioning;
}
- (AllShowtimesProto_Builder*) setCaptioning:(NSString*) value {
  result.hasCaptioning = YES;
  result.captioning = value;
  return self;
}
- (AllShowtimesProto_Builder*) clearCaptioning {
  result.hasCaptioning = NO;
  result.captioning = @"";
  return self;
}
@end

@interface MovieProto ()
@property (retain) NSString* identifier;
@property (retain) NSString* title;
@property int32_t length;
@property (retain) NSString* language;
@property (retain) NSString* genre;
@property (retain) NSString* description;
@property (retain) NSString* rawRating;
@property int32_t score;
@property (retain) NSString* iMDbUrl;
@property (retain) NSMutableArray* mutableDirectorList;
@property (retain) NSMutableArray* mutableCastList;
@property (retain) NSMutableArray* mutableDubbedList;
@property (retain) NSMutableArray* mutableSubtitledList;
@property (retain) NSString* releaseDate;
@end

@implementation MovieProto

- (BOOL) hasIdentifier {
  return hasIdentifier != 0;
}
- (void) setHasIdentifier:(BOOL) hasIdentifier_ {
  hasIdentifier = (hasIdentifier_ != 0);
}
@synthesize identifier;
- (BOOL) hasTitle {
  return hasTitle != 0;
}
- (void) setHasTitle:(BOOL) hasTitle_ {
  hasTitle = (hasTitle_ != 0);
}
@synthesize title;
- (BOOL) hasLength {
  return hasLength != 0;
}
- (void) setHasLength:(BOOL) hasLength_ {
  hasLength = (hasLength_ != 0);
}
@synthesize length;
- (BOOL) hasLanguage {
  return hasLanguage != 0;
}
- (void) setHasLanguage:(BOOL) hasLanguage_ {
  hasLanguage = (hasLanguage_ != 0);
}
@synthesize language;
- (BOOL) hasGenre {
  return hasGenre != 0;
}
- (void) setHasGenre:(BOOL) hasGenre_ {
  hasGenre = (hasGenre_ != 0);
}
@synthesize genre;
- (BOOL) hasDescription {
  return hasDescription != 0;
}
- (void) setHasDescription:(BOOL) hasDescription_ {
  hasDescription = (hasDescription_ != 0);
}
@synthesize description;
- (BOOL) hasRawRating {
  return hasRawRating != 0;
}
- (void) setHasRawRating:(BOOL) hasRawRating_ {
  hasRawRating = (hasRawRating_ != 0);
}
@synthesize rawRating;
- (BOOL) hasScore {
  return hasScore != 0;
}
- (void) setHasScore:(BOOL) hasScore_ {
  hasScore = (hasScore_ != 0);
}
@synthesize score;
- (BOOL) hasIMDbUrl {
  return hasIMDbUrl != 0;
}
- (void) setHasIMDbUrl:(BOOL) hasIMDbUrl_ {
  hasIMDbUrl = (hasIMDbUrl_ != 0);
}
@synthesize iMDbUrl;
@synthesize mutableDirectorList;
@synthesize mutableCastList;
@synthesize mutableDubbedList;
@synthesize mutableSubtitledList;
- (BOOL) hasReleaseDate {
  return hasReleaseDate != 0;
}
- (void) setHasReleaseDate:(BOOL) hasReleaseDate_ {
  hasReleaseDate = (hasReleaseDate_ != 0);
}
@synthesize releaseDate;
- (void) dealloc {
  self.identifier = nil;
  self.title = nil;
  self.language = nil;
  self.genre = nil;
  self.description = nil;
  self.rawRating = nil;
  self.iMDbUrl = nil;
  self.mutableDirectorList = nil;
  self.mutableCastList = nil;
  self.mutableDubbedList = nil;
  self.mutableSubtitledList = nil;
  self.releaseDate = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.identifier = @"";
    self.title = @"";
    self.length = 0;
    self.language = @"";
    self.genre = @"";
    self.description = @"";
    self.rawRating = @"";
    self.score = 0;
    self.iMDbUrl = @"";
    self.releaseDate = @"";
  }
  return self;
}
static MovieProto* defaultMovieProtoInstance = nil;
+ (void) initialize {
  if (self == [MovieProto class]) {
    defaultMovieProtoInstance = [[MovieProto alloc] init];
  }
}
+ (MovieProto*) defaultInstance {
  return defaultMovieProtoInstance;
}
- (MovieProto*) defaultInstance {
  return defaultMovieProtoInstance;
}
- (PBDescriptor*) descriptor {
  return [MovieProto descriptor];
}
+ (PBDescriptor*) descriptor {
  return [MetaFlixRoot internal_static_MovieProto_descriptor];
}
- (PBFieldAccessorTable*) fieldAccessorTable {
  return [MetaFlixRoot internal_static_MovieProto_fieldAccessorTable];
}
- (NSArray*) directorList {
  return mutableDirectorList;
}
- (NSString*) directorAtIndex:(int32_t) index {
  id value = [mutableDirectorList objectAtIndex:index];
  return value;
}
- (NSArray*) castList {
  return mutableCastList;
}
- (NSString*) castAtIndex:(int32_t) index {
  id value = [mutableCastList objectAtIndex:index];
  return value;
}
- (NSArray*) dubbedList {
  return mutableDubbedList;
}
- (NSString*) dubbedAtIndex:(int32_t) index {
  id value = [mutableDubbedList objectAtIndex:index];
  return value;
}
- (NSArray*) subtitledList {
  return mutableSubtitledList;
}
- (NSString*) subtitledAtIndex:(int32_t) index {
  id value = [mutableSubtitledList objectAtIndex:index];
  return value;
}
- (BOOL) isInitialized {
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasIdentifier) {
    [output writeString:1 value:self.identifier];
  }
  if (hasTitle) {
    [output writeString:2 value:self.title];
  }
  if (hasLength) {
    [output writeInt32:3 value:self.length];
  }
  if (hasLanguage) {
    [output writeString:4 value:self.language];
  }
  if (hasGenre) {
    [output writeString:5 value:self.genre];
  }
  if (hasDescription) {
    [output writeString:6 value:self.description];
  }
  if (hasRawRating) {
    [output writeString:8 value:self.rawRating];
  }
  if (hasScore) {
    [output writeInt32:9 value:self.score];
  }
  if (hasIMDbUrl) {
    [output writeString:10 value:self.iMDbUrl];
  }
  for (NSString* element in self.mutableDirectorList) {
    [output writeString:11 value:element];
  }
  for (NSString* element in self.mutableCastList) {
    [output writeString:12 value:element];
  }
  for (NSString* element in self.mutableDubbedList) {
    [output writeString:13 value:element];
  }
  for (NSString* element in self.mutableSubtitledList) {
    [output writeString:14 value:element];
  }
  if (hasReleaseDate) {
    [output writeString:15 value:self.releaseDate];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (hasIdentifier) {
    size += computeStringSize(1, self.identifier);
  }
  if (hasTitle) {
    size += computeStringSize(2, self.title);
  }
  if (hasLength) {
    size += computeInt32Size(3, self.length);
  }
  if (hasLanguage) {
    size += computeStringSize(4, self.language);
  }
  if (hasGenre) {
    size += computeStringSize(5, self.genre);
  }
  if (hasDescription) {
    size += computeStringSize(6, self.description);
  }
  if (hasRawRating) {
    size += computeStringSize(8, self.rawRating);
  }
  if (hasScore) {
    size += computeInt32Size(9, self.score);
  }
  if (hasIMDbUrl) {
    size += computeStringSize(10, self.iMDbUrl);
  }
  for (NSString* element in self.mutableDirectorList) {
    size += computeStringSize(11, element);
  }
  for (NSString* element in self.mutableCastList) {
    size += computeStringSize(12, element);
  }
  for (NSString* element in self.mutableDubbedList) {
    size += computeStringSize(13, element);
  }
  for (NSString* element in self.mutableSubtitledList) {
    size += computeStringSize(14, element);
  }
  if (hasReleaseDate) {
    size += computeStringSize(15, self.releaseDate);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (MovieProto*) parseFromData:(NSData*) data {
  return (MovieProto*)[[[MovieProto builder] mergeFromData:data] build];
}
+ (MovieProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (MovieProto*)[[[MovieProto builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (MovieProto*) parseFromInputStream:(NSInputStream*) input {
  return (MovieProto*)[[[MovieProto builder] mergeFromInputStream:input] build];
}
+ (MovieProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (MovieProto*)[[[MovieProto builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (MovieProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (MovieProto*)[[[MovieProto builder] mergeFromCodedInputStream:input] build];
}
+ (MovieProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (MovieProto*)[[[MovieProto builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (MovieProto_Builder*) builder {
  return [[[MovieProto_Builder alloc] init] autorelease];
}
+ (MovieProto_Builder*) builderWithPrototype:(MovieProto*) prototype {
  return [[MovieProto builder] mergeFromMovieProto:prototype];
}
- (MovieProto_Builder*) builder {
  return [MovieProto builder];
}
@end

@interface MovieProto_Builder()
@property (retain) MovieProto* result;
@end

@implementation MovieProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[MovieProto alloc] init] autorelease];
  }
  return self;
}
- (MovieProto*) internalGetResult {
  return result;
}
- (MovieProto_Builder*) clear {
  self.result = [[[MovieProto alloc] init] autorelease];
  return self;
}
- (MovieProto_Builder*) clone {
  return [MovieProto builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [MovieProto descriptor];
}
- (MovieProto*) defaultInstance {
  return [MovieProto defaultInstance];
}
- (MovieProto*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (MovieProto*) buildPartial {
  MovieProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (MovieProto_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[MovieProto class]]) {
    return [self mergeFromMovieProto:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (MovieProto_Builder*) mergeFromMovieProto:(MovieProto*) other {
  if (other == [MovieProto defaultInstance]) {
    return self;
  }
  if (other.hasIdentifier) {
    [self setIdentifier:other.identifier];
  }
  if (other.hasTitle) {
    [self setTitle:other.title];
  }
  if (other.hasLength) {
    [self setLength:other.length];
  }
  if (other.hasLanguage) {
    [self setLanguage:other.language];
  }
  if (other.hasGenre) {
    [self setGenre:other.genre];
  }
  if (other.hasDescription) {
    [self setDescription:other.description];
  }
  if (other.hasRawRating) {
    [self setRawRating:other.rawRating];
  }
  if (other.hasScore) {
    [self setScore:other.score];
  }
  if (other.hasIMDbUrl) {
    [self setIMDbUrl:other.iMDbUrl];
  }
  if (other.mutableDirectorList.count > 0) {
    if (result.mutableDirectorList == nil) {
      result.mutableDirectorList = [NSMutableArray array];
    }
    [result.mutableDirectorList addObjectsFromArray:other.mutableDirectorList];
  }
  if (other.mutableCastList.count > 0) {
    if (result.mutableCastList == nil) {
      result.mutableCastList = [NSMutableArray array];
    }
    [result.mutableCastList addObjectsFromArray:other.mutableCastList];
  }
  if (other.mutableDubbedList.count > 0) {
    if (result.mutableDubbedList == nil) {
      result.mutableDubbedList = [NSMutableArray array];
    }
    [result.mutableDubbedList addObjectsFromArray:other.mutableDubbedList];
  }
  if (other.mutableSubtitledList.count > 0) {
    if (result.mutableSubtitledList == nil) {
      result.mutableSubtitledList = [NSMutableArray array];
    }
    [result.mutableSubtitledList addObjectsFromArray:other.mutableSubtitledList];
  }
  if (other.hasReleaseDate) {
    [self setReleaseDate:other.releaseDate];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (MovieProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (MovieProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        [self setIdentifier:[input readString]];
        break;
      }
      case 18: {
        [self setTitle:[input readString]];
        break;
      }
      case 24: {
        [self setLength:[input readInt32]];
        break;
      }
      case 34: {
        [self setLanguage:[input readString]];
        break;
      }
      case 42: {
        [self setGenre:[input readString]];
        break;
      }
      case 50: {
        [self setDescription:[input readString]];
        break;
      }
      case 66: {
        [self setRawRating:[input readString]];
        break;
      }
      case 72: {
        [self setScore:[input readInt32]];
        break;
      }
      case 82: {
        [self setIMDbUrl:[input readString]];
        break;
      }
      case 90: {
        [self addDirector:[input readString]];
        break;
      }
      case 98: {
        [self addCast:[input readString]];
        break;
      }
      case 106: {
        [self addDubbed:[input readString]];
        break;
      }
      case 114: {
        [self addSubtitled:[input readString]];
        break;
      }
      case 122: {
        [self setReleaseDate:[input readString]];
        break;
      }
    }
  }
}
- (BOOL) hasIdentifier {
  return result.hasIdentifier;
}
- (NSString*) identifier {
  return result.identifier;
}
- (MovieProto_Builder*) setIdentifier:(NSString*) value {
  result.hasIdentifier = YES;
  result.identifier = value;
  return self;
}
- (MovieProto_Builder*) clearIdentifier {
  result.hasIdentifier = NO;
  result.identifier = @"";
  return self;
}
- (BOOL) hasTitle {
  return result.hasTitle;
}
- (NSString*) title {
  return result.title;
}
- (MovieProto_Builder*) setTitle:(NSString*) value {
  result.hasTitle = YES;
  result.title = value;
  return self;
}
- (MovieProto_Builder*) clearTitle {
  result.hasTitle = NO;
  result.title = @"";
  return self;
}
- (BOOL) hasLength {
  return result.hasLength;
}
- (int32_t) length {
  return result.length;
}
- (MovieProto_Builder*) setLength:(int32_t) value {
  result.hasLength = YES;
  result.length = value;
  return self;
}
- (MovieProto_Builder*) clearLength {
  result.hasLength = NO;
  result.length = 0;
  return self;
}
- (BOOL) hasLanguage {
  return result.hasLanguage;
}
- (NSString*) language {
  return result.language;
}
- (MovieProto_Builder*) setLanguage:(NSString*) value {
  result.hasLanguage = YES;
  result.language = value;
  return self;
}
- (MovieProto_Builder*) clearLanguage {
  result.hasLanguage = NO;
  result.language = @"";
  return self;
}
- (BOOL) hasGenre {
  return result.hasGenre;
}
- (NSString*) genre {
  return result.genre;
}
- (MovieProto_Builder*) setGenre:(NSString*) value {
  result.hasGenre = YES;
  result.genre = value;
  return self;
}
- (MovieProto_Builder*) clearGenre {
  result.hasGenre = NO;
  result.genre = @"";
  return self;
}
- (BOOL) hasDescription {
  return result.hasDescription;
}
- (NSString*) description {
  return result.description;
}
- (MovieProto_Builder*) setDescription:(NSString*) value {
  result.hasDescription = YES;
  result.description = value;
  return self;
}
- (MovieProto_Builder*) clearDescription {
  result.hasDescription = NO;
  result.description = @"";
  return self;
}
- (BOOL) hasRawRating {
  return result.hasRawRating;
}
- (NSString*) rawRating {
  return result.rawRating;
}
- (MovieProto_Builder*) setRawRating:(NSString*) value {
  result.hasRawRating = YES;
  result.rawRating = value;
  return self;
}
- (MovieProto_Builder*) clearRawRating {
  result.hasRawRating = NO;
  result.rawRating = @"";
  return self;
}
- (BOOL) hasScore {
  return result.hasScore;
}
- (int32_t) score {
  return result.score;
}
- (MovieProto_Builder*) setScore:(int32_t) value {
  result.hasScore = YES;
  result.score = value;
  return self;
}
- (MovieProto_Builder*) clearScore {
  result.hasScore = NO;
  result.score = 0;
  return self;
}
- (BOOL) hasIMDbUrl {
  return result.hasIMDbUrl;
}
- (NSString*) iMDbUrl {
  return result.iMDbUrl;
}
- (MovieProto_Builder*) setIMDbUrl:(NSString*) value {
  result.hasIMDbUrl = YES;
  result.iMDbUrl = value;
  return self;
}
- (MovieProto_Builder*) clearIMDbUrl {
  result.hasIMDbUrl = NO;
  result.iMDbUrl = @"";
  return self;
}
- (NSArray*) directorList {
  if (result.mutableDirectorList == nil) {
    return [NSArray array];
  }
  return result.mutableDirectorList;
}
- (NSString*) directorAtIndex:(int32_t) index {
  return [result directorAtIndex:index];
}
- (MovieProto_Builder*) replaceDirectorAtIndex:(int32_t) index with:(NSString*) value {
  [result.mutableDirectorList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (MovieProto_Builder*) addDirector:(NSString*) value {
  if (result.mutableDirectorList == nil) {
    result.mutableDirectorList = [NSMutableArray array];
  }
  [result.mutableDirectorList addObject:value];
  return self;
}
- (MovieProto_Builder*) addAllDirector:(NSArray*) values {
  if (result.mutableDirectorList == nil) {
    result.mutableDirectorList = [NSMutableArray array];
  }
  [result.mutableDirectorList addObjectsFromArray:values];
  return self;
}
- (MovieProto_Builder*) clearDirectorList {
  result.mutableDirectorList = nil;
  return self;
}
- (NSArray*) castList {
  if (result.mutableCastList == nil) {
    return [NSArray array];
  }
  return result.mutableCastList;
}
- (NSString*) castAtIndex:(int32_t) index {
  return [result castAtIndex:index];
}
- (MovieProto_Builder*) replaceCastAtIndex:(int32_t) index with:(NSString*) value {
  [result.mutableCastList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (MovieProto_Builder*) addCast:(NSString*) value {
  if (result.mutableCastList == nil) {
    result.mutableCastList = [NSMutableArray array];
  }
  [result.mutableCastList addObject:value];
  return self;
}
- (MovieProto_Builder*) addAllCast:(NSArray*) values {
  if (result.mutableCastList == nil) {
    result.mutableCastList = [NSMutableArray array];
  }
  [result.mutableCastList addObjectsFromArray:values];
  return self;
}
- (MovieProto_Builder*) clearCastList {
  result.mutableCastList = nil;
  return self;
}
- (NSArray*) dubbedList {
  if (result.mutableDubbedList == nil) {
    return [NSArray array];
  }
  return result.mutableDubbedList;
}
- (NSString*) dubbedAtIndex:(int32_t) index {
  return [result dubbedAtIndex:index];
}
- (MovieProto_Builder*) replaceDubbedAtIndex:(int32_t) index with:(NSString*) value {
  [result.mutableDubbedList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (MovieProto_Builder*) addDubbed:(NSString*) value {
  if (result.mutableDubbedList == nil) {
    result.mutableDubbedList = [NSMutableArray array];
  }
  [result.mutableDubbedList addObject:value];
  return self;
}
- (MovieProto_Builder*) addAllDubbed:(NSArray*) values {
  if (result.mutableDubbedList == nil) {
    result.mutableDubbedList = [NSMutableArray array];
  }
  [result.mutableDubbedList addObjectsFromArray:values];
  return self;
}
- (MovieProto_Builder*) clearDubbedList {
  result.mutableDubbedList = nil;
  return self;
}
- (NSArray*) subtitledList {
  if (result.mutableSubtitledList == nil) {
    return [NSArray array];
  }
  return result.mutableSubtitledList;
}
- (NSString*) subtitledAtIndex:(int32_t) index {
  return [result subtitledAtIndex:index];
}
- (MovieProto_Builder*) replaceSubtitledAtIndex:(int32_t) index with:(NSString*) value {
  [result.mutableSubtitledList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (MovieProto_Builder*) addSubtitled:(NSString*) value {
  if (result.mutableSubtitledList == nil) {
    result.mutableSubtitledList = [NSMutableArray array];
  }
  [result.mutableSubtitledList addObject:value];
  return self;
}
- (MovieProto_Builder*) addAllSubtitled:(NSArray*) values {
  if (result.mutableSubtitledList == nil) {
    result.mutableSubtitledList = [NSMutableArray array];
  }
  [result.mutableSubtitledList addObjectsFromArray:values];
  return self;
}
- (MovieProto_Builder*) clearSubtitledList {
  result.mutableSubtitledList = nil;
  return self;
}
- (BOOL) hasReleaseDate {
  return result.hasReleaseDate;
}
- (NSString*) releaseDate {
  return result.releaseDate;
}
- (MovieProto_Builder*) setReleaseDate:(NSString*) value {
  result.hasReleaseDate = YES;
  result.releaseDate = value;
  return self;
}
- (MovieProto_Builder*) clearReleaseDate {
  result.hasReleaseDate = NO;
  result.releaseDate = @"";
  return self;
}
@end

@interface TheaterProto ()
@property (retain) NSString* identifier;
@property (retain) NSString* name;
@property (retain) NSString* streetAddress;
@property (retain) NSString* city;
@property (retain) NSString* state;
@property (retain) NSString* postalCode;
@property (retain) NSString* country;
@property (retain) NSString* phone;
@property Float64 latitude;
@property Float64 longitude;
@end

@implementation TheaterProto

- (BOOL) hasIdentifier {
  return hasIdentifier != 0;
}
- (void) setHasIdentifier:(BOOL) hasIdentifier_ {
  hasIdentifier = (hasIdentifier_ != 0);
}
@synthesize identifier;
- (BOOL) hasName {
  return hasName != 0;
}
- (void) setHasName:(BOOL) hasName_ {
  hasName = (hasName_ != 0);
}
@synthesize name;
- (BOOL) hasStreetAddress {
  return hasStreetAddress != 0;
}
- (void) setHasStreetAddress:(BOOL) hasStreetAddress_ {
  hasStreetAddress = (hasStreetAddress_ != 0);
}
@synthesize streetAddress;
- (BOOL) hasCity {
  return hasCity != 0;
}
- (void) setHasCity:(BOOL) hasCity_ {
  hasCity = (hasCity_ != 0);
}
@synthesize city;
- (BOOL) hasState {
  return hasState != 0;
}
- (void) setHasState:(BOOL) hasState_ {
  hasState = (hasState_ != 0);
}
@synthesize state;
- (BOOL) hasPostalCode {
  return hasPostalCode != 0;
}
- (void) setHasPostalCode:(BOOL) hasPostalCode_ {
  hasPostalCode = (hasPostalCode_ != 0);
}
@synthesize postalCode;
- (BOOL) hasCountry {
  return hasCountry != 0;
}
- (void) setHasCountry:(BOOL) hasCountry_ {
  hasCountry = (hasCountry_ != 0);
}
@synthesize country;
- (BOOL) hasPhone {
  return hasPhone != 0;
}
- (void) setHasPhone:(BOOL) hasPhone_ {
  hasPhone = (hasPhone_ != 0);
}
@synthesize phone;
- (BOOL) hasLatitude {
  return hasLatitude != 0;
}
- (void) setHasLatitude:(BOOL) hasLatitude_ {
  hasLatitude = (hasLatitude_ != 0);
}
@synthesize latitude;
- (BOOL) hasLongitude {
  return hasLongitude != 0;
}
- (void) setHasLongitude:(BOOL) hasLongitude_ {
  hasLongitude = (hasLongitude_ != 0);
}
@synthesize longitude;
- (void) dealloc {
  self.identifier = nil;
  self.name = nil;
  self.streetAddress = nil;
  self.city = nil;
  self.state = nil;
  self.postalCode = nil;
  self.country = nil;
  self.phone = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.identifier = @"";
    self.name = @"";
    self.streetAddress = @"";
    self.city = @"";
    self.state = @"";
    self.postalCode = @"";
    self.country = @"";
    self.phone = @"";
    self.latitude = 0;
    self.longitude = 0;
  }
  return self;
}
static TheaterProto* defaultTheaterProtoInstance = nil;
+ (void) initialize {
  if (self == [TheaterProto class]) {
    defaultTheaterProtoInstance = [[TheaterProto alloc] init];
  }
}
+ (TheaterProto*) defaultInstance {
  return defaultTheaterProtoInstance;
}
- (TheaterProto*) defaultInstance {
  return defaultTheaterProtoInstance;
}
- (PBDescriptor*) descriptor {
  return [TheaterProto descriptor];
}
+ (PBDescriptor*) descriptor {
  return [MetaFlixRoot internal_static_TheaterProto_descriptor];
}
- (PBFieldAccessorTable*) fieldAccessorTable {
  return [MetaFlixRoot internal_static_TheaterProto_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasIdentifier) {
    [output writeString:1 value:self.identifier];
  }
  if (hasName) {
    [output writeString:2 value:self.name];
  }
  if (hasStreetAddress) {
    [output writeString:3 value:self.streetAddress];
  }
  if (hasCity) {
    [output writeString:4 value:self.city];
  }
  if (hasState) {
    [output writeString:5 value:self.state];
  }
  if (hasPostalCode) {
    [output writeString:6 value:self.postalCode];
  }
  if (hasCountry) {
    [output writeString:7 value:self.country];
  }
  if (hasPhone) {
    [output writeString:8 value:self.phone];
  }
  if (hasLatitude) {
    [output writeDouble:9 value:self.latitude];
  }
  if (hasLongitude) {
    [output writeDouble:10 value:self.longitude];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (hasIdentifier) {
    size += computeStringSize(1, self.identifier);
  }
  if (hasName) {
    size += computeStringSize(2, self.name);
  }
  if (hasStreetAddress) {
    size += computeStringSize(3, self.streetAddress);
  }
  if (hasCity) {
    size += computeStringSize(4, self.city);
  }
  if (hasState) {
    size += computeStringSize(5, self.state);
  }
  if (hasPostalCode) {
    size += computeStringSize(6, self.postalCode);
  }
  if (hasCountry) {
    size += computeStringSize(7, self.country);
  }
  if (hasPhone) {
    size += computeStringSize(8, self.phone);
  }
  if (hasLatitude) {
    size += computeDoubleSize(9, self.latitude);
  }
  if (hasLongitude) {
    size += computeDoubleSize(10, self.longitude);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TheaterProto*) parseFromData:(NSData*) data {
  return (TheaterProto*)[[[TheaterProto builder] mergeFromData:data] build];
}
+ (TheaterProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TheaterProto*)[[[TheaterProto builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TheaterProto*) parseFromInputStream:(NSInputStream*) input {
  return (TheaterProto*)[[[TheaterProto builder] mergeFromInputStream:input] build];
}
+ (TheaterProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TheaterProto*)[[[TheaterProto builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TheaterProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TheaterProto*)[[[TheaterProto builder] mergeFromCodedInputStream:input] build];
}
+ (TheaterProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TheaterProto*)[[[TheaterProto builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TheaterProto_Builder*) builder {
  return [[[TheaterProto_Builder alloc] init] autorelease];
}
+ (TheaterProto_Builder*) builderWithPrototype:(TheaterProto*) prototype {
  return [[TheaterProto builder] mergeFromTheaterProto:prototype];
}
- (TheaterProto_Builder*) builder {
  return [TheaterProto builder];
}
@end

@interface TheaterProto_Builder()
@property (retain) TheaterProto* result;
@end

@implementation TheaterProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[TheaterProto alloc] init] autorelease];
  }
  return self;
}
- (TheaterProto*) internalGetResult {
  return result;
}
- (TheaterProto_Builder*) clear {
  self.result = [[[TheaterProto alloc] init] autorelease];
  return self;
}
- (TheaterProto_Builder*) clone {
  return [TheaterProto builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [TheaterProto descriptor];
}
- (TheaterProto*) defaultInstance {
  return [TheaterProto defaultInstance];
}
- (TheaterProto*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (TheaterProto*) buildPartial {
  TheaterProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TheaterProto_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[TheaterProto class]]) {
    return [self mergeFromTheaterProto:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (TheaterProto_Builder*) mergeFromTheaterProto:(TheaterProto*) other {
  if (other == [TheaterProto defaultInstance]) {
    return self;
  }
  if (other.hasIdentifier) {
    [self setIdentifier:other.identifier];
  }
  if (other.hasName) {
    [self setName:other.name];
  }
  if (other.hasStreetAddress) {
    [self setStreetAddress:other.streetAddress];
  }
  if (other.hasCity) {
    [self setCity:other.city];
  }
  if (other.hasState) {
    [self setState:other.state];
  }
  if (other.hasPostalCode) {
    [self setPostalCode:other.postalCode];
  }
  if (other.hasCountry) {
    [self setCountry:other.country];
  }
  if (other.hasPhone) {
    [self setPhone:other.phone];
  }
  if (other.hasLatitude) {
    [self setLatitude:other.latitude];
  }
  if (other.hasLongitude) {
    [self setLongitude:other.longitude];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TheaterProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TheaterProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        [self setIdentifier:[input readString]];
        break;
      }
      case 18: {
        [self setName:[input readString]];
        break;
      }
      case 26: {
        [self setStreetAddress:[input readString]];
        break;
      }
      case 34: {
        [self setCity:[input readString]];
        break;
      }
      case 42: {
        [self setState:[input readString]];
        break;
      }
      case 50: {
        [self setPostalCode:[input readString]];
        break;
      }
      case 58: {
        [self setCountry:[input readString]];
        break;
      }
      case 66: {
        [self setPhone:[input readString]];
        break;
      }
      case 73: {
        [self setLatitude:[input readDouble]];
        break;
      }
      case 81: {
        [self setLongitude:[input readDouble]];
        break;
      }
    }
  }
}
- (BOOL) hasIdentifier {
  return result.hasIdentifier;
}
- (NSString*) identifier {
  return result.identifier;
}
- (TheaterProto_Builder*) setIdentifier:(NSString*) value {
  result.hasIdentifier = YES;
  result.identifier = value;
  return self;
}
- (TheaterProto_Builder*) clearIdentifier {
  result.hasIdentifier = NO;
  result.identifier = @"";
  return self;
}
- (BOOL) hasName {
  return result.hasName;
}
- (NSString*) name {
  return result.name;
}
- (TheaterProto_Builder*) setName:(NSString*) value {
  result.hasName = YES;
  result.name = value;
  return self;
}
- (TheaterProto_Builder*) clearName {
  result.hasName = NO;
  result.name = @"";
  return self;
}
- (BOOL) hasStreetAddress {
  return result.hasStreetAddress;
}
- (NSString*) streetAddress {
  return result.streetAddress;
}
- (TheaterProto_Builder*) setStreetAddress:(NSString*) value {
  result.hasStreetAddress = YES;
  result.streetAddress = value;
  return self;
}
- (TheaterProto_Builder*) clearStreetAddress {
  result.hasStreetAddress = NO;
  result.streetAddress = @"";
  return self;
}
- (BOOL) hasCity {
  return result.hasCity;
}
- (NSString*) city {
  return result.city;
}
- (TheaterProto_Builder*) setCity:(NSString*) value {
  result.hasCity = YES;
  result.city = value;
  return self;
}
- (TheaterProto_Builder*) clearCity {
  result.hasCity = NO;
  result.city = @"";
  return self;
}
- (BOOL) hasState {
  return result.hasState;
}
- (NSString*) state {
  return result.state;
}
- (TheaterProto_Builder*) setState:(NSString*) value {
  result.hasState = YES;
  result.state = value;
  return self;
}
- (TheaterProto_Builder*) clearState {
  result.hasState = NO;
  result.state = @"";
  return self;
}
- (BOOL) hasPostalCode {
  return result.hasPostalCode;
}
- (NSString*) postalCode {
  return result.postalCode;
}
- (TheaterProto_Builder*) setPostalCode:(NSString*) value {
  result.hasPostalCode = YES;
  result.postalCode = value;
  return self;
}
- (TheaterProto_Builder*) clearPostalCode {
  result.hasPostalCode = NO;
  result.postalCode = @"";
  return self;
}
- (BOOL) hasCountry {
  return result.hasCountry;
}
- (NSString*) country {
  return result.country;
}
- (TheaterProto_Builder*) setCountry:(NSString*) value {
  result.hasCountry = YES;
  result.country = value;
  return self;
}
- (TheaterProto_Builder*) clearCountry {
  result.hasCountry = NO;
  result.country = @"";
  return self;
}
- (BOOL) hasPhone {
  return result.hasPhone;
}
- (NSString*) phone {
  return result.phone;
}
- (TheaterProto_Builder*) setPhone:(NSString*) value {
  result.hasPhone = YES;
  result.phone = value;
  return self;
}
- (TheaterProto_Builder*) clearPhone {
  result.hasPhone = NO;
  result.phone = @"";
  return self;
}
- (BOOL) hasLatitude {
  return result.hasLatitude;
}
- (Float64) latitude {
  return result.latitude;
}
- (TheaterProto_Builder*) setLatitude:(Float64) value {
  result.hasLatitude = YES;
  result.latitude = value;
  return self;
}
- (TheaterProto_Builder*) clearLatitude {
  result.hasLatitude = NO;
  result.latitude = 0;
  return self;
}
- (BOOL) hasLongitude {
  return result.hasLongitude;
}
- (Float64) longitude {
  return result.longitude;
}
- (TheaterProto_Builder*) setLongitude:(Float64) value {
  result.hasLongitude = YES;
  result.longitude = value;
  return self;
}
- (TheaterProto_Builder*) clearLongitude {
  result.hasLongitude = NO;
  result.longitude = 0;
  return self;
}
@end

@interface TheaterListingsProto ()
@property (retain) NSMutableArray* mutableMoviesList;
@property (retain) NSMutableArray* mutableTheaterAndMovieShowtimesList;
@end

@implementation TheaterListingsProto

@synthesize mutableMoviesList;
@synthesize mutableTheaterAndMovieShowtimesList;
- (void) dealloc {
  self.mutableMoviesList = nil;
  self.mutableTheaterAndMovieShowtimesList = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
  }
  return self;
}
static TheaterListingsProto* defaultTheaterListingsProtoInstance = nil;
+ (void) initialize {
  if (self == [TheaterListingsProto class]) {
    defaultTheaterListingsProtoInstance = [[TheaterListingsProto alloc] init];
  }
}
+ (TheaterListingsProto*) defaultInstance {
  return defaultTheaterListingsProtoInstance;
}
- (TheaterListingsProto*) defaultInstance {
  return defaultTheaterListingsProtoInstance;
}
- (PBDescriptor*) descriptor {
  return [TheaterListingsProto descriptor];
}
+ (PBDescriptor*) descriptor {
  return [MetaFlixRoot internal_static_TheaterListingsProto_descriptor];
}
- (PBFieldAccessorTable*) fieldAccessorTable {
  return [MetaFlixRoot internal_static_TheaterListingsProto_fieldAccessorTable];
}
- (NSArray*) moviesList {
  return mutableMoviesList;
}
- (MovieProto*) moviesAtIndex:(int32_t) index {
  id value = [mutableMoviesList objectAtIndex:index];
  return value;
}
- (NSArray*) theaterAndMovieShowtimesList {
  return mutableTheaterAndMovieShowtimesList;
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto*) theaterAndMovieShowtimesAtIndex:(int32_t) index {
  id value = [mutableTheaterAndMovieShowtimesList objectAtIndex:index];
  return value;
}
- (BOOL) isInitialized {
  for (TheaterListingsProto_TheaterAndMovieShowtimesProto* element in self.theaterAndMovieShowtimesList) {
    if (!element.isInitialized) {
      return NO;
    }
  }
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  for (MovieProto* element in self.moviesList) {
    [output writeMessage:5 value:element];
  }
  for (TheaterListingsProto_TheaterAndMovieShowtimesProto* element in self.theaterAndMovieShowtimesList) {
    [output writeMessage:6 value:element];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  for (MovieProto* element in self.moviesList) {
    size += computeMessageSize(5, element);
  }
  for (TheaterListingsProto_TheaterAndMovieShowtimesProto* element in self.theaterAndMovieShowtimesList) {
    size += computeMessageSize(6, element);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TheaterListingsProto*) parseFromData:(NSData*) data {
  return (TheaterListingsProto*)[[[TheaterListingsProto builder] mergeFromData:data] build];
}
+ (TheaterListingsProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TheaterListingsProto*)[[[TheaterListingsProto builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TheaterListingsProto*) parseFromInputStream:(NSInputStream*) input {
  return (TheaterListingsProto*)[[[TheaterListingsProto builder] mergeFromInputStream:input] build];
}
+ (TheaterListingsProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TheaterListingsProto*)[[[TheaterListingsProto builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TheaterListingsProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TheaterListingsProto*)[[[TheaterListingsProto builder] mergeFromCodedInputStream:input] build];
}
+ (TheaterListingsProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TheaterListingsProto*)[[[TheaterListingsProto builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TheaterListingsProto_Builder*) builder {
  return [[[TheaterListingsProto_Builder alloc] init] autorelease];
}
+ (TheaterListingsProto_Builder*) builderWithPrototype:(TheaterListingsProto*) prototype {
  return [[TheaterListingsProto builder] mergeFromTheaterListingsProto:prototype];
}
- (TheaterListingsProto_Builder*) builder {
  return [TheaterListingsProto builder];
}
@end

@interface TheaterListingsProto_TheaterAndMovieShowtimesProto ()
@property (retain) TheaterProto* theater;
@property (retain) NSMutableArray* mutableMovieAndShowtimesList;
@end

@implementation TheaterListingsProto_TheaterAndMovieShowtimesProto

- (BOOL) hasTheater {
  return hasTheater != 0;
}
- (void) setHasTheater:(BOOL) hasTheater_ {
  hasTheater = (hasTheater_ != 0);
}
@synthesize theater;
@synthesize mutableMovieAndShowtimesList;
- (void) dealloc {
  self.theater = nil;
  self.mutableMovieAndShowtimesList = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.theater = [TheaterProto defaultInstance];
  }
  return self;
}
static TheaterListingsProto_TheaterAndMovieShowtimesProto* defaultTheaterListingsProto_TheaterAndMovieShowtimesProtoInstance = nil;
+ (void) initialize {
  if (self == [TheaterListingsProto_TheaterAndMovieShowtimesProto class]) {
    defaultTheaterListingsProto_TheaterAndMovieShowtimesProtoInstance = [[TheaterListingsProto_TheaterAndMovieShowtimesProto alloc] init];
  }
}
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto*) defaultInstance {
  return defaultTheaterListingsProto_TheaterAndMovieShowtimesProtoInstance;
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto*) defaultInstance {
  return defaultTheaterListingsProto_TheaterAndMovieShowtimesProtoInstance;
}
- (PBDescriptor*) descriptor {
  return [TheaterListingsProto_TheaterAndMovieShowtimesProto descriptor];
}
+ (PBDescriptor*) descriptor {
  return [MetaFlixRoot internal_static_TheaterListingsProto_TheaterAndMovieShowtimesProto_descriptor];
}
- (PBFieldAccessorTable*) fieldAccessorTable {
  return [MetaFlixRoot internal_static_TheaterListingsProto_TheaterAndMovieShowtimesProto_fieldAccessorTable];
}
- (NSArray*) movieAndShowtimesList {
  return mutableMovieAndShowtimesList;
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) movieAndShowtimesAtIndex:(int32_t) index {
  id value = [mutableMovieAndShowtimesList objectAtIndex:index];
  return value;
}
- (BOOL) isInitialized {
  if (!hasTheater) {
    return NO;
  }
  for (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto* element in self.movieAndShowtimesList) {
    if (!element.isInitialized) {
      return NO;
    }
  }
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasTheater) {
    [output writeMessage:3 value:self.theater];
  }
  for (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto* element in self.movieAndShowtimesList) {
    [output writeMessage:4 value:element];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (hasTheater) {
    size += computeMessageSize(3, self.theater);
  }
  for (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto* element in self.movieAndShowtimesList) {
    size += computeMessageSize(4, element);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto*) parseFromData:(NSData*) data {
  return (TheaterListingsProto_TheaterAndMovieShowtimesProto*)[[[TheaterListingsProto_TheaterAndMovieShowtimesProto builder] mergeFromData:data] build];
}
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TheaterListingsProto_TheaterAndMovieShowtimesProto*)[[[TheaterListingsProto_TheaterAndMovieShowtimesProto builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto*) parseFromInputStream:(NSInputStream*) input {
  return (TheaterListingsProto_TheaterAndMovieShowtimesProto*)[[[TheaterListingsProto_TheaterAndMovieShowtimesProto builder] mergeFromInputStream:input] build];
}
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TheaterListingsProto_TheaterAndMovieShowtimesProto*)[[[TheaterListingsProto_TheaterAndMovieShowtimesProto builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TheaterListingsProto_TheaterAndMovieShowtimesProto*)[[[TheaterListingsProto_TheaterAndMovieShowtimesProto builder] mergeFromCodedInputStream:input] build];
}
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TheaterListingsProto_TheaterAndMovieShowtimesProto*)[[[TheaterListingsProto_TheaterAndMovieShowtimesProto builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) builder {
  return [[[TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder alloc] init] autorelease];
}
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) builderWithPrototype:(TheaterListingsProto_TheaterAndMovieShowtimesProto*) prototype {
  return [[TheaterListingsProto_TheaterAndMovieShowtimesProto builder] mergeFromTheaterListingsProto_TheaterAndMovieShowtimesProto:prototype];
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) builder {
  return [TheaterListingsProto_TheaterAndMovieShowtimesProto builder];
}
@end

@interface TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto ()
@property (retain) NSString* movieIdentifier;
@property (retain) AllShowtimesProto* showtimes;
@end

@implementation TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto

- (BOOL) hasMovieIdentifier {
  return hasMovieIdentifier != 0;
}
- (void) setHasMovieIdentifier:(BOOL) hasMovieIdentifier_ {
  hasMovieIdentifier = (hasMovieIdentifier_ != 0);
}
@synthesize movieIdentifier;
- (BOOL) hasShowtimes {
  return hasShowtimes != 0;
}
- (void) setHasShowtimes:(BOOL) hasShowtimes_ {
  hasShowtimes = (hasShowtimes_ != 0);
}
@synthesize showtimes;
- (void) dealloc {
  self.movieIdentifier = nil;
  self.showtimes = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.movieIdentifier = @"";
    self.showtimes = [AllShowtimesProto defaultInstance];
  }
  return self;
}
static TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto* defaultTheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProtoInstance = nil;
+ (void) initialize {
  if (self == [TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto class]) {
    defaultTheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProtoInstance = [[TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto alloc] init];
  }
}
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) defaultInstance {
  return defaultTheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProtoInstance;
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) defaultInstance {
  return defaultTheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProtoInstance;
}
- (PBDescriptor*) descriptor {
  return [TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto descriptor];
}
+ (PBDescriptor*) descriptor {
  return [MetaFlixRoot internal_static_TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_descriptor];
}
- (PBFieldAccessorTable*) fieldAccessorTable {
  return [MetaFlixRoot internal_static_TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_fieldAccessorTable];
}
- (BOOL) isInitialized {
  if (!hasMovieIdentifier) {
    return NO;
  }
  if (!hasShowtimes) {
    return NO;
  }
  if (!self.showtimes.isInitialized) {
    return NO;
  }
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasMovieIdentifier) {
    [output writeString:1 value:self.movieIdentifier];
  }
  if (hasShowtimes) {
    [output writeMessage:2 value:self.showtimes];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (hasMovieIdentifier) {
    size += computeStringSize(1, self.movieIdentifier);
  }
  if (hasShowtimes) {
    size += computeMessageSize(2, self.showtimes);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) parseFromData:(NSData*) data {
  return (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*)[[[TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto builder] mergeFromData:data] build];
}
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*)[[[TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) parseFromInputStream:(NSInputStream*) input {
  return (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*)[[[TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto builder] mergeFromInputStream:input] build];
}
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*)[[[TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*)[[[TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto builder] mergeFromCodedInputStream:input] build];
}
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*)[[[TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) builder {
  return [[[TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder alloc] init] autorelease];
}
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) builderWithPrototype:(TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) prototype {
  return [[TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto builder] mergeFromTheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto:prototype];
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) builder {
  return [TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto builder];
}
@end

@interface TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder()
@property (retain) TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto* result;
@end

@implementation TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto alloc] init] autorelease];
  }
  return self;
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) internalGetResult {
  return result;
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) clear {
  self.result = [[[TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto alloc] init] autorelease];
  return self;
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) clone {
  return [TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto descriptor];
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) defaultInstance {
  return [TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto defaultInstance];
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) buildPartial {
  TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto class]]) {
    return [self mergeFromTheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) mergeFromTheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto:(TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) other {
  if (other == [TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto defaultInstance]) {
    return self;
  }
  if (other.hasMovieIdentifier) {
    [self setMovieIdentifier:other.movieIdentifier];
  }
  if (other.hasShowtimes) {
    [self mergeShowtimes:other.showtimes];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        [self setMovieIdentifier:[input readString]];
        break;
      }
      case 18: {
        AllShowtimesProto_Builder* subBuilder = [AllShowtimesProto builder];
        if (self.hasShowtimes) {
          [subBuilder mergeFromAllShowtimesProto:self.showtimes];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setShowtimes:[subBuilder buildPartial]];
        break;
      }
    }
  }
}
- (BOOL) hasMovieIdentifier {
  return result.hasMovieIdentifier;
}
- (NSString*) movieIdentifier {
  return result.movieIdentifier;
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) setMovieIdentifier:(NSString*) value {
  result.hasMovieIdentifier = YES;
  result.movieIdentifier = value;
  return self;
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) clearMovieIdentifier {
  result.hasMovieIdentifier = NO;
  result.movieIdentifier = @"";
  return self;
}
- (BOOL) hasShowtimes {
  return result.hasShowtimes;
}
- (AllShowtimesProto*) showtimes {
  return result.showtimes;
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) setShowtimes:(AllShowtimesProto*) value {
  result.hasShowtimes = YES;
  result.showtimes = value;
  return self;
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) setShowtimesBuilder:(AllShowtimesProto_Builder*) builderForValue {
  return [self setShowtimes:[builderForValue build]];
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) mergeShowtimes:(AllShowtimesProto*) value {
  if (result.hasShowtimes &&
      result.showtimes != [AllShowtimesProto defaultInstance]) {
    result.showtimes =
      [[[AllShowtimesProto builderWithPrototype:result.showtimes] mergeFromAllShowtimesProto:value] buildPartial];
  } else {
    result.showtimes = value;
  }
  result.hasShowtimes = YES;
  return self;
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) clearShowtimes {
  result.hasShowtimes = NO;
  result.showtimes = [AllShowtimesProto defaultInstance];
  return self;
}
@end

@interface TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder()
@property (retain) TheaterListingsProto_TheaterAndMovieShowtimesProto* result;
@end

@implementation TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[TheaterListingsProto_TheaterAndMovieShowtimesProto alloc] init] autorelease];
  }
  return self;
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto*) internalGetResult {
  return result;
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) clear {
  self.result = [[[TheaterListingsProto_TheaterAndMovieShowtimesProto alloc] init] autorelease];
  return self;
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) clone {
  return [TheaterListingsProto_TheaterAndMovieShowtimesProto builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [TheaterListingsProto_TheaterAndMovieShowtimesProto descriptor];
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto*) defaultInstance {
  return [TheaterListingsProto_TheaterAndMovieShowtimesProto defaultInstance];
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto*) buildPartial {
  TheaterListingsProto_TheaterAndMovieShowtimesProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[TheaterListingsProto_TheaterAndMovieShowtimesProto class]]) {
    return [self mergeFromTheaterListingsProto_TheaterAndMovieShowtimesProto:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) mergeFromTheaterListingsProto_TheaterAndMovieShowtimesProto:(TheaterListingsProto_TheaterAndMovieShowtimesProto*) other {
  if (other == [TheaterListingsProto_TheaterAndMovieShowtimesProto defaultInstance]) {
    return self;
  }
  if (other.hasTheater) {
    [self mergeTheater:other.theater];
  }
  if (other.mutableMovieAndShowtimesList.count > 0) {
    if (result.mutableMovieAndShowtimesList == nil) {
      result.mutableMovieAndShowtimesList = [NSMutableArray array];
    }
    [result.mutableMovieAndShowtimesList addObjectsFromArray:other.mutableMovieAndShowtimesList];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 26: {
        TheaterProto_Builder* subBuilder = [TheaterProto builder];
        if (self.hasTheater) {
          [subBuilder mergeFromTheaterProto:self.theater];
        }
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self setTheater:[subBuilder buildPartial]];
        break;
      }
      case 34: {
        TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder* subBuilder = [TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto builder];
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self addMovieAndShowtimes:[subBuilder buildPartial]];
        break;
      }
    }
  }
}
- (BOOL) hasTheater {
  return result.hasTheater;
}
- (TheaterProto*) theater {
  return result.theater;
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) setTheater:(TheaterProto*) value {
  result.hasTheater = YES;
  result.theater = value;
  return self;
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) setTheaterBuilder:(TheaterProto_Builder*) builderForValue {
  return [self setTheater:[builderForValue build]];
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) mergeTheater:(TheaterProto*) value {
  if (result.hasTheater &&
      result.theater != [TheaterProto defaultInstance]) {
    result.theater =
      [[[TheaterProto builderWithPrototype:result.theater] mergeFromTheaterProto:value] buildPartial];
  } else {
    result.theater = value;
  }
  result.hasTheater = YES;
  return self;
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) clearTheater {
  result.hasTheater = NO;
  result.theater = [TheaterProto defaultInstance];
  return self;
}
- (NSArray*) movieAndShowtimesList {
  if (result.mutableMovieAndShowtimesList == nil) { return [NSArray array]; }
  return result.mutableMovieAndShowtimesList;
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) movieAndShowtimesAtIndex:(int32_t) index {
  return [result movieAndShowtimesAtIndex:index];
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) replaceMovieAndShowtimesAtIndex:(int32_t) index with:(TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) value {
  [result.mutableMovieAndShowtimesList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) addAllMovieAndShowtimes:(NSArray*) values {
  if (result.mutableMovieAndShowtimesList == nil) {
    result.mutableMovieAndShowtimesList = [NSMutableArray array];
  }
  [result.mutableMovieAndShowtimesList addObjectsFromArray:values];
  return self;
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) clearMovieAndShowtimesList {
  result.mutableMovieAndShowtimesList = nil;
  return self;
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) addMovieAndShowtimes:(TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) value {
  if (result.mutableMovieAndShowtimesList == nil) {
    result.mutableMovieAndShowtimesList = [NSMutableArray array];
  }
  [result.mutableMovieAndShowtimesList addObject:value];
  return self;
}
@end

@interface TheaterListingsProto_Builder()
@property (retain) TheaterListingsProto* result;
@end

@implementation TheaterListingsProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[TheaterListingsProto alloc] init] autorelease];
  }
  return self;
}
- (TheaterListingsProto*) internalGetResult {
  return result;
}
- (TheaterListingsProto_Builder*) clear {
  self.result = [[[TheaterListingsProto alloc] init] autorelease];
  return self;
}
- (TheaterListingsProto_Builder*) clone {
  return [TheaterListingsProto builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [TheaterListingsProto descriptor];
}
- (TheaterListingsProto*) defaultInstance {
  return [TheaterListingsProto defaultInstance];
}
- (TheaterListingsProto*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (TheaterListingsProto*) buildPartial {
  TheaterListingsProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (TheaterListingsProto_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[TheaterListingsProto class]]) {
    return [self mergeFromTheaterListingsProto:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (TheaterListingsProto_Builder*) mergeFromTheaterListingsProto:(TheaterListingsProto*) other {
  if (other == [TheaterListingsProto defaultInstance]) {
    return self;
  }
  if (other.mutableMoviesList.count > 0) {
    if (result.mutableMoviesList == nil) {
      result.mutableMoviesList = [NSMutableArray array];
    }
    [result.mutableMoviesList addObjectsFromArray:other.mutableMoviesList];
  }
  if (other.mutableTheaterAndMovieShowtimesList.count > 0) {
    if (result.mutableTheaterAndMovieShowtimesList == nil) {
      result.mutableTheaterAndMovieShowtimesList = [NSMutableArray array];
    }
    [result.mutableTheaterAndMovieShowtimesList addObjectsFromArray:other.mutableTheaterAndMovieShowtimesList];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (TheaterListingsProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (TheaterListingsProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 42: {
        MovieProto_Builder* subBuilder = [MovieProto builder];
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self addMovies:[subBuilder buildPartial]];
        break;
      }
      case 50: {
        TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder* subBuilder = [TheaterListingsProto_TheaterAndMovieShowtimesProto builder];
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self addTheaterAndMovieShowtimes:[subBuilder buildPartial]];
        break;
      }
    }
  }
}
- (NSArray*) moviesList {
  if (result.mutableMoviesList == nil) { return [NSArray array]; }
  return result.mutableMoviesList;
}
- (MovieProto*) moviesAtIndex:(int32_t) index {
  return [result moviesAtIndex:index];
}
- (TheaterListingsProto_Builder*) replaceMoviesAtIndex:(int32_t) index with:(MovieProto*) value {
  [result.mutableMoviesList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (TheaterListingsProto_Builder*) addAllMovies:(NSArray*) values {
  if (result.mutableMoviesList == nil) {
    result.mutableMoviesList = [NSMutableArray array];
  }
  [result.mutableMoviesList addObjectsFromArray:values];
  return self;
}
- (TheaterListingsProto_Builder*) clearMoviesList {
  result.mutableMoviesList = nil;
  return self;
}
- (TheaterListingsProto_Builder*) addMovies:(MovieProto*) value {
  if (result.mutableMoviesList == nil) {
    result.mutableMoviesList = [NSMutableArray array];
  }
  [result.mutableMoviesList addObject:value];
  return self;
}
- (NSArray*) theaterAndMovieShowtimesList {
  if (result.mutableTheaterAndMovieShowtimesList == nil) { return [NSArray array]; }
  return result.mutableTheaterAndMovieShowtimesList;
}
- (TheaterListingsProto_TheaterAndMovieShowtimesProto*) theaterAndMovieShowtimesAtIndex:(int32_t) index {
  return [result theaterAndMovieShowtimesAtIndex:index];
}
- (TheaterListingsProto_Builder*) replaceTheaterAndMovieShowtimesAtIndex:(int32_t) index with:(TheaterListingsProto_TheaterAndMovieShowtimesProto*) value {
  [result.mutableTheaterAndMovieShowtimesList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (TheaterListingsProto_Builder*) addAllTheaterAndMovieShowtimes:(NSArray*) values {
  if (result.mutableTheaterAndMovieShowtimesList == nil) {
    result.mutableTheaterAndMovieShowtimesList = [NSMutableArray array];
  }
  [result.mutableTheaterAndMovieShowtimesList addObjectsFromArray:values];
  return self;
}
- (TheaterListingsProto_Builder*) clearTheaterAndMovieShowtimesList {
  result.mutableTheaterAndMovieShowtimesList = nil;
  return self;
}
- (TheaterListingsProto_Builder*) addTheaterAndMovieShowtimes:(TheaterListingsProto_TheaterAndMovieShowtimesProto*) value {
  if (result.mutableTheaterAndMovieShowtimesList == nil) {
    result.mutableTheaterAndMovieShowtimesList = [NSMutableArray array];
  }
  [result.mutableTheaterAndMovieShowtimesList addObject:value];
  return self;
}
@end

@interface ReviewProto ()
@property (retain) NSString* title;
@property (retain) NSString* url;
@property Float32 rating;
@property (retain) NSString* snippet;
@property (retain) NSString* content;
@property (retain) NSString* publisher;
@property (retain) NSString* author;
@property (retain) NSString* date;
@end

@implementation ReviewProto

- (BOOL) hasTitle {
  return hasTitle != 0;
}
- (void) setHasTitle:(BOOL) hasTitle_ {
  hasTitle = (hasTitle_ != 0);
}
@synthesize title;
- (BOOL) hasUrl {
  return hasUrl != 0;
}
- (void) setHasUrl:(BOOL) hasUrl_ {
  hasUrl = (hasUrl_ != 0);
}
@synthesize url;
- (BOOL) hasRating {
  return hasRating != 0;
}
- (void) setHasRating:(BOOL) hasRating_ {
  hasRating = (hasRating_ != 0);
}
@synthesize rating;
- (BOOL) hasSnippet {
  return hasSnippet != 0;
}
- (void) setHasSnippet:(BOOL) hasSnippet_ {
  hasSnippet = (hasSnippet_ != 0);
}
@synthesize snippet;
- (BOOL) hasContent {
  return hasContent != 0;
}
- (void) setHasContent:(BOOL) hasContent_ {
  hasContent = (hasContent_ != 0);
}
@synthesize content;
- (BOOL) hasPublisher {
  return hasPublisher != 0;
}
- (void) setHasPublisher:(BOOL) hasPublisher_ {
  hasPublisher = (hasPublisher_ != 0);
}
@synthesize publisher;
- (BOOL) hasAuthor {
  return hasAuthor != 0;
}
- (void) setHasAuthor:(BOOL) hasAuthor_ {
  hasAuthor = (hasAuthor_ != 0);
}
@synthesize author;
- (BOOL) hasDate {
  return hasDate != 0;
}
- (void) setHasDate:(BOOL) hasDate_ {
  hasDate = (hasDate_ != 0);
}
@synthesize date;
- (void) dealloc {
  self.title = nil;
  self.url = nil;
  self.snippet = nil;
  self.content = nil;
  self.publisher = nil;
  self.author = nil;
  self.date = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.title = @"";
    self.url = @"";
    self.rating = 0;
    self.snippet = @"";
    self.content = @"";
    self.publisher = @"";
    self.author = @"";
    self.date = @"";
  }
  return self;
}
static ReviewProto* defaultReviewProtoInstance = nil;
+ (void) initialize {
  if (self == [ReviewProto class]) {
    defaultReviewProtoInstance = [[ReviewProto alloc] init];
  }
}
+ (ReviewProto*) defaultInstance {
  return defaultReviewProtoInstance;
}
- (ReviewProto*) defaultInstance {
  return defaultReviewProtoInstance;
}
- (PBDescriptor*) descriptor {
  return [ReviewProto descriptor];
}
+ (PBDescriptor*) descriptor {
  return [MetaFlixRoot internal_static_ReviewProto_descriptor];
}
- (PBFieldAccessorTable*) fieldAccessorTable {
  return [MetaFlixRoot internal_static_ReviewProto_fieldAccessorTable];
}
- (BOOL) isInitialized {
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  if (hasTitle) {
    [output writeString:1 value:self.title];
  }
  if (hasUrl) {
    [output writeString:2 value:self.url];
  }
  if (hasRating) {
    [output writeFloat:3 value:self.rating];
  }
  if (hasSnippet) {
    [output writeString:4 value:self.snippet];
  }
  if (hasContent) {
    [output writeString:5 value:self.content];
  }
  if (hasPublisher) {
    [output writeString:6 value:self.publisher];
  }
  if (hasAuthor) {
    [output writeString:7 value:self.author];
  }
  if (hasDate) {
    [output writeString:8 value:self.date];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  if (hasTitle) {
    size += computeStringSize(1, self.title);
  }
  if (hasUrl) {
    size += computeStringSize(2, self.url);
  }
  if (hasRating) {
    size += computeFloatSize(3, self.rating);
  }
  if (hasSnippet) {
    size += computeStringSize(4, self.snippet);
  }
  if (hasContent) {
    size += computeStringSize(5, self.content);
  }
  if (hasPublisher) {
    size += computeStringSize(6, self.publisher);
  }
  if (hasAuthor) {
    size += computeStringSize(7, self.author);
  }
  if (hasDate) {
    size += computeStringSize(8, self.date);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (ReviewProto*) parseFromData:(NSData*) data {
  return (ReviewProto*)[[[ReviewProto builder] mergeFromData:data] build];
}
+ (ReviewProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (ReviewProto*)[[[ReviewProto builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (ReviewProto*) parseFromInputStream:(NSInputStream*) input {
  return (ReviewProto*)[[[ReviewProto builder] mergeFromInputStream:input] build];
}
+ (ReviewProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (ReviewProto*)[[[ReviewProto builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (ReviewProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (ReviewProto*)[[[ReviewProto builder] mergeFromCodedInputStream:input] build];
}
+ (ReviewProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (ReviewProto*)[[[ReviewProto builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (ReviewProto_Builder*) builder {
  return [[[ReviewProto_Builder alloc] init] autorelease];
}
+ (ReviewProto_Builder*) builderWithPrototype:(ReviewProto*) prototype {
  return [[ReviewProto builder] mergeFromReviewProto:prototype];
}
- (ReviewProto_Builder*) builder {
  return [ReviewProto builder];
}
@end

@interface ReviewProto_Builder()
@property (retain) ReviewProto* result;
@end

@implementation ReviewProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[ReviewProto alloc] init] autorelease];
  }
  return self;
}
- (ReviewProto*) internalGetResult {
  return result;
}
- (ReviewProto_Builder*) clear {
  self.result = [[[ReviewProto alloc] init] autorelease];
  return self;
}
- (ReviewProto_Builder*) clone {
  return [ReviewProto builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [ReviewProto descriptor];
}
- (ReviewProto*) defaultInstance {
  return [ReviewProto defaultInstance];
}
- (ReviewProto*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (ReviewProto*) buildPartial {
  ReviewProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (ReviewProto_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[ReviewProto class]]) {
    return [self mergeFromReviewProto:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (ReviewProto_Builder*) mergeFromReviewProto:(ReviewProto*) other {
  if (other == [ReviewProto defaultInstance]) {
    return self;
  }
  if (other.hasTitle) {
    [self setTitle:other.title];
  }
  if (other.hasUrl) {
    [self setUrl:other.url];
  }
  if (other.hasRating) {
    [self setRating:other.rating];
  }
  if (other.hasSnippet) {
    [self setSnippet:other.snippet];
  }
  if (other.hasContent) {
    [self setContent:other.content];
  }
  if (other.hasPublisher) {
    [self setPublisher:other.publisher];
  }
  if (other.hasAuthor) {
    [self setAuthor:other.author];
  }
  if (other.hasDate) {
    [self setDate:other.date];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (ReviewProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (ReviewProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        [self setTitle:[input readString]];
        break;
      }
      case 18: {
        [self setUrl:[input readString]];
        break;
      }
      case 29: {
        [self setRating:[input readFloat]];
        break;
      }
      case 34: {
        [self setSnippet:[input readString]];
        break;
      }
      case 42: {
        [self setContent:[input readString]];
        break;
      }
      case 50: {
        [self setPublisher:[input readString]];
        break;
      }
      case 58: {
        [self setAuthor:[input readString]];
        break;
      }
      case 66: {
        [self setDate:[input readString]];
        break;
      }
    }
  }
}
- (BOOL) hasTitle {
  return result.hasTitle;
}
- (NSString*) title {
  return result.title;
}
- (ReviewProto_Builder*) setTitle:(NSString*) value {
  result.hasTitle = YES;
  result.title = value;
  return self;
}
- (ReviewProto_Builder*) clearTitle {
  result.hasTitle = NO;
  result.title = @"";
  return self;
}
- (BOOL) hasUrl {
  return result.hasUrl;
}
- (NSString*) url {
  return result.url;
}
- (ReviewProto_Builder*) setUrl:(NSString*) value {
  result.hasUrl = YES;
  result.url = value;
  return self;
}
- (ReviewProto_Builder*) clearUrl {
  result.hasUrl = NO;
  result.url = @"";
  return self;
}
- (BOOL) hasRating {
  return result.hasRating;
}
- (Float32) rating {
  return result.rating;
}
- (ReviewProto_Builder*) setRating:(Float32) value {
  result.hasRating = YES;
  result.rating = value;
  return self;
}
- (ReviewProto_Builder*) clearRating {
  result.hasRating = NO;
  result.rating = 0;
  return self;
}
- (BOOL) hasSnippet {
  return result.hasSnippet;
}
- (NSString*) snippet {
  return result.snippet;
}
- (ReviewProto_Builder*) setSnippet:(NSString*) value {
  result.hasSnippet = YES;
  result.snippet = value;
  return self;
}
- (ReviewProto_Builder*) clearSnippet {
  result.hasSnippet = NO;
  result.snippet = @"";
  return self;
}
- (BOOL) hasContent {
  return result.hasContent;
}
- (NSString*) content {
  return result.content;
}
- (ReviewProto_Builder*) setContent:(NSString*) value {
  result.hasContent = YES;
  result.content = value;
  return self;
}
- (ReviewProto_Builder*) clearContent {
  result.hasContent = NO;
  result.content = @"";
  return self;
}
- (BOOL) hasPublisher {
  return result.hasPublisher;
}
- (NSString*) publisher {
  return result.publisher;
}
- (ReviewProto_Builder*) setPublisher:(NSString*) value {
  result.hasPublisher = YES;
  result.publisher = value;
  return self;
}
- (ReviewProto_Builder*) clearPublisher {
  result.hasPublisher = NO;
  result.publisher = @"";
  return self;
}
- (BOOL) hasAuthor {
  return result.hasAuthor;
}
- (NSString*) author {
  return result.author;
}
- (ReviewProto_Builder*) setAuthor:(NSString*) value {
  result.hasAuthor = YES;
  result.author = value;
  return self;
}
- (ReviewProto_Builder*) clearAuthor {
  result.hasAuthor = NO;
  result.author = @"";
  return self;
}
- (BOOL) hasDate {
  return result.hasDate;
}
- (NSString*) date {
  return result.date;
}
- (ReviewProto_Builder*) setDate:(NSString*) value {
  result.hasDate = YES;
  result.date = value;
  return self;
}
- (ReviewProto_Builder*) clearDate {
  result.hasDate = NO;
  result.date = @"";
  return self;
}
@end

@interface ReviewsListProto ()
@property (retain) NSMutableArray* mutableReviewsList;
@end

@implementation ReviewsListProto

@synthesize mutableReviewsList;
- (void) dealloc {
  self.mutableReviewsList = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
  }
  return self;
}
static ReviewsListProto* defaultReviewsListProtoInstance = nil;
+ (void) initialize {
  if (self == [ReviewsListProto class]) {
    defaultReviewsListProtoInstance = [[ReviewsListProto alloc] init];
  }
}
+ (ReviewsListProto*) defaultInstance {
  return defaultReviewsListProtoInstance;
}
- (ReviewsListProto*) defaultInstance {
  return defaultReviewsListProtoInstance;
}
- (PBDescriptor*) descriptor {
  return [ReviewsListProto descriptor];
}
+ (PBDescriptor*) descriptor {
  return [MetaFlixRoot internal_static_ReviewsListProto_descriptor];
}
- (PBFieldAccessorTable*) fieldAccessorTable {
  return [MetaFlixRoot internal_static_ReviewsListProto_fieldAccessorTable];
}
- (NSArray*) reviewsList {
  return mutableReviewsList;
}
- (ReviewProto*) reviewsAtIndex:(int32_t) index {
  id value = [mutableReviewsList objectAtIndex:index];
  return value;
}
- (BOOL) isInitialized {
  return YES;
}
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output {
  for (ReviewProto* element in self.reviewsList) {
    [output writeMessage:1 value:element];
  }
  [self.unknownFields writeToCodedOutputStream:output];
}
- (int32_t) serializedSize {
  int32_t size = memoizedSerializedSize;
  if (size != -1) {
    return size;
  }

  size = 0;
  for (ReviewProto* element in self.reviewsList) {
    size += computeMessageSize(1, element);
  }
  size += self.unknownFields.serializedSize;
  memoizedSerializedSize = size;
  return size;
}
+ (ReviewsListProto*) parseFromData:(NSData*) data {
  return (ReviewsListProto*)[[[ReviewsListProto builder] mergeFromData:data] build];
}
+ (ReviewsListProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (ReviewsListProto*)[[[ReviewsListProto builder] mergeFromData:data extensionRegistry:extensionRegistry] build];
}
+ (ReviewsListProto*) parseFromInputStream:(NSInputStream*) input {
  return (ReviewsListProto*)[[[ReviewsListProto builder] mergeFromInputStream:input] build];
}
+ (ReviewsListProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (ReviewsListProto*)[[[ReviewsListProto builder] mergeFromInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (ReviewsListProto*) parseFromCodedInputStream:(PBCodedInputStream*) input {
  return (ReviewsListProto*)[[[ReviewsListProto builder] mergeFromCodedInputStream:input] build];
}
+ (ReviewsListProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  return (ReviewsListProto*)[[[ReviewsListProto builder] mergeFromCodedInputStream:input extensionRegistry:extensionRegistry] build];
}
+ (ReviewsListProto_Builder*) builder {
  return [[[ReviewsListProto_Builder alloc] init] autorelease];
}
+ (ReviewsListProto_Builder*) builderWithPrototype:(ReviewsListProto*) prototype {
  return [[ReviewsListProto builder] mergeFromReviewsListProto:prototype];
}
- (ReviewsListProto_Builder*) builder {
  return [ReviewsListProto builder];
}
@end

@interface ReviewsListProto_Builder()
@property (retain) ReviewsListProto* result;
@end

@implementation ReviewsListProto_Builder
@synthesize result;
- (void) dealloc {
  self.result = nil;
  [super dealloc];
}
- (id) init {
  if (self = [super init]) {
    self.result = [[[ReviewsListProto alloc] init] autorelease];
  }
  return self;
}
- (ReviewsListProto*) internalGetResult {
  return result;
}
- (ReviewsListProto_Builder*) clear {
  self.result = [[[ReviewsListProto alloc] init] autorelease];
  return self;
}
- (ReviewsListProto_Builder*) clone {
  return [ReviewsListProto builderWithPrototype:result];
}
- (PBDescriptor*) descriptor {
  return [ReviewsListProto descriptor];
}
- (ReviewsListProto*) defaultInstance {
  return [ReviewsListProto defaultInstance];
}
- (ReviewsListProto*) build {
  if (!self.isInitialized) {
    @throw [NSException exceptionWithName:@"UninitializedMessage" reason:@"" userInfo:nil];
  }
  return [self buildPartial];
}
- (ReviewsListProto*) buildPartial {
  ReviewsListProto* returnMe = [[result retain] autorelease];
  self.result = nil;
  return returnMe;
}
- (ReviewsListProto_Builder*) mergeFromMessage:(id<PBMessage>) other {
  id o = other;
  if ([o isKindOfClass:[ReviewsListProto class]]) {
    return [self mergeFromReviewsListProto:o];
  } else {
    [super mergeFromMessage:other];
    return self;
  }
}
- (ReviewsListProto_Builder*) mergeFromReviewsListProto:(ReviewsListProto*) other {
  if (other == [ReviewsListProto defaultInstance]) {
    return self;
  }
  if (other.mutableReviewsList.count > 0) {
    if (result.mutableReviewsList == nil) {
      result.mutableReviewsList = [NSMutableArray array];
    }
    [result.mutableReviewsList addObjectsFromArray:other.mutableReviewsList];
  }
  [self mergeUnknownFields:other.unknownFields];
  return self;
}
- (ReviewsListProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input {
  return [self mergeFromCodedInputStream:input extensionRegistry:[PBExtensionRegistry emptyRegistry]];
}
- (ReviewsListProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry {
  PBUnknownFieldSet_Builder* unknownFields = [PBUnknownFieldSet builderWithUnknownFields:self.unknownFields];
  while (YES) {
    int32_t tag = [input readTag];
    switch (tag) {
      case 0:
        [self setUnknownFields:[unknownFields build]];
        return self;
      default: {
        if (![self parseUnknownField:input unknownFields:unknownFields extensionRegistry:extensionRegistry tag:tag]) {
          [self setUnknownFields:[unknownFields build]];
          return self;
        }
        break;
      }
      case 10: {
        ReviewProto_Builder* subBuilder = [ReviewProto builder];
        [input readMessage:subBuilder extensionRegistry:extensionRegistry];
        [self addReviews:[subBuilder buildPartial]];
        break;
      }
    }
  }
}
- (NSArray*) reviewsList {
  if (result.mutableReviewsList == nil) { return [NSArray array]; }
  return result.mutableReviewsList;
}
- (ReviewProto*) reviewsAtIndex:(int32_t) index {
  return [result reviewsAtIndex:index];
}
- (ReviewsListProto_Builder*) replaceReviewsAtIndex:(int32_t) index with:(ReviewProto*) value {
  [result.mutableReviewsList replaceObjectAtIndex:index withObject:value];
  return self;
}
- (ReviewsListProto_Builder*) addAllReviews:(NSArray*) values {
  if (result.mutableReviewsList == nil) {
    result.mutableReviewsList = [NSMutableArray array];
  }
  [result.mutableReviewsList addObjectsFromArray:values];
  return self;
}
- (ReviewsListProto_Builder*) clearReviewsList {
  result.mutableReviewsList = nil;
  return self;
}
- (ReviewsListProto_Builder*) addReviews:(ReviewProto*) value {
  if (result.mutableReviewsList == nil) {
    result.mutableReviewsList = [NSMutableArray array];
  }
  [result.mutableReviewsList addObject:value];
  return self;
}
@end