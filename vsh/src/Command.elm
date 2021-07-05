module Command exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href)
import Vsh


type alias Command msg =
    String -> List (Html msg) -> List (Html msg)


exec : Command msg
exec command display =
    let
        maybeCommand =
            List.head <| String.words command

        wrongCommand label string =
            [ text <| label ++ " command: ", Vsh.ctext Vsh.Magenta string ]
    in
    case maybeCommand of
        Nothing ->
            display ++ wrongCommand "Weird" command

        Just cmd ->
            case eval cmd of
                Nothing ->
                    display ++ wrongCommand "Unknown" command

                Just c ->
                    c command display


eval : String -> Maybe (Command msg)
eval command =
    case command of
        "whoami" ->
            Just whoami

        "top" ->
            Just top

        "cv" ->
            Just cv

        "jobs" ->
            Just jobs

        "touch" ->
            Just touch

        "help" ->
            Just help

        "version" ->
            Just version

        "git" ->
            Just git

        "clear" ->
            Just clear

        "exit" ->
            Just exit

        _ ->
            Nothing


whoami : Command msg
whoami _ display =
    display
        ++ [ text
                """Hey, my name is Viktor! 
I study Computer Science in the University of Southampton.

At work, I currently specialise in high-throughput microservices. I build them
with Go and Python. However, I also enjoy playing around with Haskell, Elm,
Vue.js, and Rust.

In my spare time, I dabble in compiler design and implementation. I love
creating new programming languages! Given a chance, I'd like to do some
professional research into deterministic garbage collection within pure
functional languages."""
           ]


top : Command msg
top _ display =
    let
        bars m n =
            -- m = max bars for this level; n = actual bars
            min m n

        coloredLevel color m n =
            Vsh.ctext color <|
                String.join "" <|
                    List.repeat (bars n m) "|"

        elementary =
            coloredLevel Vsh.Green 12

        intermediate n20 =
            coloredLevel Vsh.Yellow 5 (n20 - 12)

        advanced n20 =
            coloredLevel Vsh.Magenta 3 (n20 - 17)

        level n =
            let
                n20 =
                    min n 20

                offset =
                    String.join "" <| List.repeat (20 - n20) " "
            in
            [ elementary n20, intermediate n20, advanced n20, text offset ]

        skill name lvl =
            (text <|
                "\n    "
                    ++ String.padRight 11 ' ' name
                    ++ "["
            )
                :: level lvl
                ++ [ text "]" ]
    in
    display
        ++ [ text "My top skills:\n" ]
        ++ skill "Go" 20
        ++ skill "Python" 19
        ++ skill "Docker" 18
        ++ skill "Vue.js" 16
        ++ skill "JavaScript" 14
        ++ skill "Haskell" 12
        ++ skill "Elm" 9


cv : Command msg
cv _ display =
    display
        ++ [ text "My curriculum vitae: "
           , a
                [ href "https://docs.google.com/document/d/1hywF2mAq5So8Lvj9ckCM05n605-rYIurzZJud0y5izI/edit?usp=sharing" ]
                [ text "Google Drive" ]
           ]


jobs : Command msg
jobs _ display =
    display
        ++ [ text
                """Before you offer me a job, I'd like to tell you a few things:

    1. I specialise in cloud services and web development, but I'm open to
       interesting offers!
    2. I am a uni student; during my term time, I can only work 20 hr./week.
    3. Nevertheless, full-time work is possible during the term breaks.
       
Use the """
           , Vsh.ctext Vsh.Green "touch"
           , text " command to get in touch."
           ]


touch : Command msg
touch _ display =
    let
        linkWithTheSameText url =
            a [ href url ] [ text <| url ]

        entry description link =
            [ text "\n    "
            , text <| String.padRight 11 ' ' <| description ++ ":"
            , link
            ]
    in
    display
        ++ [ text "Ways to get in touch:\n" ]
        ++ entry "email"
            (a [ href "mailto:sharp.vik@gmail.com" ] [ text "sharp.vik@gmail.com" ])
        ++ entry "github"
            (linkWithTheSameText "https://github.com/sharpvik")
        ++ entry "linkedin"
            (linkWithTheSameText "https://www.linkedin.com/in/sharpvik")


help : Command msg
help _ display =
    let
        entry command description =
            [ text "\n    "
            , Vsh.ctext Vsh.Green <| String.padRight 8 ' ' command
            , text <| "-- " ++ description
            ]
    in
    display
        ++ [ text """vsh is a terminal emulator that helps you learn about me.
Use up and down arrow keys to browse command history (unless it's empty).
And most importantly -- have fun!

Available commands:
""" ]
        ++ entry "whoami" "a bit about myself"
        ++ entry "top" "my top skills"
        ++ entry "cv" "my curriculum vitae"
        ++ entry "jobs" "hire me if you're really impressed"
        ++ entry "touch" "ways to get in touch\n"
        ++ entry "help" "display this message again"
        ++ entry "version" "display vsh version"
        ++ entry "git" "explore vsh source code"
        ++ entry "clear" "clear screen"
        ++ entry "exit" "exit vsh session"


version : Command msg
version _ display =
    display
        ++ [ text "vsh v0.1.2 by Viktor A. Rozenko Voitenko <sharp.vik@gmail.com>" ]


git : Command msg
git _ display =
    display
        ++ [ text "vsh on GitHub: "
           , a
                [ href "https://github.com/sharpvik/sharpvik.github.io" ]
                [ text "https://github.com/sharpvik/sharpvik.github.io" ]
           ]


clear : Command msg
clear _ _ =
    []


exit : Command msg
exit _ display =
    display ++ [ text "Shutting down..." ]
