#!/bin/bash
#
#  Gets information on all scratch orgs associated with the dev hub.
#
#  This code is provided AS IS, with no warranty or guarantee of suitability for use.
#  Contact: john.meyer@salesforce.com

readonly devHubOrgAlias=$(jq --raw-output .defaultdevhubusername < .sfdx/sfdx-config.json) || {
    echo "Make sure that \"jq\" is installed and that \"defaultdevhubusername\" is defined in .sfdx/sfdx-config.json." >&2
    exit 1
}

sfdx force:data:soql:query \
    --targetusername "$devHubOrgAlias" \
    --query "SELECT ScratchOrg, Name, OrgName, Status, UserName, ExpirationDate FROM ScratchOrgInfo" \
    --loglevel error