"Installing yarn packages ..."

# upgrade yarn
choco upgrade yarn

# install yarn global packages
ForEach ($package in 
  "create-react-app",
  "react-native",
  "react-native-cli",
  "serve"
) {
  yarn global add $package
}