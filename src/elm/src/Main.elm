port module Main exposing (main)

import Api.InputObject
import Api.Mutation as Mutation
import Api.Object
import Api.Object.User as User
import Api.Object.UserMutations as UserMutations
import Api.Object.UserQueries as UserQueries
import Api.Query as Query
import Browser
import Graphql.Http
import Graphql.Operation exposing (RootMutation, RootQuery)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)
import RemoteData exposing (RemoteData)


-- PORTS
port storeToken : String -> Cmd msg
port removeToken : () -> Cmd msg
port onTokenLoad : (Maybe String -> msg) -> Sub msg


type alias Model =
    { username : String
    , password : String
    , token : Maybe String
    , user : RemoteData (Graphql.Http.Error (List User)) (List User)
    , authError : Maybe String
    }


type Msg
    = UpdateUsername String
    | UpdatePassword String
    | AttemptSignup
    | AttemptLogin
    | GotSignupResponse (RemoteData (Graphql.Http.Error String) String)
    | GotLoginResponse (RemoteData (Graphql.Http.Error String) String)
    | GotUserResponse (RemoteData (Graphql.Http.Error (List User)) (List User))
    | Logout
    | TokenLoaded (Maybe String)


init : Maybe String -> ( Model, Cmd Msg )
init maybeToken =
    ( { username = ""
      , password = ""
      , token = maybeToken
      , user = RemoteData.NotAsked
      , authError = Nothing
      }
    , case maybeToken of
        Just token ->
            makeUserRequest (Just token)
        Nothing ->
            Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TokenLoaded maybeToken ->
            ( { model | token = maybeToken }
            , case maybeToken of
                Just token ->
                    makeUserRequest (Just token)
                Nothing ->
                    Cmd.none
            )

        UpdateUsername username ->
            ( { model | username = username }, Cmd.none )

        UpdatePassword password ->
            ( { model | password = password }, Cmd.none )

        AttemptSignup ->
            ( model
            , makeSignupRequest model
            )

        AttemptLogin ->
            ( model
            , makeLoginRequest model
            )

        GotSignupResponse response ->
            case response of
                RemoteData.Success token ->
                    ( { model
                        | token = Just token
                        , authError = Nothing
                      }
                    , Cmd.batch
                        [ storeToken token
                        , makeUserRequest (Just token)
                        ]
                    )

                RemoteData.Failure err ->
                    ( { model | authError = Just (errorToString err) }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )

        GotLoginResponse response ->
            case response of
                RemoteData.Success token ->
                    ( { model
                        | token = Just token
                        , authError = Nothing
                      }
                    , Cmd.batch
                        [ storeToken token
                        , makeUserRequest (Just token)
                        ]
                    )

                RemoteData.Failure err ->
                    ( { model | authError = Just (errorToString err) }
                    , Cmd.none
                    )

                _ ->
                    ( model, Cmd.none )

        GotUserResponse response ->
            ( { model | user = response }
            , Cmd.none
            )

        Logout ->
            ( { model
                | token = Nothing
                , user = RemoteData.NotAsked
                , authError = Nothing
              }
            , removeToken ()
            )


type alias User =
    { id : String
    , username : String
    , isAdmin : Bool
    }


makeSignupRequest : Model -> Cmd Msg
makeSignupRequest model =
    let
        signupMutation =
            Mutation.users
                (SelectionSet.succeed
                    (\signup -> signup)
                    |> SelectionSet.with
                        (UserMutations.signup
                            { input =
                                { username = model.username
                                , password = model.password
                                }
                            }
                        )
                )
    in
    signupMutation
        |> Graphql.Http.mutationRequest "http://localhost:8080/graphql"
        |> Graphql.Http.send (RemoteData.fromResult >> GotSignupResponse)


makeLoginRequest : Model -> Cmd Msg
makeLoginRequest model =
    let
        loginMutation =
            Mutation.users
                (SelectionSet.succeed
                    (\login -> login)
                    |> SelectionSet.with
                        (UserMutations.login
                            { input =
                                { username = model.username
                                , password = model.password
                                }
                            }
                        )
                )
    in
    loginMutation
        |> Graphql.Http.mutationRequest "http://localhost:8080/graphql"
        |> Graphql.Http.send (RemoteData.fromResult >> GotLoginResponse)


makeUserRequest : Maybe String -> Cmd Msg
makeUserRequest token =
    let
        userSelection =
            SelectionSet.map3 User
                User.id
                User.username
                User.isAdmin

        query =
            Query.users
                (SelectionSet.succeed
                    (\users -> users)
                    |> SelectionSet.with
                        (UserQueries.users userSelection)
                )
    in
    query
        |> Graphql.Http.queryRequest "http://localhost:8080/graphql"
        |> Graphql.Http.send (RemoteData.fromResult >> GotUserResponse)


view : Model -> Html Msg
view model =
    div [ class "min-h-screen bg-gradient-to-b from-gray-50 to-gray-100" ]
        [ nav [ class "bg-white shadow-sm" ]
            [ div [ class "container mx-auto px-4 py-4" ]
                [ div [ class "flex justify-between items-center" ]
                    [ h1 [ class "text-2xl font-bold text-blue-600" ]
                        [ text "MyStuff" ]
                    , viewAuthButton model
                    ]
                ]
            ]
        , div [ class "container mx-auto px-4 py-8" ]
            [ viewContent model ]
        ]


viewAuthButton : Model -> Html Msg
viewAuthButton model =
    case model.token of
        Just _ ->
            button
                [ onClick Logout
                , class "bg-red-500 hover:bg-red-600 text-white font-semibold py-2 px-4 rounded-lg text-sm"
                ]
                [ text "Logout" ]

        Nothing ->
            text ""


viewContent : Model -> Html Msg
viewContent model =
    case model.token of
        Just _ ->
            viewAuthenticated model

        Nothing ->
            viewWelcome model


viewWelcome : Model -> Html Msg
viewWelcome model =
    div [ class "max-w-6xl mx-auto" ]
        [ div [ class "text-center mb-12" ]
            [ h1 [ class "text-5xl font-bold text-gray-900 mb-4" ]
                [ text "Share Your Gear with the World" ]
            , p [ class "text-xl text-gray-600 mb-8" ]
                [ text "Your digital open house for sharing the tools, equipment, and collections that make you unique." ]
            ]
        , div [ class "grid grid-cols-1 md:grid-cols-3 gap-8 mb-12" ]
            [ featureCard "For Developers" "Showcase your workstation setup, favorite IDE, mechanical keyboard, and essential dev tools."
            , featureCard "For Photographers" "Share your camera gear, lenses, editing software, and photography equipment."
            , featureCard "For Everyone" "Whatever your passion - books, art supplies, kitchen gear - show the world what you use."
            ]
        , viewLogin model
        ]


viewAuthenticated : Model -> Html Msg
viewAuthenticated model =
    div [ class "max-w-4xl mx-auto" ]
        [ h2 [ class "text-3xl font-bold mb-8" ]
            [ text "Welcome back!" ]
        , case model.user of
            RemoteData.Success users ->
                case List.head users of
                    Just user ->
                        p [ class "text-lg text-gray-700" ]
                            [ text ("Logged in as " ++ user.username) ]

                    Nothing ->
                        text ""

            RemoteData.Loading ->
                p [ class "text-lg text-gray-700" ]
                    [ text "Loading..." ]

            RemoteData.Failure err ->
                p [ class "text-lg text-red-600" ]
                    [ text (errorToString err) ]

            RemoteData.NotAsked ->
                text ""
        ]


viewLogin : Model -> Html Msg
viewLogin model =
    div [ class "max-w-md mx-auto bg-white rounded-lg shadow-md p-8" ]
        [ h2 [ class "text-2xl font-bold mb-6" ]
            [ text "Login or Sign Up" ]
        , viewAuthError model.authError
        , Html.form [ onSubmit AttemptLogin, class "space-y-4" ]
            [ div []
                [ label [ for "username", class "block text-sm font-medium text-gray-700 mb-1" ]
                    [ text "Username" ]
                , input
                    [ type_ "text"
                    , id "username"
                    , value model.username
                    , onInput UpdateUsername
                    , class "w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                    ]
                    []
                ]
            , div []
                [ label [ for "password", class "block text-sm font-medium text-gray-700 mb-1" ]
                    [ text "Password" ]
                , input
                    [ type_ "password"
                    , id "password"
                    , value model.password
                    , onInput UpdatePassword
                    , class "w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                    ]
                    []
                ]
            , div [ class "flex space-x-4" ]
                [ button
                    [ type_ "submit"
                    , class "flex-1 bg-blue-600 hover:bg-blue-700 text-white font-semibold py-2 px-4 rounded-lg"
                    ]
                    [ text "Login" ]
                , button
                    [ type_ "button"
                    , onClick AttemptSignup
                    , class "flex-1 bg-green-600 hover:bg-green-700 text-white font-semibold py-2 px-4 rounded-lg"
                    ]
                    [ text "Sign Up" ]
                ]
            ]
        ]


viewAuthError : Maybe String -> Html msg
viewAuthError maybeError =
    case maybeError of
        Just error ->
            div [ class "bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" ]
                [ text error ]

        Nothing ->
            text ""


featureCard : String -> String -> Html msg
featureCard title description =
    div [ class "bg-white rounded-lg shadow-md p-6" ]
        [ h3 [ class "text-xl font-semibold text-gray-900 mb-2" ]
            [ text title ]
        , p [ class "text-gray-600" ]
            [ text description ]
        ]


errorToString : Graphql.Http.Error a -> String
errorToString error =
    case error of
        Graphql.Http.GraphqlError _ graphqlErrors ->
            String.join "; " (List.map .message graphqlErrors)

        Graphql.Http.HttpError httpError ->
            case httpError of
                Graphql.Http.BadUrl url ->
                    "Bad URL: " ++ url

                Graphql.Http.Timeout ->
                    "Request timed out"

                Graphql.Http.NetworkError ->
                    "Network error"

                Graphql.Http.BadStatus metadata _ ->
                    "Bad status: " ++ String.fromInt metadata.statusCode

                Graphql.Http.BadPayload _ ->
                    "Invalid response from server"


main : Program (Maybe String) Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> onTokenLoad TokenLoaded
        , view = view
        } 