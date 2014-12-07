module Component.Page where

import Dreamwriter (..)

import Component.LeftSidebar  as LeftSidebar
import Component.RightSidebar as RightSidebar
import Component.Editor       as Editor

import String
import Html (..)
import Html.Attributes (..)
import Html.Events (..)
import LocalChannel (localize)

type Update
  = NoOp
  | SetLeftSidebar  LeftSidebar.Model
  | SetRightSidebar RightSidebar.Model
  | SetEditor       Editor.Model

type alias Model = {
  leftSidebar  : LeftSidebar.Model,
  rightSidebar : RightSidebar.Model,
  editor       : Editor.Model,

  fullscreen   : FullscreenState,

  currentDoc   : Maybe Doc,
  currentNote  : Maybe Note,

  docs         : List Doc,
  notes        : List Note
}

initialModel : Model
initialModel = {
    leftSidebar  = LeftSidebar.initialModel,
    rightSidebar = RightSidebar.initialModel,
    editor       = Editor.initialModel,

    fullscreen   = False,

    currentDoc   = Nothing,
    currentNote  = Nothing,

    docs         = [],
    notes        = []
  }

step : Update -> Model -> Model
step update model =
  case update of
    NoOp -> model

    SetLeftSidebar  childModel -> { model | leftSidebar  <- childModel }
    SetRightSidebar childModel -> { model | rightSidebar <- childModel }
    SetEditor       childModel -> { model | editor       <- childModel }

--view : AppChannels -> AppState -> Html
view updates channels model =
  let updateLeftSidebar    = localize (generalizeLeftSidebarUpdate model)  updates
      updateRightSidebar   = localize (generalizeRightSidebarUpdate model) updates
      leftSidebarChannels  = { channels | update = updateLeftSidebar  }
      rightSidebarChannels = { channels | update = updateRightSidebar }
      editorChannels       = channels
  in div [id "page"] <|
    case model.currentDoc of
      Nothing -> []
      Just currentDoc ->
        [
          LeftSidebar.view  leftSidebarChannels  (modelLeftSidebar currentDoc model),
          Editor.view       editorChannels       (modelEditor currentDoc model),
          RightSidebar.view rightSidebarChannels (modelRightSidebar model)
        ]

modelLeftSidebar : Doc -> Model -> LeftSidebar.Model
modelLeftSidebar currentDoc model = {
    docs       = model.docs,
    currentDoc = currentDoc,
    viewMode   = model.leftSidebar.viewMode
  }

modelEditor : Doc -> Model -> Editor.Model
modelEditor currentDoc model = {
    currentDoc = currentDoc,
    fullscreen = model.fullscreen
  }

modelRightSidebar : Model -> RightSidebar.Model
modelRightSidebar model = {
    currentNote = model.currentNote,
    notes       = model.notes
  }

generalizeLeftSidebarUpdate : Model -> LeftSidebar.Update -> Update
generalizeLeftSidebarUpdate model update =
  SetLeftSidebar (LeftSidebar.step update model.leftSidebar)

generalizeRightSidebarUpdate : Model -> RightSidebar.Update -> Update
generalizeRightSidebarUpdate model update =
  SetRightSidebar (RightSidebar.step update model.rightSidebar)