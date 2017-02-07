type Color = Red | Blue | Orange | Pink | GreenWhichIsNotACreativeColor

isMyFavoriteColor :: Color -> Bool
isMyFavoriteColor color = case color of
                            Red -> True
                            _ -> False

isWarmColor :: Color -> Bool
isWarmColor color = case color of
                      Red -> True
                      Orange -> True
                      _ -> False

isColdColor :: Color -> Bool
isColdColor Red = False
isColdColor Orange = False
isColdColor Blue = True
isColdColor Pink = False
isColdColor GreenWhichIsNotACreativeColor = True
