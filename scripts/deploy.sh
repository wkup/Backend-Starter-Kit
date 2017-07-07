#!/bin/bash

set -eux

# docker-compose exec app dpl --provider=heroku --app=web-go-demo --api-key=${HEROKU_TOKEN} --strategy=git

docker-compose exec app yarn run build

docker-compose exec app git config --global user.email "shyamchen1994@gmail.com"
docker-compose exec app git config --global user.name "Shyam Chen"
docker-compose exec app git add -f dist
docker-compose exec app git commit -m "Deploy - ${TRAVIS_BUILD_NUMBER} (${TRAVIS_BUILD_ID})"

cat >~/.netrc <<EOF
machine api.heroku.com
  login ${HEROKU_CREDENTIALS_EMAIL}
  password ${HEROKU_TOKEN}
machine git.heroku.com
  login ${HEROKU_CREDENTIALS_EMAIL}
  password ${HEROKU_TOKEN}
EOF

chmod +x ~/.netrc

# {
#   echo "#!/bin/bash"
#   (
#     echo "$HEROKU_CREDENTIALS_EMAIL"
#     echo "$HEROKU_CREDENTIALS_PASSWORD"
#   ) | heroku login
# } > heroku.sh
# docker-compose exec app heroku.sh



docker-compose exec app yarn run deploy
