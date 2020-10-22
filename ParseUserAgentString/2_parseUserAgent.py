import json
from user_agents import parse # https://pypi.org/project/user-agents/#description

def parseUserAgent(event, context):
    retVal= {} # The value/object to return to Snowflake
    retVal["data"] = []

    for row in event["data"]:
        sflkRowRef = row[0] # This is how Snowflake keeps track of data as it gets returned
        userAgentInput = row[1] # The data passed in from Snowflake that the input row contains.
                                # If the passed in data was a Variant, it lands here as a dictionary. Handy!
        
        user_agent = parse(userAgentInput) # user_agent object is not serializable

        # Create a Dictionary from the user_agent properties
        userAgentOutput = {}
        userAgentOutput["Browser"] = {} 
        userAgentOutput["Browser"]["Family"] = user_agent.browser.family
        userAgentOutput["Browser"]["Version"] = user_agent.browser.version
        userAgentOutput["Browser"]["VersionString"] = user_agent.browser.version_string

        userAgentOutput["OS"] = {}
        userAgentOutput["OS"]["Family"] = user_agent.os.family
        userAgentOutput["OS"]["Version"] = user_agent.os.version
        userAgentOutput["OS"]["VersionString"] = user_agent.os.version_string

        userAgentOutput["OS"] = {}
        userAgentOutput["OS"]["Family"] = user_agent.device.family
        userAgentOutput["OS"]["Brand"] = user_agent.device.brand
        userAgentOutput["OS"]["Model"] = user_agent.device.model

        userAgentOutput["IsMobile"] = user_agent.is_mobile
        userAgentOutput["IsTablet"] = user_agent.is_tablet
        userAgentOutput["IsTouchCapable"] = user_agent.is_touch_capable
        userAgentOutput["IsPC"] = user_agent.is_pc
        userAgentOutput["IsBot"] = user_agent.is_bot
        
        # prepare this rows response
        response = {}
        response["UserAgentInput"] = userAgentInput
        response["ParsedUserAgent"] = userAgentOutput

        # add this row to the full returned-to-snowflake response
        # It must have the row identifier
        retVal["data"].append([sflkRowRef,response])

    return retVal