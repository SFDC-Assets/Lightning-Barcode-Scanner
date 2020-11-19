#!/bin/bash
#
#  Creates a new scratch org and populates it with sample data.
#
#  This code is provided AS IS, with no warranty or guarantee of suitability for use.
#  Contact: john.meyer@salesforce.com

readonly orgAlias=$(jq --raw-output .defaultusername < .sfdx/sfdx-config.json) || {
    echo "Make sure that \"jq\" is installed and that \"defaultusername\" is defined in .sfdx/sfdx-config.json." >&2
    exit 1
}
readonly devHubUserName=$(jq --raw-output .defaultdevhubusername < .sfdx/sfdx-config.json) || {
    echo "Make sure that \"jq\" is installed and that \"defaultdevhubusername\" is defined in .sfdx/sfdx-config.json." >&2
    exit 1
}

echo "*** Creating scratch org ..."
sfdx force:org:create \
    --definitionfile config/project-scratch-def.json \
    --type scratch \
    --nonamespace \
    --targetdevhubusername "$devHubUserName" \
    --setdefaultusername \
    --setalias "$orgAlias" \
    --durationdays 30 \
    --loglevel error || exit 1
echo "*** Pushing metadata to scratch org ..."
sfdx force:source:push || exit 1
echo "*** Assigning permission set to your user ..."
sfdx force:user:permset:assign --permsetname Barcode_Scanner --loglevel error
echo "*** Generating password for your user ..."
sfdx force:user:password:generate --targetusername "$orgAlias" --loglevel error
echo "*** Setting time zone for your user ..."
sfdx force:data:record:update --sobjecttype User --where "Name='User User'" --values "TimeZoneSidKey='America/New_York'" --loglevel error