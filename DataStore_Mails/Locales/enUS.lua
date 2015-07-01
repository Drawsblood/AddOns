﻿local debug = false
--[===[@debug@
debug = true
--@end-debug@]===]

local L = LibStub("AceLocale-3.0"):NewLocale("DataStore_Mails", "enUS", true, debug)

L["EXPIRED_EMAILS_WARNING"] = "%s (%s) has expired (or about to expire) mails "
L["EXPIRY_ALL_ACCOUNTS_DISABLED"] = "Only the current account will be taken into consideration; imported accounts will be ignored."
L["EXPIRY_ALL_ACCOUNTS_ENABLED"] = "The expiry check routine will look for expired mails on all known accounts."
L["EXPIRY_ALL_ACCOUNTS_LABEL"] = "Check mail expiries on all known accounts"
L["EXPIRY_ALL_ACCOUNTS_TITLE"] = "Check All Accounts"
L["EXPIRY_ALL_REALMS_DISABLED"] = "Only the current realm will be taken into consideration; other realms will be ignored."
L["EXPIRY_ALL_REALMS_ENABLED"] = "The expiry check routine will look for expired mails on all known realms."
L["EXPIRY_ALL_REALMS_LABEL"] = "Check mail expiries on all known realms"
L["EXPIRY_ALL_REALMS_TITLE"] = "Check All Realms"
L["EXPIRY_CHECK_DISABLED"] = "No expiry check will be performed."
L["EXPIRY_CHECK_ENABLED"] = "Mail expiries will be checked 5 seconds after logon. Client add-ons will get a notification if at least one expired mail is found."
L["EXPIRY_CHECK_LABEL"] = "Mail Expiry Warning"
L["EXPIRY_CHECK_TITLE"] = "Check Mail Expiries"
L["REPORT_EXPIRED_MAILS_DISABLED"] = "Nothing will be displayed in the chat frame."
L["REPORT_EXPIRED_MAILS_ENABLED"] = "During the mail expiry check, the list of characters with expired emails will also be displayed in the chat frame."
L["REPORT_EXPIRED_MAILS_LABEL"] = "Mail expiry warning (chat frame)"
L["REPORT_EXPIRED_MAILS_TITLE"] = "Mail expiry warning (chat frame)"
L["SCAN_MAIL_BODY_DISABLED"] = "Only mail attachments will be read. Mails will keep their unread status."
L["SCAN_MAIL_BODY_ENABLED"] = "The body of each mail will be read when the mailbox is scanned. All mails will be marked as read."
L["SCAN_MAIL_BODY_LABEL"] = "Scan mail body (marks it as read)"
L["SCAN_MAIL_BODY_TITLE"] = "Scan Mail Body"
L["Warn when mail expires in less days than this value"] = true

