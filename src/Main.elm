module Main exposing (..)

import Html exposing (Html, text, a, div, span, article)
import Html.Attributes exposing (src, class)
import Html.Events exposing (onClick)
import List.Extra exposing ((!!))
import Time exposing (Time, millisecond, inSeconds)
import Task


---- MODEL ----


type alias Choice =
    { content : String, isCorrect : Bool }


type alias Exercise =
    { question : String, choices : List Choice }


type alias Model =
    { exercises : List Exercise, count : Int, numOfCorrectAns : Int, choiceTime : Maybe Time, isAnimation : Bool }


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
      , choiceTime = Nothing
      , isAnimation = False
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = Next Bool
    | Tick Time
    | ChoiceTime Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ exercises, count, numOfCorrectAns, choiceTime } as model) =
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
                { model | numOfCorrectAns = newNumOfCorrect } ! [ Task.perform ChoiceTime Time.now ]

        ChoiceTime ct ->
            { model | isAnimation = True, choiceTime = Just ct } ! []

        Tick newTime ->
            case choiceTime of
                Just ct ->
                    if (inSeconds newTime - inSeconds ct) > 2.0 then
                        if count < (List.length exercises - 1) then
                            { model | count = count + 1, choiceTime = Nothing, isAnimation = False } ! []
                        else
                            { model | count = 0, choiceTime = Nothing, isAnimation = False } ! []
                    else
                        model ! []

                Nothing ->
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

        choice =
            List.indexedMap
                (\index { content, isCorrect } ->
                    a [ class "button is-rounded", onClick <| Next isCorrect ]
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


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every (500 * millisecond) Tick



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
