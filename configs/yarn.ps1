"Installing yarn packages ..."

# upgrade yarn
choco upgrade yarn

# install yarn global packages
ForEach ($package in 
  "create-react-app",
  "react-native",
  "react-native-cli",
  "serve",
  "init"
) {
  yarn global add $package
}