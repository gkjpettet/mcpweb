#tag Class
Protected Class Search
	#tag Method, Flags = &h21, Description = 4275696C647320612055524C207769746820717565727920706172616D65746572732E2060706172616D736020697320612064696374696F6E617279206F6620706172616D65746572206E616D657320284B65792920616E642074686569722076616C756573202856616C7565292E
		Private Function BuildURL(params As Dictionary) As String
		  /// Builds a URL with query parameters.
		  /// `params` is a dictionary of parameter names (Key) and their values (Value).
		  
		  // Quick return if no parameters specified.
		  If params = Nil Or params.KeyCount = 0 Then Return BASE_URL
		  
		  Var queryParts() As String
		  
		  For Each key As Variant In params.Keys
		    Var value As String = params.Value(key).StringValue
		    queryParts.Add(EncodeURLComponent(key.StringValue) + "=" + EncodeURLComponent(value))
		  Next key
		  
		  Return BASE_URL + "?" + String.FromArray(queryParts, "&")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(apiKey As String)
		  Self.APIKey = apiKey
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 506572666F726D7320746865204854545020726571756573742E
		Private Function PerformRequest(url As String) As String
		  /// Performs the API request using a synchronous URL connection..
		  
		  Var connection As New URLConnection
		  connection.RequestHeader("Authorization") = "Bot " + APIKey
		  connection.RequestHeader("Accept") = "application/json"
		  connection.RequestHeader("User-Agent") = "Xojo-KagiSearch/1.0"
		  
		  Try
		    // Send the request and get the response.
		    Var response As String = connection.SendSync("GET", url, Timeout)
		    
		    // Check the HTTP status.
		    If connection.HTTPStatusCode >= 200 And connection.HTTPStatusCode < 300 Then
		      Return response
		    Else
		      // Build the error response.
		      Var errorJson As New JSONItem
		      errorJson.Value("error") = "API call error: " + connection.HTTPStatusCode.ToString
		      Return errorJson.ToString
		    End If
		    
		  Catch e As NetworkException
		    Var errorJson As New JSONItem
		    errorJson.Value("error") = "A network error occurred: " + e.Message
		    Return errorJson.ToString
		    
		  Catch e As RuntimeException
		    Var errorJson As New JSONItem
		    errorJson.Value("error") = "An unexpected error occurred whilst making the Kagi API call: " + e.Message
		    Return errorJson.ToString
		  End Try
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 506572666F726D20612073656172636820776974682074686520676976656E2071756572792E
		Function PerformSearch(query As String, limit As Integer = Kagi.DEFAULT_LIMIT) As Kagi.SearchResponse
		  /// Performs a search with the given query.
		  
		  // Handle an empty query.
		  If query.Trim = "" Then
		    Var response As New Kagi.SearchResponse("{}")
		    response.Success = False
		    response.ErrorMessage = "The search query cannot be empty."
		    Return response
		  Else
		    query = query.Trim
		  End If
		  
		  // Make sure the API key is set (it may still be invalid).
		  If APIKey.Trim = "" Then
		    Var response As New Kagi.SearchResponse("{}")
		    response.Success = False
		    response.ErrorMessage = "The API key is not set."
		    Return response
		  End If
		  
		  // Build the request URL.
		  Var params As New Dictionary
		  params.Value("q") = query
		  params.Value("limit") = limit.ToString
		  Var url As String = BuildURL(params)
		  
		  // Perform the API request.
		  Var jsonResponse As String = PerformRequest(url)
		  
		  // Parse and return the response.
		  Return New Kagi.SearchResponse(jsonResponse)
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 54686520415049206B657920746F2075736520666F722074686973204B616769207365617263682E
		APIKey As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206E756D626572206F66207365636F6E647320746F207761697420666F72206120726573706F6E73652066726F6D20746865204150492063616C6C2E
		Timeout As Integer = 15
	#tag EndProperty


	#tag Constant, Name = BASE_URL, Type = String, Dynamic = False, Default = \"https://kagi.com/api/v0/search", Scope = Private
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
			Name="Timeout"
			Visible=false
			Group="Behavior"
			InitialValue="30"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="APIKey"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
