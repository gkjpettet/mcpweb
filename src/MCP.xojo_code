#tag Module
Protected Module MCP
	#tag Method, Flags = &h1, Description = 52657475726E7320616E206572726F7220746F2074686520636C69656E74206279206F757470757474696E6720746F207374646F75742E2060696460206D617920626520616E20696E7465676572206F72204E696C2E
		Protected Sub Error(id As Variant, errorType As MCP.ErrorTypes, errorMessage As String)
		  /// Returns an error to the client by outputting to stdout.
		  /// `id` may be an integer or Nil.
		  
		  Var errorResponse As New JSONItem
		  errorResponse.Value("jsonrpc") = "2.0"
		  errorResponse.Value("id") = If(id = Nil, "null", id.StringValue)
		  
		  Var error As New JSONItem
		  error.Value("code") = Integer(errorType)
		  error.Value("message") = errorMessage
		  errorResponse.Value("error") = error
		  
		  Print(errorResponse.ToString)
		  
		  stdout.Flush
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E7320547275652069662060646020697320612077686F6C65206E756D6265722E
		Private Function IsInteger(d As Double) As Boolean
		  /// Returns True if `d` is a whole number.
		  
		  Return d = Floor(d)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73206120737472696E6720726570726573656E746174696F6E206F66206120746F6F6C20706172616D6574657220747970652E
		Function ToString(Extends type As MCP.ToolParameterTypes) As String
		  /// Returns a string representation of a tool parameter type.
		  
		  Select Case type
		  Case MCP.ToolParameterTypes.Array_
		    Return "array"
		    
		  Case MCP.ToolParameterTypes.Boolean_
		    Return "boolean"
		    
		  Case MCP.ToolParameterTypes.Integer_
		    Return "integer"
		    
		  Case MCP.ToolParameterTypes.Number_
		    Return "number"
		    
		  Case MCP.ToolParameterTypes.Object_
		    Return "object"
		    
		  Case MCP.ToolParameterTypes.String_
		    Return "string"
		    
		  Else
		    Raise New InvalidArgumentException("Unknown MCP.ToolParameterTypes enumeration.")
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E732074686520706172616D657465722074797065206F6620746865207061737365642076616C75652E
		Protected Function TypeFromValue(value As Variant) As MCP.ToolParameterTypes
		  /// Returns the parameter type of the passed value.
		  
		  If value.IsArray Then Return MCP.ToolParameterTypes.Array_
		  
		  If value.Type = Variant.TypeString Then Return MCP.ToolParameterTypes.String_
		  
		  If value.IsNumeric Then
		    If MCP.IsInteger(value) Then
		      Return MCP.ToolParameterTypes.Integer_
		    Else
		      Return MCP.ToolParameterTypes.Number_
		    End If
		  End If
		  
		  // Assume it's an object. This includes `null`.
		  Return MCP.ToolParameterTypes.Object_
		  
		End Function
	#tag EndMethod


	#tag Enum, Name = ErrorTypes, Type = Integer, Flags = &h1
		InternalError = -32603
		  InvalidParameters = -32602
		  InvalidRequest = -32600
		  MethodNotFound = -32601
		  ParseError = -32700
		ServerError = -32000
	#tag EndEnum

	#tag Enum, Name = ToolParameterTypes, Type = Integer, Flags = &h1
		Array_
		  Boolean_
		  Integer_
		  Number_
		  Object_
		String_
	#tag EndEnum


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
	#tag EndViewBehavior
End Module
#tag EndModule
