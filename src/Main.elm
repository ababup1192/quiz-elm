module Main exposing (..)

import Html exposing (Html, text, a, div, span, article)
import Html.Attributes exposing (src, class)
import Html.Events exposing (onClick)
import List.Extra exposing ((!!))
import Time exposing (Time, second)
import Task
import Process


---- MODEL ----


type alias Choice =
    { content : String, isCorrect : Bool }


type alias Exercise =
    { question : String, choices : List Choice }


type alias Model =
    { exercises : List Exercise, count : Int, numOfCorrectAns : Int, isAnimation : Bool }


init : ( Model, Cmd Msg )
init =
    ( { exercises =
            [ { question = "イタリアのブランド「ブルガリ」。アルファベットのつづりの二文字目は何？"
              , choices = [ Choice "正解" True, Choice "不正解" False, Choice "不正解" False, Choice "不正解" False ]
              }
            , { question = "ドラクエ６の最弱モンスターは？"
              , choices = [ Choice "不正解" False, Choice "正解" True, Choice "不正解" False, Choice "不正解" False ]
              }
            , { question = "Scalaのパターンマッチ構文は？"
              , choices = [ Choice "不正解" False, Choice "不正解" False, Choice "正解" True, Choice "不正解" False ]
              }
            , { question = "お腹すいた"
              , choices = [ Choice "不正解" False, Choice "不正解" False, Choice "不正解" False, Choice "正解" True ]
              }
            ]
      , count = 0
      , numOfCorrectAns = 0
      , isAnimation = False
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = Next Bool
    | StopAnimation
    | None


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ exercises, count, numOfCorrectAns } as model) =
    case msg of
        Next isCorrect ->
            let
                newNumOfCorrect =
                    numOfCorrectAns
                        + (if isCorrect then
                            1
                           else
                            0
                          )
            in
                { model | numOfCorrectAns = newNumOfCorrect, isAnimation = True } ! [ Task.perform (always StopAnimation) <| Process.sleep (2 * second) ]

        StopAnimation ->
            if count < (List.length exercises - 1) then
                { model | count = count + 1, isAnimation = False } ! []
            else
                { model | count = 0, isAnimation = False } ! []

        None ->
            model ! []



---- VIEW ----


view : Model -> Html Msg
view { exercises, count, isAnimation } =
    case (exercises !! count) of
        Just { question, choices } ->
            div []
                [ questionView question
                , choiceView choices isAnimation
                ]

        Nothing ->
            text ""


questionView : String -> Html Msg
questionView question =
    article [ class "message is-primary problem" ]
        [ div [ class "message-body" ]
            [ text question ]
        ]


choiceView : List Choice -> Bool -> Html Msg
choiceView choices isAnimation =
    let
        fadeInToggle =
            if isAnimation then
                ""
            else
                " fade-in-active"

        animationClass isCorrect =
            if isCorrect then
                class "correct"
            else
                class "incorrect"

        choiceAnimation isCorrect =
            if isAnimation then
                span [ animationClass isCorrect ] []
            else
                text ""

        nextMsg isCorrect =
            if isAnimation then
                onClick <| None
            else
                onClick <| Next isCorrect

        choice =
            List.indexedMap
                (\index { content, isCorrect } ->
                    a [ class <| "button is-rounded" ++ fadeInToggle, nextMsg isCorrect ]
                        [ span [ class <| "icon is-small num num" ++ toString (index + 1) ]
                            [ text <| toString (index + 1) ]
                        , span []
                            [ text content ]
                        , choiceAnimation isCorrect
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
        , subscriptions = (\_ -> Sub.none)
        }
