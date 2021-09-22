<#
.SYNOPSIS
Send a msg to Slack Channel

.DESCRIPTION
Send a msg to Slack Channel via the Incoming Webhook integration App. See in slack: Browse Apps / Custom Integrations / Incoming WebHook or see notes below

.PARAMETER Msg
The message to send

.PARAMETER Channel
The Channel to send to

.PARAMETER Username
The user of the message

.PARAMETER IconUrl
The url of the icon to display in the message, otherwise use emoji

.PARAMETER Emoji
The emoji to use like ':ghost:' or ':bom:' see slack documentation for more Emoji. Use IconUrl for custom emoji

.PARAMETER AsUser
Send msg as this User

.PARAMETER Token
The Incoming WebHook Token 

.PARAMETER Attachments
The json structured attachment. See Slack documentation

like
    $attachment = @{
        fallback = $msg
        pretext = "Sample message: <http://url_to_task|Test out Slack message attachments>"
        color = "danger" # good, warning
        fields = @(
            @{
              title = "[Alert]]"
              value = "This is much easier than I thought it would be. <https://www.sample.com/logo.png>|Logo"
              short = "false"
             }
        )
    }


.Example
Send-ToSlack -m 'Hello' -c 'TestChannel' -u 'me' -e ':bomb:' -t 'mytoken...'

.NOTES

for documentation about configuring Slack/Acquire token see 
https://api.slack.com/messaging/webhooks
or https://api.slack.com/legacy/custom-integrations
#>

function Send-ToSlack ([alias('m')]$Msg, [alias('c')]$Channel, [alias('u')]$Username, [alias('iu')]$IconUrl, [alias('e')]$Emoji, [alias('a')][Switch]$AsUser, [alias('t')]$Token, $Attachments)
{
    $slackUri = "https://hooks.slack.com/services/$Token"

    if ($Channel -and !($Channel.StartsWith('@'))) { $channel = "#$Channel" } else { $channel = $Channel }

    $body = @{
        channel    = $channel
        username   = $Username
        text       = $Msg
        icon_url   = $IconUrl
        icon_emoji = $Emoji
    }

    if ($null -eq $Emoji) { $body.Remove('icon_emoji') }
    if ($null -eq $IconUrl ) { $body.Remove('icon_url') }

    if ($Attachments)
    {
        [void]$body.Add('attachments', $Attachments)
    }

    try
    {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $response = Invoke-RestMethod -Uri $slackUri -Method Post -Body ($body | ConvertTo-Json -Compress -Depth 10) -ContentType 'application/json'
    }
    catch
    {
        Throw "Send-ToSlack error: $($_.Exception.Message)"
    }

    if ($response -ne 'ok')
    {
        Throw "Send-ToSlack error: $($response)"
    }
}