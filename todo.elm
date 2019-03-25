module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Platform.Cmd exposing (Cmd)
import Material.Button as Button exposing (..)
import Material.Icon as Icon
import Material.Options as Options exposing (css)
import Material
import Material.Scheme
import Material.Textfield as Textfield
import Material.Typography as Typo
import Material.List as Lists
import Html exposing (p)

main : Program Never Model Msg
main =
    Html.program
        { init =  ( model, Cmd.none )
        , update = update
        , subscriptions = always Sub.none
        , view = view
        }


type alias Model =
    { todo : String
    , todolists : List String
    , mdl : Material.Model
    }


model : Model
model =
    { todo = ""
    , todolists = []
    , mdl = Material.model
    }

--update

type Msg
    = UpdateTodo String
    | AddTodo
    | RemoveItem String
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Mdl msg_ -> 
            Material.update Mdl msg_ model

        UpdateTodo text ->
            ({ model | todo = text }
            , Cmd.none
            )

        AddTodo ->
            ({ model | todolists = model.todo :: model.todolists }
            , Cmd.none
            )

        RemoveItem text ->
           ( { model | todolists = List.filter (\x -> x /= text) model.todolists }
           , Cmd.none
           )
          

--view

todoItem : String -> Html Msg 
todoItem todo =
    li []
    [ text todo
     ,Button.render Mdl [0] model.mdl
        [ Button.fab
        , Button.colored
        , Options.onClick (RemoveItem todo)
        ]
        [ Icon.i "remove"]
     ]


todoList : List String -> Html Msg
todoList todolists =
    let
        child =
            List.map todoItem todolists
    in
        Lists.ul [] child


view : Model -> Html Msg
view model =
    div []
        [ 
        Options.styled p
            [ Typo.headline ]
            [ text "ToDo List" ]
        ,
         Textfield.render Mdl [0] model.mdl
            [ Options.onInput UpdateTodo
            , Textfield.value model.todo
             ]
        []
        , Button.render Mdl [0] model.mdl
            [ Button.minifab
            , Button.colored
            , Button.ripple
            , Options.onClick AddTodo
            ]
            [ Icon.i "add"]
        , todoList model.todolists
        ]
        |> Material.Scheme.top
