//
//  PostViewModel.h
//  ObjCSearchData
//
//  Created by Abiyyu Hilmi on 06/03/25.
//

#import <Foundation/Foundation.h>
#import "Post.h"

@interface PostViewModel : NSObject

@property (nonatomic, strong) NSArray<Post *> *posts;

- (void)fetchPosts:(void (^)(BOOL success))completion;
- (NSArray<Post *> *)searchPostsWithTitle:(NSString *)searchText;

@end
