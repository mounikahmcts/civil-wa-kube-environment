#!/bin/sh

EMAIL="${1:-ccd-import@fake.hmcts.net}"
FORENAME="${2:-CCD}"
SURNAME="${3:-Import}"
PASSWORD="${4:-London01}"
USER_GROUP="${5:-ccd-import}"
ROLES="${6:-[\"ccd-import\"\]}"

echo "\n\nCreating user with:\nEmail: ${EMAIL}\nPassword: ${PASSWORD}\nForename: ${FORENAME}\nSurname: ${SURNAME}\nUser group: ${USER_GROUP}\nRoles: ${ROLES}\n"

curl --silent --show-error \
  ${IDAM_URL}/testing-support/accounts \
  -H "Content-Type: application/json" \
  -d '{"email": "'"${EMAIL}"'",
       "forename": "'"${FORENAME}"'",
       "surname": "'"${SURNAME}"'",
       "password": "'"${PASSWORD}"'",
       "roles": '"${ROLES}"'
      }'

echo ""
