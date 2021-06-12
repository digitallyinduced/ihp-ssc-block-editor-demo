module Web.View.Posts.Edit where
import Web.View.Prelude
import Web.Component.BlockEditor
import IHP.ServerSideComponent.ViewFunctions

data EditView = EditView { post :: Post }

instance View EditView where
    html EditView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={PostsAction}>Posts</a></li>
                <li class="breadcrumb-item active">Edit Post</li>
            </ol>
        </nav>
        <h1>Edit Post</h1>

        {blockEditor}
    |]
        where
            blockEditor = component @BlockEditor

renderForm :: Post -> Html
renderForm post = formFor post [hsx|
    {(textField #title)}
    {submitButton}
|]
