//
//  Post.m
//  ObjCSearchData
//
//  Created by Abiyyu Hilmi on 06/03/25.
//

#import "Post.h"

@implementation Post

-(instancetype) initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        _postId = [dict[@"id"] integerValue];
        _userId = [dict[@"userId"] integerValue];
        _title = dict[@"title"];
        _body = dict[@"body"];
    }
    return self;
}


@end
