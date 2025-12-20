#tag Class
Protected Class ToolResult
	#tag Method, Flags = &h0, Description = 437265617465732061206E657720546F6F6C526573756C742E
		Sub Constructor(output As String, isError As Boolean = False)
		  /// Creates a new ToolResult.
		  
		  Self.Output = output
		  Self.IsError = isError
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436F6E76656E69656E6365206D6574686F6420746F20637265617465206120726573756C7420696E6469636174696E67206661696C7572652E
		Shared Function Failure(errorMessage As String) As MCPKit.ToolResult
		  /// Convenience method to create a result indicating failure.
		  
		  Return New MCPKit.ToolResult(errorMessage, True)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436F6E76656E69656E6365206D6574686F6420746F206372656174652061207375636365737366756C20726573756C742E
		Shared Function Success(output As String) As MCPKit.ToolResult
		  /// Convenience method to create a successful result.
		  
		  Return New MCPKit.ToolResult(output, False)
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 49662054727565207468656E2074686520746F6F6C20656E636F756E746572656420616E206572726F722E
		IsError As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 546865206F757470757420746578742066726F6D2074686520746F6F6C2E
		Output As String
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
			Name="Output"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsError"
			Visible=false
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
