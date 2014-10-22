module Dreamwriter.View.Editor where

import Dreamwriter.Doc (..)
import Dreamwriter.Model (..)

import String
import Html (..)
import Html.Attributes (..)
import Html.Events (..)
import Html.Tags (..)
import Maybe

-- TODO remove this once it's fixed in elm-html
contenteditable = toggle "contentEditable" 


view : Doc -> AppState -> Html
view currentDoc state =
  div [id "editor-container"] [
    div [id "editor-frame"] [
      div [id "document-page"] [
        h1  [id "edit-title",        contenteditable True, spellcheck True] [text currentDoc.title],
        div [id "edit-description",  contenteditable True, spellcheck True] [],
        div [id "chapters"] <| map viewChapter currentDoc.chapters
      ]
    ]
  ]

viewChapter : Chapter -> Html
viewChapter chapter =
  section [key ("chapter " ++ chapter.id)] [
    h2  [id ("edit-chapter-heading-" ++ chapter.id), contenteditable True, spellcheck True] [text chapter.heading],
    div [id ("edit-chapter-body-" ++ chapter.id),    contenteditable True, spellcheck True] []
  ]