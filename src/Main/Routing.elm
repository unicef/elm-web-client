module Main.Routing exposing
    ( Route(..)
    , assetPath
    , createInitiativePath
    , exploreInitiativesPath
    , forgotPassPath
    , homepagePath
    , loginPath
    , logoutPath
    , notificationPath
    , parseLocation
    , privacyPath
    , profilePath
    , signupPath
    , termsPath
    )

import Navigation exposing (Location)
import UrlParser exposing ((</>), Parser, int, map, oneOf, parseHash, s, string, top)


type Route
    = NotFoundRoute
    | HomepageRoute
    | UserLoginRoute
    | UserForgotRoute
    | UserForgotResetPassRoute Int String
    | UserSignupRoute
    | PrivacyRoute
    | TermsRoute
    | ExploreInitiativesRoute
    | NotificationRoute
    | CreateInitiativeRoute
    | AssetRoute Int
    | ProfileRoute Int


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map HomepageRoute top
        , map UserLoginRoute (s "login")
        , map UserSignupRoute (s "signup")
        , map UserForgotRoute (s "forgot")
        , map UserForgotResetPassRoute (s "forgot-reset-password" </> int </> string)
        , map ExploreInitiativesRoute (s "explore-assets")
        , map NotificationRoute (s "notification")
        , map CreateInitiativeRoute (s "create-asset")
        , map TermsRoute (s "site-terms")
        , map PrivacyRoute (s "site-privacy")
        , map AssetRoute (s "asset" </> int)
        , map ProfileRoute (s "profile" </> int)
        ]


parseLocation : Location -> Route
parseLocation location =
    case parseHash matchers location of
        Just route ->
            route

        Nothing ->
            NotFoundRoute


homepagePath : String
homepagePath =
    "#"


loginPath : String
loginPath =
    "#login"


forgotPassPath : String
forgotPassPath =
    "#forgot"


signupPath : String
signupPath =
    "#signup"


logoutPath : String
logoutPath =
    "#logout"


exploreInitiativesPath : String
exploreInitiativesPath =
    "#explore-assets"


notificationPath : String
notificationPath =
    "#notification"


createInitiativePath : String
createInitiativePath =
    "#create-asset"


assetPath : Int -> String
assetPath assetId =
    "#asset/" ++ toString assetId


profilePath : Int -> String
profilePath userId =
    "#profile/" ++ toString userId


termsPath : String
termsPath =
    "#site-terms"


privacyPath : String
privacyPath =
    "#site-privacy"
