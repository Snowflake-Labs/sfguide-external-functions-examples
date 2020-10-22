Enables Notifications from Snowflake. 

Be aware that Snowflake does **NOT** guarantee an ExternalFunction will be called only once. This may result in multiple notifications being sent.

To minimise this;
* Increase your Lambda timeout to more than the default 3 seconds
* Only send one notification in your ExternalFunction call. Let SNS do the email-many-recipients