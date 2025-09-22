#tag Class
Protected Class Tool
	#tag Method, Flags = &h1, Description = 52657475726E732054727565206966207468652070617373656420706172616D6574657220616E6420617267756D656E742061726520636F6D70617469626C652E
		Protected Function Compatible(param As MCP.ToolParameter, arg As MCP.ToolArgument) As Boolean
		  /// Returns True if the passed parameter and argument are compatible.
		  
		  // Names must match.
		  If param.Name <> arg.Name Then Return False
		  
		  // Easy if both types match.
		  If param.Type = arg.Type Then Return True
		  
		  // All integers are numbers but not all numbers are integers...
		  If param.Type = MCP.ToolParameterTypes.Integer_ And arg.Type = MCP.ToolParameterTypes.Number_ Then
		    Return False
		  End If
		  If param.Type = MCP.ToolParameterTypes.Number_ And arg.Type = MCP.ToolParameterTypes.Integer_ Then
		    Return True
		  End If
		  
		  // Not compatible.
		  Return False
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(name As String, description As String)
		  If name = "" Then
		    Raise New InvalidArgumentException("A tool cannot have an empty name.")
		  Else
		    Self.Name = name
		  End If
		  
		  If description = "" Then
		    Raise New InvalidArgumentException("You must provide a description for a tool.")
		  Else
		    Self.Description = description
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52756E73207468697320746F6F6C20616E642072657475726E732074686520726573756C742061732061204A534F4E206974656D2E20546865207365727665722077696C6C20706C6163652074686973206974656D2077697468696E207468652060726573756C742E636F6E74656E7460206F66207468652072657475726E656420726573706F6E73652E
		Function Run(args() As MCP.ToolArgument) As JSONItem
		  /// Runs this tool and returns the result as a JSON item.
		  /// The server will place this item within the `result.content` of the returned response.
		  
		  #Pragma Unused args
		  
		  Raise New UnsupportedOperationException("The `Run()` method should be overridden by subclasses.")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E732061204A534F4E20726570726573656E746174696F6E206F66207468697320746F6F6C2E
		Function ToJSONItem() As JSONItem
		  /// Returns a JSON representation of this tool.
		  
		  // Create the `web_search` tool.
		  Var tool As New JSONItem
		  tool.Value("name") = Name
		  tool.Value("description") = Description
		  
		  // Create the input schema.
		  Var inputSchema As New JSONItem
		  inputSchema.Value("type") = "object"
		  
		  // Required properties.
		  Var requiredProperties As New JSONItem("[]")
		  
		  // Define properties.
		  Var jsonProperties As New JSONItem
		  For Each param As MCP.ToolParameter In Parameters
		    If param.Required Then requiredProperties.Add(param.Name)
		    jsonProperties.Value(param.Name) = param.ToJSONItem
		  Next param
		  
		  // Add the property definitions to the schema.
		  inputSchema.Value("properties") = jsonProperties
		  
		  // Add the required properties to the schema.
		  inputSchema.Value("required") = requiredProperties
		  
		  tool.Value("inputSchema") = inputSchema
		  
		  Return tool
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 56616C69646174657320746861742074686520617267756D656E747320706173736564206D617463682077686174207468697320746F6F6C20657870656374732E2049662076616C6964207468656E20616E20656D70747920737472696E672069732072657475726E65642C206F74686572776973652077652072657475726E20746865206572726F72206D6573736167652E
		Function ValidateArguments(arguments() As MCP.ToolArgument) As String
		  /// Validates that the arguments passed match what this tool expects.
		  /// If valid then an empty string is returned, otherwise we return the error message.
		  
		  // Easy exit?
		  If Parameters.Count = 0 And arguments.Count = 0 Then Return ""
		  
		  // How many required and optional properties are there?
		  Var requiredParams(), optionalParams() As MCP.ToolParameter
		  For Each param As MCP.ToolParameter In Parameters
		    If param.Required Then
		      requiredParams.Add(param)
		    Else
		      optionalParams.Add(param)
		    End If
		  Next param
		  
		  // Clone the arguments array because we'll do some popping...
		  Var tmp() As MCP.ToolArgument
		  For Each arg As MCP.ToolArgument In arguments
		    tmp.Add(arg)
		  Next arg
		  
		  // Check required properties.
		  For i As Integer = requiredParams.LastIndex DownTo 0
		    Var param As MCP.ToolParameter = requiredParams(i)
		    For j As Integer = tmp.LastIndex DownTo 0
		      Var arg As MCP.ToolArgument = tmp(j)
		      
		      If param.Name = arg.Name And Not Compatible(param, arg) Then
		        Return "Wrong parameter type for parameter named `" + param.Name + "`. Expected " + _
		        param.Type.ToString + " but received " + arg.Type.ToString + "."
		      End If
		      
		      If Compatible(param, arg) Then
		        tmp.RemoveAt(j)
		        requiredParams.RemoveAt(i)
		        Continue For i
		      End If
		    Next j
		  Next i
		  
		  If requiredParams.Count = 1 Then
		    Return "Missing the required `" + requiredParams(0).Name + "` parameter."
		  ElseIf requiredParams.Count > 0 Then
		    Var missing() As String
		    For Each rp As MCP.ToolParameter In requiredParams
		      missing.Add(rp.Name)
		    Next rp
		    Return "Missing multiple required parameters (" + String.FromArray(missing, ", ") + ")."
		  End If
		  
		  // Check optional properties.
		  For i As Integer = optionalParams.LastIndex DownTo 0
		    Var param As MCP.ToolParameter = optionalParams(i)
		    For j As Integer = tmp.LastIndex DownTo 0
		      Var arg As MCP.ToolArgument = tmp(j)
		      
		      If param.Name = arg.Name And Not Compatible(param, arg) Then
		        Return "Wrong parameter type for parameter named `" + param.Name + "`. Expected " + _
		        param.Type.ToString + " but received " + arg.Type.ToString + "."
		      End If
		      
		      If Compatible(param, arg) Then
		        tmp.RemoveAt(j)
		        optionalParams.RemoveAt(i)
		        Continue For i
		      End If
		    Next j
		  Next i
		  
		  // Make sure we haven't been passed too many parameters.
		  If tmp.Count > 0 Then
		    Var extra() As String
		    For Each arg As MCP.ToolArgument In tmp
		      extra.Add("`" + arg.Name + "`")
		    Next arg
		    Return "Unexpected parameters (" + String.FromArray(extra, ", ") + ") passed to `" + Self.Name + "` tool."
		  End If
		  
		  // All good.
		  Return ""
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 41206465736372697074696F6E206F662077686174207468697320746F6F6C20646F65732E
		Description As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206E616D65206F66207468697320746F6F6C2E
		Name As String
	#tag EndProperty

	#tag Property, Flags = &h1, Description = 5468697320746F6F6C27732070726F706572746965732E
		Protected Parameters() As MCP.ToolParameter
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Description"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
