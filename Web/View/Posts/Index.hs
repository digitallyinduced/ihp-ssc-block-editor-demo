module Web.View.Posts.Index where
import Web.View.Prelude

data IndexView = IndexView { posts :: [Post] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item active"><a href={PostsAction}>Posts</a></li>
            </ol>
        </nav>
        <h1>Index <a href={pathTo NewPostAction} class="btn btn-primary ml-4">+ New</a></h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Post</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach posts renderPost}</tbody>
            </table>
        </div>
    |]


renderPost :: Post -> Html
renderPost post = [hsx|
    <tr>
        <td>{post}</td>
        <td><a href={ShowPostAction post.id}>Show</a></td>
        <td><a href={EditPostAction post.id} class="text-muted">Edit</a></td>
        <td><a href={DeletePostAction post.id} class="js-delete text-muted">Delete</a></td>
    </tr>
|]
