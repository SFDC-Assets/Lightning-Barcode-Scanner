#!/bin/bash
#
#  Deletes the current scratch org.
#
#  This code is provided AS IS, with no warranty or guarantee of suitability for use.
#  Contact: john.meyer@salesforce.com

readonly devHubOrgAlias=$(jq --raw-output .defaultdevhubusername < .sfdx/sfdx-config.json) || {
    echo "Make sure that \"jq\" is installed and that \"defaultdevhubusername\" is defined in .sfdx/sfdx-config.json." >&2
    exit 1
}
readonly tmpFile=$(jq --raw-output .defaultdevhubusername < .sfdx/sfdx-config.json) || {
    echo "Make sure that \"jq\" is installed and that \"defaultdevhubusername\" is defined in .sfdx/sfdx-config.json." >&2
    exit 1
}
readonly scratchOrgId=$(sfdx force:org:display --json | jq --raw-output .result.id | cut -c 1-15)

sfdx force:data:soql:query \
    --query "SELECT Id FROM ScratchOrgInfo WHERE ScratchOrg = '$scratchOrgId'" \
    --resultformat csv \
    --targetusername "$devHubOrgAlias" > "$tmpFile"
echo "*** Found scratch org $scratchOrgId ..."
sfdx force:data:bulk:delete --csvfile "$tmpFile" --sobjecttype ScratchOrgInfo --wait 10 --targetusername "$devHubOrgAlias" --loglevel error
rm -f "$tmpFile"