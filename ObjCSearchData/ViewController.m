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
    [self fetchData];
}

- (void)setupView {
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)fetchData {
    [self.viewModel fetchPosts:^(BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.posts = self.viewModel.posts;
                [self.tableView reloadData];
            });
        } else {
            NSLog(@"Failed to fetch data");
        }
    }];
}



#pragma mark - UITableView DataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    
    if (self.posts.count > indexPath.row) {
        Post *post = self.posts[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld - %@", (long)post.postId, post.title];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.posts.count > indexPath.row) {
            Post *post = self.posts[indexPath.row];
            
            NSString *message = [NSString stringWithFormat:@"ID: %ld\n\nTitle: %@\n\nBody: %@",
                                 (long)post.postId, post.title, post.body];

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Post Details"
                                                                           message:message
                                                                    preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"Close"
                                                                  style:UIAlertActionStyleCancel
                                                                handler:nil];

            [alert addAction:closeAction];

            [self presentViewController:alert animated:YES completion:nil];
        }
}


@end
