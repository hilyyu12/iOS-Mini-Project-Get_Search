//
//  Post.h
//  ObjCSearchData
//
//  Created by Abiyyu Hilmi on 06/03/25.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

@property (nonatomic, assign) NSInteger postId;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
