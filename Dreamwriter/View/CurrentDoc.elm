module Dreamwriter.View.CurrentDoc (view) where

import Dreamwriter.Model (..)
import Dreamwriter.Action (..)

import Html (..)
import Html.Attributes (..)
import Html.Events (..)

view : Doc -> Html
view currentDoc =
  div [key "current-doc-view", id "current-doc-view"] [
    div [id "title", onclick navigateToTitleInput.handle (always ())]
      [text currentDoc.title],

    viewOutline currentDoc.chapters
  ]

viewOutline : [Chapter] -> Html
viewOutline chapters =
  ul [id "outline"] <| indexedMap viewChapter chapters

viewChapter : Int -> Chapter -> Html
viewChapter index chapter = li [
    key ("chapter" ++ (show index)),
    title chapter.heading,
    onclick navigateToChapterIdInput.handle (always chapter.id)
  ] [text chapter.heading]