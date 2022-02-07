
let packages = [
  { name = "base"
  , repo = "https://github.com/dfinity/motoko-base.git"
  , version = "57c3bb724dfe36928d443f5a81446872bf646de9" --0.6.20
  , dependencies = [] : List Text
  },
  { name = "matchers"
  , repo = "https://github.com/kritzcreek/motoko-matchers"
  , version = "v1.2.0"
  , dependencies = [ "base" ]
  },
  { name = "color"
  , repo = "https://github.com/ByronBecker/motoko-color"
  , version = "v1.0.0"
  , dependencies = [ "base", "matchers" ]
  }
]

in packages