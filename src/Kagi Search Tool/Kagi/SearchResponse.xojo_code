#tag Class
Protected Class SearchResponse
	#tag Method, Flags = &h0, Description = 54616B65732061204A534F4E20726573706F6E73652066726F6D2061204B616769204150492063616C6C20616E6420696E7374616E746961746573206974206173206120536561726368526573706F6E736520696E7374616E63652E
		Sub Constructor(jsonResponse As String)
		  /// Takes a JSON response from a Kagi API call and instantiates it as a SearchResponse instance.
		  
		  Try
		    Var json As JSONItem = New JSONItem(jsonResponse)
		    
		    // Check for API errors.
		    If json.HasKey("error") Then
		      Success = False
		      ErrorMessage = json.Value("error").StringValue
		      Return
		    End If
		    
		    // Parse metadata.
		    If json.HasKey("meta") Then
		      Var meta As JSONItem = json.Value("meta")
		      SearchTime = meta.Lookup("ms", 0.0).DoubleValue / 1000.0 // Convert ms to seconds.
		    End If
		    
		    // Parse results.
		    If json.HasKey("data") Then
		      Var dataArray As JSONItem = json.Value("data")
		      
		      For i As Integer = 0 To dataArray.Count - 1
		        Var resultData As JSONItem = dataArray.ValueAt(i)
		        Var result As New Kagi.SearchResult(resultData)
		        Results.Add(result)
		      Next i
		      
		      Success = True
		    End If
		    
		  Catch e As RuntimeException
		    Success = False
		    ErrorMessage = "Failed to parse JSON response: " + e.Message
		  End Try
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		ErrorMessage As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Results() As Kagi.SearchResult
	#tag EndProperty

	#tag Property, Flags = &h0
		SearchTime As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		Success As Boolean = False
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
			Name="Success"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ErrorMessage"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SearchTime"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
