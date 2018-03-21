module Main exposing (..)

import Html exposing (Html, text, a, div, span, article)
import Html.Attributes exposing (src, class)
import Html.Events exposing (onClick)
import List.Extra exposing ((!!))


---- MODEL ----


type alias Choice =
    String


type alias Exercise =
    { question : String, choices : List Choice }


type alias Model =
    { exercises : List Exercise, count : Int }


init : ( Model, Cmd Msg )
init =
    ( { exercises =
            [ { question = "イタリアのブランド「ブルガリ」。アルファベットのつづりの二文字目は何？"
              , choices = [ "選択肢1", "選択肢2", "選択肢3", "選択肢4" ]
              }
            , { question = "ドラクエ６の最弱モンスターは？"
              , choices = [ "選択肢5", "選択肢6", "選択肢7", "選択肢8" ]
              }
            , { question = "Scalaのパターンマッチ構文は？"
              , choices = [ "選択肢9", "選択肢10", "選択肢11", "選択肢12" ]
              }
            , { question = "お腹すいた"
              , choices = [ "選択肢13", "選択肢14", "選択肢15", "選択肢16" ]
              }
            ]
      , count = 0
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = Next


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ exercises, count } as model) =
    case msg of
        Next ->
            if count < (List.length exercises - 1) then
                { model | count = count + 1 } ! []
            else
                { model | count = 0 } ! []



---- VIEW ----


view : Model -> Html Msg
view { exercises, count } =
    case (exercises !! count) of
        Just { question, choices } ->
            div []
                [ questionView question
                , choiceView choices
                ]

        Nothing ->
            text ""


questionView : String -> Html Msg
questionView question =
    article [ class "message is-primary problem" ]
        [ div [ class "message-body" ]
            [ text question ]
        ]


choiceView : List Choice -> Html Msg
choiceView choices =
    let
        choice =
            List.indexedMap
                (\index choice ->
                    a [ class "button is-rounded", onClick Next ]
                        [ span [ class <| "icon is-small num num" ++ toString (index + 1) ]
                            [ text <| toString (index + 1) ]
                        , span []
                            [ text choice ]
                        ]
                )
                choices
    in
        article [ class "message" ]
            [ div [ class "message-body choice" ]
                choice
            ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
