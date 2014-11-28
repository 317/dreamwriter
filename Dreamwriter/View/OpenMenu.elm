module Dreamwriter.View.OpenMenu (view) where

import Dreamwriter.Model (..)
import Dreamwriter.Action (..)

import Html (..)
import Html.Attributes (..)
import Html.Events (..)

view : [Doc] -> Doc -> Html
view docs currentDoc =
  let sortedDocs : [Doc]
      sortedDocs = sortBy (negate << .lastModifiedTime) docs

      docNodes : [Html]
      docNodes = map (viewOpenDocEntryFor currentDoc) sortedDocs

      openFileNodes : [Html]
      openFileNodes = [
        div [class "open-entry from-file",
            onclick openFromFileInput.handle (always ())
          ] [
            span [] [text "A "],
            b    [] [text ".html"],
            span [] [text " file from your computer..."]
          ]
      ]
  in
    div [key "open-menu-view", id "open"] (openFileNodes ++ docNodes)

viewOpenDocEntryFor : Doc -> Doc -> Html
viewOpenDocEntryFor currentDoc doc =
  let className = if doc.id == currentDoc.id
    then "open-entry current"
    else "open-entry"
  in
    div [key ("#open-doc-" ++ doc.id), class className,
      onclick actions.handle (\_ -> OpenDocId doc.id)] [text doc.title]
