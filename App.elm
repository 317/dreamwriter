module App where

import Dreamwriter (Identifier)
import Dreamwriter.Action (..)
import Dreamwriter.Doc (..)
import Dreamwriter.Model (..)
import Dreamwriter.View.App (view)

import String
import Html (..)
import Html.Attributes (..)
import Html.Events (..)
import Html.Tags (..)
import Html.Optimize.RefEq as Ref
import Maybe
import Window

-- TODO remove this once it's in elm-html
key = attr "key"

-- ACTIONS --

step : Action -> AppState -> AppState
step action state =
  case action of
    NoOp -> state

    OpenDocId id ->
      {state | currentDocId <- Just id
             , showOpenMenu <- False
      }

    LoadAsCurrentDoc (id, doc) ->
      {state | currentDocId <- Just id
             , currentDoc   <- Just doc
      }

main : Signal Element
main = lift2 scene state Window.dimensions

userInput : Signal Action
userInput =
  merges
  [ lift LoadAsCurrentDoc loadAsCurrentDoc
  , actions.signal
  ]

scene : AppState -> (Int, Int) -> Element
scene state (w, h) =
  container w h midTop (toElement w h (view state))

-- manage the state of our application over time
state : Signal AppState
state = foldp step emptyState userInput

port loadAsCurrentDoc : Signal (Identifier, Doc)

port setCurrentDocId : Signal (Maybe Identifier)
port setCurrentDocId = lift .currentDocId state

port newDoc : Signal ()
port newDoc = newDocInput.signal

port downloadDoc : Signal DownloadOptions
port downloadDoc = downloadInput.signal