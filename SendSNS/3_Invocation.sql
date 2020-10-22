use admin.extfuncs;

set notificationSubject = 'Job completed successfully';
set notificationBody = 'ELT job completed! No error';

select 
    admin.extfuncs.EXT_UDF_SendNotification(
            parse_json('{"Subject":"'|| $notificationSubject
                            ||'","Body":"'|| $notificationBody
                            ||'"}')
        );            