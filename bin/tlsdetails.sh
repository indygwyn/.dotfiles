#!/usr/bin/env bash
# Purpose:
#     Check TLS certificate and HTTPS details.
# Source:
#     https://www.gilesorr.com/blog/tls-https-details2.html


######################################################################
#                       Version Check
######################################################################
# Apple's own 'openssl' was incredibly old (0.9.8) until ~2019-06 when they
# changed to LibreSSL which is better, but doesn't support TLS 1.3.  Brew
# respects Apple's version, so we have to go on a version hunt.

OPENSSL=""

# Put most desirable/least-likely last:
for opensslbinary in /usr/local/opt/openssl@1.1/bin/openssl /usr/local/opt/openssl/bin/openssl /usr/bin/openssl
do
    # Every version of OpenSSL I've checked (several across multiple
    # OpenSSL versions and Apple's LibreSSL) respond to 'openssl version'
    # with '<brand> <version-no> ...' - there may or may not be stuff after
    # those two items (usually a build date, but not with Libre).
    #
    if [ -x "${opensslbinary}" ]
    then
        read -r brand version rest <<< "$(echo "" | "${opensslbinary}" version)"
        case "${brand}:${version}" in
            OpenSSL:1.1*) OPENSSL="${opensslbinary}" ;;
        esac
    fi
done
if [ -z "${OPENSSL}" ]
then
    echo "This script requires OpenSSL v1.1, which was not found."
    echo "If on Mac, please 'brew install openssl@1.1'"
    exit 1
fi
echo "Using OpenSSL:  ${OPENSSL}"

######################################################################
#                            Help
######################################################################

help() {
    cat << EOF
Usage:
    $(basename "${0}") [-h]|<domain-name>

Show HTTP(s) and TLS certificate details.
Do not include the 'http(s)://' leader on the domain name.

-h            show this help and exit
EOF
}


######################################################################
#                    is hostname valid
######################################################################

ishostnamevalid() {
    # given a hostname, try to find the IP and use that to determine if the
    # hostname is actually valid.  Return 0 for a valid hostname, 1 for an
    # invalid hostname.

    IP="$( dig +short "${1}")"
    if [ -z "${IP}" ]
    then
        # hostname isn't valid - no IP returned
        echo 1
    else
        # IP returned, valid hostname
        echo 0
    fi
}


######################################################################
#                       Utility Functions
######################################################################

expiry_date() {
    echo "${1}" | ${OPENSSL} x509 -noout -dates | awk 'BEGIN { FS="=" } /notAfter/ { print $2 }'
}

days_to_expiry() {
    expiry_date="$(expiry_date "${1}")"
    if date --version 2>/dev/null | grep -q GNU
    then
        # Linux (or at least GNU)
        expiry_epoch_seconds=$(date --date="${expiry_date}" "+%s")
    else
        # Assuming the Mac version:
        expiry_epoch_seconds=$(date -jf '%b %e %H:%M:%S %Y %Z' "${expiry_date}" "+%s")
    fi
    # and we convert to seconds from the Unix Epoch ...
    now_epoch_seconds=$(date "+%s")
    seconds_to_expiry=$(( expiry_epoch_seconds - now_epoch_seconds ))
    echo "$(( seconds_to_expiry / 60 / 60 / 24 ))"
}

issuer() {
    echo "${1}" | ${OPENSSL} x509 -noout -issuer | awk -F "=" '{ print $4 }' | sed -e 's@/.*@@'
}

tlsversions() {
    successful=""
    failed=""
    for tlsversion in ssl2 ssl3 tls1 tls1_1 tls1_2 tls1_3
    do
        if echo | ${OPENSSL} s_client -connect "${1}":443 -${tlsversion} > /dev/null 2> /dev/null
        then
            successful="${tlsversion} ${successful}"
        else
            failed="${tlsversion} ${failed}"
        fi
    done
    echo "${successful} (tried but unavailable: ${failed})"
}

httpversion() {
    # This 'curl' command returns nothing but a number: '1.1' for most
    # connections, but '2' for HTTP2 sites - and '0' for https:// requests
    # on an unencrypted site.
    unEncNum=$(curl -sI "${1}"         -o/dev/null -w '%{http_version}')
    EncNum=$(curl -sI   "https://${1}" -o/dev/null -w '%{http_version}')
    # since possible return values of EncNum include '1.1', which isn't a
    # valid number in Bash, this is a string comparison:
    if [ "${EncNum}" -eq "0" ]
    then
        echo "${unEncNum}"
    else
        echo "${EncNum}"
    fi
}


######################################################################
#                    Process the command line
######################################################################

if [ $# -lt 1 ]
then
    help
    exit 1
fi

# http://wiki.bash-hackers.org/howto/getopts_tutorial
while getopts ":h" opt
do
    case ${opt} in
        h)
            help
            exit 0
            ;;

        \?)
            echo "invalid option: -${OPTARG}" >&2
            help
            exit 1
            ;;

        :)
            echo "option -${OPTARG} requires an argument." >&2
            help
            exit 1
            ;;
    esac
done

domain_name="${1}"

if [ "$(ishostnamevalid "${domain_name}")" -eq "0" ]
then
    # it's extremely difficult to capture stderr and stdout into two
    # separate variables at once, so use a tmpfile:
    tmpfile="$(/usr/bin/mktemp "/tmp/$(basename "${0}").XXXXXXXX")"
    sclient_out="$(echo | ${OPENSSL} s_client -connect "${domain_name}:443" -servername "${domain_name}" 2>"${tmpfile}")"
    sclient_ret=$?
    sclient_err=$(cat "${tmpfile}")
    rm "${tmpfile}"
    if [ ${sclient_ret} -ne 0 ]
    then
        echo "There was a problem getting the certificate."
        exit 1
    fi
    if [ -z "${sclient_out}" ]
    then
        echo "No certificate returned."
    else
        echo "Expiry Date:    $(expiry_date "${sclient_out}") ($(days_to_expiry "${sclient_out}") days)"
        echo "Issuer:        $(issuer "${sclient_out}")"
        echo "TLS Versions:   $(tlsversions "${domain_name}")"
        echo "HTTP Version:   $(httpversion "${domain_name}")"
    fi
else
    echo "'${1}' appears to be an invalid domain."
fi
