im silly

# Resource access protocol
	Inspired by HTTP response codes, of course
#### Request processed successfully
- 100 - SUCCESS
	- resource in response body
- 101 - SUCCESS + NOTES
	- resource in response body
	- additional human-readable notes in response header
- 102 - SUCCESS + UPDATE
	- resource in response body
	- updates in response header, specifying new access methods/locations etc. - may also contain human-readable notes about the update
- 103 - REDIRECT, THEN SUCCESS
	- resource in response body
	- redirection details in response header, specifying the path followed to find the resource (e.g. in json), may also contain human-readable notes about the redirection - the client can memorize to the new location using either this or the following field
	- updates in response header, specifying new access methods/locations etc. - may also contain human-readable notes about the update
#### Client fault
- *200 - CLIENT FAULT does not exist, as the server cannot determine wether the client has a defect, it can only analyze the requests*
- 201 - BAD REQUEST
	- human readable details about the errors in the request in response header
	- (optional) machine-readable details on how to adapt and send good requests
- 203 - REDIRECT, THEN BAD REQUEST
		*initial request was good, redirected, request is bad for new location*
	- redirection details in response header, specifying the path followed to find the resource (e.g. in json), may also contain human-readable notes about the redirection - the client can memorize to the new location using either this or the following field
	- updates in response header, specifying correct access methods for new location - may also contain human-readable notes about the update
	- (optional) machine-readable details on how to adapt and send good requests
#### Server fault
- 300 - SERVER FAULT
	- error message in response header
- 301 - SERVER UNAVAILABLE
	- error message in response header
- 302 - UNABLE TO RETRIEVE
		*resource exists, but cannot be retrieved. in case of inexistent resource, see [[possible-response-codes-for-creating-a-protocol#^47533c|404]].* ^08ef5c
	- error message in response header
- 303 - REDIRECTION, THEN SERVER FAULT
		*initial request was good, redirected, server fault in new location*
	- redirection details in response header, specifying the path followed to find the resource (e.g. in json), may also contain human-readable notes about the redirection - the client can memorize to the new location using either this or the following field
	- updates in response header, specifying other access methods to try for new location - may also contain human-readable notes about the update
#### Cannot return resource
- 400 - CANNOT RETURN
	- error message in response header
- 401 - CONNECTION UNSAFE
		*connection is either unstable or unencrypted*
	- error message in response header
- 402 - UNSUPPORTED RESPONSE
		*cannot appropriately format the response for transmission*
	- error message in response header
- 403 - REDIRECTED, THEN CANNOT RETURN
		*initial request was good, redirected, cannot return from new location*
	- redirection details in response header, specifying the path followed to find the resource (e.g. in json), may also contain human-readable notes about the redirection - the client can memorize to the new location using either this or the following field
	- updates in response header, specifying other access methods to try for new location - may also contain human-readable notes about the update
- 404 - NOT FOUND
		*resource was not found. in case of existing unretrievable resource, see [[possible-response-codes-for-creating-a-protocol#^08ef5c|302]].* ^47533c
	- error message in response header
- 405 - INSUFFICIENT PERMISSIONS
		*client does not have sufficient permission for access, client is blacklisted, client is not whitelisted, resource is locked behind paywall. for other reasons, see [[possible-response-codes-for-creating-a-protocol#^12dc38|406]].*
	- error message in response header
- 406 - ACCESS FORBIDDEN ^12dc38
		*resource cannot be distributed*
	- error message in response header
#### Media and caching
*response codes when requesting resource. last cache date should be passed in the request*
- 501 - NOT MODIFIED
	- cached resource still works
- 502 - MODIFIED
	- cached resource no longer works
	- response body contains new resource
- 503 - REDIRECTED, THEN NOT MODIFIED
		*initial request was good, redirected, resource is not modified in new location*
	- redirection details in response header, specifying the path followed to find the resource (e.g. in json), may also contain human-readable notes about the redirection - the client can memorize to the new location using either this or the following field
	- updates in response header, specifying other access methods to try for new location - may also contain human-readable notes about the update
- 504 - REDIRECTED, THEN MODIFIED
		*initial request was good, redirected, resource is modified in new location*
	- redirection details in response header, specifying the path followed to find the resource (e.g. in json), may also contain human-readable notes about the redirection - the client can memorize to the new location using either this or the following field
	- updates in response header, specifying other access methods to try for new location - may also contain human-readable notes about the update
#### Other
- 901 - REFUSED TO PROCESS
		*server refused to process the request*
	- information message in response header
- 999 - OTHER RESPONSE TYPE
		*request was not handled in any of the defined ways*
	- information message in response header
