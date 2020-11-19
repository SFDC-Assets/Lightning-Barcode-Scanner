#!/bin/bash
#
#  Lists all of the orgs that have installed packages from this dev hub.
#
#  This code is provided AS IS, with no warranty or guarantee of suitability for use.
#  Contact: john.meyer@salesforce.com

readonly devHubOrgAlias=$(jq --raw-output .defaultdevhubusername < .sfdx/sfdx-config.json) || {
    echo "Make sure that \"jq\" is installed and that \"defaultdevhubusername\" is defined in .sfdx/sfdx-config.json." >&2
    exit 1
}

sfdx force:data:soql:query \
    --query "SELECT InstanceName, MetadataPackageId, MetadataPackageVersionId, OrgName, OrgType FROM PackageSubscriber WHERE InstalledStatus = 'i' ORDER BY MetadataPackageId, MetadataPackageVersionId" \
    --targetusername "$devHubOrgAlias"