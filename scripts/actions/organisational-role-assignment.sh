#!/bin/sh
## Usage: ./organisational-role-assignment.sh [username] [password] [role_classification] [role_name] [role_attributes] [microservice_name]
##
## Options:
##    - username: Email for user. Default to `ccd-import@fake.hmcts.net`.
##    - password: Password for user. Default to `London01`.
##    - role_classification: Role assignment classification. Default to `PUBLIC`.
##    - role_name: Name of the role for role-assignment. Default to `tribunal-caseworker`.
##    - role_attributes: Role attributes to add to role assignment. Default to `jurisdiction: "IA"`.
##    - microservice_name: Name of the microservice to obtain S2S token. Default to `ccd_gw`.
##

USERNAME=${1:-ccd-import@fake.hmcts.net}
PASSWORD=${2:-London01}
ROLE_CLASSIFICATION="${3:-PUBLIC}"
ROLE_NAME="${4:-"tribunal-caseworker"}"
ROLE_ATTRIBUTES="${5:-'{"jurisdiction":"IA"}'}"
MICROSERVICE="${6:-wa_task_management_api}"

BASEDIR=$(dirname "$0")

USER_TOKEN=$($BASEDIR/idam-user-token.sh $USERNAME $PASSWORD)
USER_ID=$($BASEDIR/idam-user-id.sh $USER_TOKEN)
SERVICE_TOKEN=$($BASEDIR/idam-service-token.sh $MICROSERVICE)

echo "\n\nCreating role assignment: \n User: ${USER_ID}\n Role name: ${ROLE_NAME}\n ROLE_CLASSIFICATION: ${ROLE_CLASSIFICATION}\n"

curl --silent --show-error -X POST "${ROLE_ASSIGNMENT_URL}/am/role-assignments" \
  -H "accept: application/vnd.uk.gov.hmcts.role-assignment-service.create-assignments+json;charset=UTF-8;version=1.0" \
  -H "Authorization: Bearer ${USER_TOKEN}" \
  -H "ServiceAuthorization: Bearer ${SERVICE_TOKEN}" \
  -H "Content-Type: application/json" \
  -d '{ "roleRequest": {
          "assignerId": "'"${USER_ID}"'",
          "process": "staff-organisational-role-mapping",
          "reference": "'"${USER_ID}/${ROLE_NAME}"'",
          "replaceExisting": true
        },
        "requestedRoles": [
          {
            "actorIdType": "IDAM",
            "actorId": "'"${USER_ID}"'",
            "roleType": "ORGANISATION",
            "roleName": "'"${ROLE_NAME}"'",
            "classification": "'"${ROLE_CLASSIFICATION}"'",
            "grantType": "STANDARD",
            "roleCategory": "LEGAL_OPERATIONS",
            "readOnly": false,
            "attributes": '${ROLE_ATTRIBUTES}'
          }
        ]
      }'
