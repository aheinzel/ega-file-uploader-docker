#!/bin/bash

set -e

USAGE=$(cat << EOF
USAGE: ${0} encrypt|upload [encrypt|upload] -o output [-i input -f num_threads]
Actions:
 encrypt: run EGACryptor to encrypt all files in the input directory (-i)
 upload: upload the given output directory (-o) to EGA

Both actions can be run at once.

Options:
 -i input directory containing files to be encrytped
 -o output directory for encrypted files; when action encrypt
    is used this directory must not exist prior to the execution;
    command upload will upload the entire output directory to EGA
 -t number of threads used by EGACrytpor (default 1)

EGA user credentials for uploading must be provided via the
environment variables ASPERA_SCP_USER and ASPERA_SCP_PASS
EOF
)

function print_usage_and_die(){
   echo "${USAGE}" >&2
   exit 1
}

#parse actions
while [[ $# -gt 0 ]] && { echo "${1}" | grep -v "^-" > /dev/null || [[ "${1}" == "-h" ]]; }
do
   case "$1" in
      encrypt)
         do_encrypt=1
         ;;
      upload)
         do_upload=1
         ;;
      -h)
         print_usage_and_die
         ;;
      *)
         echo "ERROR: unknown action ${1}" >&2
         print_usage_and_die
   esac

   shift
done

#parse options
while getopts "i:o:t:" option
do
   case "${option}" in
      i)
         input_dir="${OPTARG}"
         ;;
      o)
         output_dir="${OPTARG}"
         ;;
      t)
         num_threads="${OPTARG}"
   esac
done


if [[ ! ( -v do_encrypt || -v do_upload ) ]]
then
   echo "ERROR: missing action" >&2
   print_usage_and_die
fi


if [[ -v do_encrypt ]]
then
   if [[ -z "${input_dir}" ]]
   then
      echo "ERROR: input dir (-i) must be set for encrypt" >&2
      print_usage_and_die
   fi

   if [[ -z "${output_dir}" ]]
   then
      echo "ERROR: output dir (-o) must be set for encrypt" >&2
      print_usage_and_die
   fi


   if [[ -d "${output_dir}" ]]
   then
      echo "ERROR: output dir (-o) must not exist when encrypting" >&2
      print_usage_and_die
   fi
fi


if [[ -v do_upload ]]
then
   if [[ -z "${output_dir}" ]]
   then
      echo "ERROR: output dir (-o) must be set when uploading" >&2
      print_usage_and_die
   fi

   if [[ ! -v do_encrypt && ! -d "${output_dir}" ]]
   then
      echo "ERROR: output dir (-o) must exist when uploading" >&2
      print_usage_and_die
   fi

   if [[ -z "${ASPERA_SCP_USER}" || -z "${ASPERA_SCP_PASS}" ]]
   then
      echo "ERROR: EGA user credentials must be provided via env variables ASPERA_SCP_USER and ASPERA_SCP_PASS when uploading" >&2
      print_usage_and_die
   fi
fi



if [[ -v do_encrypt ]]
then
   mkdir "${output_dir}"
   args=("-i" "${input_dir}" "-o" "${output_dir}")
   if [[ ! -z "${num_threads}" ]]
   then
      args+=("-t" "${num_threads}")
   fi

   java -jar /home/ega/.egacryptor/ega-cryptor-2.0.0.jar "${args[@]}"
fi


if [[ -v do_upload ]]
then
   /home/ega/.aspera/connect/bin/ascp -P33001 -O33001 -QT "${output_dir}" "${ASPERA_SCP_USER}@fasp.ega.ebi.ac.uk:/"
fi
