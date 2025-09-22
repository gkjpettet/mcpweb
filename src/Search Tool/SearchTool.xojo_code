#tag Class
Protected Class SearchTool
Inherits MCP.Tool
	#tag Method, Flags = &h0
		Sub Constructor()
		  // Pass the superclass this tool's name and description.
		  Super.Constructor("search", _
		  "Searches the web and returns text content from the most relevant webpage.")
		  
		  // The `query` parameter is a string.
		  Var queryParam As New MCP.ToolParameter("query", MCP.ToolParameterTypes.String_, _
		  "The web search query.", False, "", True)
		  Parameters.Add(queryParam)
		  
		  // `maxLength` is an optional integer specifying the maximum length of the result returned.
		  Var maxLenParam As New MCP.ToolParameter("maxLength", MCP.ToolParameterTypes.Integer_, _
		  "The maximum number of characters to return from the web search.", True, DEFAULT_MAX_LENGTH, False)
		  
		  Parameters.Add(maxLenParam)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52756E2061207765622073656172636820616761696E7374207468652071756572792E
		Function Run(args() As MCP.ToolArgument) As JSONItem
		  /// Run a web search against the query.
		  
		  // Get the arguments and their values.
		  // The MCP server application will have validated that the arguments passed are valid.
		  Var query As String
		  Var maxLength As Integer = DEFAULT_MAX_LENGTH
		  For Each arg As MCP.ToolArgument In args
		    Select Case arg.Name
		    Case "query"
		      query = arg.Value.StringValue
		    Case "maxLength"
		      maxLength = Max(1, arg.Value.IntegerValue)
		    End Select
		  Next arg
		  
		  If App.Verbose Then
		    System.DebugLog("Search query: " + query)
		    System.DebugLog("Seach maxLength: " + maxLength.ToString)
		  End If
		  
		  Var summary As String = "Aoife Pettet is a trampolinist, pianist and grammar school student."
		  
		  Var result As New JSONItem
		  result.Value("summary") = summary
		  result.Value("url") = "https://garrypettet.com/info"
		  result.Value("relevance_score") = 0.95
		  
		  Return result
		  
		End Function
	#tag EndMethod


	#tag Constant, Name = DEFAULT_MAX_LENGTH, Type = Double, Dynamic = False, Default = \"5000", Scope = Public
	#tag EndConstant


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
