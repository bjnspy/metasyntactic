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

@class PBDescriptor;
@class PBEnumDescriptor;
@class PBEnumValueDescriptor;
@class PBFieldAccessorTable;
@class PBFileDescriptor;
@class PBGeneratedMessage_Builder;
@class AllShowtimesProto;
@class AllShowtimesProto_Builder;
@class MovieProto;
@class MovieProto_Builder;
@class ReviewProto;
@class ReviewProto_Builder;
@class ReviewsListProto;
@class ReviewsListProto_Builder;
@class ShowtimeProto;
@class ShowtimeProto_Builder;
@class TheaterListingsProto;
@class TheaterListingsProto_Builder;
@class TheaterListingsProto_TheaterAndMovieShowtimesProto;
@class TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder;
@class TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto;
@class TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder;
@class TheaterProto;
@class TheaterProto_Builder;

@interface MetaFlixRoot : NSObject {
}
+ (PBFileDescriptor*) descriptor;
+ (PBFileDescriptor*) buildDescriptor;
@end

@interface ShowtimeProto : PBGeneratedMessage {
 @private
  BOOL hasTime:1;
  BOOL hasUrl:1;
  NSString* time;
  NSString* url;
  NSMutableArray* mutableDubbedList;
  NSMutableArray* mutableSubtitledList;
}
- (BOOL) hasTime;
- (BOOL) hasUrl;
@property (readonly, retain) NSString* time;
@property (readonly, retain) NSString* url;
- (NSArray*) dubbedList;
- (NSString*) dubbedAtIndex:(int32_t) index;
- (NSArray*) subtitledList;
- (NSString*) subtitledAtIndex:(int32_t) index;

+ (PBDescriptor*) descriptor;
- (PBDescriptor*) descriptor;
+ (ShowtimeProto*) defaultInstance;
- (ShowtimeProto*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (ShowtimeProto_Builder*) builder;
+ (ShowtimeProto_Builder*) builder;
+ (ShowtimeProto_Builder*) builderWithPrototype:(ShowtimeProto*) prototype;

+ (ShowtimeProto*) parseFromData:(NSData*) data;
+ (ShowtimeProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (ShowtimeProto*) parseFromInputStream:(NSInputStream*) input;
+ (ShowtimeProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (ShowtimeProto*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (ShowtimeProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface ShowtimeProto_Builder : PBGeneratedMessage_Builder {
 @private
  ShowtimeProto* result;
}

- (PBDescriptor*) descriptor;
- (ShowtimeProto*) defaultInstance;

- (ShowtimeProto_Builder*) clear;
- (ShowtimeProto_Builder*) clone;

- (ShowtimeProto*) build;
- (ShowtimeProto*) buildPartial;

- (ShowtimeProto_Builder*) mergeFromMessage:(id<PBMessage>) other;
- (ShowtimeProto_Builder*) mergeFromShowtimeProto:(ShowtimeProto*) other;
- (ShowtimeProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (ShowtimeProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasTime;
- (NSString*) time;
- (ShowtimeProto_Builder*) setTime:(NSString*) value;
- (ShowtimeProto_Builder*) clearTime;

- (BOOL) hasUrl;
- (NSString*) url;
- (ShowtimeProto_Builder*) setUrl:(NSString*) value;
- (ShowtimeProto_Builder*) clearUrl;

- (NSArray*) dubbedList;
- (NSString*) dubbedAtIndex:(int32_t) index;
- (ShowtimeProto_Builder*) replaceDubbedAtIndex:(int32_t) index with:(NSString*) value;
- (ShowtimeProto_Builder*) addDubbed:(NSString*) value;
- (ShowtimeProto_Builder*) addAllDubbed:(NSArray*) values;
- (ShowtimeProto_Builder*) clearDubbedList;

- (NSArray*) subtitledList;
- (NSString*) subtitledAtIndex:(int32_t) index;
- (ShowtimeProto_Builder*) replaceSubtitledAtIndex:(int32_t) index with:(NSString*) value;
- (ShowtimeProto_Builder*) addSubtitled:(NSString*) value;
- (ShowtimeProto_Builder*) addAllSubtitled:(NSArray*) values;
- (ShowtimeProto_Builder*) clearSubtitledList;
@end

@interface AllShowtimesProto : PBGeneratedMessage {
 @private
  BOOL hasVendor:1;
  BOOL hasCaptioning:1;
  NSString* vendor;
  NSString* captioning;
  NSMutableArray* mutableShowtimesList;
}
- (BOOL) hasVendor;
- (BOOL) hasCaptioning;
@property (readonly, retain) NSString* vendor;
@property (readonly, retain) NSString* captioning;
- (NSArray*) showtimesList;
- (ShowtimeProto*) showtimesAtIndex:(int32_t) index;

+ (PBDescriptor*) descriptor;
- (PBDescriptor*) descriptor;
+ (AllShowtimesProto*) defaultInstance;
- (AllShowtimesProto*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (AllShowtimesProto_Builder*) builder;
+ (AllShowtimesProto_Builder*) builder;
+ (AllShowtimesProto_Builder*) builderWithPrototype:(AllShowtimesProto*) prototype;

+ (AllShowtimesProto*) parseFromData:(NSData*) data;
+ (AllShowtimesProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (AllShowtimesProto*) parseFromInputStream:(NSInputStream*) input;
+ (AllShowtimesProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (AllShowtimesProto*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (AllShowtimesProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface AllShowtimesProto_Builder : PBGeneratedMessage_Builder {
 @private
  AllShowtimesProto* result;
}

- (PBDescriptor*) descriptor;
- (AllShowtimesProto*) defaultInstance;

- (AllShowtimesProto_Builder*) clear;
- (AllShowtimesProto_Builder*) clone;

- (AllShowtimesProto*) build;
- (AllShowtimesProto*) buildPartial;

- (AllShowtimesProto_Builder*) mergeFromMessage:(id<PBMessage>) other;
- (AllShowtimesProto_Builder*) mergeFromAllShowtimesProto:(AllShowtimesProto*) other;
- (AllShowtimesProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (AllShowtimesProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (NSArray*) showtimesList;
- (ShowtimeProto*) showtimesAtIndex:(int32_t) index;
- (AllShowtimesProto_Builder*) replaceShowtimesAtIndex:(int32_t) index with:(ShowtimeProto*) value;
- (AllShowtimesProto_Builder*) addShowtimes:(ShowtimeProto*) value;
- (AllShowtimesProto_Builder*) addAllShowtimes:(NSArray*) values;
- (AllShowtimesProto_Builder*) clearShowtimesList;

- (BOOL) hasVendor;
- (NSString*) vendor;
- (AllShowtimesProto_Builder*) setVendor:(NSString*) value;
- (AllShowtimesProto_Builder*) clearVendor;

- (BOOL) hasCaptioning;
- (NSString*) captioning;
- (AllShowtimesProto_Builder*) setCaptioning:(NSString*) value;
- (AllShowtimesProto_Builder*) clearCaptioning;
@end

@interface MovieProto : PBGeneratedMessage {
 @private
  BOOL hasLength:1;
  BOOL hasScore:1;
  BOOL hasIdentifier:1;
  BOOL hasTitle:1;
  BOOL hasLanguage:1;
  BOOL hasGenre:1;
  BOOL hasDescription:1;
  BOOL hasRawRating:1;
  BOOL hasIMDbUrl:1;
  BOOL hasReleaseDate:1;
  int32_t length;
  int32_t score;
  NSString* identifier;
  NSString* title;
  NSString* language;
  NSString* genre;
  NSString* description;
  NSString* rawRating;
  NSString* iMDbUrl;
  NSString* releaseDate;
  NSMutableArray* mutableDirectorList;
  NSMutableArray* mutableCastList;
  NSMutableArray* mutableDubbedList;
  NSMutableArray* mutableSubtitledList;
}
- (BOOL) hasIdentifier;
- (BOOL) hasTitle;
- (BOOL) hasLength;
- (BOOL) hasLanguage;
- (BOOL) hasGenre;
- (BOOL) hasDescription;
- (BOOL) hasRawRating;
- (BOOL) hasScore;
- (BOOL) hasIMDbUrl;
- (BOOL) hasReleaseDate;
@property (readonly, retain) NSString* identifier;
@property (readonly, retain) NSString* title;
@property (readonly) int32_t length;
@property (readonly, retain) NSString* language;
@property (readonly, retain) NSString* genre;
@property (readonly, retain) NSString* description;
@property (readonly, retain) NSString* rawRating;
@property (readonly) int32_t score;
@property (readonly, retain) NSString* iMDbUrl;
@property (readonly, retain) NSString* releaseDate;
- (NSArray*) directorList;
- (NSString*) directorAtIndex:(int32_t) index;
- (NSArray*) castList;
- (NSString*) castAtIndex:(int32_t) index;
- (NSArray*) dubbedList;
- (NSString*) dubbedAtIndex:(int32_t) index;
- (NSArray*) subtitledList;
- (NSString*) subtitledAtIndex:(int32_t) index;

+ (PBDescriptor*) descriptor;
- (PBDescriptor*) descriptor;
+ (MovieProto*) defaultInstance;
- (MovieProto*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (MovieProto_Builder*) builder;
+ (MovieProto_Builder*) builder;
+ (MovieProto_Builder*) builderWithPrototype:(MovieProto*) prototype;

+ (MovieProto*) parseFromData:(NSData*) data;
+ (MovieProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (MovieProto*) parseFromInputStream:(NSInputStream*) input;
+ (MovieProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (MovieProto*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (MovieProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface MovieProto_Builder : PBGeneratedMessage_Builder {
 @private
  MovieProto* result;
}

- (PBDescriptor*) descriptor;
- (MovieProto*) defaultInstance;

- (MovieProto_Builder*) clear;
- (MovieProto_Builder*) clone;

- (MovieProto*) build;
- (MovieProto*) buildPartial;

- (MovieProto_Builder*) mergeFromMessage:(id<PBMessage>) other;
- (MovieProto_Builder*) mergeFromMovieProto:(MovieProto*) other;
- (MovieProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (MovieProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasIdentifier;
- (NSString*) identifier;
- (MovieProto_Builder*) setIdentifier:(NSString*) value;
- (MovieProto_Builder*) clearIdentifier;

- (BOOL) hasTitle;
- (NSString*) title;
- (MovieProto_Builder*) setTitle:(NSString*) value;
- (MovieProto_Builder*) clearTitle;

- (BOOL) hasLength;
- (int32_t) length;
- (MovieProto_Builder*) setLength:(int32_t) value;
- (MovieProto_Builder*) clearLength;

- (BOOL) hasLanguage;
- (NSString*) language;
- (MovieProto_Builder*) setLanguage:(NSString*) value;
- (MovieProto_Builder*) clearLanguage;

- (BOOL) hasGenre;
- (NSString*) genre;
- (MovieProto_Builder*) setGenre:(NSString*) value;
- (MovieProto_Builder*) clearGenre;

- (BOOL) hasDescription;
- (NSString*) description;
- (MovieProto_Builder*) setDescription:(NSString*) value;
- (MovieProto_Builder*) clearDescription;

- (BOOL) hasRawRating;
- (NSString*) rawRating;
- (MovieProto_Builder*) setRawRating:(NSString*) value;
- (MovieProto_Builder*) clearRawRating;

- (BOOL) hasScore;
- (int32_t) score;
- (MovieProto_Builder*) setScore:(int32_t) value;
- (MovieProto_Builder*) clearScore;

- (BOOL) hasIMDbUrl;
- (NSString*) iMDbUrl;
- (MovieProto_Builder*) setIMDbUrl:(NSString*) value;
- (MovieProto_Builder*) clearIMDbUrl;

- (NSArray*) directorList;
- (NSString*) directorAtIndex:(int32_t) index;
- (MovieProto_Builder*) replaceDirectorAtIndex:(int32_t) index with:(NSString*) value;
- (MovieProto_Builder*) addDirector:(NSString*) value;
- (MovieProto_Builder*) addAllDirector:(NSArray*) values;
- (MovieProto_Builder*) clearDirectorList;

- (NSArray*) castList;
- (NSString*) castAtIndex:(int32_t) index;
- (MovieProto_Builder*) replaceCastAtIndex:(int32_t) index with:(NSString*) value;
- (MovieProto_Builder*) addCast:(NSString*) value;
- (MovieProto_Builder*) addAllCast:(NSArray*) values;
- (MovieProto_Builder*) clearCastList;

- (NSArray*) dubbedList;
- (NSString*) dubbedAtIndex:(int32_t) index;
- (MovieProto_Builder*) replaceDubbedAtIndex:(int32_t) index with:(NSString*) value;
- (MovieProto_Builder*) addDubbed:(NSString*) value;
- (MovieProto_Builder*) addAllDubbed:(NSArray*) values;
- (MovieProto_Builder*) clearDubbedList;

- (NSArray*) subtitledList;
- (NSString*) subtitledAtIndex:(int32_t) index;
- (MovieProto_Builder*) replaceSubtitledAtIndex:(int32_t) index with:(NSString*) value;
- (MovieProto_Builder*) addSubtitled:(NSString*) value;
- (MovieProto_Builder*) addAllSubtitled:(NSArray*) values;
- (MovieProto_Builder*) clearSubtitledList;

- (BOOL) hasReleaseDate;
- (NSString*) releaseDate;
- (MovieProto_Builder*) setReleaseDate:(NSString*) value;
- (MovieProto_Builder*) clearReleaseDate;
@end

@interface TheaterProto : PBGeneratedMessage {
 @private
  BOOL hasLatitude:1;
  BOOL hasLongitude:1;
  BOOL hasIdentifier:1;
  BOOL hasName:1;
  BOOL hasStreetAddress:1;
  BOOL hasCity:1;
  BOOL hasState:1;
  BOOL hasPostalCode:1;
  BOOL hasCountry:1;
  BOOL hasPhone:1;
  Float64 latitude;
  Float64 longitude;
  NSString* identifier;
  NSString* name;
  NSString* streetAddress;
  NSString* city;
  NSString* state;
  NSString* postalCode;
  NSString* country;
  NSString* phone;
}
- (BOOL) hasIdentifier;
- (BOOL) hasName;
- (BOOL) hasStreetAddress;
- (BOOL) hasCity;
- (BOOL) hasState;
- (BOOL) hasPostalCode;
- (BOOL) hasCountry;
- (BOOL) hasPhone;
- (BOOL) hasLatitude;
- (BOOL) hasLongitude;
@property (readonly, retain) NSString* identifier;
@property (readonly, retain) NSString* name;
@property (readonly, retain) NSString* streetAddress;
@property (readonly, retain) NSString* city;
@property (readonly, retain) NSString* state;
@property (readonly, retain) NSString* postalCode;
@property (readonly, retain) NSString* country;
@property (readonly, retain) NSString* phone;
@property (readonly) Float64 latitude;
@property (readonly) Float64 longitude;

+ (PBDescriptor*) descriptor;
- (PBDescriptor*) descriptor;
+ (TheaterProto*) defaultInstance;
- (TheaterProto*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (TheaterProto_Builder*) builder;
+ (TheaterProto_Builder*) builder;
+ (TheaterProto_Builder*) builderWithPrototype:(TheaterProto*) prototype;

+ (TheaterProto*) parseFromData:(NSData*) data;
+ (TheaterProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TheaterProto*) parseFromInputStream:(NSInputStream*) input;
+ (TheaterProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TheaterProto*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (TheaterProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface TheaterProto_Builder : PBGeneratedMessage_Builder {
 @private
  TheaterProto* result;
}

- (PBDescriptor*) descriptor;
- (TheaterProto*) defaultInstance;

- (TheaterProto_Builder*) clear;
- (TheaterProto_Builder*) clone;

- (TheaterProto*) build;
- (TheaterProto*) buildPartial;

- (TheaterProto_Builder*) mergeFromMessage:(id<PBMessage>) other;
- (TheaterProto_Builder*) mergeFromTheaterProto:(TheaterProto*) other;
- (TheaterProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (TheaterProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasIdentifier;
- (NSString*) identifier;
- (TheaterProto_Builder*) setIdentifier:(NSString*) value;
- (TheaterProto_Builder*) clearIdentifier;

- (BOOL) hasName;
- (NSString*) name;
- (TheaterProto_Builder*) setName:(NSString*) value;
- (TheaterProto_Builder*) clearName;

- (BOOL) hasStreetAddress;
- (NSString*) streetAddress;
- (TheaterProto_Builder*) setStreetAddress:(NSString*) value;
- (TheaterProto_Builder*) clearStreetAddress;

- (BOOL) hasCity;
- (NSString*) city;
- (TheaterProto_Builder*) setCity:(NSString*) value;
- (TheaterProto_Builder*) clearCity;

- (BOOL) hasState;
- (NSString*) state;
- (TheaterProto_Builder*) setState:(NSString*) value;
- (TheaterProto_Builder*) clearState;

- (BOOL) hasPostalCode;
- (NSString*) postalCode;
- (TheaterProto_Builder*) setPostalCode:(NSString*) value;
- (TheaterProto_Builder*) clearPostalCode;

- (BOOL) hasCountry;
- (NSString*) country;
- (TheaterProto_Builder*) setCountry:(NSString*) value;
- (TheaterProto_Builder*) clearCountry;

- (BOOL) hasPhone;
- (NSString*) phone;
- (TheaterProto_Builder*) setPhone:(NSString*) value;
- (TheaterProto_Builder*) clearPhone;

- (BOOL) hasLatitude;
- (Float64) latitude;
- (TheaterProto_Builder*) setLatitude:(Float64) value;
- (TheaterProto_Builder*) clearLatitude;

- (BOOL) hasLongitude;
- (Float64) longitude;
- (TheaterProto_Builder*) setLongitude:(Float64) value;
- (TheaterProto_Builder*) clearLongitude;
@end

@interface TheaterListingsProto : PBGeneratedMessage {
 @private
  NSMutableArray* mutableMoviesList;
  NSMutableArray* mutableTheaterAndMovieShowtimesList;
}
- (NSArray*) moviesList;
- (MovieProto*) moviesAtIndex:(int32_t) index;
- (NSArray*) theaterAndMovieShowtimesList;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto*) theaterAndMovieShowtimesAtIndex:(int32_t) index;

+ (PBDescriptor*) descriptor;
- (PBDescriptor*) descriptor;
+ (TheaterListingsProto*) defaultInstance;
- (TheaterListingsProto*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (TheaterListingsProto_Builder*) builder;
+ (TheaterListingsProto_Builder*) builder;
+ (TheaterListingsProto_Builder*) builderWithPrototype:(TheaterListingsProto*) prototype;

+ (TheaterListingsProto*) parseFromData:(NSData*) data;
+ (TheaterListingsProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TheaterListingsProto*) parseFromInputStream:(NSInputStream*) input;
+ (TheaterListingsProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TheaterListingsProto*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (TheaterListingsProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface TheaterListingsProto_TheaterAndMovieShowtimesProto : PBGeneratedMessage {
 @private
  BOOL hasTheater:1;
  TheaterProto* theater;
  NSMutableArray* mutableMovieAndShowtimesList;
}
- (BOOL) hasTheater;
@property (readonly, retain) TheaterProto* theater;
- (NSArray*) movieAndShowtimesList;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) movieAndShowtimesAtIndex:(int32_t) index;

+ (PBDescriptor*) descriptor;
- (PBDescriptor*) descriptor;
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto*) defaultInstance;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) builder;
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) builder;
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) builderWithPrototype:(TheaterListingsProto_TheaterAndMovieShowtimesProto*) prototype;

+ (TheaterListingsProto_TheaterAndMovieShowtimesProto*) parseFromData:(NSData*) data;
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto*) parseFromInputStream:(NSInputStream*) input;
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto : PBGeneratedMessage {
 @private
  BOOL hasMovieIdentifier:1;
  BOOL hasShowtimes:1;
  NSString* movieIdentifier;
  AllShowtimesProto* showtimes;
}
- (BOOL) hasMovieIdentifier;
- (BOOL) hasShowtimes;
@property (readonly, retain) NSString* movieIdentifier;
@property (readonly, retain) AllShowtimesProto* showtimes;

+ (PBDescriptor*) descriptor;
- (PBDescriptor*) descriptor;
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) defaultInstance;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) builder;
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) builder;
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) builderWithPrototype:(TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) prototype;

+ (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) parseFromData:(NSData*) data;
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) parseFromInputStream:(NSInputStream*) input;
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder : PBGeneratedMessage_Builder {
 @private
  TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto* result;
}

- (PBDescriptor*) descriptor;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) defaultInstance;

- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) clear;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) clone;

- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) build;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) buildPartial;

- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) mergeFromMessage:(id<PBMessage>) other;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) mergeFromTheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto:(TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) other;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasMovieIdentifier;
- (NSString*) movieIdentifier;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) setMovieIdentifier:(NSString*) value;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) clearMovieIdentifier;

- (BOOL) hasShowtimes;
- (AllShowtimesProto*) showtimes;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) setShowtimes:(AllShowtimesProto*) value;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) setShowtimesBuilder:(AllShowtimesProto_Builder*) builderForValue;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) mergeShowtimes:(AllShowtimesProto*) value;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) clearShowtimes;
@end

@interface TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder : PBGeneratedMessage_Builder {
 @private
  TheaterListingsProto_TheaterAndMovieShowtimesProto* result;
}

- (PBDescriptor*) descriptor;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto*) defaultInstance;

- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) clear;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) clone;

- (TheaterListingsProto_TheaterAndMovieShowtimesProto*) build;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto*) buildPartial;

- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) mergeFromMessage:(id<PBMessage>) other;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) mergeFromTheaterListingsProto_TheaterAndMovieShowtimesProto:(TheaterListingsProto_TheaterAndMovieShowtimesProto*) other;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasTheater;
- (TheaterProto*) theater;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) setTheater:(TheaterProto*) value;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) setTheaterBuilder:(TheaterProto_Builder*) builderForValue;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) mergeTheater:(TheaterProto*) value;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) clearTheater;

- (NSArray*) movieAndShowtimesList;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) movieAndShowtimesAtIndex:(int32_t) index;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) replaceMovieAndShowtimesAtIndex:(int32_t) index with:(TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) value;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) addMovieAndShowtimes:(TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) value;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) addAllMovieAndShowtimes:(NSArray*) values;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) clearMovieAndShowtimesList;
@end

@interface TheaterListingsProto_Builder : PBGeneratedMessage_Builder {
 @private
  TheaterListingsProto* result;
}

- (PBDescriptor*) descriptor;
- (TheaterListingsProto*) defaultInstance;

- (TheaterListingsProto_Builder*) clear;
- (TheaterListingsProto_Builder*) clone;

- (TheaterListingsProto*) build;
- (TheaterListingsProto*) buildPartial;

- (TheaterListingsProto_Builder*) mergeFromMessage:(id<PBMessage>) other;
- (TheaterListingsProto_Builder*) mergeFromTheaterListingsProto:(TheaterListingsProto*) other;
- (TheaterListingsProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (TheaterListingsProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (NSArray*) moviesList;
- (MovieProto*) moviesAtIndex:(int32_t) index;
- (TheaterListingsProto_Builder*) replaceMoviesAtIndex:(int32_t) index with:(MovieProto*) value;
- (TheaterListingsProto_Builder*) addMovies:(MovieProto*) value;
- (TheaterListingsProto_Builder*) addAllMovies:(NSArray*) values;
- (TheaterListingsProto_Builder*) clearMoviesList;

- (NSArray*) theaterAndMovieShowtimesList;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto*) theaterAndMovieShowtimesAtIndex:(int32_t) index;
- (TheaterListingsProto_Builder*) replaceTheaterAndMovieShowtimesAtIndex:(int32_t) index with:(TheaterListingsProto_TheaterAndMovieShowtimesProto*) value;
- (TheaterListingsProto_Builder*) addTheaterAndMovieShowtimes:(TheaterListingsProto_TheaterAndMovieShowtimesProto*) value;
- (TheaterListingsProto_Builder*) addAllTheaterAndMovieShowtimes:(NSArray*) values;
- (TheaterListingsProto_Builder*) clearTheaterAndMovieShowtimesList;
@end

@interface ReviewProto : PBGeneratedMessage {
 @private
  BOOL hasRating:1;
  BOOL hasTitle:1;
  BOOL hasUrl:1;
  BOOL hasSnippet:1;
  BOOL hasContent:1;
  BOOL hasPublisher:1;
  BOOL hasAuthor:1;
  BOOL hasDate:1;
  Float32 rating;
  NSString* title;
  NSString* url;
  NSString* snippet;
  NSString* content;
  NSString* publisher;
  NSString* author;
  NSString* date;
}
- (BOOL) hasTitle;
- (BOOL) hasUrl;
- (BOOL) hasRating;
- (BOOL) hasSnippet;
- (BOOL) hasContent;
- (BOOL) hasPublisher;
- (BOOL) hasAuthor;
- (BOOL) hasDate;
@property (readonly, retain) NSString* title;
@property (readonly, retain) NSString* url;
@property (readonly) Float32 rating;
@property (readonly, retain) NSString* snippet;
@property (readonly, retain) NSString* content;
@property (readonly, retain) NSString* publisher;
@property (readonly, retain) NSString* author;
@property (readonly, retain) NSString* date;

+ (PBDescriptor*) descriptor;
- (PBDescriptor*) descriptor;
+ (ReviewProto*) defaultInstance;
- (ReviewProto*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (ReviewProto_Builder*) builder;
+ (ReviewProto_Builder*) builder;
+ (ReviewProto_Builder*) builderWithPrototype:(ReviewProto*) prototype;

+ (ReviewProto*) parseFromData:(NSData*) data;
+ (ReviewProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (ReviewProto*) parseFromInputStream:(NSInputStream*) input;
+ (ReviewProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (ReviewProto*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (ReviewProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface ReviewProto_Builder : PBGeneratedMessage_Builder {
 @private
  ReviewProto* result;
}

- (PBDescriptor*) descriptor;
- (ReviewProto*) defaultInstance;

- (ReviewProto_Builder*) clear;
- (ReviewProto_Builder*) clone;

- (ReviewProto*) build;
- (ReviewProto*) buildPartial;

- (ReviewProto_Builder*) mergeFromMessage:(id<PBMessage>) other;
- (ReviewProto_Builder*) mergeFromReviewProto:(ReviewProto*) other;
- (ReviewProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (ReviewProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (BOOL) hasTitle;
- (NSString*) title;
- (ReviewProto_Builder*) setTitle:(NSString*) value;
- (ReviewProto_Builder*) clearTitle;

- (BOOL) hasUrl;
- (NSString*) url;
- (ReviewProto_Builder*) setUrl:(NSString*) value;
- (ReviewProto_Builder*) clearUrl;

- (BOOL) hasRating;
- (Float32) rating;
- (ReviewProto_Builder*) setRating:(Float32) value;
- (ReviewProto_Builder*) clearRating;

- (BOOL) hasSnippet;
- (NSString*) snippet;
- (ReviewProto_Builder*) setSnippet:(NSString*) value;
- (ReviewProto_Builder*) clearSnippet;

- (BOOL) hasContent;
- (NSString*) content;
- (ReviewProto_Builder*) setContent:(NSString*) value;
- (ReviewProto_Builder*) clearContent;

- (BOOL) hasPublisher;
- (NSString*) publisher;
- (ReviewProto_Builder*) setPublisher:(NSString*) value;
- (ReviewProto_Builder*) clearPublisher;

- (BOOL) hasAuthor;
- (NSString*) author;
- (ReviewProto_Builder*) setAuthor:(NSString*) value;
- (ReviewProto_Builder*) clearAuthor;

- (BOOL) hasDate;
- (NSString*) date;
- (ReviewProto_Builder*) setDate:(NSString*) value;
- (ReviewProto_Builder*) clearDate;
@end

@interface ReviewsListProto : PBGeneratedMessage {
 @private
  NSMutableArray* mutableReviewsList;
}
- (NSArray*) reviewsList;
- (ReviewProto*) reviewsAtIndex:(int32_t) index;

+ (PBDescriptor*) descriptor;
- (PBDescriptor*) descriptor;
+ (ReviewsListProto*) defaultInstance;
- (ReviewsListProto*) defaultInstance;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
- (ReviewsListProto_Builder*) builder;
+ (ReviewsListProto_Builder*) builder;
+ (ReviewsListProto_Builder*) builderWithPrototype:(ReviewsListProto*) prototype;

+ (ReviewsListProto*) parseFromData:(NSData*) data;
+ (ReviewsListProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (ReviewsListProto*) parseFromInputStream:(NSInputStream*) input;
+ (ReviewsListProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (ReviewsListProto*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (ReviewsListProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface ReviewsListProto_Builder : PBGeneratedMessage_Builder {
 @private
  ReviewsListProto* result;
}

- (PBDescriptor*) descriptor;
- (ReviewsListProto*) defaultInstance;

- (ReviewsListProto_Builder*) clear;
- (ReviewsListProto_Builder*) clone;

- (ReviewsListProto*) build;
- (ReviewsListProto*) buildPartial;

- (ReviewsListProto_Builder*) mergeFromMessage:(id<PBMessage>) other;
- (ReviewsListProto_Builder*) mergeFromReviewsListProto:(ReviewsListProto*) other;
- (ReviewsListProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input;
- (ReviewsListProto_Builder*) mergeFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;

- (NSArray*) reviewsList;
- (ReviewProto*) reviewsAtIndex:(int32_t) index;
- (ReviewsListProto_Builder*) replaceReviewsAtIndex:(int32_t) index with:(ReviewProto*) value;
- (ReviewsListProto_Builder*) addReviews:(ReviewProto*) value;
- (ReviewsListProto_Builder*) addAllReviews:(NSArray*) values;
- (ReviewsListProto_Builder*) clearReviewsList;
@end