module Dreamwriter.Action where

import Dreamwriter (..)
import Dreamwriter.Doc (..)

import Graphics.Input
import Graphics.Input as Input

data Action
  = NoOp
  | NewDoc
  | LoadDoc (Identifier, Maybe Doc)
  | OpenDocId Identifier
  | ChangeEditorContent (Maybe Doc)

-- actions from user input
actions : Input.Input Action
actions = Input.input NoOp
