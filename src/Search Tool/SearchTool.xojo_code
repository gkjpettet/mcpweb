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

	#tag Method, Flags = &h0, Description = 52756E2061207765622073656172636820616761696E73742074686520717565727920616E642072657475726E73206120666F726D6174746564207465787420726573706F6E73652E20546865207365727665722077696C6C20706C6163652074686973206974656D20617320746865206F6E6C7920656E74727920696E207468652060726573756C742E636F6E74656E7460206172726179206F66207468652072657475726E656420726573706F6E73652E
		Function Run(args() As MCP.ToolArgument) As String
		  /// Run a web search against the query and returns a formatted text response.
		  /// The server will place this item as the only entry in the `result.content` array of 
		  /// the returned response.
		  
		  #Pragma Warning "TODO: Actually implement properly!"
		  
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
		  
		  Var content1 As String = "ObjoScript is an open source object-oriented scripting language written in Xojo that is designed to be embedded in a Xojo app. it's fast, production-ready and easily extensible."
		  Var url1 As String = "https://garrypettet.com/projects/objoscript.html"
		  Var score1 As Double = 0.99
		  Var result1 As New WebResult(url1, content1, score1)
		  
		  Var content2 As String = "ObjoScript is a toy programming language inspired by Wren"
		  Var url2 As String = "https://google.com"
		  Var score2 As Double = 0.75
		  Var result2 As New WebResult(url2, content2, score2)
		  
		  Return SummariseResults(result1, result2)
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function SummariseResults(ParamArray results() As WebResult) As String
		  /// Summarises the passed web results into a single string for returning to the LLM.
		  
		  Var summary() As String
		  
		  If results.Count = 0 Then Return "0 results found."
		  
		  If results.Count = 1 Then
		    summary.Add("1 result found.")
		  Else
		    summary.Add(results.Count.ToString + " results found.")
		  End If
		  summary.Add(EndOfLine)
		  
		  For i As Integer = 0 To results.LastIndex
		    Var result As WebResult = results(i)
		    Var index As Integer = i + 1
		    summary.Add("Result " + index.ToString + ":")
		    summary.Add(result.ToString)
		  Next i
		  
		  Return String.FromArray(summary, EndOfLine)
		  
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
