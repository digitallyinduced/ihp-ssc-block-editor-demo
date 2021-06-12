{-# LANGUAGE TemplateHaskell #-}
module Web.Component.BlockEditor where

import IHP.ViewPrelude hiding (fetch, query)
import Web.Controller.Prelude hiding (render, setState, getState)
import IHP.ModelSupport

import IHP.ServerSideComponent.Types
import IHP.ServerSideComponent.ControllerFunctions

data BlockEditor = BlockEditor
    { postId :: !(Id Post)
    , blocks :: [Block]
    }

deriving instance Data BlockType
data BlockEditorController
    = AddBlock { blockType :: BlockType }
    | UpdateBlockParagraphText { blockId :: !(Id Block), paragraphText :: Text }
    | UpdateBlockHeadlineText { blockId :: !(Id Block), headlineText :: Text }
    | UpdateBlockImageSrc { blockId :: !(Id Block), imageSrc :: Text }
    | DeleteBlock { blockId :: !(Id Block) }
    | MoveBlockUp { blockId :: !(Id Block) }
    | MoveBlockDown { blockId :: !(Id Block) }
    deriving (Eq, Show, Data)

$(deriveSSC ''BlockEditorController)
$(deriveSSC ''BlockType)


instance Component BlockEditor BlockEditorController where
    initialState = BlockEditor { postId = "603dc027-6305-4055-bef3-aedaa0fdf3f7", blocks = [] }

    componentDidMount state = fetchBlocks state

    
    render BlockEditor { postId, blocks } = [hsx|
        <div class="blocks">{forEach orderedBlocks renderBlock}</div>

        <div class="dropdown">
            <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                Add Block
            </button>
            <div class="dropdown-menu" aria-labelledby="dropdownMenuButton">
                <a class="dropdown-item" href="#" onclick="event.preventDefault(); callServerAction('AddBlock', {blockType: 'Paragraph'})">Paragraph</a>
                <a class="dropdown-item" href="#" onclick="event.preventDefault(); callServerAction('AddBlock', {blockType: 'Headline'})">Headline</a>
                <a class="dropdown-item" href="#" onclick="event.preventDefault(); callServerAction('AddBlock', {blockType: 'RawHtml'})">Raw HTML</a>
                <a class="dropdown-item" href="#" onclick="event.preventDefault(); callServerAction('AddBlock', {blockType: 'Image'})">Image</a>
            </div>
        </div>
    |]
        where
            orderedBlocks = blocks |> sortBy (comparing (get #orderPosition))
    
    action state AddBlock { blockType } = do
        let nextPosition = state
                |> get #blocks
                |> lastMay
                |> maybe 0 (get #orderPosition)
                |> (+) 1
        block <- newRecord @Block
                |> set #postId (get #postId state)
                |> set #blockType blockType
                |> set #orderPosition nextPosition
                |> \block -> case blockType of
                        Paragraph -> block |> setJust #paragraphText "Hello World!"
                        Headline -> block |> setJust #headlineText "Hello World!"
                        RawHtml -> block |> setJust #rawHtml "<p>hello</p>"
                        _ -> block

                |> createRecord


        state
            |> modify #blocks (\blocks -> blocks <> [block])
            |> pure

    action state UpdateBlockParagraphText { blockId, paragraphText } = do
        block <- fetch blockId
        block
            |> setJust #paragraphText paragraphText
            |> updateRecord

        fetchBlocks state

    action state UpdateBlockHeadlineText { blockId, headlineText } = do
        block <- fetch blockId
        block
            |> setJust #headlineText headlineText
            |> updateRecord

        fetchBlocks state

    action state UpdateBlockImageSrc { blockId, imageSrc } = do
        block <- fetch blockId
        block
            |> setJust #imageSrc imageSrc
            |> updateRecord

        fetchBlocks state

    action state DeleteBlock { blockId } = do
        block <- fetch blockId
        deleteRecord block

        fetchBlocks state
    
    action state MoveBlockUp { blockId } = do
        block <- fetch blockId

        prevBlock <- query @Block
                |> filterWhere (#orderPosition, (get #orderPosition block) - 1)
                |> fetchOneOrNothing

        case prevBlock of
            Just prevBlock -> do
                block
                    |> decrementField #orderPosition
                    |> updateRecord

                prevBlock
                    |> incrementField #orderPosition
                    |> updateRecord

                pure ()
            Nothing -> pure ()

        fetchBlocks state

    action state MoveBlockDown { blockId } = do
        block <- fetch blockId

        nextBlock <- query @Block
                |> filterWhere (#orderPosition, (get #orderPosition block) + 1)
                |> fetchOneOrNothing

        case nextBlock of
            Just nextBlock -> do
                block
                    |> incrementField #orderPosition
                    |> updateRecord

                nextBlock
                    |> decrementField #orderPosition
                    |> updateRecord

                pure ()
            Nothing -> pure ()

        fetchBlocks state

renderBlock :: Block -> Html
renderBlock block = [hsx|
    <div class="block" data-block-id={show (get #id block)}>
        {renderBlockInner block}

        <div class="controls">
            <button class="btn btn-link text-danger" onclick="callServerAction('DeleteBlock', {blockId: this.parentNode.parentNode.dataset.blockId})">Delete</button>
            <button class="btn btn-link text-info" onclick="callServerAction('MoveBlockUp', {blockId: this.parentNode.parentNode.dataset.blockId})">Move up</button>
            <button class="btn btn-link text-info" onclick="callServerAction('MoveBlockDown', {blockId: this.parentNode.parentNode.dataset.blockId})">Move down</button>
        </div>
    </div>
|]

renderBlockInner :: Block -> Html
renderBlockInner Block { id, blockType = Paragraph, paragraphText = Just text }= [hsx|
    <p
        contenteditable="true"
        data-block-id={show id}
        oninput="callServerAction('UpdateBlockParagraphText', {blockId: this.parentNode.dataset.blockId, paragraphText: this.innerText})"
    >
        {text}
    </p>
|]
renderBlockInner Block { id, blockType = Headline, headlineText = Just text } = [hsx|
    <h1
        contenteditable="true"
        data-block-id={tshow id}
        oninput="callServerAction('UpdateBlockHeadlineText', {blockId: this.parentNode.dataset.blockId, headlineText: this.innerText})"
    >
        {text}
    </h1>
|]
renderBlockInner Block { id, blockType = RawHtml, rawHtml = Just html } = [hsx|
    <div class="raw-html">    
        <textarea>{preEscapedToHtml html}</textarea>
    </div>
|]
renderBlockInner Block { id, blockType = Image, imageSrc = Just src } = [hsx|
    <img src={src} class="w-100"/>
|]
renderBlockInner Block { id, blockType = Image, imageSrc = Nothing } = [hsx|
    <form onsubmit="event.preventDefault();event.stopPropagation(); callServerAction('UpdateBlockImageSrc', {blockId: this.parentNode.dataset.blockId, imageSrc: this.imageSrc.value})">
        <div class="form-group">
            <label>Provide an image url:</label>
            <input type="text" placeholder="https://..." class="form-control" name="imageSrc"/>
            
        </div>

        <button class="btn btn-primary mr-4">Use image</button>

        <a href="https://unsplash.com/" target="_blank">Find inspiration</a>
    </form>
|]
renderBlockInner otherwise = [hsx|<div>{otherwise}</div>|]

instance SetField "blocks" BlockEditor [Block] where setField value' record = record { blocks = value' }

fetchBlocks :: _ => state -> IO state
fetchBlocks state = do
        blocks <- query @Block
                |> orderBy #orderPosition
                |> fetch

        state
            |> set #blocks blocks
            |> pure