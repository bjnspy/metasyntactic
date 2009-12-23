

@protocol StoreItem

@property (readonly, copy) NSString* identifier;
@property (readonly, copy) NSString* itunesIdentifier;

@property (readonly, copy) NSString* canonicalTitle;

@property (readonly) BOOL isFree;
@property (readonly, copy) NSString* price;

@end
