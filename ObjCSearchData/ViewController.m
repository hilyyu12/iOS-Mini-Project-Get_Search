//
//  ViewController.m
//  ObjCSearchData
//
//  Created by Abiyyu Hilmi on 06/03/25.
//

#import "ViewController.h"
#import "PostViewModel.h"
#import "Post.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) PostViewModel *viewModel;
@property (strong, nonatomic) NSArray *posts;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewModel = [[PostViewModel alloc] init];
    
    [self setupView];
    
}

- (void)setupView {
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
}

- (void)fetchData {
    NSURL *url = [NSURL URLWithString:@"https://jsonplaceholder.typicode.com/posts"];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error fetching data: %@", error.localizedDescription);
            return;
        }

        NSError *jsonError;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            NSLog(@"JSON Parsing Error: %@", jsonError.localizedDescription);
            return;
        }

        NSMutableArray *posts = [NSMutableArray array];
        for (NSDictionary *dict in jsonArray) {
            Post *post = [[Post alloc] initWithDictionary:dict];
            [posts addObject:post];
        }

        self.posts = posts;

        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Data loaded, reloading table view");
            [self.tableView reloadData];
        });
    }];
    
    [task resume];
}


#pragma mark - UITableView DataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    
    if (self.posts.count > indexPath.row) {
        Post *post = self.posts[indexPath.row];
//        cell.textLabel.text = NSString(post.postId);
        cell.textLabel.text = post.title;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    Post *post = self.filteredPosts[indexPath.row];
//    DetailVC *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
//    detailVC.post = post;
//    
//    [self.navigationController pushViewController:detailVC animated:YES];
}


@end
