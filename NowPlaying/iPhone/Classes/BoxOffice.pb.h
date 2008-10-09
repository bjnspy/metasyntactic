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

#import <ProtocolBuffers/ProtocolBuffers.h>

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

@interface BoxOfficeProtoRoot : NSObject {
}
+ (PBFileDescriptor*) descriptor;
+ (PBFileDescriptor*) buildDescriptor;
@end

@interface ShowtimeProto : PBGeneratedMessage {
  BOOL hasTime;
  NSString* time;
  BOOL hasUrl;
  NSString* url;
  NSMutableArray* mutableDubbedList;
  NSMutableArray* mutableSubtitledList;
}
@property (readonly) BOOL hasTime;
@property (retain, readonly) NSString* time;
@property (readonly) BOOL hasUrl;
@property (retain, readonly) NSString* url;
- (NSArray*) dubbedList;
- (NSString*) dubbedAtIndex:(int32_t) index;
- (NSArray*) subtitledList;
- (NSString*) subtitledAtIndex:(int32_t) index;

+ (PBDescriptor*) descriptor;
+ (ShowtimeProto*) defaultInstance;
- (ShowtimeProto*) defaultInstanceForType;
- (PBFieldAccessorTable*) internalGetFieldAccessorTable;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
+ (ShowtimeProto_Builder*) newBuilder;
- (ShowtimeProto_Builder*) newBuilderForType;
+ (ShowtimeProto_Builder*) newBuilderWithShowtimeProto:(ShowtimeProto*) prototype;

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
@property (retain) ShowtimeProto* result;

- (PBDescriptor*) descriptorForType;
- (ShowtimeProto*) defaultInstanceForType;

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
- (ShowtimeProto_Builder*) replaceDubbedAtIndex:(int32_t) index withDubbed:(NSString*) value;
- (ShowtimeProto_Builder*) addDubbed:(NSString*) value;
- (ShowtimeProto_Builder*) addAllDubbed:(NSArray*) values;
- (ShowtimeProto_Builder*) clearDubbedList;

- (NSArray*) subtitledList;
- (NSString*) subtitledAtIndex:(int32_t) index;
- (ShowtimeProto_Builder*) replaceSubtitledAtIndex:(int32_t) index withSubtitled:(NSString*) value;
- (ShowtimeProto_Builder*) addSubtitled:(NSString*) value;
- (ShowtimeProto_Builder*) addAllSubtitled:(NSArray*) values;
- (ShowtimeProto_Builder*) clearSubtitledList;
@end

@interface AllShowtimesProto : PBGeneratedMessage {
  NSMutableArray* mutableShowtimesList;
  BOOL hasVendor;
  NSString* vendor;
  BOOL hasCaptioning;
  NSString* captioning;
}
@property (readonly) BOOL hasVendor;
@property (retain, readonly) NSString* vendor;
@property (readonly) BOOL hasCaptioning;
@property (retain, readonly) NSString* captioning;
- (NSArray*) showtimesList;
- (ShowtimeProto*) showtimesAtIndex:(int32_t) index;

+ (PBDescriptor*) descriptor;
+ (AllShowtimesProto*) defaultInstance;
- (AllShowtimesProto*) defaultInstanceForType;
- (PBFieldAccessorTable*) internalGetFieldAccessorTable;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
+ (AllShowtimesProto_Builder*) newBuilder;
- (AllShowtimesProto_Builder*) newBuilderForType;
+ (AllShowtimesProto_Builder*) newBuilderWithAllShowtimesProto:(AllShowtimesProto*) prototype;

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
@property (retain) AllShowtimesProto* result;

- (PBDescriptor*) descriptorForType;
- (AllShowtimesProto*) defaultInstanceForType;

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
- (AllShowtimesProto_Builder*) replaceShowtimesAtIndex:(int32_t) index withShowtimes:(ShowtimeProto*) value;
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
  BOOL hasIdentifier;
  NSString* identifier;
  BOOL hasTitle;
  NSString* title;
  BOOL hasLength;
  int32_t length;
  BOOL hasLanguage;
  NSString* language;
  BOOL hasGenre;
  NSString* genre;
  BOOL hasDescription;
  NSString* description;
  BOOL hasRawRating;
  NSString* rawRating;
  BOOL hasScore;
  int32_t score;
  BOOL hasIMDbUrl;
  NSString* iMDbUrl;
  NSMutableArray* mutableDirectorList;
  NSMutableArray* mutableCastList;
  NSMutableArray* mutableDubbedList;
  NSMutableArray* mutableSubtitledList;
  BOOL hasReleaseDate;
  NSString* releaseDate;
}
@property (readonly) BOOL hasIdentifier;
@property (retain, readonly) NSString* identifier;
@property (readonly) BOOL hasTitle;
@property (retain, readonly) NSString* title;
@property (readonly) BOOL hasLength;
@property (readonly) int32_t length;
@property (readonly) BOOL hasLanguage;
@property (retain, readonly) NSString* language;
@property (readonly) BOOL hasGenre;
@property (retain, readonly) NSString* genre;
@property (readonly) BOOL hasDescription;
@property (retain, readonly) NSString* description;
@property (readonly) BOOL hasRawRating;
@property (retain, readonly) NSString* rawRating;
@property (readonly) BOOL hasScore;
@property (readonly) int32_t score;
@property (readonly) BOOL hasIMDbUrl;
@property (retain, readonly) NSString* iMDbUrl;
@property (readonly) BOOL hasReleaseDate;
@property (retain, readonly) NSString* releaseDate;
- (NSArray*) directorList;
- (NSString*) directorAtIndex:(int32_t) index;
- (NSArray*) castList;
- (NSString*) castAtIndex:(int32_t) index;
- (NSArray*) dubbedList;
- (NSString*) dubbedAtIndex:(int32_t) index;
- (NSArray*) subtitledList;
- (NSString*) subtitledAtIndex:(int32_t) index;

+ (PBDescriptor*) descriptor;
+ (MovieProto*) defaultInstance;
- (MovieProto*) defaultInstanceForType;
- (PBFieldAccessorTable*) internalGetFieldAccessorTable;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
+ (MovieProto_Builder*) newBuilder;
- (MovieProto_Builder*) newBuilderForType;
+ (MovieProto_Builder*) newBuilderWithMovieProto:(MovieProto*) prototype;

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
@property (retain) MovieProto* result;

- (PBDescriptor*) descriptorForType;
- (MovieProto*) defaultInstanceForType;

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
- (MovieProto_Builder*) replaceDirectorAtIndex:(int32_t) index withDirector:(NSString*) value;
- (MovieProto_Builder*) addDirector:(NSString*) value;
- (MovieProto_Builder*) addAllDirector:(NSArray*) values;
- (MovieProto_Builder*) clearDirectorList;

- (NSArray*) castList;
- (NSString*) castAtIndex:(int32_t) index;
- (MovieProto_Builder*) replaceCastAtIndex:(int32_t) index withCast:(NSString*) value;
- (MovieProto_Builder*) addCast:(NSString*) value;
- (MovieProto_Builder*) addAllCast:(NSArray*) values;
- (MovieProto_Builder*) clearCastList;

- (NSArray*) dubbedList;
- (NSString*) dubbedAtIndex:(int32_t) index;
- (MovieProto_Builder*) replaceDubbedAtIndex:(int32_t) index withDubbed:(NSString*) value;
- (MovieProto_Builder*) addDubbed:(NSString*) value;
- (MovieProto_Builder*) addAllDubbed:(NSArray*) values;
- (MovieProto_Builder*) clearDubbedList;

- (NSArray*) subtitledList;
- (NSString*) subtitledAtIndex:(int32_t) index;
- (MovieProto_Builder*) replaceSubtitledAtIndex:(int32_t) index withSubtitled:(NSString*) value;
- (MovieProto_Builder*) addSubtitled:(NSString*) value;
- (MovieProto_Builder*) addAllSubtitled:(NSArray*) values;
- (MovieProto_Builder*) clearSubtitledList;

- (BOOL) hasReleaseDate;
- (NSString*) releaseDate;
- (MovieProto_Builder*) setReleaseDate:(NSString*) value;
- (MovieProto_Builder*) clearReleaseDate;
@end

@interface TheaterProto : PBGeneratedMessage {
  BOOL hasIdentifier;
  NSString* identifier;
  BOOL hasName;
  NSString* name;
  BOOL hasStreetAddress;
  NSString* streetAddress;
  BOOL hasCity;
  NSString* city;
  BOOL hasState;
  NSString* state;
  BOOL hasPostalCode;
  NSString* postalCode;
  BOOL hasCountry;
  NSString* country;
  BOOL hasPhone;
  NSString* phone;
  BOOL hasLatitude;
  Float64 latitude;
  BOOL hasLongitude;
  Float64 longitude;
}
@property (readonly) BOOL hasIdentifier;
@property (retain, readonly) NSString* identifier;
@property (readonly) BOOL hasName;
@property (retain, readonly) NSString* name;
@property (readonly) BOOL hasStreetAddress;
@property (retain, readonly) NSString* streetAddress;
@property (readonly) BOOL hasCity;
@property (retain, readonly) NSString* city;
@property (readonly) BOOL hasState;
@property (retain, readonly) NSString* state;
@property (readonly) BOOL hasPostalCode;
@property (retain, readonly) NSString* postalCode;
@property (readonly) BOOL hasCountry;
@property (retain, readonly) NSString* country;
@property (readonly) BOOL hasPhone;
@property (retain, readonly) NSString* phone;
@property (readonly) BOOL hasLatitude;
@property (readonly) Float64 latitude;
@property (readonly) BOOL hasLongitude;
@property (readonly) Float64 longitude;

+ (PBDescriptor*) descriptor;
+ (TheaterProto*) defaultInstance;
- (TheaterProto*) defaultInstanceForType;
- (PBFieldAccessorTable*) internalGetFieldAccessorTable;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
+ (TheaterProto_Builder*) newBuilder;
- (TheaterProto_Builder*) newBuilderForType;
+ (TheaterProto_Builder*) newBuilderWithTheaterProto:(TheaterProto*) prototype;

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
@property (retain) TheaterProto* result;

- (PBDescriptor*) descriptorForType;
- (TheaterProto*) defaultInstanceForType;

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
  NSMutableArray* mutableMoviesList;
  NSMutableArray* mutableTheaterAndMovieShowtimesList;
}
- (NSArray*) moviesList;
- (MovieProto*) moviesAtIndex:(int32_t) index;
- (NSArray*) theaterAndMovieShowtimesList;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto*) theaterAndMovieShowtimesAtIndex:(int32_t) index;

+ (PBDescriptor*) descriptor;
+ (TheaterListingsProto*) defaultInstance;
- (TheaterListingsProto*) defaultInstanceForType;
- (PBFieldAccessorTable*) internalGetFieldAccessorTable;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
+ (TheaterListingsProto_Builder*) newBuilder;
- (TheaterListingsProto_Builder*) newBuilderForType;
+ (TheaterListingsProto_Builder*) newBuilderWithTheaterListingsProto:(TheaterListingsProto*) prototype;

+ (TheaterListingsProto*) parseFromData:(NSData*) data;
+ (TheaterListingsProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TheaterListingsProto*) parseFromInputStream:(NSInputStream*) input;
+ (TheaterListingsProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TheaterListingsProto*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (TheaterListingsProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface TheaterListingsProto_TheaterAndMovieShowtimesProto : PBGeneratedMessage {
  BOOL hasTheater;
  TheaterProto* theater;
  NSMutableArray* mutableMovieAndShowtimesList;
}
@property (readonly) BOOL hasTheater;
@property (retain, readonly) TheaterProto* theater;
- (NSArray*) movieAndShowtimesList;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) movieAndShowtimesAtIndex:(int32_t) index;

+ (PBDescriptor*) descriptor;
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto*) defaultInstance;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto*) defaultInstanceForType;
- (PBFieldAccessorTable*) internalGetFieldAccessorTable;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) newBuilder;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) newBuilderForType;
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) newBuilderWithTheaterListingsProto_TheaterAndMovieShowtimesProto:(TheaterListingsProto_TheaterAndMovieShowtimesProto*) prototype;

+ (TheaterListingsProto_TheaterAndMovieShowtimesProto*) parseFromData:(NSData*) data;
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto*) parseFromData:(NSData*) data extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto*) parseFromInputStream:(NSInputStream*) input;
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto*) parseFromInputStream:(NSInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto*) parseFromCodedInputStream:(PBCodedInputStream*) input;
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto*) parseFromCodedInputStream:(PBCodedInputStream*) input extensionRegistry:(PBExtensionRegistry*) extensionRegistry;
@end

@interface TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto : PBGeneratedMessage {
  BOOL hasMovieIdentifier;
  NSString* movieIdentifier;
  BOOL hasShowtimes;
  AllShowtimesProto* showtimes;
}
@property (readonly) BOOL hasMovieIdentifier;
@property (retain, readonly) NSString* movieIdentifier;
@property (readonly) BOOL hasShowtimes;
@property (retain, readonly) AllShowtimesProto* showtimes;

+ (PBDescriptor*) descriptor;
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) defaultInstance;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) defaultInstanceForType;
- (PBFieldAccessorTable*) internalGetFieldAccessorTable;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) newBuilder;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) newBuilderForType;
+ (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto_Builder*) newBuilderWithTheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto:(TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) prototype;

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
@property (retain) TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto* result;

- (PBDescriptor*) descriptorForType;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) defaultInstanceForType;

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
- (id<PBMessage_Builder>) setShowtimes:(AllShowtimesProto*) value;
- (id<PBMessage_Builder>) setShowtimesBuilder:(AllShowtimesProto_Builder*) builderForValue;
- (id<PBMessage_Builder>) mergeShowtimes:(AllShowtimesProto*) value;
- (id<PBMessage_Builder>) clearShowtimes;
@end

@interface TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder : PBGeneratedMessage_Builder {
 @private
  TheaterListingsProto_TheaterAndMovieShowtimesProto* result;
}
@property (retain) TheaterListingsProto_TheaterAndMovieShowtimesProto* result;

- (PBDescriptor*) descriptorForType;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto*) defaultInstanceForType;

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
- (id<PBMessage_Builder>) setTheater:(TheaterProto*) value;
- (id<PBMessage_Builder>) setTheaterBuilder:(TheaterProto_Builder*) builderForValue;
- (id<PBMessage_Builder>) mergeTheater:(TheaterProto*) value;
- (id<PBMessage_Builder>) clearTheater;

- (NSArray*) movieAndShowtimesList;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) movieAndShowtimesAtIndex:(int32_t) index;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) replaceMovieAndShowtimesAtIndex:(int32_t) index withMovieAndShowtimes:(TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) value;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) addMovieAndShowtimes:(TheaterListingsProto_TheaterAndMovieShowtimesProto_MovieAndShowtimesProto*) value;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) addAllMovieAndShowtimes:(NSArray*) values;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto_Builder*) clearMovieAndShowtimesList;
@end

@interface TheaterListingsProto_Builder : PBGeneratedMessage_Builder {
 @private
  TheaterListingsProto* result;
}
@property (retain) TheaterListingsProto* result;

- (PBDescriptor*) descriptorForType;
- (TheaterListingsProto*) defaultInstanceForType;

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
- (TheaterListingsProto_Builder*) replaceMoviesAtIndex:(int32_t) index withMovies:(MovieProto*) value;
- (TheaterListingsProto_Builder*) addMovies:(MovieProto*) value;
- (TheaterListingsProto_Builder*) addAllMovies:(NSArray*) values;
- (TheaterListingsProto_Builder*) clearMoviesList;

- (NSArray*) theaterAndMovieShowtimesList;
- (TheaterListingsProto_TheaterAndMovieShowtimesProto*) theaterAndMovieShowtimesAtIndex:(int32_t) index;
- (TheaterListingsProto_Builder*) replaceTheaterAndMovieShowtimesAtIndex:(int32_t) index withTheaterAndMovieShowtimes:(TheaterListingsProto_TheaterAndMovieShowtimesProto*) value;
- (TheaterListingsProto_Builder*) addTheaterAndMovieShowtimes:(TheaterListingsProto_TheaterAndMovieShowtimesProto*) value;
- (TheaterListingsProto_Builder*) addAllTheaterAndMovieShowtimes:(NSArray*) values;
- (TheaterListingsProto_Builder*) clearTheaterAndMovieShowtimesList;
@end

@interface ReviewProto : PBGeneratedMessage {
  BOOL hasTitle;
  NSString* title;
  BOOL hasUrl;
  NSString* url;
  BOOL hasRating;
  Float32 rating;
  BOOL hasSnippet;
  NSString* snippet;
  BOOL hasContent;
  NSString* content;
  BOOL hasPublisher;
  NSString* publisher;
  BOOL hasAuthor;
  NSString* author;
  BOOL hasDate;
  NSString* date;
}
@property (readonly) BOOL hasTitle;
@property (retain, readonly) NSString* title;
@property (readonly) BOOL hasUrl;
@property (retain, readonly) NSString* url;
@property (readonly) BOOL hasRating;
@property (readonly) Float32 rating;
@property (readonly) BOOL hasSnippet;
@property (retain, readonly) NSString* snippet;
@property (readonly) BOOL hasContent;
@property (retain, readonly) NSString* content;
@property (readonly) BOOL hasPublisher;
@property (retain, readonly) NSString* publisher;
@property (readonly) BOOL hasAuthor;
@property (retain, readonly) NSString* author;
@property (readonly) BOOL hasDate;
@property (retain, readonly) NSString* date;

+ (PBDescriptor*) descriptor;
+ (ReviewProto*) defaultInstance;
- (ReviewProto*) defaultInstanceForType;
- (PBFieldAccessorTable*) internalGetFieldAccessorTable;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
+ (ReviewProto_Builder*) newBuilder;
- (ReviewProto_Builder*) newBuilderForType;
+ (ReviewProto_Builder*) newBuilderWithReviewProto:(ReviewProto*) prototype;

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
@property (retain) ReviewProto* result;

- (PBDescriptor*) descriptorForType;
- (ReviewProto*) defaultInstanceForType;

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
  NSMutableArray* mutableReviewsList;
}
- (NSArray*) reviewsList;
- (ReviewProto*) reviewsAtIndex:(int32_t) index;

+ (PBDescriptor*) descriptor;
+ (ReviewsListProto*) defaultInstance;
- (ReviewsListProto*) defaultInstanceForType;
- (PBFieldAccessorTable*) internalGetFieldAccessorTable;

- (BOOL) isInitialized;
- (void) writeToCodedOutputStream:(PBCodedOutputStream*) output;
+ (ReviewsListProto_Builder*) newBuilder;
- (ReviewsListProto_Builder*) newBuilderForType;
+ (ReviewsListProto_Builder*) newBuilderWithReviewsListProto:(ReviewsListProto*) prototype;

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
@property (retain) ReviewsListProto* result;

- (PBDescriptor*) descriptorForType;
- (ReviewsListProto*) defaultInstanceForType;

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
- (ReviewsListProto_Builder*) replaceReviewsAtIndex:(int32_t) index withReviews:(ReviewProto*) value;
- (ReviewsListProto_Builder*) addReviews:(ReviewProto*) value;
- (ReviewsListProto_Builder*) addAllReviews:(NSArray*) values;
- (ReviewsListProto_Builder*) clearReviewsList;
@end