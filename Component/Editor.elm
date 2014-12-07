module Component.Editor where

import Dreamwriter (..)

import String
import Html (..)
import Html.Attributes (..)
import Html.Lazy (..)
import Html.Events (..)
import Maybe
import List (..)
import LocalChannel (send, LocalChannel)
import Json.Encode (string)

type alias Channels = {
  fullscreen  : LocalChannel FullscreenState,
  execCommand : LocalChannel String
}

type alias Model = {
  currentDoc : Doc,
  fullscreen : FullscreenState
}

initialModel : Model
initialModel = {
    currentDoc = emptyDoc,
    fullscreen = False
  }

view : Channels -> Model -> Html
view channels model =
  lazy3 viewEditor channels model.currentDoc model.fullscreen

viewEditor : Channels -> Doc -> FullscreenState -> Html
viewEditor channels currentDoc fullscreen =
  div [id "editor-container"] [
    div [id "editor-frame"] [
      div [id "editor-header"] [
        div [class "toolbar-section toolbar-button flaticon-zoom19"] [],
        div [class "toolbar-section"] [
          viewFontControl channels.execCommand "toggle-bold" "B" "bold",
          viewFontControl channels.execCommand "toggle-italics" "I" "italic",
          viewFontControl channels.execCommand "toggle-strikethrough" "\xA0S\xA0" "strikethrough"
        ],
        lazy2 viewFullscreenButton channels.fullscreen fullscreen
      ],

      div [id "document-page"] <| [
        h1  [id "edit-title"      ] [],
        div [id "edit-description"] []
      ] ++ concatMap (lazyViewChapter << .id) currentDoc.chapters,

      div [id "editor-footer"] [
        let wordCount = currentDoc.titleWords + currentDoc.descriptionWords +
          (sum <| map (\chap -> chap.headingWords + chap.bodyWords) currentDoc.chapters)
        in
          div [id "doc-word-count"] [text <| (pluralize "word" wordCount) ++ " saved"],
        div [id "dropbox-sync"] [
          input [id "toggle-dropbox-sync", property "type" (string "checkbox")] [],
          label [for "toggle-dropbox-sync"] [
            text " sync to Dropbox"
          ]
        ]
      ]
    ]
  ]

withCommas : Int -> String
withCommas num =
  if num >= 1000
    then
      let prefix = withCommas <| floor (num / 1000)
      in
        prefix ++ "," ++ (String.right 3 <| toString num)
    else
      toString num

pluralize : String -> Int -> String
pluralize noun quantity =
  if quantity == 1
    then "1 " ++ noun
    else (withCommas quantity) ++ " " ++ noun ++ "s"

viewFullscreenButton : LocalChannel FullscreenState -> FullscreenState -> Html
viewFullscreenButton fullscreenChannel fullscreen =
  let {fullscreenClass, targetMode, fullscreenTitle} = case fullscreen of
    True ->
      { fullscreenClass = "flaticon-collapsing"
      , targetMode      = False
      , fullscreenTitle = "Leave Fullscreen Mode"
      }
    False ->
      { fullscreenClass = "flaticon-expand"
      , targetMode      = True
      , fullscreenTitle = "Enter Fullscreen Mode"
      }
  in
    div [class ("toolbar-section toolbar-button " ++ fullscreenClass),
      title fullscreenTitle,
      onClick <| send fullscreenChannel targetMode
    ] []

lazyViewChapter : Identifier -> List Html
lazyViewChapter chapterId = [
    lazy viewChapterHeading chapterId,
    lazy viewChapterBody    chapterId
  ]

viewChapterBody : Identifier -> Html
viewChapterBody chapterId =
  div [key ("chapter-body-" ++ chapterId),
    id ("edit-chapter-body-" ++ chapterId),
    class "chapter-body"] []

viewChapterHeading : Identifier -> Html
viewChapterHeading chapterId =
  h2 [key ("chapter-heading-" ++ chapterId),
    id ("edit-chapter-heading-" ++ chapterId),
    class "chapter-heading"] []

viewFontControl : LocalChannel String -> String -> String -> String -> Html
viewFontControl execCommandChannel idAttr label command =
  span [class "font-control toolbar-button toolbar-font-button", id idAttr,
    (property "unselectable" (string "on")),
    onClick <| send execCommandChannel command] [text label]