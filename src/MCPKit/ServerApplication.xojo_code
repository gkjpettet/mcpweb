#tag Class
Protected Class ServerApplication
Inherits ConsoleApplication
	#tag Event
		Function Run(args() as String) As Integer
		  CommandLineParser = New MCPKit.OptionParser("")
		  
		  WillParseOptions
		  
		  Try
		    CommandLineParser.Parse(args)
		  Catch e As RuntimeException
		    MCPKit.Error(Nil, MCPKit.ErrorTypes.ServerError, "Error parsing command line arguments: " + e.Message)
		    System.DebugLog("Error parsing command line arguments: " + e.Message)
		    Exit
		  End Try
		  
		  Verbose = CommandLineParser.BooleanValue("verbose", False)
		  
		  RaiseEvent DidParseOptions
		  
		  RaiseEvent Configure
		  
		  If Verbose Then System.DebugLog(Name + " starting...")
		  
		  While True
		    Try
		      // Read from stdin and ignore blank lines.
		      Var inputLine As String = Input
		      If inputLine = "" Then Continue
		      
		      If Verbose Then System.DebugLog(Name + " received: " + inputLine)
		      
		      // Parse the input (which should be a JSON-RPC request) into a JSONItem.
		      Var request As New JSONItem(inputLine)
		      
		      // Get the request ID. Notifications do not include an ID.
		      RequestID = request.Lookup("id", "")
		      If RequestID = "" Then
		        // Could be a notification...
		        If request.HasKey("method") = False Or _
		          request.Value("method").StringValue.BeginsWith("notifications/") = False Then
		          // Not a notification so much be an error.
		          MCPKit.Error(Nil, MCPKit.ErrorTypes.InvalidRequest, "Missing `id` in request.")
		          System.DebugLog("Missing `id` in request.")
		          Exit
		        End If
		      End If
		      
		      // Process the request into a JSON response.
		      Var response As JSONItem = ProcessRequest(request)
		      
		      If response <> Nil Then
		        // Send our response to stdout so the client can use it.
		        Print(response.ToString)
		        stdout.Flush
		      End If
		      
		    Catch e As IOException
		      // End of input stream, exit gracefully.
		      Exit
		      
		    Catch e As JSONException
		      
		      MCPKit.Error(RequestID, MCPKit.ErrorTypes.ParseError, "JSON parsing error: " + e.Message)
		      
		    Catch e As RuntimeException
		      
		      MCPKit.Error(RequestID, MCPKit.ErrorTypes.ServerError, "Unexpected runtime exception: " + e.Message)
		      System.DebugLog("Error: " + e.Message)
		    End Try
		  Wend
		  
		End Function
	#tag EndEvent


	#tag Method, Flags = &h1, Description = 54616B657320616E2060617267756D656E747360204A534F4E4974656D2066726F6D206120746F6F6C2063616C6C20616E6420636F6E766572747320697420746F20616E206172726179206F6620546F6F6C50726F706572747920696E7374616E6365732E204D617920726169736520616E20496E76616C6964417267756D656E74457863657074696F6E20736F2074686973206D6574686F642073686F756C64206265207772617070656420696E20612054727920626C6F636B2E
		Protected Function ArgumentsFromJSONItem(argumentsJSON As JSONItem) As MCPKit.ToolArgument()
		  /// Takes an `arguments` JSONItem from a tool call and converts it to an array of ToolArgument
		  /// instances.
		  /// May raise an InvalidArgumentException so this method should be wrapped in a Try block.
		  
		  Var args() As MCPKit.ToolArgument
		  For Each key As String In argumentsJSON.Keys
		    Var value As Variant = argumentsJSON.Value(key)
		    Var type As MCPKit.ToolParameterTypes = TypeFromValue(value)
		    args.Add(New MCPKit.ToolArgument(key, type, value))
		  Next key
		  
		  Return args
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E7320746865207265676973746572656420746F6F6C20776974682074686520737065636966696564206E616D65206F72204E696C20696620697420646F65736E27742065786973742E
		Function GetToolNamed(toolName As String) As MCPKit.Tool
		  /// Returns the registered tool with the specified name or Nil if it doesn't exist.
		  
		  For Each tool As MCPKit.Tool In mTools
		    If tool.Name = toolName Then
		      Return tool
		    End If
		  Next tool
		  
		  Return Nil
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 48616E646C6573206120636C69656E74207265717565737420666F7220696E7469616C69736174696F6E2C2072657475726E696E6720746865204A534F4E20746F207075736820746F207374646F75742E20417373756D657320607265717565737460206973206E6F74204E696C20616E64207468617420605265717565737449446020686173206265656E207365742E
		Protected Function HandleInitialize(request As JSONItem) As JSONItem
		  /// Handles a client request for intialisation, returning the JSON to push to stdout.
		  /// Assumes `request` is not Nil and that `RequestID` has been set.
		  
		  Var response As New JSONItem
		  response.Value("jsonrpc") = "2.0"
		  response.Value("id") = If(RequestID = Nil, "null", RequestID.StringValue)
		  
		  // Create the result object.
		  Var result As New JSONItem
		  result.Value("protocolVersion") = request.Lookup("protocolVersion", PROTOCOL_VERSION)
		  
		  // Add capabilities.
		  Var capabilities As New JSONItem
		  Var tools As New JSONItem("{}")  // Empty object means we support tools.
		  capabilities.Value("tools") = tools
		  result.Value("capabilities") = capabilities
		  
		  // Add server info.
		  Var serverInfo As New JSONItem
		  serverInfo.Value("name") = Self.Name
		  serverInfo.Value("version") = _
		  MajorVersion.ToString + "." + MinorVersion.ToString + "." + BugVersion.ToString
		  result.Value("serverInfo") = serverInfo
		  
		  response.Value("result") = result
		  
		  Return response
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 48616E646C6573206120636C69656E74206E6F74696669636174696F6E2E2052657175657374494420697320696E76616C696420286E6F7420757365642920696E206E6F74696669636174696F6E732E
		Protected Sub HandleNotification(request As JSONItem)
		  /// Handles a client notification.
		  /// RequestID is invalid (not used) in notifications.
		  
		  Var notificationType As String = request.Value("method").StringValue.Replace("notifications/", "").Trim
		  Var params As JSONItem = request.Lookup("params", Nil)
		  
		  Select Case notificationType
		  Case "initialized"
		    If Verbose Then
		      System.DebugLog("MCP Client successfully initialised.")
		    End If
		    
		  Case "cancelled"
		    Var idToCancel As String = If(params <> Nil, params.Lookup("requestId", "null"), "null")
		    If Verbose Then
		      System.DebugLog("The MCP client wants to cancel request " + idToCancel + ".")
		    End If
		    
		  Case "progress"
		    If Verbose Then
		      System.DebugLog("The MCP server has reported progress.")
		    End If
		    
		  Case "roots/list_changed"
		    If Verbose Then
		      System.DebugLog("`roots/list_changed` notification received.")
		    End If
		    
		  Else
		    System.DebugLog("Unknown MCP client notification received.")
		  End Select
		  
		  Return
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E732061204A534F4E20726573706F6E736520666F72206120636C69656E742072657175657374696E6720757365206F66206120746F6F6C2E20417373756D657320746F6F6C73206861766520616C7265616479206265656E20726567697374657265642E20417373756D657320605265717565737449446020686173206265656E207365742E204D61792072657475726E20616E206572726F7220746F2074686520636C69656E742028696E2077686963682063617365204E696C2077696C6C2062652072657475726E65642066726F6D2074686973206D6574686F64292E
		Protected Function HandleToolsCall(request As JSONItem) As JSONItem
		  /// Returns a JSON response for a client requesting use of a tool.
		  /// Assumes tools have already been registered.
		  /// Assumes `RequestID` has been set.
		  /// May return an error to the client (in which case Nil will be returned from this method).
		  
		  If Not request.HasKey("params") Then
		    Var message As String = "Missing `params` key in request."
		    MCPKit.Error(RequestID, MCPKit.ErrorTypes.InvalidRequest, message)
		    If Verbose Then System.DebugLog(message)
		    Return Nil
		  End If
		  Var params As JSONItem = request.Value("params")
		  
		  // Check this server has a tool with this name and get it if it does.
		  Var toolName As String = params.Value("name")
		  If Not HasToolWithName(toolName) Then
		    Var message As String = "There is no tool named `" + toolName + "`."
		    MCPKit.Error(RequestID, MCPKit.ErrorTypes.MethodNotFound, message)
		    If Verbose Then System.DebugLog(message)
		    Return Nil
		  End If
		  Var tool As MCPKit.Tool = GetToolNamed(toolName)
		  
		  // Get the arguments to the tool.
		  Var argumentsJSON As JSONItem = params.Value("arguments")
		  
		  // Convert the arguments from a JSONItem to an array of ToolArgument instances.
		  Var arguments() As MCPKit.ToolArgument
		  Try
		    arguments = ArgumentsFromJSONItem(argumentsJSON)
		  Catch e As RuntimeException
		    Var message As String = "Invalid parameters passed."
		    MCPKit.Error(RequestID, MCPKit.ErrorTypes.InvalidParameters, message)
		    If Verbose Then System.DebugLog(message)
		    Return Nil
		  End Try
		  
		  // Validate that the arguments passed are what the tool expects.
		  Var argValidationMessage As String = tool.ValidateArguments(arguments)
		  If argValidationMessage <> "" Then
		    MCPKit.Error(RequestID, MCPKit.ErrorTypes.InvalidParameters, argValidationMessage)
		    If Verbose Then System.DebugLog(argValidationMessage)
		    Return Nil
		  End If
		  
		  If Verbose Then System.DebugLog("Calling tool: " + toolName)
		  
		  Var toolOutput As String = tool.Run(arguments)
		  
		  Return Response(toolOutput)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E732061204A534F4E20726573706F6E736520666F72206120636C69656E7420696E666F726D696E67206974207768617420746F6F6C732074686973207365727665722070726F76696465732E20417373756D657320746F6F6C73206861766520616C7265616479206265656E20726567697374657265642E20417373756D657320605265717565737449446020686173206265656E207365742E
		Protected Function HandleToolsList() As JSONItem
		  /// Returns a JSON response for a client informing it what tools this server provides.
		  /// Assumes tools have already been registered.
		  /// Assumes `RequestID` has been set.
		  
		  Var response As New JSONItem
		  response.Value("jsonrpc") = "2.0"
		  response.Value("id") = If(RequestID = Nil, "null", RequestID.StringValue)
		  
		  // The response contains a result object.
		  Var result As New JSONItem
		  
		  // Create the tools array.
		  Var tools As New JSONItem("[]")  // Start with an empty array.
		  For Each tool As MCPKit.Tool In mTools
		    tools.Add(tool.ToJSONItem)
		  Next tool
		  
		  // Add the tools to the result.
		  result.Value("tools") = tools
		  
		  // Add the result to the response.
		  response.Value("result") = result
		  
		  Return response
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73205472756520696620746869732073657276657220686173206120746F6F6C207265676973746572656420776974682060746F6F6C4E616D65602E
		Function HasToolWithName(toolName As String) As Boolean
		  /// Returns True if this server has a tool registered with `toolName`.
		  
		  For Each tool As MCPKit.Tool In mTools
		    If tool.Name = toolName Then Return True
		  Next tool
		  
		  Return False
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 50726F6365737365732061204A534F4E207265717565737420616E642072657475726E732074686520726573706F6E73652061732061204A534F4E4974656D2E20417373756D65732060726571756573746020636F6E7461696E7320616E2060696460206B657920616E6420746861742060526571756573744944602068617320616C7265616479206265656E207365742E204E6F74696669636174696F6E7320444F204E4F542068617665206120726571756573742049442E20496620616E206572726F72206F6363757273207468656E2069742069732070757368656420746F207374646F757420616E64206C6F6767656420616E64204E696C2069732072657475726E65642E
		Protected Function ProcessRequest(request As JSONItem) As JSONItem
		  /// Processes a JSON request and returns the response as a JSONItem.
		  /// Assumes `request` contains an `id` key and that `RequestID` has already been set.
		  /// Notifications DO NOT have a request ID.
		  /// If an error occurs then it is pushed to stdout and logged and Nil is returned.
		  
		  If Not request.HasKey("method") Then
		    MCPKit.Error(RequestID, MCPKit.ErrorTypes.InvalidRequest, "Missing `method` key in JSON request.")
		    System.DebugLog("Missing `method` key in JSON request.")
		    Return Nil
		  End If
		  
		  Var method As String = request.Value("method")
		  If Verbose Then System.DebugLog("Processing method: " + method)
		  Select Case method
		  Case "initialize"
		    
		    Return HandleInitialize(request)
		    
		  Case "tools/list"
		    Return HandleToolsList
		    
		  Case "tools/call"
		    Return HandleToolsCall(request)
		    
		  Else
		    
		    If method.BeginsWith("notifications/") Then
		      HandleNotification(request)
		      Return Nil // No need to provide a response from this server.
		    End If
		    
		    MCPKit.Error(RequestID, MCPKit.ErrorTypes.MethodNotFound, "Method not found: " + method)
		    Return Nil
		  End Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 5265676973746572732074686520746F6F6C732070726F76696465642062792074686973204D4350207365727665722E204561636820746F6F6C20696E2060746F6F6C73602073686F756C6420626520616E20696E7374616E6365206F6620616E20604D43502E546F6F6C6020737562636C6173732E
		Protected Sub RegisterTools(ParamArray tools() As MCPKit.Tool)
		  /// Registers the tools provided by this MCP server.
		  /// Each tool in `tools` should be an instance of an `MCPKit.Tool` subclass.
		  
		  // Make sure each tool is unique.
		  For Each tool As MCPKit.Tool In tools
		    mTools.Add(tool)
		  Next tool
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E732074686520726573756C74206F66206120746F6F6C2063616C6C20287768696368206973206120737472696E6729207772617070656420696E2061204A534F4E4974656D2E
		Function Response(toolOutput As String) As JSONItem
		  /// Returns the result of a tool call (which is a string) wrapped in a JSONItem.
		  
		  Var response As New JSONItem
		  response.Value("jsonrpc") = "2.0"
		  response.Value("id") = RequestID
		  
		  Var result As New JSONItem
		  
		  // Create the content array.
		  Var content As New JSONItem("[]")
		  
		  // Add the tool's text output.
		  Var textContent As New JSONItem
		  textContent.Value("type") = "text"
		  textContent.Value("text") = toolOutput
		  
		  content.Add(textContent)
		  result.Value("content") = content
		  
		  response.Value("result") = result
		  
		  Return response
		  
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0, Description = 43616C6C207468697320746F20706572666F726D20616E7920726571756972656420636F6E66696775726174696F6E207374657073206265666F726520746865207365727665722072756E732E2054686973206576656E742069732072616973656420696D6D6564696174656C79206265666F726520746865206052756E2829602062757420616674657220746865206057696C6C50617273654F7074696F6E7328296020616E64206044696450617273654F7074696F6E73282960206576656E742E20596F752073686F756C6420726567697374657220746F6F6C7320696E2074686973206576656E742E
		Event Configure()
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 52616973656420616674657220616E7920617267756D656E74732070617373656420746F20746865206170706C69636174696F6E2068617665206265656E2070617273656420616E642061726520617661696C61626C6520666F72207573652E
		Event DidParseOptions()
	#tag EndHook

	#tag Hook, Flags = &h0, Description = 546865206170706C69636174696F6E2069732061626F757420746F20706172736520616E79206F7074696F6E732070617373656420746F20746865206170706C69636174696F6E2E20596F752073686F756C64207265676973746572206F7074696F6E7320686572652E
		Event WillParseOptions()
	#tag EndHook


	#tag Property, Flags = &h0
		CommandLineParser As MCPKit.OptionParser
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected mTools() As MCPKit.Tool
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206E616D65206F662074686973207365727665722E
		Name As String
	#tag EndProperty

	#tag Property, Flags = &h1, Description = 546865204944206F6620746865206C6173742072657175657374206F7220602D3160206966206E6F6E652E
		Protected RequestID As Variant
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 49662054727565207468656E206164646974696F6E616C206C6F6767696E6720746F207374646572722077696C6C206F636375722E
		Verbose As Boolean = True
	#tag EndProperty


	#tag Constant, Name = PROTOCOL_VERSION, Type = String, Dynamic = False, Default = \"2025-06-18", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Verbose"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
