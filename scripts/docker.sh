
#!/bin/sh

###########################
# HELPERS
if [[ -f /scripts/common/header.sh ]]; then
  source /scripts/common/header.sh
fi

if [[ -f /scripts/common/divider.sh ]]; then
  source /scripts/common/divider.sh
fi

###########################
# SCRIPTS

if [[ -f /scripts/parts/functions.sh ]]; then
  source /scripts/parts/functions.sh
fi


###########################

big_divider
printf "\n"
printf ":::> ENV VARIABLES \n"
printf ".....................\n"
printf "\n"

printenv

###########################

start_timestamp=$(date +%T)
rm -rf "${IMPORTS_SCRIPT}"
create_config_files "${TERRAFORM_CONFIG_VARS}" "${CF_TERRAFORMING_CONFIG}"

###########################

big_divider
create_directories $CLOUDFLARE_ZONE_IDS

big_divider
import_data $CLOUDFLARE_ZONE_IDS || true

# Sync the states
sleep 2

big_divider
sync_local_and_remote_state || true

big_divider
fix_generated_imports || true

# TERRAFORM MAGIC
big_divider

# Remove the .terraform directory to clear any corrupted or mismatched cached data:
printf ":::> rm -rf .terraform && rm .terraform.lock.hcl"
printf "\n\n"
rm -rf .terraform && rm .terraform.lock.hcl

# Start the stack
divider
printf ":::> terraform init"
printf "\n\n"
terraform init

# checking everything
divider
printf ":::> terraform validate"
printf "\n\n"
terraform validate

###########################

# Let's run the infra import
sh "$IMPORTS_SCRIPT"

divider
printf ":::> terraform show : See what is being managed"
printf "\n\n"
terraform show

# # Compare the LOCAL infrastructure with the REMOTE changes
# divider
# printf ":::> terraform plan"
# printf "\n\n"
# terraform init
# printf "\n\n"

###########################

big_divider
end_timestamp=$(date +%T)
printf ":::> STARTED @ ${start_timestamp}"
printf "\n\n"
printf ":::> ENDED @ ${end_timestamp}"
printf "\n\n"
big_divider
