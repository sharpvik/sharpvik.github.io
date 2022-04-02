module Vsh.Command exposing (..)

import Common.Link as Link
import Html exposing (..)
import Html.Attributes exposing (href, target)
import Vsh.Text exposing (Color(..), ctext)


type alias Command msg =
    String -> List (Html msg) -> List (Html msg)


exec : Command msg
exec command display =
    let
        maybeCommand =
            List.head <| String.words command

        wrongCommand label string =
            [ text <| label ++ " command: ", ctext Magenta string ]
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

        "cut" ->
            Just cut

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
            Vsh.Text.ctext color <|
                String.join "" <|
                    List.repeat (bars n m) "|"

        elementary =
            coloredLevel Green 12

        intermediate n20 =
            coloredLevel Yellow 5 (n20 - 12)

        advanced n20 =
            coloredLevel Magenta 3 (n20 - 17)

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
        ++ skill "Haskell" 12
        ++ skill "Elm" 9
        ++ skill "Ansible" 7


cv : Command msg
cv _ display =
    display
        ++ [ text "My curriculum vitae: "
           , a
                [ href "https://docs.google.com/document/d/1stYuixTXS9gbvcs2KKHLZBax8JRrnxkKxXqT7A9d9RA/edit?usp=sharing" ]
                [ text "Google Docs" ]
           ]


jobs : Command msg
jobs _ display =
    display
        ++ [ Vsh.Text.ctext Yellow
                "I am currenly looking for a graduate role starting June 2022!"
           , text
                """
                
Here's a few things you should know:

    1. I specialise in cloud services and web development, but I'm open to
       interesting offers!
    2. I am a uni student; during my term time, I can only work 20 hr./week.
    3. Nevertheless, full-time work is possible during the term breaks.
       
Use the """
           , Vsh.Text.ctext Green "touch"
           , text " command to get in touch."
           ]


touch : Command msg
touch _ display =
    let
        linkTo url =
            a [ href url, target "_blank" ] [ text <| url ]

        mailTo email =
            a [ href <| "mailto:" ++ email ] [ text email ]

        entry description link =
            [ text "\n    "
            , text <| String.padRight 11 ' ' <| description ++ ":"
            , link
            ]
    in
    display
        ++ [ text "Ways to get in touch:\n" ]
        ++ entry "email" (mailTo Link.email)
        ++ entry "github" (linkTo Link.github)
        ++ entry "linkedin" (linkTo Link.linkedin)


help : Command msg
help _ display =
    let
        entry command description =
            [ text "\n    "
            , Vsh.Text.ctext Green <| String.padRight 8 ' ' command
            , text <| "-- " ++ description
            ]
    in
    display
        ++ [ text """VSH is a terminal emulator that helps you learn about me.
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
        ++ entry "cut" "keyboard shortcuts cheatsheet"
        ++ entry "git" "explore vsh source code"
        ++ entry "clear" "clear screen"
        ++ entry "exit" "exit vsh session"


version : Command msg
version _ display =
    display
        ++ [ text "vsh v0.1.3 by Viktor A. Rozenko Voitenko <sharp.vik@gmail.com>" ]


cut : Command msg
cut _ display =
    let
        entry command description =
            [ text "\n    "
            , Vsh.Text.ctext Green <| String.padRight 8 ' ' command
            , text <| "-- " ++ description
            ]
    in
    display
        ++ entry "CTRL+e" "quit vsh"
        ++ entry "CTRL+;" "clear screen"


git : Command msg
git _ display =
    display
        ++ [ text "vsh on GitHub: "
           , a [ href Link.repo ] [ text Link.repo ]
           ]


clear : Command msg
clear _ _ =
    []


exit : Command msg
exit _ display =
    display ++ [ text "Shutting down..." ]
