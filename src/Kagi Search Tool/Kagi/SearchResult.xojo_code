#tag Class
Protected Class SearchResult
	#tag Method, Flags = &h0, Description = 54616B65732074686520646174612072657475726E65642066726F6D2061204B6167692073656172636820717565727920616E642063726561746573206120536561726368526573756C7420696E7374616E63652E
		Sub Constructor(data As JSONItem)
		  /// Takes the data returned from a Kagi search query and creates a SearchResult instance.
		  
		  If data <> Nil Then
		    Title = data.Lookup("title", "").StringValue
		    URL = data.Lookup("url", "").StringValue
		    Snippet = data.Lookup("snippet", "").StringValue // Optional.
		    PublishedDate = data.Lookup("published", "").StringValue // Optional.
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E732074686973204B6167692073656172636820726573756C74206173206120666F726D617474656420737472696E672E
		Function ToString() As String
		  /// Returns this Kagi search result as a formatted string.
		  
		  Var result() As String
		  
		  result.Add("URL: " + URL)
		  If Title <> "" Then result.Add("Title: " + Title)
		  If PublishedDate <> "" Then result.Add("Published Date: " + PublishedDate)
		  If Snippet <> "" Then result.Add("Snippet:" + Snippet)
		  
		  Return String.FromArray(result, EndOfLine)
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		PublishedDate As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Snippet As String
	#tag EndProperty

	#tag Property, Flags = &h0
		Title As String
	#tag EndProperty

	#tag Property, Flags = &h0
		URL As String
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
			Name="Title"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
