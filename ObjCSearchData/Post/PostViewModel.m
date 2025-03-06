//
//  PostViewModel.m
//  ObjCSearchData
//
//  Created by Abiyyu Hilmi on 06/03/25.
//

#import "PostViewModel.h"
#import "Post.h"

@implementation PostViewModel

- (void)fetchPosts:(void (^)(BOOL success))completion {
    NSURL *url = [NSURL URLWithString:@"https://jsonplaceholder.typicode.com/posts"];
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data && !error) {
            NSError *jsonError;
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonArray && !jsonError) {
                NSMutableArray *postsArray = [NSMutableArray array];
                for (NSDictionary *dict in jsonArray) {
                    Post *post = [[Post alloc] initWithDictionary:dict];
                    [postsArray addObject:post];
                }
                self.posts = [postsArray copy];
                completion(YES);
            } else {
                completion(NO);
            }
        } else {
            completion(NO);
        }
    }];
    [dataTask resume];
}

- (NSArray<Post *> *)searchPostsWithTitle:(NSString *)searchText {
    if (searchText.length == 0) {
        return self.posts;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", searchText];
    return [self.posts filteredArrayUsingPredicate:predicate];
}


@end
