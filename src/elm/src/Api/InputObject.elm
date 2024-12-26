-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Api.InputObject exposing (..)

import Api.Interface
import Api.Object
import Api.Scalar
import Api.ScalarCodecs
import Api.Union
import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode


buildAdminLoginInput :
    AdminLoginInputRequiredFields
    -> AdminLoginInput
buildAdminLoginInput required____ =
    { password = required____.password }


type alias AdminLoginInputRequiredFields =
    { password : String }


{-| Type for the AdminLoginInput input object.
-}
type alias AdminLoginInput =
    { password : String }


{-| Encode a AdminLoginInput into a value that can be used as an argument.
-}
encodeAdminLoginInput : AdminLoginInput -> Value
encodeAdminLoginInput input____ =
    Encode.maybeObject
        [ ( "password", Encode.string input____.password |> Just ) ]


buildLoginInput :
    LoginInputRequiredFields
    -> LoginInput
buildLoginInput required____ =
    { username = required____.username, password = required____.password }


type alias LoginInputRequiredFields =
    { username : String
    , password : String
    }


{-| Type for the LoginInput input object.
-}
type alias LoginInput =
    { username : String
    , password : String
    }


{-| Encode a LoginInput into a value that can be used as an argument.
-}
encodeLoginInput : LoginInput -> Value
encodeLoginInput input____ =
    Encode.maybeObject
        [ ( "username", Encode.string input____.username |> Just ), ( "password", Encode.string input____.password |> Just ) ]


buildSignupInput :
    SignupInputRequiredFields
    -> SignupInput
buildSignupInput required____ =
    { username = required____.username, password = required____.password }


type alias SignupInputRequiredFields =
    { username : String
    , password : String
    }


{-| Type for the SignupInput input object.
-}
type alias SignupInput =
    { username : String
    , password : String
    }


{-| Encode a SignupInput into a value that can be used as an argument.
-}
encodeSignupInput : SignupInput -> Value
encodeSignupInput input____ =
    Encode.maybeObject
        [ ( "username", Encode.string input____.username |> Just ), ( "password", Encode.string input____.password |> Just ) ]
