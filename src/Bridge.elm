module Bridge exposing (ToBackend(..))


type ToBackend
    = SubmitScore String String Int Int Int
