module Main exposing (..)

import Html exposing (Html, text, a, div, span, article)
import Html.Attributes exposing (src, class)


---- MODEL ----


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( {}, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ article [ class "message is-primary problem" ]
            [ div [ class "message-body" ]
                [ text "イタリアのブランド「ブルガリ」。アルファベットのつづりの２文字目は何？      " ]
            ]
        , article [ class "message" ]
            [ div [ class "message-body choice" ]
                [ a [ class "button is-rounded" ]
                    [ span [ class "icon is-small num num1" ]
                        [ text "1          " ]
                    , span []
                        [ text "選択肢" ]
                    ]
                , a [ class "button is-rounded" ]
                    [ span [ class "icon is-small num num2" ]
                        [ text "2          " ]
                    , span []
                        [ text "選択肢" ]
                    ]
                , a [ class "button is-rounded" ]
                    [ span [ class "icon is-small num num3" ]
                        [ text "3          " ]
                    , span []
                        [ text "選択肢" ]
                    ]
                , a [ class "button is-rounded" ]
                    [ span [ class "icon is-small num num4" ]
                        [ text "4          " ]
                    , span []
                        [ text "選択肢" ]
                    ]
                ]
            ]
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
