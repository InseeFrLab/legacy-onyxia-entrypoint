curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g yarn
code-server --install-extension vscodevim.vim
cd /home/coder/work
echo "test" > hello4.txt
git clone tss-react   && cd tss-react   && yarn        && yarn build
git clone powerhooks  && cd powerhooks  && yarn        && yarn build
git clone onyxia-ui   && cd onyxia-ui   && yarn        && yarn build
git clone keycloakify && cd keycloakify && yarn        && yarn build
git clone evt         && cd evt         && npm install && npm run build
git clone cra-envs    && cd cra-envs    && yarn        && yarn build
git clone tsafe       && cd tsafe       && yarn        && yarn build
git clone clean-redux && cd clean-redux && yarn        && yarn build
git clone onyxia-web  && cd onyxia-web  && yarn        && yarn link_inhouse_deps
