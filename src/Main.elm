module Main exposing (..)

import About.Main as About
import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Nav
import Common.Element as Element
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Route exposing (Route(..))
import Typer.Main as Typer
import Url exposing (Url)
import Vsh.Main as Vsh



-- MAIN


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = LinkChanged
        }



-- FLAGS


type alias Flags =
    ()



-- MODEL


type Model
    = AboutModel Nav.Key About.Model
    | VshModel Nav.Key Vsh.Model
    | TyperModel Nav.Key Typer.Model


toKey : Model -> Nav.Key
toKey model =
    case model of
        AboutModel key _ ->
            key

        VshModel key _ ->
            key

        TyperModel key _ ->
            key


toActiveIndex : Model -> Int
toActiveIndex model =
    case model of
        AboutModel _ _ ->
            0

        VshModel _ _ ->
            1

        TyperModel _ _ ->
            2



-- MSG


type Msg
    = GotAboutMsg About.Msg
    | GotVshMsg Vsh.Msg
    | GotTyperMsg Typer.Msg
    | LinkClicked UrlRequest
    | LinkChanged Url



-- INIT


init : Flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    mux (AboutModel key About.initModel) url


mux : Model -> Url -> ( Model, Cmd Msg )
mux model url =
    let
        norm :
            (subModel -> model)
            -> (subMsg -> msg)
            -> ( subModel, Cmd subMsg )
            -> ( model, Cmd msg )
        norm toModel toMsg ( subModel, cmd ) =
            ( toModel subModel, Cmd.map toMsg cmd )

        key =
            toKey model

        route =
            Route.fromUrl url
    in
    case route of
        AboutRoute ->
            norm (AboutModel key) GotAboutMsg About.init

        VshRoute ->
            norm (VshModel key) GotVshMsg Vsh.init

        TyperRoute ->
            norm (TyperModel key) GotTyperMsg Typer.init



-- VIEW


view : Model -> Document Msg
view model =
    let
        norm : (msg -> a) -> Document msg -> Document a
        norm toMsg { title, body } =
            { title = title
            , body =
                Element.navbar (toActiveIndex model)
                    :: List.map (Html.map toMsg) body
            }
    in
    case model of
        AboutModel _ mo ->
            norm GotAboutMsg <| About.view mo

        VshModel _ mo ->
            norm GotVshMsg <| Vsh.view mo

        TyperModel _ mo ->
            norm GotTyperMsg <| Typer.view mo



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        norm :
            (subModel -> model)
            -> (subMsg -> msg)
            -> ( subModel, Cmd subMsg )
            -> ( model, Cmd msg )
        norm toModel toMsg ( subModel, cmd ) =
            ( toModel subModel, Cmd.map toMsg cmd )

        key =
            toKey model
    in
    case ( msg, model ) of
        ( GotAboutMsg ms, AboutModel _ mo ) ->
            norm (AboutModel key) GotAboutMsg <| About.update ms mo

        ( GotVshMsg ms, VshModel _ mo ) ->
            norm (VshModel key) GotVshMsg <| Vsh.update ms mo

        ( GotTyperMsg ms, TyperModel _ mo ) ->
            norm (TyperModel key) GotTyperMsg <| Typer.update ms mo

        ( LinkChanged url, _ ) ->
            mux model url

        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Internal url ->
                    ( model
                    , Nav.pushUrl key (Url.toString url)
                    )

                External href ->
                    ( model
                    , Nav.load href
                    )

        ( _, _ ) ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        AboutModel _ mo ->
            Sub.map GotAboutMsg <| About.subscriptions mo

        VshModel _ mo ->
            Sub.map GotVshMsg <| Vsh.subscriptions mo

        TyperModel _ mo ->
            Sub.map GotTyperMsg <| Typer.subscriptions mo
