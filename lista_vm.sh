#echo "Start!"
#echo ""

#PROJECT=prj-lym-dev
#gcloud config set project ${PROJECT} 

gcloud projects list --format='value(project_id)' | grep dev > lista.txt

while read p; do

    #echo "Listing: $p"

    # Get instance name,zone for `${PROJECT}
    
    PROJECT=$p
    
    for PAIR in $(\
    gcloud compute instances list \
    --project=${PROJECT} \
    --format="csv[no-heading](name,zone.scope(zones))")
    do
    # Parse result from above into instance and zone vars
    IFS=, read INSTANCE ZONE <<< ${PAIR}
    # Get the machine type value only
    MACHINE_TYPE=$(\
        gcloud compute instances describe ${INSTANCE} \
        --project=${PROJECT} \
        --zone=${ZONE} \
        --format="value(machineType.scope(machineTypes))")
    # If it's custom-${vCPUs}-${RAM} we've sufficient info
    if [[ ${MACHINE_TYPE}} == custom* ]]
    then
        IFS=- read CUSTOM CPU MEM <<< ${MACHINE_TYPE}
        printf "Hostname: %s; vCPUs: %s; Mem: %s; Project: %s \n"  ${INSTANCE} ${CPU} ${MEM} ${PROJECT}
    else
        # Otherwise, we need to call `machine-types describe`
        CPU_MEMORY=$(\
        gcloud compute machine-types describe ${MACHINE_TYPE} \
        --project=${PROJECT} \
        --zone=${ZONE} \
        --format="csv[no-heading](guestCpus,memoryMb)")
        IFS=, read CPU MEM <<< ${CPU_MEMORY}
        printf "Hostname: %s; vCPUs: %s; Mem: %s;Project: %s \n" ${INSTANCE} ${CPU} ${MEM} ${PROJECT}
    fi
    done

done < lista.txt
#echo ""
#echo "Done!"

exit 0
