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
@property (strong, nonatomic) NSArray *filteredPosts;



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
    self.searchBar.showsCancelButton = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)fetchData {
    [self.viewModel fetchPosts:^(BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.posts = self.viewModel.posts;
                self.filteredPosts = self.posts;  // Inisialisasi filteredPosts
                [self.tableView reloadData];
            });
        } else {
            NSLog(@"Failed to fetch data");
        }
    }];
}

#pragma mark - UITableView DataSource & Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredPosts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    
    if (self.filteredPosts.count > indexPath.row) {
        Post *post = self.filteredPosts[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld - %@", (long)post.postId, post.title];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.filteredPosts.count > indexPath.row) {
        Post *post = self.filteredPosts[indexPath.row];
        
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

#pragma mark - Search Data

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.filteredPosts = [self.viewModel searchPostsWithTitle:searchText];
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    self.filteredPosts = self.posts;
    [self.tableView reloadData];
    [searchBar resignFirstResponder]; // Menutup keyboard
}


@end
