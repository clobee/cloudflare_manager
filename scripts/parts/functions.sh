#!/bin/sh

###########################
# FUNCTIONS

create_config_files() {

  terraform_config_vars=$1
  cf_terraforming_config=$2

  # Create cf-terraforming config
  echo "cloudflare_email   = \"${CLOUDFLARE_EMAIL}\"" > $terraform_config_vars
  echo "cloudflare_api_key = \"${CLOUDFLARE_API_KEY}\"" >> $terraform_config_vars

  # Create cf-terraforming config
  echo "email: \"${CLOUDFLARE_EMAIL}\"" > $cf_terraforming_config
  echo "key: \"${CLOUDFLARE_API_KEY}\"" >> $cf_terraforming_config
}

create_directories () {

  cpt=0
  for zone_id in $CLOUDFLARE_ZONE_IDS; do
    if [ $cpt -gt 1 ]; then
      divider
    fi

    printf "[ create_directories() ] \n\n"
    printf "# ZONE_ID: \"${zone_id}\""
    printf "\n\n"

    dir="${DIR_GENERATED}/${zone_id}"

    cmd0="rm -rf ${dir}"
    printf ":::> ${cmd0}"
    printf "\n"
    $(echo "${cmd0}")

    cmd="mkdir -vp ${dir}"
    printf ":::> ${cmd}"
    printf "\n"
    $(echo "${cmd}")

    # for type in $MANAGED_SERVICES; do
    #   dir="${DIR_GENERATED}/${zone_id}/${type}"
    #   cmd="mkdir -vp ${dir}"
    #   printf ":::> ${cmd}"
    #   printf "\n"
    #   $(echo "${cmd}")
    # done

    cpt=$((cpt + 1))
  done

}

import_data () {

  cpt=0
  for zone_id in $CLOUDFLARE_ZONE_IDS; do
    if [ $cpt -gt 1 ]; then
      divider
    fi

    printf "[ import_data() ] \n\n"
    printf "# ZONE_ID: \"${zone_id}\""
    printf "\n\n"

    for type in $MANAGED_SERVICES; do

      divider

      dir="${DIR_GENERATED}/${zone_id}/${type}"
      file="${DIR_GENERATED}/${zone_id}/${type}.tf"

      cmd="cf-terraforming generate \
      --resource-type \"${type}\" \
      --zone \"${zone_id}\" \
      --terraform-binary-path `which terraform` \
      | tee -a -i \"${file}\""

      printf ":::> ${cmd} \n"
      printf "\n"
      eval "${cmd}"

      #Delete empty file
      if [ ! -s "${file}" ]; then
        rm "${file}"
      fi

    done

    cpt=$((cpt + 1))
  done

}

sync_local_and_remote_state () {

  # NEW_MANAGED_SERVICES=$(echo $MANAGED_SERVICES | tr -s ' ' ',')

  cpt=0
  for zone_id in $CLOUDFLARE_ZONE_IDS; do
    if [ $cpt -gt 1 ]; then
      divider
    fi

    printf "[ sync_local_and_remote_state() ] \n\n"
    printf "# Generates commands to be run (see ${IMPORTS_SCRIPT}) \n\n"
    printf "# ZONE_ID: \"${zone_id}\""
    printf "\n\n"

    echo "#!/bin/sh" > $IMPORTS_SCRIPT

    for type in $MANAGED_SERVICES; do

      divider

      cmd="cf-terraforming import \
      --resource-type \"${type}\" \
      --zone \"${zone_id}\" \
      --terraform-binary-path `which terraform`"

      printf ":::> ${cmd} \n"
      printf "\n"
      result=$(eval "${cmd}")

      echo "${result}" >> $IMPORTS_SCRIPT

    done

    cpt=$((cpt + 1))
  done

  if [ -s "${IMPORTS_SCRIPT}" ]; then
    divider
    printf ":::> Commands to be run from ${IMPORTS_SCRIPT} \n\n"
    cat "${IMPORTS_SCRIPT}"
  fi
}


fix_generated_imports () {

  if [ ! -s "${IMPORTS_SCRIPT}" ]; then
    printf ":::> No commands to fix found in ${IMPORTS_SCRIPT} \n\n"
    return 1
  fi

  cpt=0
  for zone_id in $CLOUDFLARE_ZONE_IDS; do
    if [ $cpt -gt 1 ]; then
      divider
    fi

    printf "[ fix_imports() ] \n\n"
    printf "# Fix the generated imports in ${IMPORTS_SCRIPT} \n\n"
    printf "\n\n"

    for type in $MANAGED_SERVICES; do

      divider

      cmd="sed -i 's/import ${type}/import module.zone_id_${zone_id}\.${type}/g' $IMPORTS_SCRIPT"

      printf ":::> ${cmd} \n"
      printf "\n"
      eval "${cmd}"

    done

    cpt=$((cpt + 1))
  done

  printf ":::> Commands to be run from ${IMPORTS_SCRIPT} \n\n"
  cat "${IMPORTS_SCRIPT}"

  chmod +x "${IMPORTS_SCRIPT}"
  source "${IMPORTS_SCRIPT}"
}
