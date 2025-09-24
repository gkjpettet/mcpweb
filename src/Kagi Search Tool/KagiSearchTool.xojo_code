#tag Class
Protected Class KagiSearchTool
Inherits MCP.Tool
	#tag Method, Flags = &h0
		Sub Constructor(apiKey As String)
		  // Pass the superclass this tool's name and description.
		  Super.Constructor("search", _
		  "Searches the web using the specified search engine and returns text content from the most" + _
		  " relevant web pages.")
		  
		  Self.APIKey = apiKey
		  
		  // The `query` parameter is a string.
		  Var query As New MCP.ToolParameter("query", MCP.ToolParameterTypes.String_, _
		  "The web search query.", False, "", True)
		  Parameters.Add(query)
		  
		  // `maxLength` is an optional integer specifying the maximum length of the result returned.
		  Var maxLen As New MCP.ToolParameter("maxLength", MCP.ToolParameterTypes.Integer_, _
		  "The maximum number of characters to return from the web search.", True, DEFAULT_MAX_LENGTH, False)
		  
		  Parameters.Add(maxLen)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52756E2061207765622073656172636820616761696E73742074686520717565727920616E642072657475726E73206120666F726D6174746564207465787420726573706F6E73652E20546865207365727665722077696C6C20706C6163652074686973206974656D20617320746865206F6E6C7920656E74727920696E207468652060726573756C742E636F6E74656E7460206172726179206F66207468652072657475726E656420726573706F6E73652E
		Function Run(args() As MCP.ToolArgument) As String
		  /// Run a web search against the query and returns a formatted text response.
		  /// The server will place this item as the only entry in the `result.content` array of 
		  /// the returned response.
		  
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
		  
		  Var engine As New Kagi.Search(APIKey)
		  
		  If App.Verbose Then
		    System.DebugLog("Search query: " + query)
		    System.DebugLog("Seach maxLength: " + maxLength.ToString)
		  End If
		  
		  // Perform the search.
		  Var response As Kagi.SearchResponse = engine.Search(query)
		  
		  Return SummariseResponse(response)
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 53756D6D6172697365732074686520706173736564204B6167692073656172636820726573706F6E736520696E746F20612073696E676C6520737472696E6720666F722072657475726E696E6720746F20746865204C4C4D2E
		Protected Function SummariseResponse(response As Kagi.SearchResponse) As String
		  /// Summarises the passed Kagi search response into a single string for returning to the LLM.
		  
		  Var summary() As String
		  
		  If Not response.Success Then
		    Return "An error occurred whilst performing the search: " + response.ErrorMessage
		  End If
		  
		  If response.Results.Count = 0 Then Return "0 results found."
		  
		  If response.Results.Count = 1 Then
		    summary.Add("1 result found.")
		  Else
		    summary.Add(response.Results.Count.ToString + " results found.")
		  End If
		  summary.Add(EndOfLine)
		  
		  For i As Integer = 0 To response.Results.LastIndex
		    Var result As Kagi.SearchResult = response.Results(i)
		    Var index As Integer = i + 1
		    summary.Add("Result " + index.ToString + ":")
		    summary.Add(result.ToString)
		  Next i
		  
		  Return String.FromArray(summary, EndOfLine)
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 596F75204B6167692073656172636820415049206B65792E
		APIKey As String
	#tag EndProperty


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
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
